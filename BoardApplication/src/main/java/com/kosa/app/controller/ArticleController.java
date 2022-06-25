package com.kosa.app.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.DirectoryNotEmptyException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kosa.app.dto.ArticleDTO;
import com.kosa.app.dto.AttachDTO;
import com.kosa.app.service.ArticleService;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Log4j
@Controller
@RequestMapping("article/{page}")
public class ArticleController {
	@Value("${articlePerPage}")
	private int articlePerPage; // 한 페이지에 보여지는 게시물의 개수
	
	@Value("${blockPerPage}")
	private int blockPerPage; // 한 페이지에 보여지는 페이지 블록의 개수
	
	@Value("${uploadPath}")
	private String uploadPath; // 파일 업로드 경로
	
	// 생성자 주입
	private ArticleService service;
	public ArticleController(ArticleService service) {
		this.service = service;
	}
	
	// 오늘 날짜의 경로를 문자열로 생성하는 메소드
	private String getFolderPath() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String str = sdf.format(new Date());
		return str.replace("-", "/");
	}
	
	// 특정 파일이 이미지 타입인지 검사하는 메소드
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	// 게시글 목록 불러오기
	@GetMapping("/")
	public String getArticleList(@PathVariable("page") long page, Model model) {
		try {
			// 전체 게시물의 개수
			long articleCount = service.getArticleCount();
			// 전체 페이지 개수 = 전체 게시물 개수 / 한 페이지에 보여지는 게시물의 개수
			long pageCount = articleCount / articlePerPage;
			// 예를 들어, 게시물의 개수가 101개인 경우, 11페이지 필요하므로 총 페이지의 개수를 증가시켜준다.
			if(articleCount % articlePerPage != 0) pageCount++;
			
			// 시작 페이지 = (현재 페이지-1) / 페이지 블록 크기 * 페이지 블록 크기 + 1
			long startPage = (page-1) / blockPerPage * blockPerPage + 1;
			// 마지막 페이지 = (현재 페이지-1) / 페이지 블록 크기 * 페이지 블록 크기 + 페이지 블록 크기
			long endPage = (page-1) / blockPerPage * blockPerPage + blockPerPage;
			// 마지막 페이지 개수가 전체 페이지 개수보다 많은 경우, 마지막 페이지를 전체 페이지 개수로 맞춰준다.
			if(endPage > pageCount) endPage = pageCount;
			
			List<ArticleDTO> list = service.getArticleList(page);
			model.addAttribute("list", list);
			model.addAttribute("page", page);
			model.addAttribute("startPage", startPage);
			model.addAttribute("endPage", endPage);
			model.addAttribute("pageCount", pageCount);
			model.addAttribute("articleCount", articleCount);
			model.addAttribute("articlePerPage", articlePerPage);
			return "article.list";
		} catch (Exception e) {
			log.info(e.getMessage());
			model.addAttribute("msg", "Error : getArticleList()");
			model.addAttribute("url", "javascript:history.back();");
			return "result";
		}
	}
	
	// 게시글 등록하기(GET)
	@GetMapping("insert")
	public String insertArticle() {
		return "article.insert";
	}

	// 게시글 등록하기(POST)
	@PostMapping("insert")
	@ResponseBody // 클라이언트의 요청에 JSON 데이터 형식으로 응답하기 위해서 사용
	public String insertArticle(
		@RequestParam String title, @RequestParam String author,
		@RequestParam String password, @RequestParam String content,
		@PathVariable long page, Model model) {
		try {
			ArticleDTO articleDTO = new ArticleDTO();
			articleDTO.setTitle(title); articleDTO.setAuthor(author);
			articleDTO.setPassword(password); articleDTO.setContent(content);

			File uploadFolder = new File(uploadPath, getFolderPath());
			if(uploadFolder.exists()==false) {
				uploadFolder.mkdirs();
			}
			
			List<AttachDTO> list = new ArrayList<>();
			File tempUploadFolder = new File(uploadPath+"temp");
			for(File tempFile : tempUploadFolder.listFiles()) { 
				UUID uuid = UUID.randomUUID();
				String uploadFileName = tempFile.getName();
				uploadFileName = uuid.toString() + "_" + uploadFileName;
				
				// temp 폴더에 존재하는 파일들을 업로드용 폴더로 이동
				File saveFile = new File(uploadFolder, uploadFileName);
				if(tempFile.renameTo(saveFile)) log.info("파일 업로드 성공 : " + uploadFileName);
				
				AttachDTO attachDTO = new AttachDTO();
				attachDTO.setFname(tempFile.getName());
				attachDTO.setFpath(getFolderPath());
				attachDTO.setUuid(uuid.toString());
				if(checkImageType(saveFile)) {
					attachDTO.setFtype(1);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadFolder, "s_" + uploadFileName));
					Thumbnailator.createThumbnail(new FileInputStream(saveFile), thumbnail, 100, 100);
					thumbnail.close();
				}
				list.add(attachDTO);
			}
			service.insertArticle(articleDTO, list);
			log.info("글쓰기 성공");
		} catch (Exception e) {
			log.info(e.getMessage());
			return "2";
		}
		return "1";
	}
	
	// 게시글 쓰기 페이지에서 파일을 추가할 때마다 temp 폴더로 업로드
	@PostMapping("**/uploadAttach")
	@ResponseBody // 클라이언트의 요청에 JSON 데이터 형식으로 응답하기 위해서 사용
	public String uploadAttach(MultipartFile[] attach) {
		try {
			File uploadFolder = new File(uploadPath+"temp");
			if(uploadFolder.exists()==false) {
				uploadFolder.mkdirs();
			}
			
			for(MultipartFile multipartFile : attach) {
				log.info("------------------------------------------------");
				log.info("Original File Name : " + multipartFile.getOriginalFilename());
				log.info("Original File Size : " + multipartFile.getSize());
				
				String uploadFileName = multipartFile.getOriginalFilename();
				File saveFile = new File(uploadFolder, uploadFileName);
				multipartFile.transferTo(saveFile);
			}
		} catch(Exception e) {
			log.info(e.getMessage());
			return "2";
		}
		return "1";
	}
	
	// 게시글 쓰기 페이지에서 'X' 버튼을 눌러서 첨부파일을 삭제
	@PostMapping("**/deleteAttach")
	@ResponseBody
	public String deleteAttach(String fileName) {
		log.info(fileName);
		try {
			File tempFile = new File(uploadPath+"temp", fileName);
			Path filePath = Paths.get(tempFile.getAbsolutePath());
			Files.deleteIfExists(filePath);
			log.info("파일 삭제 성공 : " +tempFile.getAbsolutePath());
		} catch (DirectoryNotEmptyException e) {
			log.info("Directory is not empty.");
			return "3";
		} catch (IOException e) {
			log.info(e.getMessage());
			return "2";
		}
		return "1";
	}
	
	// 게시글 쓰기 페이지에서 '취소' 버튼을 눌러서 첨부파일 전체 삭제
	@PostMapping("**/deleteAttachAll")
	@ResponseBody
	public String deleteAttachAll() {
		try {
			File tempUploadFolder = new File(uploadPath+"temp");
			for(File tempFile : tempUploadFolder.listFiles()) {
				Path filePath = Paths.get(tempFile.getAbsolutePath());
				Files.deleteIfExists(filePath);
				log.info("파일 삭제 성공 : " +tempFile.getAbsolutePath());
			}
		} catch (DirectoryNotEmptyException e) {
			log.info("Directory is not empty.");
			return "3";
		} catch (Exception e) {
			log.info(e.getMessage());
			return "2";
		}
		return "1";
	}
}