package com.utm.md.orders.config;

import com.utm.md.orders.job.ProcessOrderJob;
import org.quartz.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

import static org.quartz.SimpleScheduleBuilder.simpleSchedule;

@Configuration
public class QuartzConfig {

    @Bean
    public JobDetail jobDetail() {
        return JobBuilder.newJob().ofType(ProcessOrderJob.class)
                .storeDurably()
                .withIdentity("Qrtz_Job_Detail")
                .withDescription("Invoke Sample Job service...")
                .build();
    }

    @Bean
    public Trigger trigger(JobDetail job) {
        return TriggerBuilder.newTrigger().forJob(job)
                .withIdentity("Qrtz_Trigger")
                .withDescription("Sample trigger")
                .withSchedule(simpleSchedule().repeatForever().withIntervalInHours(1))
                .build();
    }

    @Bean
    public Scheduler scheduler(Trigger trigger, JobDetail job, SchedulerFactoryBean factory)
            throws SchedulerException {
        Scheduler scheduler = factory.getScheduler();
        scheduler.scheduleJob(job, trigger);
        scheduler.start();
        return scheduler;
    }
}
