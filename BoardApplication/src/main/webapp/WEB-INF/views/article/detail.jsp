<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.Date"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="app" value="${pageContext.request.contextPath}" />
<c:set var="now" value="<%= new Date() %>" />
<fmt:formatDate value="${now}" pattern="YYYY-MM-dd" var="today" />
<fmt:formatDate value="${articleDTO.createdAt}" pattern="YYYY-MM-dd" var="articleCreated" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>${articleDTO.title} :: Spring Board Project</title>
	<link rel="stylesheet" href="<c:url value="/webjars/bootstrap/4.6.1/css/bootstrap.min.css"/>">
	<style>
		.attachResult {
			width : 100%;
		}
		.attachResult ul {
			display-flex;
			flex-flow : row;
			justify-content : center;
			align-items : center;
		}
		.attachResult ul li {
			list-style
		}
		.attachResult ul li img {
			width : 20px;
		}
	</style>
</head>
<body>
	<div class="form-group">
		<div class="form-row">
			<div class="col">
				<label>번호</label>
				${vno}
			</div>
			<div class="col">
				<label>조회수</label>
				${articleDTO.viewCount}
			</div>
		</div>
		<div class="form-row">
			<div class="col">
				<label>작성자</label>
				${articleDTO.author}
			</div>
			<div class="col">
				<label>작성일자</label>
				<c:choose>
					<c:when test="${today eq articleCreated}">
						<fmt:formatDate value="${articleDTO.createdAt}" type="time" />
					</c:when>
					<c:otherwise>
						<fmt:formatDate value="${articleDTO.createdAt}" type="date" pattern="YYYY-MM-dd" />
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<div class="form-group">
			<label>제목</label>
			${articleDTO.title}
		</div>
		<div class="form-group">
			<label>내용</label>
			${articleDTO.content}
		</div>
	</div>
	<!-- 
	<table class="table">
		<tbody align="center">
			<tr>
				<th class="thead-dark">번호</th>
				<td>${vno}</td>
			</tr>
			<tr>
				<th class="thead-dark">작성자</th>
				<td>${articleDTO.author}</td>
			</tr>
			<tr>
				<th class="thead-dark">제목</th>
				<td>${articleDTO.title}</td>
			</tr>
			<tr>
				<th class="thead-dark">내용</th>
				<td>${articleDTO.content}</td>
			</tr>
			<tr>
				<th class="thead-dark">작성일자</th>
				<td>
					<c:choose>
						<c:when test="${today eq articleCreated}">
							<fmt:formatDate value="${articleDTO.createdAt}" type="time" />
						</c:when>
						<c:otherwise>
							<fmt:formatDate value="${articleDTO.createdAt}" type="date" pattern="YYYY-MM-dd" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th class="thead-dark">조회수</th>
				<td>${articleDTO.viewCount}</td>
			</tr>
		</tbody>
	</table>
	 -->
	<hr>
	
	<div class="attachResult" align="center">
		<ul class="list-inline">
			<c:choose>
				<c:when test="${empty attachList}">
					등록된 첨부파일이 없습니다.
				</c:when>
				<c:otherwise>
					<c:forEach var="attachDTO" items="${attachList}">
						<c:choose>
							<c:when test="${attachDTO.ftype eq 1}">
								<li class="list-inline-item">
									<!-- 첨부파일이 이미지인 경우 썸네일 표시 -->
									<a href="javascript:;" data-fpath="${attachDTO.fpath}" data-uuid="${attachDTO.uuid}" data-fname="${attachDTO.fname}" data-ftype="${attachDTO.ftype}">
										<img src="<c:url value='display?fname=${attachDTO.fpath}/s_${attachDTO.uuid}_${attachDTO.fname}'/>" />
									</a>
								</li>
							</c:when>
							<c:otherwise>
								<li class="list-inline-item">
									<a href="<c:url value='download?fname=${attachDTO.fpath}/${attachDTO.uuid}_${attachDTO.fname}'/>">
										<!-- 첨부파일이 이미지가 아닌 경우 attach.png 표시 -->
										<img src="${app}/resources/img/attach.png" style="width : 100px" />
									</a>
								</li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		
		</div>
	</div>
	<hr>
	
	<!-- 댓글 시작 -->
	<h4>댓글</h4>
		<form id="replyForm" method="POST">
			<div class="form-group">
				<div class="form-row">
					<div class="col">
						<label>이름</label>
						<input type="text" id="replyer" class="form-control" required />
					</div>
					<div class="col">
						<label>비밀번호</label>
						<input type="password" id="password" class="form-control" required />
					</div>
				</div>
			</div>
			<div class="form-group">
				<label>내용</label>
				<textarea id="reply" class="form-control" rows="5" cols="50" style="resize:none;" required></textarea>
			</div>	
		</form>
		<div align="right">
			<button type="button" class="btn btn-primary btn-sm" id="reply-btn">댓글 쓰기</button>
		</div>
	<hr>
	
	<div id="replyResult">
		<ul class="list-unstyled">
			
		</ul>
	</div>
	<!-- 댓글 끝 -->
	
	<div align="center">
		<ul class="list-inline">
			<li class="list-inline-item">
				<a href="${vno}/update">게시글 수정</a>
			</li>
			<li class="list-inline-item">
				<a href="${vno}/delete">게시글 삭제</a>
			</li>
			<li class="list-inline-item">
				<a href="../">목록으로</a>
			</li>
		</ul>
	</div>
