package com.kosa.app.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.kosa.app.dto.ReplyDTO;
import com.kosa.app.mapper.ReplyMapper;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class ReplyServiceImpl implements ReplyService {
	//생성자 주입
	private ReplyMapper mapper;
	public ReplyServiceImpl(ReplyMapper mapper) {
		this.mapper = mapper;
	}
	
	@Override
	public List<ReplyDTO> getReplyList(long ano) {
		return mapper.getReplyList(ano);
	}
	
	@Override
	public int insertReply(ReplyDTO dto) {
		return mapper.insertReply(dto);
	}

	@Override
	public int updateReply(ReplyDTO dto) {
		return mapper.updateReply(dto);
	}

	@Override
	public int deleteReply(ReplyDTO dto) {
		return mapper.deleteReply(dto);
	}
}
