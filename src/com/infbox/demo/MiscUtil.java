package com.infbox.demo;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.bson.types.ObjectId;


import java.awt.Image;
import java.awt.image.*;
import java.io.File;

import com.sun.image.codec.jpeg.*;

import com.mongodb.BasicDBObject;
public class MiscUtil {	
	public static Boolean bDebug=true;


	//判断网页表单传来的SQL参数是否有SQL注入
	public static String checkSQLInjection(String str) 
	{ 
		return str.replaceAll(".*([';]+|(--)+).*", " "); 
	} 
	
	public static Date Str2Date(String dateString){
		Date date =null;
		try
		{
			SimpleDateFormat sdf = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");
			if(dateString.length()>15) date = sdf.parse(dateString);
			else if(dateString.length()<11) date = sdf.parse(dateString+" 01:01:01");
			}
		catch (ParseException e)
		{
			System.out.println(e.getMessage());
		}
		return date;

	}
	
	public static void checkdDir(String dir){
		File file =new File(dir);    
		//如果文件夹不存在则创建    
		if  (!file .exists()  && !file .isDirectory())      
		{       
		    System.out.println("创建目录:"+dir);  
		    file .mkdir();    
		}
	}
	public static String date2Str(Date dt) {
		if(dt==null) return "";
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(dt.getTime());
		
		//c.add(Calendar.HOUR_OF_DAY, 24);
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		return dateFormat.format(c.getTime());
		
	}
	public static String date2Str(Date dt,Boolean noTime) {
		if(dt==null) return "";
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(dt.getTime());
		
		//c.add(Calendar.HOUR_OF_DAY, 24);
		SimpleDateFormat dateFormat = null;
	if(noTime)	 dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd");
	else   dateFormat = new SimpleDateFormat(
	"yyyy-MM-dd HH:mm:ss");
	return dateFormat.format(c.getTime());
		
	}
	
	public static String todayPicPath() {
		Date dt=new Date();		
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(dt.getTime());
		
		//c.add(Calendar.HOUR_OF_DAY, 24);
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyyMMdd");
		return dateFormat.format(c.getTime());
		
	}
	
	public static String replace(String parentStr,String ch,String rep) { 
		int i = parentStr.indexOf(ch); 
		StringBuffer sb = new StringBuffer(); 
		if (i == -1) 
		return parentStr; 
		sb.append(parentStr.substring(0,i) + rep); 
		if (i+ch.length() < parentStr.length()) 
		sb.append(replace(parentStr.substring(i+ch.length(),parentStr.length()),ch,rep)); 
		return sb.toString(); 
		}
	
	public static Date nowTime() {
		/*Calendar c = Calendar.getInstance();
		c.setTimeInMillis(new Date().getTime());
		
		//c.add(Calendar.HOUR_OF_DAY, 24);
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		return dateFormat.format(c.getTime());*/
		return new Date();
	}
	
	public static String nowTime2Str() {
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(new Date().getTime());
		
		//c.add(Calendar.HOUR_OF_DAY, 24);
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		return dateFormat.format(c.getTime());		
	}
	
	public static Date getTomorrow() {
		
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(new Date().getTime());

		c.add(Calendar.HOUR_OF_DAY, 24);
		c.set(Calendar.HOUR_OF_DAY, 0);//明天0点
		return c.getTime();
		//SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		//return dateFormat.format(c.getTime());
	}
	
	public static Calendar getDayAfter(Date fromDate,int n) {//得到几天之后的时间
		Calendar c = Calendar.getInstance();
		if(fromDate==null) c.setTimeInMillis(new Date().getTime());
		else c.setTimeInMillis(fromDate.getTime());
		c.add(Calendar.HOUR_OF_DAY, n*24);		
		return c;
		
	}
	
	public static Date weekAfter() {
		Calendar c = Calendar.getInstance();
		c.setTimeInMillis(new Date().getTime());
		c.add(Calendar.DATE, 7);
		/*SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		return dateFormat.format(c.getTime());*/
		return c.getTime();
	}
	
	public static  void debug(String data){
		if (bDebug) System.out.println(nowTime()+":"+data);
	}
	

