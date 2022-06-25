package com.kosa.app.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.kosa.app.dto.ReplyDTO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
public class ReplyMapperTest {
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	private long[] anoArr = { 1067L, 1061L, 1060L, 1056L, 1052L };
	
	@Test
	public void testInsert() {
		IntStream.rangeClosed(1, 10).forEach(i -> {
			ReplyDTO dto = new ReplyDTO();
			dto.setAno(anoArr[i%5]);
			dto.setReply("댓글 테스트" + i);
			dto.setReplyer("김경섭");
			dto.setPassword("1111");
			mapper.insertReply(dto);
		});
	}
	
	@Test
	public void testRead() {
		List<ReplyDTO> list = mapper.getReplyList(1056);
		for(ReplyDTO dto : list) {
			log.info(dto);
		}
	}
	
	@Test
	public void testDelete() {
		ReplyDTO dto = new ReplyDTO();
		dto.setAno(1061L);
		dto.setPassword("1111");
		//mapper.deleteReply(dto);
	}
	
	@Test
	public void testUpdate() {
		ReplyDTO dto = new ReplyDTO();
		dto.setAno(1060);
		dto.setPassword("1111");
		dto.setReply("테스트 댓글");
		log.info("UPDATE COUNT : " + mapper.updateReply(dto));
	}
}
