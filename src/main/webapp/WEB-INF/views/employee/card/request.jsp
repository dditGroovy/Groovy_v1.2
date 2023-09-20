<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">
        <h1>법인카드 신청</h1>
        <div>
            <form action="${pageContext.request.contextPath}/card/request" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <table border="1">
                    <input type="hidden" name="cprCardResveEmplId" value="${CustomUser.employeeVO.emplId}"/>
                    <tr>
                        <th>기간</th>
                        <td>
                            <input type="date" name="cprCardResveBeginDate" id="startDay" placeholder="시작 날짜"> ~
                            <input type="date" name="cprCardResveClosDate" id="endDay" placeholder="끝 날짜">
                        </td>
                    </tr>
                    <tr>
                        <th>사용처</th>
                        <td>
                            <input type="text" name="cprCardUseLoca" id="useLocation">
                        </td>
                    </tr>
                    <tr>
                        <th>사용목적</th>
                        <td>
                            <textarea name="cprCardUsePurps" id="content" cols="30" rows="10"
                                      placeholder="사용 목적"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>사용예상금액</th>
                        <td>
                            <input type="number" name="cprCardUseExpectAmount" id="amount">
                        </td>
                    </tr>
                </table>
                <button type="submit" id="save">저장하기</button>
            </form>
        </div>
        <div>
            <h2>법인카드 신청 기록</h2>
            <table border="1">
                <tr>
                    <td>신청 번호</td>
                    <td>사용 기간</td>
                    <td>사용처</td>
                    <td>사용 목적</td>
                    <td>상신 여부</td>
                </tr>
                <c:forEach var="recodeVO" items="${cardRecord}" varStatus="stat">
                    <tr>
                        <td><a href="/card/detail/${recodeVO.cprCardResveSn}">${recodeVO.cprCardResveSn}</a></td>
                        <td>${recodeVO.cprCardResveBeginDate} - ${recodeVO.cprCardResveClosDate}</td>
                        <td>${recodeVO.cprCardUseLoca}</td>
                        <td>${recodeVO.cprCardUsePurps}</td>
                        <td>${recodeVO.commonCodeYrycState == 'YRYC031'? '상신' : '미상신'}</td>
                    </tr>
                </c:forEach>
            </table>
        </div>
</sec:authorize>