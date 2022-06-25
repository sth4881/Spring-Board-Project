<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>게시물 목록</title>
	<link rel="stylesheet" href="<c:url value="/webjars/bootstrap/4.6.1/css/bootstrap.min.css"/>">
</head>
<body>
	<table class="table table-hover">
		<thead class="thead-dark">
			<tr align="center">
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>조회수</th>
			</tr>
		</thead>
		<tbody align="center">
			<c:forEach items="${list}" var="dto" varStatus="status">
				<tr>
					<td>${articleCount - status.index - ((page-1)*articlePerPage)}</td>
					<td><a href="../${page}/${dto.ano}/?vno=${articleCount - status.index - ((page-1)*articlePerPage)}">${dto.title}</a></td>
					<td>${dto.author}</td>
					<td>${dto.viewCount}</td>
				</tr>
			</c:forEach>
			<tr>
				<td colspan="4">
					<!-- 시작 페이지가 1이 아닌 경우 '이전' 출력 -->
					<c:if test="${startPage != 1}">
						[<a href="../${startPage-1}/">이전</a>]
					</c:if>
					
					<!-- 페이지 블록 출력 -->
					<c:forEach begin="${startPage}" end="${endPage}" var="p">
						<c:if test="${p == page}">${p}</c:if>
						<c:if test="${p != page}">
							<a href="../${p}/">${p}</a>
						</c:if>
					</c:forEach>
					
					<!-- 마지막 페이지가 총 페이지의 개수가 아닌 경우 '다음' 출력 -->
					<c:if test="${endPage != pageCount}">
						[<a href="../${endPage+1}/">다음</a>]
					</c:if>
				</td>
			</tr>
		</tbody>
	</table>
	<div align="center">
		<a href="insert">글쓰기</a>
	</div>
</body>
<script type="text/javascript" src="<c:url value='/webjars/jquery/3.6.0/dist/jquery.js' />"></script>
<script type="text/javascript" src="<c:url value="/webjars/bootstrap/4.6.1/js/bootstrap.min.js"/>"></script>
</html>