<%@page import="member.MemberDTO"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
String id = request.getParameter("id");

MemberDAO memberDAO = new MemberDAO();
MemberDTO memberDTO = memberDAO.getMember(id);

if(memberDTO == null){
	%><span style="color: green;">아이디 사용가능</span><%
	
}else {
	%><span style="color: red;">아이디 중복</span><%
}
%>
		
