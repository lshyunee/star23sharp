package com.ssafy.star.message.repository;

import com.ssafy.star.message.entity.MessageBox;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface MessageBoxRepository extends JpaRepository<MessageBox, Long> {
    @Query("SELECT mb.message.id FROM MessageBox mb WHERE mb.member.id = :memberId AND mb.messageDirection = :type")
    List<Long> getMessageIdByMemberId(Long memberId, short type);

    @Query("SELECT mb.member.nickname FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.messageDirection = :type")
    String getRecipientNameByMessageId(Long messageId, short type);

    @Query("SELECT mb.member.nickname FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.messageDirection = :type AND mb.state = :state")
    String getRecipientNameByMessageIdAndState(Long messageId, short type, boolean state);

    @Query(value = "SELECT m.nickname FROM message_box mb JOIN member m ON mb.member_id = m.id WHERE mb.message_id = :messageId AND mb.message_direction = :type LIMIT 1", nativeQuery = true)
    String findMemberNicknameByMessageId(@Param("messageId") Long messageId, @Param("type") short type);

    @Query("SELECT count(*) FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.messageDirection = :type")
    int getMemberCountByMessageId(Long messageId, short type);

    @Query("SELECT mb.member.nickname FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.messageDirection = :type")
    List<String> getRecipientNamesByMessageId(Long messageId, short type);

    boolean existsByMemberIdAndMessageIdAndMessageDirection(Long memberId, Long messageId, short messageDirection);

    boolean existsByMemberIdAndMessageId(Long memberId, Long messageId);

    @Query("SELECT mb.isDeleted FROM MessageBox mb WHERE mb.message.id = :messageId AND mb.member.id = :memberId")
    boolean existsByMessageIdAndMemberIdAndIsDeletedFalse(Long messageId, Long memberId);

    @Transactional
    @Modifying
    @Query("UPDATE MessageBox mb SET mb.isDeleted = true WHERE mb.message.id = :messageId AND mb.member.id = :memberId")
    void updateIsDeletedByMessageIdAndMemberId(Long messageId, Long memberId);
}