package com.kosa.app.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kosa.app.dto.ArticleDTO;

public interface ArticleMapper {
	long getArticleCount() throws Exception;

	List<ArticleDTO> getArticleList(@Param("startNum") long startNum, @Param("endNum") long endNum) throws Exception;

	ArticleDTO getArticleDetail(long ano) throws Exception;
	
	void updateViewCount(long ano) throws Exception;

	void insertArticle(ArticleDTO dto) throws Exception;

	int updateArticle(ArticleDTO dto) throws Exception;

	int deleteArticle(ArticleDTO dto) throws Exception;
}