package com.kosa.app.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kosa.app.dto.ReplyDTO;

public interface ReplyMapper {
	List<ReplyDTO> getReplyList(@Param("ano") long ano);
	
	int insertReply(ReplyDTO dto);
	
	int updateReply(ReplyDTO dto);
	
	int deleteReply(ReplyDTO dto);
}
