package com.ssafy.star.message.repository;

import com.ssafy.star.message.dto.response.ReceiveMessageListResponse;
import com.ssafy.star.message.dto.response.SendMessageListProjection;
import com.ssafy.star.message.entity.MessageBox;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface MessageBoxRepository extends JpaRepository<MessageBox, Long> {
    @Query("SELECT mb.message.id FROM MessageBox mb WHERE mb.member.id = :memberId AND mb.messageDirection = :messageDirection")
    List<Long> getMessageIdByMemberId(Long memberId, short messageDirection);

    @Query("SELECT mb.member.nickname FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.messageDirection = :messageDirection")
    String getRecipientNameByMessageId(Long messageId, short messageDirection);

    @Query("SELECT mb.member.nickname FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.messageDirection = :type AND mb.state = :state")
    String getRecipientNameByMessageIdAndState(Long messageId, short type, boolean state);

    @Query(value = "SELECT m.nickname FROM message_box mb JOIN member m ON mb.member_id = m.id WHERE mb.message_id = :messageId AND mb.message_direction = :type LIMIT 1", nativeQuery = true)
    String findMemberNicknameByMessageId(@Param("messageId") Long messageId, @Param("type") short type);

    @Query("SELECT count(*) FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.messageDirection = :messageDirection")
    int getMemberCountByMessageId(Long messageId, short messageDirection);

    @Query("SELECT mb.member.nickname FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.messageDirection = :messageDirection")
    List<String> getRecipientNamesByMessageId(Long messageId, short messageDirection);

    boolean existsByMemberIdAndMessageIdAndMessageDirection(Long memberId, Long messageId, short messageDirection);

    boolean existsByMemberIdAndMessageId(Long memberId, Long messageId);

    @Query("SELECT mb.isDeleted FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.member.id = :memberId")
    boolean existsByMessageIdAndMemberIdAndIsDeletedFalse(Long messageId, Long memberId);

    @Transactional
    @Modifying
    @Query("UPDATE MessageBox mb SET mb.isDeleted = true WHERE mb.message.id = :messageId AND mb.member.id = :memberId")
    void updateIsDeletedByMessageIdAndMemberId(Long messageId, Long memberId);

    @Query("SELECT mb.isReported FROM MessageBox mb WHERE mb.member.id = :memberId AND mb.message.id = :messageId")
    boolean existsByMemberIdAndMessageIdAndIsReportedTrue(Long memberId, Long messageId);

    @Transactional
    @Modifying
    @Query("UPDATE MessageBox mb SET mb.isReported = true WHERE mb.message.id = :messageId AND mb.member.id = :memberId")
    void updateIsReportedByMessageIdAndMemberId(Long messageId, Long memberId);

    @Query("SELECT mb.state FROM MessageBox mb WHERE mb.member.id = :memberId AND mb.message.id = :messageId AND mb.messageDirection = :messageDirection")
    boolean existsByMemberIdAndMessageIdAndStateTrue(Long memberId, Long messageId, short messageDirection);

    @Transactional
    @Modifying
    @Query("UPDATE MessageBox mb SET mb.state = true WHERE mb.message.id = :messageId AND mb.member.id = :memberId AND mb.messageDirection = :messageDirection")
    void updateStateByMessageIdAndMemberId(Long messageId, Long memberId, short messageDirection);

    @Query("SELECT count(*) FROM MessageBox mb WHERE mb.member.id = :memberId AND mb.messageDirection = :messageDirection AND mb.state = false")
    int existsByMemberIdANDMessageDirection(Long memberId, short messageDirection);



    // Message Box에서
    // memberId, messageDirection,isDeleted 조건으로 messageId와 state 조회해서
    // messageId로 message에서 조회 할 건데 만약에 message의 is_treasure 속성이 true이면 state가 true 인것만, false이면 state가 true/false 인
    // message의 m. id, m. title, m. receiverType, m. sender. nickname, m. createdAt, m. isTreasure, mb. state 조회하는 쿼리
    @Query("SELECT new com.ssafy.star.message.dto.response.ReceiveMessageListResponse(" +
            "m.id, m.title, m.receiverType, m.sender.nickname, m.createdAt, m.isTreasure, mb.state) " +
            "FROM MessageBox mb " +
            "JOIN mb.message m " +
            "WHERE mb.member.id = :memberId " +
            "AND mb.messageDirection = :messageDirection " +
            "AND mb.isDeleted = false " +
            "AND ((m.isTreasure = true AND mb.state = true) OR (m.isTreasure = false))")
    List<ReceiveMessageListResponse> findReceivedMessageList(Long memberId, short messageDirection);

    @Query("SELECT new com.ssafy.star.message.dto.response.ReceiveMessageListResponse(" +
            "m.id, m.title, m.receiverType, m.sender.nickname, m.createdAt, m.isTreasure, mb.state) " +
            "FROM MessageBox mb " +
            "JOIN mb.message m " +
            "WHERE mb.member.id = :memberId " +
            "AND mb.messageDirection = :messageDirection " +
            "AND mb.isDeleted = false " +
            "AND m.isTreasure = :isTreasure " +
            "AND (:state IS NULL OR mb.state = :state)")
    List<ReceiveMessageListResponse> findReceivedMessageListByIsTreasure(Long memberId, short messageDirection,
                                                                         boolean isTreasure, Boolean state);

//    @Query("SELECT new com.ssafy.star.message.dto.response.SendMessageListResponseDto(" +
//            "m.id, m.title,m.receiver ,m.receiverType, m.createdAt, m.isTreasure, mb.state, m.group.id, m.isFound) " +
//            "FROM MessageBox mb " +
//            "JOIN mb.message m " +
//            "WHERE mb.member.id = :memberId " +
//            "AND mb.messageDirection =0" +
//            "AND mb.isDeleted = false ")
//    List<SendMessageListResponseDto> findSendMessageList(@Param("memberId") Long memberId);


    // MessageBoxRepository.java

    @Query("""
    SELECT COUNT(mb) > 0
    FROM MessageBox mb
    WHERE mb.message.id = :messageId
    AND mb.member.id = :memberId
    AND mb.messageDirection = :messageDirection
    AND mb.isDeleted = false
""")
    boolean existsByMessageIdAndMemberIdAndMessageDirectionAndIsDeletedFalse(
            @Param("messageId") Long messageId,
            @Param("memberId") Long memberId,
            @Param("messageDirection") short messageDirection);


    /*
     *
     *
     * 개선된 쿼리 V1 : receiver 라는 리스트로 받는 대상에 대한 정보 받고 receiver_type을 1개 더 추가해서
     *                  비그룹 단체 쪽지와 그룹 단체 쪽지를 나눈 후 receiver_type에 따라 처리하는 쿼리
     *
     * */
//    @Query(value = """
//    SELECT
//        m.id AS messageId,
//        m.title,
//        CASE
//            WHEN m.receiver_type = 0 THEN (SELECT mem.nickname FROM member mem WHERE mem.id = m.receiver[1])
//            WHEN m.receiver_type = 1 THEN (SELECT mem.nickname || ' 외 ' || (array_length(m.receiver, 1) - 1) || '명'  FROM member mem WHERE mem.id = m.receiver[1])
//            WHEN m.receiver_type = 2 THEN (SELECT mg.group_name FROM member_group mg WHERE mg.id = m.group_id)
//            WHEN m.receiver_type = 3 THEN COALESCE((SELECT mem.nickname FROM member mem WHERE mem.id = m.receiver[1]), '모두에게')
//        END AS recipient,
//        m.created_at AS createdAt,
//        m.is_treasure AS kind,
//        m.receiver_type AS receiverType,
//        m.group_id AS groupId,
//        m.is_found AS isFound
//    FROM message_box mb
//    JOIN message m ON mb.message_id = m.id
//    WHERE mb.member_id = :memberId
//      AND mb.message_direction = 0
//      AND mb.is_deleted = false
//""", nativeQuery = true)
//    List<SendMessageListProjection> findMessagesByMemberId(@Param("memberId") Long memberId);

    /*
    *
    *
    * 개선된 쿼리 V2 : 비 그룹 단체일경우 보물쪽지 찾았을때 OO외 0명으로 응답되는 문제 해결한것
    *
    * */

  @Query(value = """
   SELECT
   m.id AS messageId,
   m.title,
   CASE
       WHEN m.receiver_type = 0 THEN mem.nickname
       WHEN m.receiver_type = 1 THEN
           CASE
               WHEN m.is_treasure = true AND m.is_found = true THEN mem.nickname
               ELSE mem.nickname || ' 외 ' || (array_length(m.receiver, 1) - 1) || '명'
           END
       WHEN m.receiver_type = 2 THEN mg.group_name
       WHEN m.receiver_type = 3 THEN COALESCE(mem.nickname, '모두에게')
   END AS recipient,
   m.created_at AS createdAt,
   m.is_treasure AS kind,
   m.receiver_type AS receiverType,
   m.group_id AS groupId,
   m.is_found AS isFound
FROM
   message_box mb
JOIN
   message m ON mb.message_id = m.id
LEFT JOIN
   member mem ON mem.id = m.receiver[1]
LEFT JOIN
   member_group mg ON mg.id = m.group_id
WHERE
   mb.member_id = :memberId
   AND mb.message_direction = 0
   AND mb.is_deleted = false;
""", nativeQuery = true)
    List<SendMessageListProjection> findMessagesByMemberId2(@Param("memberId") Long memberId);

/*
*
*
*
*  개선된 쿼리 V3: 개선된 버전에서 기존에 확인하던걸 receiver 배열이 길이가 1이상이면 그냥 외 N명 붙이기
*
* */


    @Query(value = """
    SELECT
        m.id AS messageId,
        m.title,
        CASE
            WHEN m.receiver_type = 0 THEN (SELECT mem.nickname FROM member mem WHERE mem.id = m.receiver[1])
            WHEN m.receiver_type = 1 THEN (
                    SELECT mem.nickname || 
                      CASE
                           WHEN array_length(m.receiver, 1) > 1 THEN ' 외 ' || (array_length(m.receiver, 1) - 1) || '명'
                           ELSE ''
                      END
                   FROM member mem
                   WHERE mem.id = m.receiver[1])
            WHEN m.receiver_type = 2 THEN (SELECT mg.group_name FROM member_group mg WHERE mg.id = m.group_id)
            WHEN m.receiver_type = 3 THEN COALESCE((SELECT mem.nickname FROM member mem WHERE mem.id = m.receiver[1]), '모두에게')
        END AS recipient,
        m.created_at AS createdAt,
        m.is_treasure AS kind,
        m.receiver_type AS receiverType,
        m.group_id AS groupId,
        m.is_found AS isFound
    FROM message_box mb
    JOIN message m ON mb.message_id = m.id
    WHERE mb.member_id = :memberId
      AND mb.message_direction = 0
      AND mb.is_deleted = false
""", nativeQuery = true)
    List<SendMessageListProjection> findMessagesByMemberId(Long memberId);

    // 일반, 보물 송신 리스트
    @Query(value = """
    SELECT
        m.id AS messageId,
        m.title,
        CASE
            WHEN m.receiver_type = 0 THEN (SELECT mem.nickname FROM member mem WHERE mem.id = m.receiver[1])
            WHEN m.receiver_type = 1 THEN (
                    SELECT mem.nickname || 
                      CASE
                           WHEN array_length(m.receiver, 1) > 1 THEN ' 외 ' || (array_length(m.receiver, 1) - 1) || '명'
                           ELSE ''
                      END
                   FROM member mem
                   WHERE mem.id = m.receiver[1])
            WHEN m.receiver_type = 2 THEN (SELECT mg.group_name FROM member_group mg WHERE mg.id = m.group_id)
            WHEN m.receiver_type = 3 THEN COALESCE((SELECT mem.nickname FROM member mem WHERE mem.id = m.receiver[1]), '모두에게')
        END AS recipient,
        m.created_at AS createdAt,
        m.is_treasure AS kind,
        m.receiver_type AS receiverType,
        m.group_id AS groupId,
        m.is_found AS isFound
    FROM message_box mb
    JOIN message m ON mb.message_id = m.id
    WHERE mb.member_id = :memberId
      AND mb.message_direction = 0
      AND mb.is_deleted = false
        AND m.is_treasure = :isTreasure
""", nativeQuery = true)
    List<SendMessageListProjection> findMessagesByMemberIdANDIsTreasure(Long memberId, boolean isTreasure);

/*
* 
*  개선된 쿼리 V4: 쿼리를 나눔
* 
* */
    
    
    
    @Query(value = """
    SELECT 
        m.id AS messageId,
        m.title,
        (SELECT mem.nickname FROM member mem WHERE mem.id = m.receiver[1]) AS recipient,
        m.created_at AS createdAt,
        m.is_treasure AS kind,
        m.receiver_type AS receiverType,
        m.group_id AS groupId,
        m.is_found AS isFound
    FROM message_box mb
    JOIN message m ON mb.message_id = m.id
    WHERE mb.member_id = :memberId
      AND mb.message_direction = 0
      AND mb.is_deleted = false
      AND m.receiver_type = 0

    UNION ALL

    SELECT 
        m.id AS messageId,
        m.title,
        (SELECT mem.nickname || 
            CASE 
                WHEN array_length(m.receiver, 1) > 1 THEN ' 외 ' || (array_length(m.receiver, 1) - 1) || '명'
                ELSE ''
            END
        FROM member mem WHERE mem.id = m.receiver[1]) AS recipient,
        m.created_at AS createdAt,
        m.is_treasure AS kind,
        m.receiver_type AS receiverType,
        m.group_id AS groupId,
        m.is_found AS isFound
    FROM message_box mb
    JOIN message m ON mb.message_id = m.id
    WHERE mb.member_id = :memberId
      AND mb.message_direction = 0
      AND mb.is_deleted = false
      AND m.receiver_type = 1

    UNION ALL

    SELECT 
        m.id AS messageId,
        m.title,
        (SELECT mg.group_name FROM member_group mg WHERE mg.id = m.group_id) AS recipient,
        m.created_at AS createdAt,
        m.is_treasure AS kind,
        m.receiver_type AS receiverType,
        m.group_id AS groupId,
        m.is_found AS isFound
    FROM message_box mb
    JOIN message m ON mb.message_id = m.id
    WHERE mb.member_id = :memberId
      AND mb.message_direction = 0
      AND mb.is_deleted = false
      AND m.receiver_type = 2

    UNION ALL

    SELECT 
        m.id AS messageId,
        m.title,
        COALESCE((SELECT mem.nickname FROM member mem WHERE mem.id = m.receiver[1]), '모두에게') AS recipient,
        m.created_at AS createdAt,
        m.is_treasure AS kind,
        m.receiver_type AS receiverType,
        m.group_id AS groupId,
        m.is_found AS isFound
    FROM message_box mb
    JOIN message m ON mb.message_id = m.id
    WHERE mb.member_id = :memberId
      AND mb.message_direction = 0
      AND mb.is_deleted = false
      AND m.receiver_type = 3
""", nativeQuery = true)
    List<SendMessageListProjection> findMessagesByMemberId4(@Param("memberId") Long memberId);




}
