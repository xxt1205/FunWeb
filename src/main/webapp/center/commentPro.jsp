<%@page import="member.MemberDAO"%>
<%@page import="member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>center/commentPro.jsp</title>
</head>
<body>
<%
String id = (String)session.getAttribute("id");
request.setCharacterEncoding("utf-8");
String comment = request.getParameter("comment");
int num = Integer.parseInt(request.getParameter("num"));

MemberDAO memberDAO = new MemberDAO();
MemberDTO memberDTO = memberDAO.getMember(id);



%>
</body>
</html>