	public static String convertStr(String strIn, String sourceCode,
			String targetCode) {
		String strOut = null;
		if (strIn == null || (strIn.trim()).equals(""))
			return strIn;
		try {
			byte[] b = strIn.getBytes(sourceCode);
			//for (int i = 0; i < b.length; i++) {
			//	System.out.print(b[i] + "  ");
			//}
			//System.out.println("");
			//System.out.println("--------------------------------------------------------");
			String str = new String(b, sourceCode);
			byte[] c = str.getBytes(targetCode);

			strOut = new String(c, targetCode);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return strOut;
	}
	
	public static Boolean isValidEmail(String mail) {		
		
		 Pattern p = Pattern.compile("\\w+@(\\w+.)+[a-z]{2,3}");
		Matcher m = p.matcher(mail);
		 boolean b = m.matches();
		return b;
	}
	
	/**
     * Java��1��char���͵ı����ɴ洢��������1���ַ���1��ASC��ͻ�1�������ַ�
     * ���磺����3��ASC�ͺ���3�������ַ���ַ�����һ��ģ� "1ac".length()==3;  "���a".length()=3;
     * �����������ַ���ռ��byte�ǲ�һ��ģ�ǰ����3��������5��1������2byte����
     * ���д����:
     *     public static String leftStr(String source, int maxByteLen)
     * ��source��ȡ���maxByteLen��byte���Ӵ���
     * �����һ��byteǡ��Ϊһ�����ֵ�ǰ����ֽ�ʱ�������byte�����磺
     *     String str="��LRW��JAVA";
     *     leftStr(str,1,-1)=="";
     *     leftStr(str,2,-1)=="��";
     *     leftStr(str,4,-1)=="��LR";
     *     leftStr(str,11,-1)=="��LRW";
     * �����һ��byteǡ��Ϊһ�����ֵ�ǰ����ֽ�ʱ����ȫ���֣���ȡһ���ֽڣ������磺
     *     String str="��LRW��JAVA";
     *     leftStr(str,1,1)=="��";
     *     leftStr(str,2,1)=="��";
     *     leftStr(str,4,1)=="��LR";
     *     leftStr(str,11,1)=="��LRW��";
     *
     * @param source ԭʼ�ַ�
     * @param maxByteLen ��ȡ���ֽ���
     * @param flag ��ʾ���?�ֵķ�ʽ��1��ʾ�����������ʱ��ȫ��-1��ʾ�����������ʱ����
     * @return ��ȡ����ַ�
     */
    public static String leftStr(String source, int maxByteLen, int flag){
        if(source == null || maxByteLen <= 0){
            return "";
        }
        byte[] bStr = source.getBytes();
        if(maxByteLen >= bStr.length)return source;
        String cStr = new String(bStr, maxByteLen - 1, 2);
        if(cStr.length() == 1 && source.contains(cStr)){
            maxByteLen += flag;
        }
        return new String(bStr, 0, maxByteLen);
    }
   
    public boolean isValidSQLParam(String str){
    	if (str.indexOf(";")>0) return false;
    	if (str.indexOf(" ")>0) return false;
    	return true;
    	
    	
    }

	
	
    /**
     * 判断两个日期是否是同一天
     * 
     * @param date1
     *            date1
     * @param date2
     *            date2
     * @return
     */
    public  static boolean isSameDate(Date date1, Date date2) {
        Calendar cal1 = Calendar.getInstance();
        if(date1!=null) cal1.setTime(date1);

        Calendar cal2 = Calendar.getInstance();
        if(date2!=null)cal2.setTime(date2);

        boolean isSameYear = cal1.get(Calendar.YEAR) == cal2
                .get(Calendar.YEAR);
        boolean isSameMonth = isSameYear
                && cal1.get(Calendar.MONTH) == cal2.get(Calendar.MONTH);
        boolean isSameDate = isSameMonth
                && cal1.get(Calendar.DAY_OF_MONTH) == cal2
                        .get(Calendar.DAY_OF_MONTH);

        return isSameDate;
    }
    
    public static String toHTMLString(String in)  
    {  
    	
       StringBuffer out = new StringBuffer();  
         for(int i = 0; in != null && i < in.length(); i++)  
         {  
                 char   c   =   in.charAt(i);  
                 if   (c   ==   '\'')  
                         out.append("&#039;");  
                 else   if   (c == '\"')  
                         out.append("&#034;");  
                 else   if   (c == '<')  
                         out.append("&lt;");  
                 else   if   (c == '>')
                         out.append("&gt;");  
                 else   if   (c == '&')  
                         out.append("&amp;");  
                 else   if   (c == ' ')  
                         out.append("&nbsp;");                  
                 else  
                         out.append(c);  
         }  
         String ss=out.toString();
         String newContent=ss.replaceAll("(\r\n|\r|\n|\n\r)", "<br>");
         
         return   newContent;  
    } 
    
    public static String html2Str(String in)  
    {  
    	
       StringBuffer out = new StringBuffer();  
         for(int i = 0; in != null && i < in.length(); i++)  
         {  
                 char   c   =   in.charAt(i);  
                 if   (c   ==   '\'')  
                         out.append("&#039;");  
                 else   if   (c == '\"')  
                         out.append("&#034;");  
                 else   if   (c == '<')  
                         out.append("&lt;");  
                 else   if   (c == '>')
                         out.append("&gt;");  
                 else   if   (c == '&')  
                         out.append("&amp;");  
                 else   if   (c == ' ')  
                         out.append("&nbsp;");                  
                 else  
                         out.append(c);  
         }  
         String ss=out.toString();
         String newContent=ss.replaceAll("(\r\n|\r|\n|\n\r)", "<br>");
         return   newContent;  
    } 

    public static boolean isInteger(String str) {  
        Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");  
        Boolean b= pattern.matcher(str).matches();  
        return b;
  }
    
}
