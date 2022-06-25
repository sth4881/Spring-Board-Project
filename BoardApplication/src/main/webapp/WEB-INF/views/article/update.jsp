<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="app" value="${pageContext.request.contextPath}" />
<c:set var="source" value="${app}/resources/img/attach.png" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>${vno}번 게시물 수정 :: Spring Board Project</title>
	<link rel="stylesheet" href="<c:url value="/webjars/bootstrap/4.6.1/css/bootstrap.min.css"/>">
</head>
<body>
	<c:set var="articleDTO" value="${articleDTO}" />
	<form method="POST">
		<div class="form-group">
			<label for="numberForm">번호</label>
			<input type="text" id="vno" class="form-control" placeholder="${vno}" readonly />
			<input type="hidden" name="ano" value="${articleDTO.ano}" />
		</div>
		<div class="form-row">
			<div class="col">
				<label for="authorForm">작성자</label>
				<input type="text" name="author" value="${articleDTO.author}" class="form-control" placeholder="${articleDTO.author}" readonly />
			</div>
			<div class="col">
				<label for="passwordForm">비밀번호</label>
				<input type="password" name="password" value="${articleDTO.password}" class="form-control" required /><br>
			</div>
		</div>
		<div class="form-group">
			<label for="titleForm">제목</label>
			<input type="text" name="title" class="form-control" value="${articleDTO.title}" autofocus="autofocus" required />
		</div>
		<div class="form-group">
			<label for="contentForm">내용</label>
			<textarea name="content" class="form-control" rows="5" cols="50" style="resize: none;" required>${articleDTO.content}</textarea>
		</div>
		<hr>
	
		<div id="attachResult" align="center">
			<c:forEach var="attachDTO" items="${attachList}" varStatus="status">
				<c:choose>
					<c:when test="${attachDTO.ftype eq 1}">
						<!-- 첨부파일이 이미지인 경우 썸네일 표시
						<a href="javascript:;" data-fpath="${attachDTO.fpath}" data-uuid="${attachDTO.uuid}" data-fname="${attachDTO.fname}" data-ftype="${attachDTO.ftype}">
							<img src="<c:url value='update/display?fname=${attachDTO.fpath}/s_${attachDTO.uuid}_${attachDTO.fname}'/>" />
						</a>
						-->
						<img src="<c:url value='display?fname=${attachDTO.fpath}/s_${attachDTO.uuid}_${attachDTO.fname}'/>" data-filename="${attachDTO.fname}" />
						<input type="hidden" class="hidden" name='list[${status.index}].uuid' value="${attachDTO.uuid}" data-filename="${attachDTO.fname}" />
						<input type="hidden" class="hidden" name='list[${status.index}].fname' value="${attachDTO.fname}" data-filename="${attachDTO.fname}" />
						<input type="hidden" class="hidden" name='list[${status.index}].fpath' value="${attachDTO.fpath}" data-filename="${attachDTO.fname}" />
						<input type="hidden" class="hidden" name='list[${status.index}].ftype' value="${attachDTO.ftype}" data-filename="${attachDTO.fname}" />
						<input type="button" class="btn btn-danger btn-sm" id="${attachDTO.fname}" value="삭제" />
					</c:when>
					<c:otherwise>
						<!-- 첨부파일이 이미지가 아닌 경우 attach.png 표시
						<a href="<c:url value='download?fname=${attachDTO.fpath}/${attachDTO.uuid}_${attachDTO.fname}'/>">
							<img src="${app}/resources/img/attach.png" style="width : 100px" />
						</a>
						-->
						<img src="${app}/resources/img/attach.png" data-filename="${attachDTO.fname}" style="width : 100px" />
						<input type="hidden" class="hidden" name='list[${status.index}].uuid' value="${attachDTO.uuid}" data-filename="${attachDTO.fname}" />
						<input type="hidden" class="hidden" name='list[${status.index}].fname' value="${attachDTO.fname}" data-filename="${attachDTO.fname}" />
						<input type="hidden" class="hidden" name='list[${status.index}].fpath' value="${attachDTO.fpath}" data-filename="${attachDTO.fname}" />
						<input type="hidden" class="hidden" name='list[${status.index}].ftype' value="${attachDTO.ftype}" data-filename="${attachDTO.fname}" />
						<input type="button" class="btn btn-danger btn-sm" id="${attachDTO.fname}" value="삭제" />
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
		<hr>
		<div class="input mb-3">
			<div class="custom-file">
				<input type="file" class="custom-file-input" id="attach" aria-describedby="inputGroupFileAddon01" multiple />
			    <label class="custom-file-label">파일을 업로드해주세요 :)</label>
			</div>
		</div>
		<div align="right">
			<button type="button" id="modify" class="btn btn-primary btn-sm">수정</button>
			<button type="button" id="back" class="btn btn-danger btn-sm" onClick="window.location.href='../?vno=${vno}'">취소</button>
		</div>
	</form>
