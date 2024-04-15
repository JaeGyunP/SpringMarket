<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../main/menu.jsp"%>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-3.7.1.js"></script>
<script>
$(function() {   
   $("#btnWrite").click(function() {
      if("${sessionScope.userid}" != ""){
      location.href="/board/write.do";
      }else{
         alert("로그인 후에 이용 가능합니다.");
      location.href="/member/pagelogin.do";
      }
   });
});
function list(page){
   location.href="/board/list.do?cur_page=" 
         + page + "&search_option=${search_option}&keyword=${keyword}";
}   

$(function() {
   $(".article-row").click(function() {
	   let row = $(this).attr("data-id");
      location.href = "/board/view.do/" + row
   });
});
</script>
<style>


.table-fixed {
    table-layout: fixed;
    width: 100%; /* 테이블 전체 너비를 100%로 설정 */
    word-break: break-all;
    height: auto;
    border: 1px solid #bcbcbc;
}
.board-list {
   margin: 30px auto;
}
 
.size01 { 
   width:9%;
}

.size02 {
   width: 30%;
}

.size03 {
   width: 15%;
}

.size04 {
   width: 7%;
}
/* 사이드바 스타일 */
.sidebar {
    width: 15%;
    padding: 20px;
}

/* 본문 스타일 */
#main_content {
    width: 70%;
    height: auto;
    padding: 20px;
    margin: 0 auto; /* 가운데 정렬 */
    box-sizing: inherit; /* 패딩, 테두리를 요소의 크기에 포함시킴 */
    
}

/* 푸터 스타일 */
#footer {
    clear: both; /* 사이드바와 본문의 밑에 푸터를 위치시키기 위해 clear 속성 추가 */
    text-align: center; /* 가운데 정렬 */
    padding: 20px;
    border-top: 1px solid #bcbcbc;
}

.button {
    display: inline-block;
    padding: 1px 2px;
    background-color: #f0f0f0;
    color: #333;
    border: 1px solid #ccc;
    border-radius: 4px;
    cursor: pointer;
}

.btn-outline-gagi {
  --bs-btn-color:   #9523ff;
  --bs-btn-border-color:    #9523ff;
  --bs-btn-hover-color: #fff;
  --bs-btn-hover-bg:    #9523ff;
  --bs-btn-hover-border-color:    #9523ff;
  --bs-btn-focus-shadow-rgb: 25, 135, 84;
  --bs-btn-active-color: #fff;
  --bs-btn-active-bg:    #9523ff;
  --bs-btn-active-border-color:    #9523ff;
  --bs-btn-active-shadow: inset 0 3px 5px rgba(0, 0, 0, 0.125);
  --bs-btn-disabled-color:    #9523ff;
  --bs-btn-disabled-bg: transparent;
  --bs-btn-disabled-border-color:    #9523ff;
  --bs-gradient: none;
}
.page-link {
    color: #9523ff;
}
.page-link:hover {
   color: white;
     background-color:  #9523ff;
     border-color: #9523ff;
}

</style>
</head>
<body>
<div class="sidebar" style="float: left;">
      </div>
      
<div id="main_content">
<h2>게시판</h2>
<form name="form1" method="post" action="/board/search.do">
<div class="btn-group" style="text-align: center">
<select name="search_option" aria-expanded="false">
<c:choose>
   <c:when test="${search_option == null || search_option == 'all'}">
      <option value="all" selected>전체검색</option>
      <option value="nickname" >작성자</option>
      <option value="subject" >제목</option>
      <option value="content" >내용</option>
   </c:when>
   <c:when test="${search_option == 'nickname'}">
      <option value="all" >전체검색</option>
      <option value="nickname" selected>작성자</option>
      <option value="subject" >제목</option>
      <option value="content" >내용</option>
   </c:when>
   <c:when test="${search_option == 'subject'}">
      <option value="all" >전체검색</option>
      <option value="nickname" >작성자</option>
      <option value="subject" selected>제목</option>
      <option value="content" >내용</option>
   </c:when>
   <c:when test="${search_option == 'content'}">
      <option value="all" >전체검색</option>
      <option value="nickname" >작성자</option>
      <option value="subject" >제목</option>
      <option value="content" selected>내용</option>
   </c:when>
