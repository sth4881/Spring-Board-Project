package com.kosa.app.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kosa.app.dto.ArticleDTO;
import com.kosa.app.dto.AttachDTO;
import com.kosa.app.mapper.ArticleMapper;
import com.kosa.app.mapper.AttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class ArticleServiceImpl implements ArticleService {
	@Value("${articlePerPage}")
	private int articlePerPage;

	// Setter 메소드를 통해서 2개의 Mapper를 주입
	@Setter(onMethod_ = @Autowired)
	private ArticleMapper articleMapper;
	@Setter(onMethod_ = @Autowired)
	private AttachMapper attachMapper;
	
	@Override
	public long getArticleCount() throws Exception {
		return articleMapper.getArticleCount();
	}

	@Override
	public List<ArticleDTO> getArticleList(long page) throws Exception {
		long startNum = (page-1) * articlePerPage + 1;
		long endNum = page * articlePerPage;
		return articleMapper.getArticleList(startNum, endNum);
	}

	@Override
	public ArticleDTO getArticleDetail(long ano) throws Exception {
		if(ano<1) throw new RuntimeException("잘못된 접근입니다.");
		ArticleDTO dto = articleMapper.getArticleDetail(ano);
		articleMapper.updateViewCount(ano);
		return dto;
	}

	@Transactional
	@Override
	public void insertArticle(ArticleDTO dto, List<AttachDTO> list) throws Exception {
		articleMapper.insertArticle(dto); // 게시글을 생성
		if(list == null || list.size() <= 0) return;
		list.forEach(attach -> {
			attach.setAno(dto.getAno()); // 게시글 생성 후에 만들어진 게시글 번호를 가져와서 첨부파일에 각각 넣어줌 
			try {
				attachMapper.insertAttachFile(attach);
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}

	@Transactional
	@Override
	public void updateArticle(ArticleDTO dto) throws Exception {
		if(articleMapper.updateArticle(dto) != 1)
			throw new RuntimeException("게시물이 존재하지 않거나 비밀번호가 틀립니다.");
		else {
			attachMapper.deleteAttachFiles(dto.getAno()); // 기존 게시물 전체 삭제
			dto.getList().forEach(attach -> {
				attach.setAno(dto.getAno());
				try {
					attachMapper.insertAttachFile(attach);
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
		}
	}

	@Transactional
	@Override
	public void deleteArticle(ArticleDTO dto) throws Exception {
		if(articleMapper.deleteArticle(dto) == 1) attachMapper.deleteAttachFiles(dto.getAno());
		else throw new RuntimeException("게시물이 존재하지 않거나 비밀번호가 틀립니다.");
	}
	
	@Override
	public List<AttachDTO> getAttachList(long ano) throws Exception {
		return attachMapper.getAttachList(ano); // 게시물 번호(ano)에 대한 첨부파일 리스트 반환
	}
}