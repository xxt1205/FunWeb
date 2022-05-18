<%@page import="shop.ShopDAO"%>
<%@page import="java.util.List"%>
<%@page import="comment.CommentDTO"%>
<%@page import="comment.CommentDAO"%>
<%@page import="member.MemberDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.BoardDTO"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>gcenter/gcontent.jsp</title>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/subpage.css" rel="stylesheet" type="text/css">
<!--[if lt IE 9]>
<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js" type="text/javascript"></script>
<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/ie7-squish.js" type="text/javascript"></script>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
<![endif]-->
<!--[if IE 6]>
 <script src="../script/DD_belatedPNG_0.0.8a.js"></script>
 <script>
   /* EXAMPLE */
   DD_belatedPNG.fix('#wrap');
   DD_belatedPNG.fix('#main_img');   

 </script>
 <![endif]-->
</head>
<body>

<div id="wrap">
<!-- 헤더들어가는 곳 -->
<jsp:include page="../inc/top.jsp"></jsp:include>
<!-- 헤더들어가는 곳 -->
<!-- 본문들어가는 곳 -->
<!-- 메인이미지 -->
<div id="sub_img_center"></div>
<!-- 메인이미지 -->

<!-- 왼쪽메뉴 -->
<nav id="sub_menu">
<ul>
<li><a href="../center/notice.jsp">Notice</a></li>
<li><a href="#">Public News</a></li>
<li><a href="../fcenter/fnotice.jsp">Driver Download</a></li>
<li><a href="#">Service Policy</a></li>
</ul>
</nav>
<!-- 왼쪽메뉴 -->
<!-- 게시판 -->
<%

request.setCharacterEncoding("utf-8");
String id = (String)session.getAttribute("id");
int num = Integer.parseInt(request.getParameter("num"));
int pageSize = 10;

String pageNum= request.getParameter("pageNum");

if(pageNum == null){
	pageNum = "1";
}
int currentPage = Integer.parseInt(pageNum);

int startRow = (currentPage - 1) * pageSize +1;

int endRow = startRow + (pageSize - 1);

ShopDAO shopDAO = new ShopDAO();

//게시판 글 조회수 증가
// 리턴할형 없음 updateReadcount(int num) 메서드
// update board set readcount = readcount +1 where num=?
// updateReadcount(num) 호출

BoardDTO boardDTO = shopDAO.getShop(num);
shopDAO.updateReadcount(num);

CommentDAO commentDAO = new CommentDAO();

boardDTO.setNum(num);

List<CommentDTO> commentList=commentDAO.getCommentList(boardDTO.getNum(), startRow, pageSize);

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.M.d. H:mm");

%>

<article>
<h1>상품</h1>

<table id="notice">
<tr><td>글번호</td><td><%=boardDTO.getNum()%></td>
    <td>등록일</td><td><%=dateFormat.format(boardDTO.getDate())%></td></tr>
<tr><td>글쓴이</td><td><%=boardDTO.getName()%></td>
    <td>조회수</td><td><%=boardDTO.getReadcount()%></td></tr>
