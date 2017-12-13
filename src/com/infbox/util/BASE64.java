package com.infbox.util;


import java.io.IOException;
import java.io.UnsupportedEncodingException;

import org.apache.commons.codec.binary.Base64;

/**
 * BASE64编码解码
 * @author Administrator
 *
 */
public class BASE64 {
	public BASE64(){
		
	}
	
	/**
	 * 加密
	 * @param s
	 * @return
	 */
	public static String encode (String s){
		String encoderStr = "";
		try {
			encoderStr = Base64.encodeBase64String(s.getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return encoderStr;
	}
	
	/**
	 * 解密
	 * @param s
	 * @return
	 */
	public static String decode (String s){ 
		try {
			byte[] temp = Base64.decodeBase64(s);
			return new String(temp, "UTF-8");
		} catch (IOException ioe) { 
			ioe.printStackTrace();
		}
		return s;
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
//		String str="001132522198101153210	123456	2	6000	163828941	nihao	2	1	1	0	2020-09-15";
		System.out.println(BASE64.encode("你好"));
	}

}