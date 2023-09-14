<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>
    #modifyCardInfoBtn, #saveCardInfoBtn, #cancelModifyCardInfoBtn, #deleteCardBtn {
        display: none;
    }
</style>

<header>
    <h1>회사 카드 관리</h1>
    <h1>대여 내역 관리</h1>
</header>
<main>
    <h1>카드 등록</h1>
    <div id="registerCard">
        <form id="registerCardForm" method="post">
            <label for="cardName">카드 이름</label>
            <input type="text" id="cardName" name="cprCardNm" required><br/>
            <label for="cardNo">카드 번호</label>
            <input type="text" id="cardNo" name="cprCardNo" placeholder="0000-0000-0000-0000" required><br/>
            <labek for="cardCom">카드사</labek>
            <select name="cprCardChrgCmpny" id="cardCom">
                <option value="IBK기업은행">IBK기업은행</option>
                <option value="KB국민카드">KB국민카드</option>
                <option value="NH농협은행">NH농협은행</option>
                <option value="롯데카드">롯데카드</option>
                <option value="비씨카드">비씨카드</option>
                <option value="삼성카드">삼성카드</option>
                <option value="신한카드">신한카드</option>
                <option value="우리카드">우리카드</option>
                <option value="하나카드">하나카드</option>
                <option value="한국씨티은행">한국씨티은행</option>
                <option value="현대카드">현대카드</option>
            </select>
            <button id="registerCardBtn">등록</button>
        </form>
    </div>
    y65
    <hr/>
    <h1>카드 목록</h1>
    <div id="cardList"></div>
    <hr/>
    <h1>카드 기본 정보</h1>
    <div id="cardInfo">
        <button id="modifyCardInfoBtn">수정</button>
        <button id="saveCardInfoBtn">저장</button>
        <button id="cancelModifyCardInfoBtn">취소</button>
        <button id="deleteCardBtn">삭제</button>
        <form id="cardInfoForm" method="post">
            <table border="1">
                <tr>
                    <td>카드 이름</td>
                    <td id="selectedCardName"></td>
                </tr>
                <tr>
                    <td>카드 번호</td>
                    <td id="selectedCardNo"></td>
                </tr>
                <tr>
                    <td>카드 회사</td>
                    <td id="selectedCardCom"></td>
                </tr>
            </table>
        </form>
    </div>
    <hr/>
    <h1>카드 신청 미처리건 <span id="waitingListCnt" style="color: dodgerblue">${waitingListCnt}</span></h1>
    <div id="cardWaitingList">
        <table>
            <tr>
                <th>순번</th>
                <th>사용 시작 일자</th>
                <th>사용 마감 일자</th>
                <th>사원명(사번)</th>
                <th>카드 지정</th>
            </tr>
            <c:forEach items="${loadCardWaitingList}" var="resve">
                <tr>
                    <td>${resve.cprCardResveSn}</td>
                    <td><fmt:formatDate value="${resve.cprCardResveBeginDate}" type="date" pattern="yyyy-MM-dd" /></td>
                    <td><fmt:formatDate value="${resve.cprCardResveClosDate}" type="date" pattern="yyyy-MM-dd" /></td>
                    <td>${resve.cprCardResveEmplNm}(${resve.cprCardResveEmplId})</td>
                    <td>
                        <select name="cprCardNo" class="selectedCard">

                        </select>
                        <button>저장</button>
                    </td>
                </tr>
            </c:forEach>
        </table>

    </div>
    <hr/>

</main>

