package com.infbox.demo;
/*
 * 任务类
 * */
public class Task {
	public long id;//本地id
	public String title,
				content,
				comment;//任务完成后获得的评语
	public long begin,//任务设定的开始时间
				end,//任务制定的截止日期
				finishTime;//实际执行的结束时间
	public short score,//任务完成后获得的评分
				level;//任务级别，0=重要不紧急，1=重要紧急，2=紧急不重要，3=不重要不紧急
	public short state;//任务状态
}