</body>
<script type="text/javascript" src="<c:url value='/webjars/jquery/3.6.0/dist/jquery.js' />"></script>
<script type="text/javascript" src="<c:url value="/webjars/bootstrap/4.6.1/js/bootstrap.min.js"/>"></script
>
<script type="text/javascript">
	$(document).ready(function() {
		// 파일 종류 및 크기 제한
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; // 5MB
		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert("파일 크기 초과");
				return false;
			}
			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드할 수 없습니다.")
				return false;
			}
			return true;
		}
		
		// 파일을 추가할 때마다 업로드 및 미리보기 업데이트
		$("#attach").on("change", function(e) {
			var files = e.target.files;
			var formData = new FormData();
			for(var i=0; i<files.length; i++) {
				if(!checkExtension(files[i].name, files[i].size)) return false;
				formData.append("attach", files[i]);
			}
	
			$.ajax({
				url : 'uploadAttach',
				type : 'POST',
				processData : false,
				contentType : false,
				data : formData,
				success:function(result) {
					if(result==1) console.log("파일 업로드 성공");
				}
			});
			
			var fileArr = Array.from(e.target.files);
			fileArr.forEach((file, index) => {
				console.log(file);
				var reader = new FileReader();
				reader.onload = event => {
					// 선택한 첨부파일을 생성하기 위한 img 태그 추가
					var img = document.createElement("img");
					if(file.type=="image/jpeg" || file.type=="image/png" || file.type=="image/gif") {
						img.setAttribute("src", event.target.result);
						img.setAttribute("width", 100);
						img.setAttribute("height", 100);
						img.setAttribute("data-filename", file.name);
					}
					else {
						img.setAttribute("src", "${source}");
						img.setAttribute("width", 150);
						img.setAttribute("height", 100);
						img.setAttribute("data-filename", file.name);
					}
					
					// 첨부파일을 삭제하기 위한 'button' 요소 생성
					var cancelBtn = document.createElement("input");
					cancelBtn.setAttribute("type", "button");
					cancelBtn.setAttribute("id", file.name);
					cancelBtn.setAttribute("value", "삭제");
					cancelBtn.setAttribute("class", "btn btn-danger btn-sm");
					
					// attachResult에 자식 요소로 첨부파일 및 버튼 추가
					document.getElementById("attachResult").appendChild(img);
					document.getElementById("attachResult").appendChild(cancelBtn);
				}
				reader.readAsDataURL(file);
			});
		});
		
		// 'X' 버튼을 누르면 원본 파일, 표시 이미지, 버튼 삭제
		$("#attachResult").on("click", "input", function(e) {
			var fileName = $(this).attr("id");
			$.ajax({
				url : 'deleteAttach',
				type : 'POST',
				data : {
					fileName : fileName
				},
				success:function(result) {
					if(result==1) {
						$("input[data-filename='"+fileName+"']").remove();
						$("img[data-filename='"+fileName+"']").remove();
						document.getElementById(fileName).remove();
						console.log("파일 삭제 성공");
					}
				}
			})
		});
		
		// '수정' 버튼을 누르면 formData를 통해서 데이터 전송
		$("#modify").on("click", function(e) {
			var formObj = $("form");
			var files = $("#attachResult").children('input.hidden');
			for(var i=0; i<files.length; i++) {
				formObj.append(files[i]);
				console.log(files[i]);
			}
			formObj.submit();
		});
		
		// '취소' 버튼을 누르면 temp에 저장된 데이터 전부 삭제하고 뒤로가기
		$("#back").on("click", function(e) {
			$.ajax({
				url : 'deleteAttachAll',
				type : 'POST',
				success:function(result) {
					if(result==1) {
						window.location.href="../?vno=${vno}";
					}
				}
			});
		});
	});
</script>
</html>