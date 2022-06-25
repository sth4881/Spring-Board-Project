package com.kosa.app.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyDTO {
	private long rno;
	private String reply;
	private String replyer;
	private String password;
	private Date createdAt;
	private Date updatedAt;
	private long ano;
}