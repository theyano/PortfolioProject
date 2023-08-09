--Calculating Number of Users and Averages

--1 Tracking their physical activities

SELECT
	COUNT(DISTINCT Id) AS users_tracking_activity,
	AVG(TotalSteps) AS average_steps, 
	AVG(TotalDistance) AS average_distance,
	AVG(Calories) AS average_calories
FROM Bellabeat..daily_activity_cleaned

--2 Tracking heartrate

Select
	COUNT(DISTINCT Id) AS users_tracking_heartRate,
	AVG(Value) AS average_heartrate,
	MIN(Value) AS minimum_heartrate,
	MAX(Value) AS maximum_heartrate
FROM Bellabeat..heartrate_seconds

--3 Tracking sleep

Select
	COUNT(DISTINCT Id) AS users_tracking_sleep,
	AVG(TotalMinutesAsleep)/60.0 AS average_hours_asleep,
	MIN(TotalMinutesAsleep)/60.0 AS minimum_hours_asleep,
	MAX(TotalMinutesAsleep)/60.0 AS maximum_hours_asleep,
	AVG(TotalTimeInBed)/60.0 AS average_hours_inBed
FROM Bellabeat..sleep_day

--4 Tracking weight
Select
	COUNT(DISTINCT Id) AS users_tracking_weight,
	AVG(WeightKg) AS average_weight,
	MIN(WeightKg) AS minimum_weight,
	MAX(WeightKg) AS maximum_weight
FROM Bellabeat..weight_cleaned

--Calculations number of days each user tracked phsyical activity

SELECT
	DISTINCT Id,
	COUNT(ActivityDate) OVER (PARTITION BY Id) AS days_activity_recorded
FROM Bellabeat..daily_activity_cleaned
ORDER BY days_activity_recorded DESC

--Calculations average minutes for each activity

SELECT
	ROUND(AVG(VeryActiveMinutes),2) AS AverageVeryActiveMinutes,
	ROUND(AVG(FairlyActiveMinutes),2) AS AverageFairlyActiveMinutes,
	ROUND(AVG(LightlyActiveMinutes)/60.0,2) AS AverageLightlyActiveHours,
	ROUND(AVG(SedentaryMinutes)/60.0,2) AS AverageSedentaryHours
FROM Bellabeat..daily_activity_cleaned

--Determine when users were mostly active

SELECT
	DISTINCT (CAST(ActivityHour AS TIME)) AS activity_time,
	AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_intensity,
	AVG(METs/10.0) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_METs
FROM Bellabeat..hourly_activity AS hourly_activity
JOIN bellabeat..minuteMETsNarrow AS METs
ON hourly_activity.id = METs.id
AND hourly_activity.ActivityHour = METs.ActivityMinute
ORDER BY average_intensity DESC