<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Insert title here</title>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="http://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
	function showPostcode() {
		new daum.Postcode(
				{
					oncomplete : function(data) {
						let fullAddr = "";
						let extraAddr = "";
						if (data.userSelectedType === "R") {
							fullAddr = data.roadAddress;
						} else {
							fullAddr = data.jibunAddress;
						}
						if (data.userSelectedType === "R") {
							if (data.bname !== "") {
								extraAddr += data.bname;
							}
							if (data.buildingName !== "") {
								extraAddr += (extraAddr !== "" ? ", "
										+ data.buildingName : data.buildingName);
							}
							fullAddr += (extraAddr !== "" ? " (" + extraAddr
									+ ")" : "");
						}
						document.getElementById("post_code").value = data.zonecode;
						document.getElementById("address1").value = fullAddr;
						document.getElementById("address2").focus();
					}
				}).open();
	}
</script>

<style>
body {
	font-family: 'Arial', sans-serif;
	background-color: #f5f5f5;
	margin: 0;
	padding: 0;
}

table {
	margin: 20px auto;
	background-color: white;
	border: 1px solid #ddd;
	border-collapse: collapse;
	width: 50%;
}

table:nth-of-type(2) input[type="text"], table:nth-of-type(3) input[type="text"]
	{
	border: none; /* 테두리 없음 */
	outline: none; /* 포커스시 테두리 없음 */
	text-align: right;
}

td {
	padding: 10px;
	border: 1px solid #ddd;
}

input {
	padding: 5px; /* 입력 필드의 여백을 줄임 */
	margin: 2px;
}

#emailresult, #nicknameresult {
	font-size: small;
	color: red;
}

.zip-code-group {
	display: flex;
	align-items: center;
}

#post_code {
	flex: 1;
}

#updateButton {
	background-color: #4CAF50;
	color: white;
	border: none;
	padding: 8px 16px; /* 버튼의 크기를 작게 조절 */
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 14px; /* 버튼의 글자 크기를 작게 조절 */
	margin: 4px 2px;
	cursor: pointer;
	border-radius: 4px;
	margin-top: 10px; /* 버튼을 아래로 내림 */
}

#btnCancle {
	background-color: red;
	color: white;
	border: none;
	padding: 8px 16px; /* 버튼의 크기를 작게 조절 */
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 14px; /* 버튼의 글자 크기를 작게 조절 */
	margin: 4px 2px;
	cursor: pointer;
	border-radius: 4px;
	margin-top: 10px; /*

}

/* 푸터 스타일 */ # footer { clear : both;
	text-align: center;
	padding: 5px;
	border-top: 1px solid #bcbcbc;
	position: relative; /* 푸터를 화면 하단에 고정시킴 */
	bottom: 0;
	width: 100%;
	background-color: white;
}
</style>
<script src="http://code.jquery.com/jquery-latest.min.js"
	type="text/javascript"></script>
<script src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<script>
function buy() {
	IMP.init('imp10032786'); //iamport 대신 자신의 "가맹점 식별코드"를 사용
	IMP.request_pay({
		pg : "kakaopay",
		pay_method : "card",
		merchant_uid : 'merchant_' + new Date().getTime(),
		name : "가지마켓",
		amount : ${map.totalPrice},
		buyer_name :'${sessionScope.userid}'
	}, function(rsp) { // callback
		if (rsp.success) {
			var msg = '결제가 완료되었습니다.';
			alert(msg);
		 	savePayment(); // savePayment 함수 호출 --%>
		
		} else {
			var msg = '결제에 실패하였습니다.';
			msg += '에러내용 : ' + rsp.error_msg;
			alert(msg);
		}
	});
	}
	
 	function savePayment(amount) {
		document.form1.action = "/buy/buy.do";
		document.form1.submit();
	}

</script>

</head>
<body>
	<%@ include file="../main/menu.jsp"%>



	<form name="form1" method="post">
		<h2 align="center">배송지</h2>

		<table>
			<tr>
				<td align="center">이름&nbsp;</td>
				<td><input name="name" value="${map.mdto.name}"></td>

			</tr>

			<tr>
				<td align="center">휴대폰&nbsp;</td>
				<td><input name="phone" value="${map.mdto.phone}"></td>
			</tr>

			<tr>
				<td align="center">주소&nbsp;</td>
				<td><div class="zip-code-group">
						<input placeholder="우편번호" name="zipcode" id="post_code" readonly>&nbsp;&nbsp;&nbsp;
						<input type="button" onclick="showPostcode()" value="우편번호 찾기">
					</div></td>
			</tr>

			<tr>
				<td></td>
				<td><input placeholder="주소" name="address1" id="address1"
					size="60" value="${map.mdto.address}"> <br> <input
					placeholder="상세주소" name="address2" id="address2"></td>
			</tr>



		</table>

		<h2 align="center">주문상품</h2>
		<table>


			<tr>
				<td rowspan="4"><img style="width: 200px; height: 200px;"
					id="img" src="/resources/images/${map.gdto.filename}"></td>
			</tr>
			<tr>
				<td align="center">상품명&nbsp;</td>
				<td><input type="text" name="goodname" id="goodname"
					value="${map.gdto.goodname}" readonly></td>

			</tr>

			<tr>
				<td align="center">개당 가격&nbsp;</td>
				<td><input type="text" name="price" id="price"
					value="${map.gdto.price}" readonly>원</td>
			</tr>

			<tr>
				<td align="center">갯수&nbsp;</td>
				<td><input type="text" name="amount" id="amount"
					value="${map.amount}" readonly>개</td>
			</tr>



		</table>

		<table>
			<tr align="right">
				<td align="right">총 주문금액 : ${map.totalPrice}원</td>
				<td><input type="button" value="결제하기" onclick="buy()"></td>
			</tr>
		</table>
		<input type="hidden" name="userid" value="${sessionScope.userid }">
		<input type="hidden" name="totalPrice" value="${map.totalPrice}">
		<input type="hidden" name="filename" value="${map.gdto.filename}">
		<input type="hidden" name="goodidx" value="${map.gdto.goodidx}">
	</form>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<div id="footer">
		<%@ include file="../main/footer.jsp"%>
	</div>
</body>
</html>