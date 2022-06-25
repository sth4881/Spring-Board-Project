package com.kosa.app.service;

import java.util.List;

import com.kosa.app.dto.ReplyDTO;

public interface ReplyService {
	List<ReplyDTO> getReplyList(long ano);
	
	int insertReply(ReplyDTO dto) throws Exception;
	
	int updateReply(ReplyDTO dto) throws Exception;

	int deleteReply(ReplyDTO dto) throws Exception;
}
