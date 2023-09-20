<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 초기화</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/resources/favicon.svg">
</head>
<body>
<h1>비밀번호 초기화</h1>
<h2>사번을 입력해주세요</h2>

<label for="emplId">사번 <input type="text" name="emplId" id="emplId"></label>
<button>확인</button>
</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
    $("button").on("click", function () {
        let emplId = $("#emplId").val();
        $.ajax({
            url: "/employee/findTelNo",
            type: "post",
            data: {"emplId": emplId},
            success: function (result) {
                if (result == "exists") {
                    alert("등록된 휴대폰 번호로 임시 비밀번호를 전송합니다.");
                    $.ajax({
                        url: "/employee/findPassword",
                        data: {"emplId": emplId},
                        type: "post",
                        success: function (result) {
                            if (result == "success") {
                                alert("비밀번호가 초기화 되었습니다. 로그인 화면으로 이동합니다");
                                location.href = "/employee/signIn";
                            }
                        },
                        error: function (xhr, textStatus, error) {
                            console.log("AJAX 오류:", error);
                        }
                    })
                } else if (result == "null") {
                    alert("등록되지 않은 사번입니다. 다시 시도하거나 인사팀에 연락하세요");
                }

            },
            error: function (xhr, textStatus, error) {
                console.log("AJAX 오류:", error);
            }
        });
    })
</script>
</html>