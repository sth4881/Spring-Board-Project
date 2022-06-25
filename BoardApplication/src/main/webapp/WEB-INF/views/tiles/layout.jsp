<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="<c:url value="/webjars/bootstrap/4.6.1/css/bootstrap.min.css"/>">
</head>
<body>
	<div class="container-fluid" align="center">
		<table>
			<tr>
				<td colspan="2">
					<tiles:insertAttribute name="header" />
				</td>
			</tr>
			<tr>
				<td>
					<tiles:insertAttribute name="body" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<tiles:insertAttribute name="footer" />
				</td>
			</tr>
		</table>
	</div>
</body>
<script type="text/javascript" src="<c:url value='/webjars/jquery/3.6.0/dist/jquery.js' />"></script>
<script type="text/javascript" src="<c:url value="/webjars/bootstrap/4.6.1/js/bootstrap.min.js"/>"></script>
</html>