</body>
<script type="text/javascript" src="<c:url value="/webjars/jquery/3.6.0/dist/jquery.js"/>"></script>
<script type="text/javascript" src="<c:url value="/webjars/bootstrap/4.6.1/js/bootstrap.min.js"/>"></script>
<script type="text/javascript">
	// 썸네일을 클릭하면 원본 이미지를 보여주는 메소드
	function showBigImage(fileCallPath) {
		$(".bigPictureWrapper").css("display", "flex").show();
		$(".bigPicture")
			.html("<img src='display?fname=" + encodeURI(fileCallPath) + "'>")
			.animate({width:'100%', height:'100%'}, 1000);
	}
	
	function showReplyList() {
		var ano = "${articleDTO.ano}";
		$.ajax({
			url : '${app}/reply/',
			type : 'POST',
			data : {
				ano : ano
			},
			success:function(result) {
				var html = "";
				if(result.length < 1) html = '<p align="center">등록된 댓글이 없습니다.</p><hr>';
				else {
					html += "";
					$(result).each(function() {
						var createDate = new Date(this.createdAt);
						var createTime = getFormatTime(createDate);
						// 날짜가 오늘이 아니라면 날짜 형식의 포맷 반환 
						if(getFormatDate(createDate) != "${today}") {
							createDate = getFormatDate(createDate);
						}
						// 날짜가 오늘이라면 시간 형식의 포맷 반환
						else {
							if(createDate.getHours()<12) createDate = "오전 "; else createDate = "오후 ";
							createDate += createTime;
						}
						html += "<li>";
						html += "	<strong>"+this.replyer+"</strong>&nbsp;&nbsp;&nbsp;&nbsp;";
						html += "	"+createDate+"<br>";
						html += "	<p>"+this.reply+"</p>";
						//html += '	<button type="button" id="update-btn" data-rno='+this.rno+'>수정</button>';
						//html += '	<button type="button" id="delete-btn" data-rno='+this.rno+'>삭제</button>';
						html += "</li>";
						html += "<hr>";
					});
				}
				$(".list-unstyled").html(html);
			}
		});
	}

	// 작성일자를 포맷팅시켜서 보여주기
	function getFormatDate(date) {
		var year = date.getFullYear();
		var month = (1 + date.getMonth());
		month = month >= 10 ? month : '0' + month; // '월'을 두 자릿수로 저장
		var day = date.getDate();
		day = day >= 10 ? day : '0' + day; // '일'을 두 자릿수로 저장
		return year + '-' + month + '-' + day;
	}
	
	function getFormatTime(date) {
		var hour = date.getHours();
		if(hour < 10) {
			hour = '0'+hour;
		}
		var min = date.getMinutes();
		if(min < 10) {
			min = '0'+min;
		}
		var sec = date.getSeconds();
		if(sec < 10) {
			sec = '0'+sec;
		}
		return hour+":"+min+":"+sec;
	}
	
	$(document).ready(function() {
		showReplyList();
		// 썸네일을 클릭하면 원본 이미지 표시
		$(".attachResult").on("click", "a", function(e) {
			var path = decodeURIComponent($(this).data("fpath")+"/" + $(this).data("uuid") + "_" + $(this).data("fname"));
			if($(this).data("ftype")==1) {
				showBigImage(path.replace(new RegExp(/\\/g), "/"));
			}
		});
		
		// 원본 이미지를 클릭하면 이미지 소멸
		$(".bigPictureWrapper").on("click", function(e) {
			$(".bigPicture").animate({width : '0%', height : '0%'}, 1000);
			setTimeout(() => { $(this).hide() }, 1000);
		});
		
		// '등록' 버튼을 누르면 댓글 추가
		$("#reply-btn").on("click", function(e) {
			$.ajax({
				url : '${app}/reply/insert',
				type : 'POST',
				headers : { "Content-Type" : "application/json" },
				data : JSON.stringify({
					reply : $("#reply").val(),
					replyer : $("#replyer").val(),
					password : $("#password").val(),
					ano : ${articleDTO.ano}
				}),
				success:function(result) {
					$("#reply").val("");
					$("#replyer").val("");
					$("#password").val("");
					console.log(result);
					showReplyList();
				}
			});
		});
	});
</script>
</html>