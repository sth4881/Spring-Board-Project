package com.kosa.app.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kosa.app.dto.AttachDTO;

public interface AttachMapper {
	List<AttachDTO> getAttachList(@Param("ano") long ano) throws Exception;
	
	void insertAttachFile(AttachDTO dto) throws Exception;

	void deleteAttachFiles(@Param("ano") long ano) throws Exception;
}
