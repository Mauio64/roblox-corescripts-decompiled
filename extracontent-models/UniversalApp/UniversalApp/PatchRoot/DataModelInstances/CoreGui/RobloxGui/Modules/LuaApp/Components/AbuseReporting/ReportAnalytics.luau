local Modules = game:GetService("CoreGui").RobloxGui.Modules
local EventIngestService = game:GetService("EventIngestService")
local Constants = require(Modules.LuaApp.Components.AbuseReporting.Constants)
local COMMON_FORMAT_ENTRY_POINT = Constants.COMMON_FORMAT_ENTRY_POINT
local REPORT_ENTRYPOINT = Constants.REPORT_ENTRYPOINT
local t1 = {
	platform = "",
	dialogEntryPoint = "",
	selectItemCount = 0,
	backButtonClickCount = 0,
	isSeenSummaryPage = false
}

local function getCommonFormattedEntryPoint(s1: string) -- line: 35
	-- upvalues: COMMON_FORMAT_ENTRY_POINT (copy), REPORT_ENTRYPOINT (copy)
	if s1 == COMMON_FORMAT_ENTRY_POINT.Profile or (s1 == COMMON_FORMAT_ENTRY_POINT.Chat or s1 == COMMON_FORMAT_ENTRY_POINT.Experience or s1 == COMMON_FORMAT_ENTRY_POINT.Item) then
		return s1
	end

	if s1 == REPORT_ENTRYPOINT.Profile then
		return COMMON_FORMAT_ENTRY_POINT.Profile
	end

	if s1 == REPORT_ENTRYPOINT.Chat then
		return COMMON_FORMAT_ENTRY_POINT.Chat
	end

	if s1 == REPORT_ENTRYPOINT.ExperienceDetails then
		return COMMON_FORMAT_ENTRY_POINT.Experience
	end

	if s1 == REPORT_ENTRYPOINT.Item then
		return COMMON_FORMAT_ENTRY_POINT.Item
	end

	return ""
end

local t2 = {
	SET_BASIC_INFO = "SET_BASIC_INFO",
	INCREMENT_SELECTION_ITEM = "INCREMENT_SELECTION_ITEM",
	INCREMENT_BACK_BUTTON_CLICK = "INCREMENT_BACK_BUTTON_CLICK",
	SET_IS_SEEN_SUMMARY_PAGE = "SET_IS_SEEN_SUMMARY_PAGE"
}

return {
	reportAnalyticsReducer = function(t3: {[any]: any}, p1) -- line: 67
		-- upvalues: t2 (copy), getCommonFormattedEntryPoint (copy)
		local v14 = table.clone(t3)

		if p1.type == t2.SET_BASIC_INFO then
			v14.platform = p1.platform
			v14.dialogEntryPoint = getCommonFormattedEntryPoint(p1.dialogEntryPoint)

			return v14
		end

		if p1.type == t2.INCREMENT_SELECTION_ITEM then
			v14.selectItemCount = v14.selectItemCount + 1

			return v14
		end

		if p1.type == t2.INCREMENT_BACK_BUTTON_CLICK then
			v14.backButtonClickCount = v14.backButtonClickCount + 1

			return v14
		end

		if p1.type == t2.SET_IS_SEEN_SUMMARY_PAGE then
			v14.isSeenSummaryPage = true
		end

		return v14
	end,
	EMPTY_LOGGING_STATE = t1,
	sendEventData = function(t4: {[any]: any}, s2: string) -- line: 24
		-- upvalues: EventIngestService (copy)
		if t4.platform ~= "" and t4.dialogEntryPoint ~= "" then
			EventIngestService:SendEventDeferred(t4.platform, t4.dialogEntryPoint, s2, t4)
		end
	end,
	ActionTypes = t2
}