<script>

    const cardListDiv = $("#cardList");
    let currentCardNo;
    let currentCardNm;

    loadAllCard();

    $("#registerCardBtn").on("click", function (event) {
        event.preventDefault();

        let cardNo = $("#cardNo").val();
        if (!isValidCardNumber(cardNo)) {
            alert("카드 번호 형식이 올바르지 않습니다.\n0000-0000-0000-0000 형식으로 입력하세요.");
            return;
        }

        let form = $("#registerCardForm")[0];
        let formData = new FormData(form);
        $.ajax({
            url: "/reserve/inputCard",
            type: "post",
            data: formData,
            contentType: false,
            processData: false,
            cache: false,
            success: function (result) {
                loadAllCard();
            },
            error: function (xhr) {
                console.log(xhr.responseText);
                alert("오류로 인한 실패")
            }
        })
    })

    function loadAllCard() {
        $.ajax({
            url: "/reserve/loadAllCard",
            type: "get",
            dataType: "json",
            success: function (result) {
                codeforList = "";
                codeforSelect = "";
                $.each(result, function (idx, obj) {
                    codeforList += `<button class="cards" id="\${obj.cprCardNo}">
                    <p id="btnCardNm">\${obj.cprCardNm}</p>
                    <p id="btnCardNo">\${obj.maskCardNo}</p>
                    <p id="btnCardCom">\${obj.cprCardChrgCmpny}</p>
                    <input type=hidden id="btnCardStatus" value="\${obj.cprCardSttus}">
                    </button><br/>`;

                    let cprCardSttus = obj.cprCardSttus

                    if(cprCardSttus == 0) {
                        codeforSelect += `<option value="\${obj.cprCardNo}">\${obj.cprCardNm}</option>`;
                    }
                });
                cardListDiv.html(codeforList);
                $(".selectedCard").append(codeforSelect);
            },
            error: function (xhr) {
                console.log(xhr.responseText);
                alert("실패");
            }
        })
    }

    cardListDiv.on("click", ".cards", function () {
        $("#saveCardInfoBtn").hide();
        $("#cancelModifyCardInfoBtn").hide();
        $("#modifyCardInfoBtn").show();
        $("#deleteCardBtn").show();

        let selectedCard = $(this);
        let selectedCardNo = selectedCard.attr("id");
        let selectedCardMarkNo = selectedCard.find("#btnCardNo").text();
        let selectedCardNm = selectedCard.find("#btnCardNm").text();
        let selectedCardCom = selectedCard.find("#btnCardCom").text();

        $("#selectedCardName").text(selectedCardNm);
        $("#selectedCardCom").text(selectedCardCom);
        $("#selectedCardNo").text(selectedCardMarkNo);

        currentCardNo = selectedCardNo;
        currentCardNm = selectedCardNm;
    })

    $("#modifyCardInfoBtn").on("click", function () {
        $("#selectedCardName").html(`<input type='text' id='newCardNm' value='\${currentCardNm}'>`);
        $(this).hide();
        $("#deleteCardBtn").hide();
        $("#saveCardInfoBtn").show();
        $("#cancelModifyCardInfoBtn").show();
    })

    $("#saveCardInfoBtn").on("click", function () {
        let newCardNm = $("#newCardNm").val();
        $("#selectedCardName").html('');
        $("#selectedCardName").text(newCardNm);

        let modifiedData = {
            cprCardNo: currentCardNo,
            cprCardNm: newCardNm
        }

        $.ajax({
            url: "/reserve/modifyCardNm",
            type: "post",
            data: JSON.stringify(modifiedData),
            contentType: "application/json;charset:utf-8",
            success: function (result) {
                if (result == 1) {
                    loadAllCard();
                } else {
                    alert("수정 실패")
                }
            },
            error: function (xhr) {
                console.log(xhr.responseText);
                alert("오류로 인한 실패");
            }
        })

        $(this).hide();
        $("#cancelModifyCardInfoBtn").hide();
        $("#modifyCardInfoBtn").show();
        $("#deleteCardBtn").show();
    })

    $("#cancelModifyCardInfoBtn").on("click", function () {
        $("#selectedCardName").html('');
        $("#selectedCardName").text(currentCardNm);

        $(this).hide();
        $("#saveCardInfoBtn").hide();
        $("#modifyCardInfoBtn").show();
        $("#deleteCardBtn").show();
    })

    $("#deleteCardBtn").on("click", function () {
        if (confirm(`'\${currentCardNm}' 카드를 사용불가 처리하시겠습니까?`)) {
            $.ajax({
                url: `/reserve/modifyCardUseAt/\${currentCardNo}`,
                type: "get",
                success: function (result) {
                    if (result == 1) {
                        loadAllCard();
                        $("#selectedCardName").html('');
                        $("#selectedCardNo").html('');
                        $("#selectedCardCom").html('');
                        alert("사용불가 처리 완료");
                    } else {
                        alert("사용불가 처리 실패")
                    }
                },
                error: function (xhr) {
                    console.log(xhr.responseText);
                    alert("오류로 인한 실패")
                }
            })
        } else {
            alert("사용불가 처리 취소");
        }
    })

    function isValidCardNumber(cardNumber) {
        let cardNumberPattern = /^\d{4}-\d{4}-\d{4}-\d{4}$/;
        return cardNumberPattern.test(cardNumber);
    }

</script>