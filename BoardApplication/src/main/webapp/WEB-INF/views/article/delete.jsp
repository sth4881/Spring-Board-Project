<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>${vno}번 게시물 삭제 :: Spring Board Application</title>
	<link rel="stylesheet" href="<c:url value="/webjars/bootstrap/4.6.1/css/bootstrap.min.css"/>">
</head>
<body>
	<form method="post">
		<div class="form-group">
			<label>번호</label>
			<input type="text" id="vno" value="${vno}" class="form-control" readonly>
		</div>
		<div class="form-group">
			<label>비밀번호</label>
			<input type="password" name="password" class="form-control" required="required" autofocus="autofocus" />
		</div>
		<div align="right">
			<input type="submit" class="btn btn-primary btn-sm" value="삭제" />
			<input type="button" class="btn btn-danger btn-sm" value="취소" onClick="window.location.href='../?vno=${vno}'" />
		</div>
	</form>
</body>
<script type="text/javascript" src="<c:url value='/webjars/jquery/3.6.0/dist/jquery.js' />"></script>
<script type="text/javascript" src="<c:url value="/webjars/bootstrap/4.6.1/js/bootstrap.min.js"/>"></script>
</html>