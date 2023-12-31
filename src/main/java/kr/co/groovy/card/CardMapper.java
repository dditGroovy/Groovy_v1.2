package kr.co.groovy.card;

import kr.co.groovy.utils.ParamMap;
import kr.co.groovy.vo.CardReservationVO;
import kr.co.groovy.vo.CardVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CardMapper {

    int inputCard(CardVO cardVO);

    List<CardVO> loadAllCard();

    int modifyCardNm(CardVO cardVO);

    int modifyCardStatusDisabled(String cprCardNo);

    List<CardReservationVO> loadCardWaitingList();

    int assignCard(CardReservationVO cardReservationVO);

    List<CardReservationVO> loadAllResveRecords();

    int returnChecked(CardReservationVO cardReservationVO);

    /* */
    int inputRequest(CardReservationVO cardReservationVO);

    CardReservationVO loadRequestDetail(int cprCardResveSn);

    List<CardReservationVO> loadCardRecord(String emplId);

    void modifyStatus(ParamMap map);

    List<CardReservationVO> loadSanctionList();
}