</c:choose>
</select>
</div>
<input name="keyword" value="${map.keyword}">
<input type="submit" value="검색" class="btn btn-outline-gagi" id="btn_Search"> 
<button type="button" id="btnWrite" class="btn btn-outline-gagi" >게시글 작성</button>
</form>


<article>   
   <table class="board-list table-fixed">
      <tr align="center" style="background-color: write; ">
         <th class="size04">번호</th>
         <th class="size01">작성자</th>
         <th class="size02">제목</th>
         <th class="size03">날짜</th>
         <th class="size03">조회수</th>
      </tr>
      <c:forEach var="dto" items="${map.list}" varStatus="s">
      <c:choose>
      <c:when test="${dto.nickname == '관리자'}">
         <tr align="center" class="article-row" data-id="${dto.num}" style="background-color: #F2F2F2; cursor: pointer;" >
            <td><span class="button">공지</span></td>  
            <td><span>관리자</span></td>
            <td>${dto.subject}</td>
            <td>${dto.reg_date}</td>
            <td>${dto.hit}</td>
         </tr>
         <tr>
         <td></td>
         </tr>
         </c:when>
         <c:otherwise>
         <tr align="center" class="article-row" data-id="${dto.num}" style="cursor: pointer;">
            <td>${(map.page.totalCount - (dto.rn - 1))}</td>  
            <td>${dto.nickname}</td>
            <td>${dto.subject}</td>
            <td>${dto.reg_date}</td>
            <td>${dto.hit}</td>
         </tr>
         <tr>
         <td></td>
         </tr>
         </c:otherwise>
         </c:choose>
      </c:forEach>
   </table>
</article>
   <nav aria-label="Page navigation example">
    <ul class="pagination pagination-sm justify-content-center">
        <li class="page-item">
            <c:if test="${map.page.curPage > 1}">
                <a class="page-link" href="#" onclick="list('1')" aria-label="First">
                    <span aria-hidden="true"></span>
                    <span class="sr-only">처음</span>
                </a>
            </c:if>
        </li>
        <li class="page-item">
            <c:if test="${map.page.curBlock > 1}">
                <a class="page-link" href="#" onclick="list('${map.page.prevPage}')" aria-label="Previous">
                    <span aria-hidden="true"></span>
                    <span class="sr-only">처음으로</span>
                </a>
            </c:if>
        </li>
        
        <c:forEach var="num" begin="${map.page.blockStart}" end="${map.page.blockEnd}">
            <li class="page-item <c:if test='${num == map.page.curPage}'>active</c:if>'">
                <c:choose>
                    <c:when test="${num == map.page.curPage}">
                        <span class="page-link">${num}</span>
                    </c:when>
                    <c:otherwise>
                        <a class="page-link" href="#" onclick="list('${num}')">${num}</a>
                    </c:otherwise>
                </c:choose>
            </li>
        </c:forEach>
        
        <li class="page-item">
            <c:if test="${map.page.curBlock < map.page.totBlock}">
                <a class="page-link" href="#" onclick="list('${map.page.nextPage}')" aria-label="Next">
                    <span aria-hidden="true"></span>
                    <span class="sr-only">다음</span>
                </a>
            </c:if>
        </li>
        <li class="page-item">
            <c:if test="${map.page.curPage < map.page.totPage}">
                <a class="page-link" href="#" onclick="list('${map.page.totPage}')" aria-label="Last">
                    <span aria-hidden="true"></span>
                    <span class="sr-only">마지막</span>
                </a>
            </c:if>
        </li>
    </ul>
</nav>

</div>
<br><br><br><br><br><br><br><br>
<div class="sidebar" style="float: right;">
 </div>
      
<div id="footer">
<%@ include file="../main/footer.jsp"%>
</div>
</body>
</html>