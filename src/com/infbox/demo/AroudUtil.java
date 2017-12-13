package com.infbox.demo;

public class AroudUtil {
	/**  
     * 生成以中心点为中心的四方形经纬度  
     *   
     * @param lat 纬度  
     * @param lon 精度  
     * @param raidus 半径（以米为单位）  
     * @return  
     */    
    public static double[] getAround(double lat, double lon, int raidus) {    
    
//        Double latitude = lat;    
//        Double longitude = lon;    
//    
//        Double degree = (24901 * 1609) / 360.0;    // 赤道周长24901英里 1609是转换成米的系数
//        double raidusMile = raidus;    
//    
//        Double dpmLat = 1 / degree;    
//        Double radiusLat = dpmLat * raidusMile;    
//        Double minLat = latitude - radiusLat;  //最小维度  
//        Double maxLat = latitude + radiusLat;  //最大纬度
//    
//        Double mpdLng = degree * Math.cos(latitude * (Math.PI / 180));    
//        Double dpmLng = 1 / mpdLng;                 
//        Double radiusLng = dpmLng * raidusMile;     
//        Double minLng = longitude - radiusLng;  //最小经度    
//        Double maxLng = longitude + radiusLng;  //最大经度   
    	
    	
    	 double r = 6371; //地球半径千米  
         double dis = raidus; 
         double dlng =  2*Math.asin(Math.sin(dis/(2*r))/Math.cos(lat*Math.PI/180));  
         dlng = dlng*180/Math.PI;//角度转为弧度  
         double dlat = dis/r;  
         dlat = dlat*180/Math.PI;          
         double minLat =lat-dlat;  
         double maxLat = lat+dlat;  
         double minLng = lon -dlng;  
         double maxLng = lon + dlng;  
    	
        return new double[] { minLat, maxLat, minLng, maxLng };    
    }  
    
    /**  
     * 计算中心经纬度与目标经纬度的距离（米）  
     *   
     * @param centerLon  
     *            中心精度  
     * @param centerLan  
     *            中心纬度  
     * @param targetLon  
     *            需要计算的精度  
     * @param targetLan  
     *            需要计算的纬度  
     * @return 米  
     */    
    public static double distance(double centerLon, double centerLat, double targetLon, double targetLat) {    
        double jl_jd = 102834.74258026089786013677476285;// 每经度单位米;    
        double jl_wd = 111712.69150641055729984301412873;// 每纬度单位米;    
        double b = Math.abs((centerLat - targetLat) * jl_jd);    
        double a = Math.abs((centerLon - targetLon) * jl_wd);    
        return Math.sqrt((a * a + b * b));    
    }   
    
    
    private static double EARTH_RADIUS = 6371.393;  
    private static double rad(double d)  
    {  
       return d * Math.PI / 180.0;  
    }  
  
    /** 
     * 计算两个经纬度之间的距离 
     * @param lat1 
     * @param lng1 
     * @param lat2 
     * @param lng2 
     * @return 
     */  
    public static double getDistance(double lat1, double lng1, double lat2, double lng2)  
    {  
       double radLat1 = rad(lat1);  
       double radLat2 = rad(lat2);  
       double a = radLat1 - radLat2;      
       double b = rad(lng1) - rad(lng2);  
       double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +   
        Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));  
       s = s * EARTH_RADIUS;  
       s = Math.round(s * 1000);  
       return s;  
    }  
}
