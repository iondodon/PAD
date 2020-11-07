package com.utm.md.orders.job;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobKey;
import org.springframework.stereotype.Component;

@Component
public class ProcessOrderJob implements Job {

    public void execute(JobExecutionContext context) throws JobExecutionException {
        JobKey key = context.getJobDetail().getKey();
        System.out.println("Simple Job started with key :" + key.getName() + ", Group :"+key.getGroup() + " , Thread Name :"+Thread.currentThread().getName());
    }
}