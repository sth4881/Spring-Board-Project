package com.kosa.app.dto;

import lombok.Data;

@Data
public class AttachDTO {
	private String uuid; // 첨부파일 UUID
	private String fname; // 첨부파일 이름
	private String fpath; // 첨부파일 경로
	private long ftype; // 첨부파일 타입
	private long ano; // 게시글 번호
}