<tr><td>글제목</td><td colspan="3"><%=boardDTO.getSubject()%></td></tr>
<tr><td>첨부파일</td><td colspan="3"><a href="../upload/<%=boardDTO.getFile()%>" ><%=boardDTO.getFile()%></a></td></tr>
<tr><td>이미지</td><td colspan="3"><img src="../upload/<%=boardDTO.getFile()%>" ></td></tr>
<tr><td>글내용</td><td colspan="3"><%=boardDTO.getContent()%></td></tr>
<tr><td>가격</td><td colspan="3"><%=boardDTO.getPrice() %>&nbsp; point</td></tr>
</table><br>
<%if(id != null){%>
<% if (!id.equals(boardDTO.getName())) {%>
	<form action="purchasePro.jsp" method="post">
	<input type="hidden" name="price" value="<%=boardDTO.getPrice()%>"> 
	<input type="hidden" name="merchantId" value="<%=boardDTO.getName()%>"> 
	<input type="hidden" name="boardNum" value="<%=boardDTO.getNum()%>"> 
	<input type="submit" id="purchase" name="purchase" value="구매하기"  style="cursor: pointer; border: 1px solid #222; 
	border-radius: 20px;
	font-size: 16px;
	letter-spacing: 1px;
	padding: 7px 25px;
	margin: 0px auto;
	display: block; "></form><br>
	<%}}else{ %><p style="border: 1px solid #222; 
	border-radius: 20px;
	font-size: 16px;
	letter-spacing: 1px;
	padding: 7px 25px;
	margin: 0px auto;
	display: block; ">로그인 후 구매 하실 수 있습니다</p><br><%} %>
	
	
	
	
<div id="comment">




<!-- table로 추후에 변경 --> 
<fieldset>
댓글목록<br>
<form action="gdeleteCommentPro.jsp" name="gdeleteComment" method="post" onsubmit="return fn_deletecomment();">
<table id="notice" style="width: 100%">
<%try{
    for(int i = 0; i < commentList.size(); i++){
    	// 배열 한칸 데이터 가져올때 get()
    	CommentDTO commentDTO = commentList.get(i);%>
    	<tr><td class="left"><%=commentDTO.getName() %></td>
        <td colspan="2" style="width: 50%; "><%=commentDTO.getComment()%></td><td></td>
        <td style="font-size: 1px"><%=dateFormat.format(commentDTO.getDate())%></td>
        <td><input type="hidden" value="<%=commentDTO.getId()%>"><%if(id.equals(commentDTO.getId())){%>
        
        <input type="hidden" name="gcomment_num" value="<%=commentDTO.getComment_num()%>">
        <input type="hidden" name="num" value="<%=boardDTO.getNum()%>">
        <input type="submit" value="댓글삭제" style="cursor: pointer; float: left;">
        <input type="button" name="gcommentUpate" value="댓글수정" onclick="return fn_updateComment(this.form);" style="float: left;"><%}%></td>
        
        
        </tr>
        <%}
        } catch (Exception e){
        	e.printStackTrace();}%>
</table>
</form>
</fieldset>
<form name="fr" action="gcommentPro.jsp" method="post" onsubmit="return fn_content();">
<fieldset>
댓글작성란<br>
<textarea name="comment" rows=5 cols=75 style="resize: none"></textarea>
<input type="hidden" name="num" value="<%=boardDTO.getNum()%>">
<input type="hidden" name="id" value="<%=id%>">


<input type="submit" value="댓글작성" class="btn" style="cursor: pointer; width: 80px; height: 80px; margin: auto;">
</fieldset>

</form>
</div>
<div id="page_control">
<%


int pageBlock=3;

//시작하는 페이지 번호
// pageNum(currentPage) pageBlock => startPage
// 		1~10(0~9)			10		=>	0*10 + 1 => 1
//		11~20(10~19)		10		=>	1*10 + 1 =>11
//		21~30(20~29)		10		=>	2*10 + 1 =>21
int startPage = (currentPage-1) / pageBlock * pageBlock+1; 
//끝나는 페이지 번호
int endPage = startPage + pageSize - 1;



// 구한 끝나는 페이지번호 10, 실제 페이지 번호 2
// 글개수 구하기

// 전체페이지 개수 구하기 글개수 50 , 한화면에 보여줄 글개수 10 => 페이지개수 5 + 0 => 5
// 전체페이지 개수 구하기 글개수 50 , 한화면에 보여줄 글개수 10 => 페이지개수 5 + 1 => 6
// int PageCount=글개수/pageSize + (글개수%pageSize==0?0:1);
int count = commentDAO.getCommentCount(boardDTO.getNum());

int pageCount = count/pageSize + (count%pageSize==0?0:1);
if(endPage > pageCount){
	endPage=pageCount;
	}
%>

<%
if(startPage > pageBlock){
	%>
	<a href="content.jsp?pageNum=<%=startPage-pageBlock%>&num=<%=num%>">Prev</a>
	<%
}
%>
<%for(int i=startPage; i<=endPage; i++) {

%>
<a href="content.jsp?pageNum=<%=i%>&num=<%=num%>"><%=i %></a>
<%

}
%>
<% if(endPage < pageCount){
%>
<a href="content.jsp?pageNum=<%=startPage+pageBlock%>&num=<%=num%>">Next</a>
<%
}
%>

</div>


<div id="table_search">
<%if(id != null ) {%>
	
	<%if(id.equals(boardDTO.getName())) {%>
<input type="button" value="글수정" class="btn" style="cursor: pointer;" onclick="location.href='gupdate.jsp?num=<%=boardDTO.getNum()%>'">
<form action="fdeleteBoard.jsp" name="deleteB" onsubmit="return fn_deleteBoard()" style="float: left;">
<input type="hidden" name="num" value="<%=boardDTO.getNum()%>">
<input type="submit" value="글삭제" class="btn" style="cursor: pointer;">
</form>
<%-- location.href='deleteForm.jsp?num=<%=boardDTO.getNum()%> --%>

<%}
}%>
<input type="button" value="글목록" class="btn" onclick="location.href=gnotice.jsp" style="cursor: pointer;">

</div>
<div class="clear"></div>

</article>
<!-- 게시판 -->
<!-- 본문들어가는 곳 -->
<div class="clear"></div>
<!-- 푸터들어가는 곳 -->
<jsp:include page="../inc/bottom.jsp"></jsp:include>
<!-- 푸터들어가는 곳 -->
</div>
<script type="text/javascript">

	function fn_content() {
		if(document.fr.comment.value=="") {
			
			alert("댓글내용을 작성해주세요");
			return false;
		}
		if(document.fr.id.value=="null" || document.fr.id.value=="") {
			alert("로그인후 댓글 작성해주세요");
			location.href="../member/login.jsp";
			return false;
		} else {
			return true;
		}
	}//fn_content()
	function fn_deletecomment() {
			if(confirm("정말 삭제하시겠습니까?") == true) {
				
				return true;
			}else {
				
				return false;
			}
	}//fn_deletecomment()
	function fn_updateComment(fn) {
		fn.action="gupdateComment.jsp"; 
	    fn.submit();
	    return true;
	}//updatComment()
	
	
	function fn_deleteBoard() {
		if(confirm("정말 삭제하시겠습니까?") == true) {
			
			return true;
		}else {
			
			return false;
		}
	}
	$(document).ready(function(){
		
	}
	

</script>
</body>
</html>