<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>목록보기</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
<link href="https://fonts.googleapis.com/css2?family=Anton&display=swap" rel="stylesheet" />
</head>
<body>
<fmt:requestEncoding value="UTF-8"/>
<!-- 헤더 -->
<div class="container bg-light mx-auto text-center my-5 p-3">
	<form onsubmit="doubleSubmitCheck(this, event);" action="./answer" method="post">
		<input id="pren" type="hidden" value="${prenums}" name="prenums"><!-- 오답리스트 저장 -->
		<input type="hidden" value="${answer}" name="answer"><!-- 정답저장 -->
		<input type="hidden" value="${chance}" name="chance"><!-- 남은횟수 -->
		<input type="hidden" value="${closeup}" name="closeup"><!-- up 숫자 중에 가장 근접값 -->
		<input type="hidden" value="${closedown}" name="closedown"><!-- down 숫자 중에 가장 근접값 -->
		
		<h2 class="my-3 fw-bold" style="font-family: 'Anton'"><i class="bi bi-caret-left"></i>Up Down Game <i class="bi bi-controller"></i><i class="bi bi-caret-right"></i></h2>
		
		<span><b class="bg-success-subtle">1부터 100까지</b>의 정수 중에서 하나의 숫자를 정했습니다.</span><br/>
		<span>당신이 정답을 외칠 수 있는 기회는 <b class="bg-danger-subtle">10번</b> 입니다.</span><br/>
		<span>추측한 숫자의 결과는 입력박스 아래에서 표시됩니다. </span><br/><br/>
		
		<h3 class="my-3 fw-bold text-success" style="font-family: 'Anton'"> How To Play <i class="bi bi-android2 text-success"></i><i class="bi bi-question-lg text-success"></i></h3>
		<span>숫자를 입력하고 추측하기 버튼을 누르세요...</span><br/>
		<span>결과가 <b class="text-danger">Up <i class="bi bi-arrow-up-circle-fill"></i></b> 로 시작하면 더 큰 숫자를 입력하고,</span><br/>
		<span><b class="text-primary">Down <i class="bi bi-arrow-down-circle-fill"></i></b> 로 시작하면 더 작은 숫자를 입력하세요. </span><br/>
		
		<c:if test="${chance > 0}">
			<input id="tryn" class="mt-3" name="trynum" type="number" min="1" max="100" step="1" required="required" />
			<button class="btn btn-sm btn-danger" type="submit">추측하기</button><br/><br/>
		</c:if>
		<c:if test="${chance == 0}">
			<input class="mt-3" name="trynum" type="number" min="1" max="100" step="1" required="required" disabled="disabled" />
			<button class="btn btn-sm btn-danger" type="submit" disabled="disabled">추측하기</button><br/><br/>
		</c:if>
		
		<b>${result}</b><br/><br/><!-- 중간 결과 출력 -->
		<c:if test="${result2 != null}"><!-- 게임이 끝나면 -->
			<b>${result2}</b><br/><br/><!-- 최종정답 공개 -->
		</c:if>
		
		<c:if test="${prenums != null}">
			<b>입력한 오답<i class="bi bi-arrow-right fw-bold text-dark"></i>  
				<c:forEach var="num" items="${prenums}">
					<c:if test="${num < answer}">
						${num} <i class="bi bi-arrow-up-circle-fill text-danger"></i>
					</c:if>
					<c:if test="${num > answer}">
						${num} <i class="bi bi-arrow-down-circle-fill text-primary"></i>
					</c:if>
				
				</c:forEach>
			</b><!-- 결과저장 -->
			<br/><br/>
		</c:if>
	</form>
	<button class="btn btn-sm btn-dark" type="button" onclick="location.href='./restart'">다시하기</button><br/><br/>
</div>

<script>
// submit 버튼이 눌리면 폼을 가지고 실행되는 함수
function doubleSubmitCheck(form, e){
	//일단 submit 중지
    e.preventDefault();
	
	// 변수들을 받는다.(자동으로 문자열이 된다.)
	let trynum = form.tryn.value; // 입력한 정답
	let prenums = form.pren.value; // 오답리스트
	let prenums2 = prenums.replace("[", "").replace("]",""); //오답리스트 대괄호 제거
	//console.log(trynum + ' =======try ');
	//console.log(prenums + ' =======pre ');
	//console.log(prenums2 + ' =======pre2 ');
	let aaa = [];//배열 선언
	aaa = prenums2.split(', '); // 스프릿한 문자 토큰들 배열 입력
	//console.log(aaa);
	let closeup = ~~form.closeup.value; // 정답에 가장 근접한 up숫자(~~ : parseint)
	let closedown = ~~form.closedown.value; // 정답에 가장 근접한 downs숫자
	//console.log(closeup + '========================')
	//console.log(typeof(closeup))
	//console.log(closedown + '========================')
	
	// trynum이 aaa 배열에 포함되어 있으면 
	if(aaa.indexOf(trynum) != -1){ //indexOf => 포함된 값이 없으면 -1을 리턴한다.
    	alert('이미 입력한 오답입니다.');
        return false; // submit 중지 및 경고창 출력
    } 
	else if (closeup != 0 && trynum < closeup) {
		
    	alert(closeup + ' 보다 커야 된다고!!!! 돌대가리세요?');
        return false; // submit 중지 및 경고창 출력
    } 
	else if (closedown != 0 && trynum > closedown) {
		
    	alert(closedown + ' 보다 작은 수라고!!!! 새대가리세요?');
        return false; // submit 중지 및 경고창 출력
    } 
	else{
		
        form.submit();
        return false; // submit 계속 진행
    }
}
</script>


<!-- 풋터 -->
<footer id="footer-wrapper" class="container-fluid bg-dark fixed-bottom">
	<div id="footer" class="container-fluid text-center text-white">
		&copy; Copywrite Team TAG
	</div>
</footer>
</body>
</html>