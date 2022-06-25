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
	<title>글쓰기 :: Spring Board Project</title>
	<link rel="stylesheet" href="<c:url value="/webjars/bootstrap/4.6.1/css/bootstrap.min.css"/>">
</head>
<body>
	<form method='POST' enctype="multipart/form-data">
		<div class="form-group">
			<div class="form-row">
				<div class="col">
					<label>작성자</label>
					<input type="text" id="author" class="form-control" autofocus="autofocus" required="required" />
				</div>
				<div class="col">
					<label>비밀번호</label>
					<input type="password" id="password" class="form-control" required />
				</div>
			</div>
		</div>
		<div class="form-group">
			<label>제목</label>
			<input type="text" id="title" class="form-control" placeholder="제목을 입력해주세요 :)" required="required" />
		</div>
		<div class="form-group">
			<label>내용</label>
			<textarea id="content" class="form-control" placeholder="내용을 입력해주세요 :)" rows="5" cols="50" style="resize:none;" required></textarea>
		</div>
		<hr>
		
		<div id="attachResult">
		
		</div>
		<hr>
		
		<div class="input mb-3">
			<div class="custom-file">
				<input type="file" class="custom-file-input" id="attach" aria-describedby="inputGroupFileAddon01" multiple />
			    <label class="custom-file-label">Choose file</label>
			</div>
		</div>
		<div align="right">
			<button type="button" id="register" class="btn btn-primary btn-sm">글쓰기</button>
			<button type="button" id="back" class="btn btn-danger btn-sm">취소</button>
		</div>
	</form>
</body>
<script type="text/javascript" src="<c:url value='/webjars/jquery/3.6.0/dist/jquery.js' />"></script>
<script type="text/javascript" src="<c:url value="/webjars/bootstrap/4.6.1/js/bootstrap.min.js"/>"></script>
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
				processData : false,
				contentType : false,
				data : formData,
				type : 'POST',
				success:function(result) {
					if(result==1) console.log("파일 업로드 성공");
				}
			});
			
			var fileArr = Array.from(e.target.files);
			fileArr.forEach((file, index) => {
				var reader = new FileReader();
				reader.onload = event => {
					// 선택한 첨부파일을 생성하기 위한 img 태그 추가
					var img = document.createElement("img");
					// 첨부파일 타입이 이미지 포맷이라면
					if(file.type=="image/jpeg" || file.type=="image/png" || file.type=="image/gif") {
						img.setAttribute("src", event.target.result);
						img.setAttribute("width", 100);
						img.setAttribute("height", 100);
						img.setAttribute("data-filename", file.name);
					}
					// 첨부파일 타입이 이미지 포맷이 아니라면
					else {
						img.setAttribute("src", "${source}");
						img.setAttribute("width", 150);
						img.setAttribute("height", 100);
						img.setAttribute("data-filename", file.name);
					}
					
					// 첨부파일을 삭제하기 위한 'button' 요소 생성
					var cancelBtn = document.createElement("input");
					cancelBtn.setAttribute("type", "button");
					cancelBtn.setAttribute("value", "삭제");
					cancelBtn.setAttribute("id", file.name);
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
			//var fileName = $(this).data('name');
			var fileName = $(this).attr("id");
			$.ajax({
				url : 'deleteAttach',
				data : {
					fileName : fileName
				},
				type : 'POST',
				success:function(result) {
					if(result==1) {
						$("img[data-filename='"+fileName+"']").remove();
						document.getElementById(fileName).remove();
						console.log("파일 삭제 성공");
					}
				}
			});
		});
		
		// '등록' 버튼을 누르면 데이터가 formData를 통해서 전송
		$("#register").on("click", function(e) {
			var formData = new FormData();
			formData.append("title", $("#title").val());
			formData.append("author", $("#author").val());
			formData.append("password", $("#password").val());
			formData.append("content", $("#content").val());

			$.ajax({
				url : '',
				processData : false,
				contentType : false,
				data : formData,
				type : 'POST',
				success:function(result) {
					if(result==1) {
						alert("게시물 작성 완료");
						window.location.href = "../1/";
					}
				}
			});
		});
		
		// '취소' 버튼을 누르면 temp에 저장된 데이터 전부 삭제하고 뒤로가기
		$("#back").on("click", function(e) {
			$.ajax({
				url : 'deleteAttachAll',
				type : 'POST',
				success:function(result) {
					if(result==1) {
						window.location.href="./";
					}
				}
			});
		});
	});
</script>
</html>