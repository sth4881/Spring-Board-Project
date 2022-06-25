package com.kosa.app.dto;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class ArticleDTO {
	private long ano;
	private String title;
	private String content;
	private String author;
	private String password;
	private Date createdAt;
	private Date updatedAt;
	private int viewCount;
	private List<AttachDTO> list;
}