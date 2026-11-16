local function toStartMs(startTime: string?) -- 1 equivalent call inferred from this helper
	if type(startTime) ~= "string" then
		return 0
	end

	local success, result = pcall(DateTime.fromIsoDate, startTime)

	if success and result ~= nil then
		return result.UnixTimestampMillis
	end

	return 0
end

local function campaignEndExclusiveMs(p: number, durationInDays: number) -- 1 equivalent call inferred from this helper
	return p + math.max(0, durationInDays) * 86400000
end

local AdCampaignScheduleUtils = {}
AdCampaignScheduleUtils.MS_PER_DAY = 86400000
AdCampaignScheduleUtils.toStartMs = toStartMs

function AdCampaignScheduleUtils.campaignEndMs(p: number, p2: number)
	return p + math.max(0, p2 - 1) * 86400000
end

AdCampaignScheduleUtils.campaignEndExclusiveMs = campaignEndExclusiveMs

function AdCampaignScheduleUtils.hasActiveCampaign(items, p: number?, p2: number): boolean
	if items == nil or p == nil or p == 0 then
		return false
	end

	local v = tostring(p)

	for _, item in items do
		if not (item.targetUniverseId == v and item.status ~= "CANCELLED" and item.deliveryStatus ~= "REJECTED") then
			continue
		end

		if item.deliveryStatus == "IN_REVIEW" then
			return true
		end

		if item.status == "PAUSED" then
			continue
		end

		local startMs = toStartMs(item.schedule.startTime) -- inferred equivalent call
		local v2

		if startMs > 0 then
			v2 = item.schedule.durationInDays > 0
		else
			v2 = false
		end

		if
			item.deliveryStatus == "SERVING" and not v2
			or p2 < campaignEndExclusiveMs(startMs, item.schedule.durationInDays) -- inferred equivalent call
		then
			return true
		end
	end

	return false
end

return AdCampaignScheduleUtils
