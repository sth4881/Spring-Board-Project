package com.kosa.app.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kosa.app.dto.ReplyDTO;
import com.kosa.app.service.ReplyService;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("reply")
public class ReplyController {
	// 생성자 주입
	private ReplyService service;
	public ReplyController(ReplyService service) {
		this.service = service;
	}
	
	// 특정 게시물의 댓글 조회
	@PostMapping(value="/", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<ReplyDTO>> getReplyList(long ano) {
		try {
			List<ReplyDTO> replyList = service.getReplyList(ano);
			return new ResponseEntity<>(replyList, HttpStatus.OK);
		} catch (Exception e) {
			log.info(e.getMessage());
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	// 브라우저로부터 JSON 타입의 댓글 데이터를 받아서 댓글 처리 결과를 문자열로 알려준다.
	// @RequestBody를 통해서 JSON 데이터를 ReplyDTO 타입으로 변환하도록 지정한다.
	@PostMapping(value="insert", consumes="application/json", produces="text/plain; charset=utf-8")
	public ResponseEntity<String> insertReply(@RequestBody ReplyDTO dto) {
		log.info(dto);
		try {
			log.info("Reply Count : " + service.insertReply(dto));
			return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			log.info(e.getMessage());
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	/*
	// 특정 댓글 수정
	@RequestMapping(value="/{rno}", method = {RequestMethod.PUT, RequestMethod.PATCH},
		produces=MediaType.TEXT_PLAIN_VALUE, consumes="application/json")
	public ResponseEntity<String> updateReply(
		@PathVariable long rno, @RequestBody ReplyDTO dto) {
		dto.setRno(rno);
		try {
			log.info("Update Count : " + service.updateReply(dto));
			return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			log.info(e.getMessage());
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	
	// 특정 댓글 삭제
	@DeleteMapping(value="/{rno}", produces=MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> deleteReply(
			@PathVariable long rno, @RequestBody ReplyDTO dto) {
		dto.setRno(rno);
		try {
			log.info("Delete Count : " + service.deleteReply(dto));
			return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			log.info(e.getMessage());
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
	*/
}