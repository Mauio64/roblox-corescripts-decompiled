local EventIngestService = game:GetService("EventIngestService")

local module = require("@luauforge/deferred/gMk")
local COMMON_FORMAT_ENTRY_POINT = module.COMMON_FORMAT_ENTRY_POINT
local REPORT_ENTRYPOINT = module.REPORT_ENTRYPOINT

local function getCommonFormattedEntryPoint(dialogEntryPoint)
	if
		dialogEntryPoint == COMMON_FORMAT_ENTRY_POINT.Profile
		or dialogEntryPoint == COMMON_FORMAT_ENTRY_POINT.Chat
		or dialogEntryPoint == COMMON_FORMAT_ENTRY_POINT.Experience
		or dialogEntryPoint == COMMON_FORMAT_ENTRY_POINT.Item
	then
		return dialogEntryPoint
	end

	if dialogEntryPoint == REPORT_ENTRYPOINT.Profile then
		return COMMON_FORMAT_ENTRY_POINT.Profile
	end

	if dialogEntryPoint == REPORT_ENTRYPOINT.Chat then
		return COMMON_FORMAT_ENTRY_POINT.Chat
	end

	if dialogEntryPoint == REPORT_ENTRYPOINT.ExperienceDetails then
		return COMMON_FORMAT_ENTRY_POINT.Experience
	end

	if dialogEntryPoint == REPORT_ENTRYPOINT.Item then
		return COMMON_FORMAT_ENTRY_POINT.Item
	end

	return ""
end

local v5 = {
	SET_BASIC_INFO = "SET_BASIC_INFO",
	INCREMENT_SELECTION_ITEM = "INCREMENT_SELECTION_ITEM",
	INCREMENT_BACK_BUTTON_CLICK = "INCREMENT_BACK_BUTTON_CLICK",
	SET_IS_SEEN_SUMMARY_PAGE = "SET_IS_SEEN_SUMMARY_PAGE"
}
return {
	reportAnalyticsReducer = function(p2, data)
		local clone = table.clone(p2)

		if data.type == v5.SET_BASIC_INFO then
			clone.platform = data.platform
			clone.dialogEntryPoint = getCommonFormattedEntryPoint(data.dialogEntryPoint)
		else
			if data.type == v5.INCREMENT_SELECTION_ITEM then
				clone.selectItemCount += 1
				return clone
			end

			if data.type == v5.INCREMENT_BACK_BUTTON_CLICK then
				clone.backButtonClickCount += 1
				return clone
			end

			if data.type == v5.SET_IS_SEEN_SUMMARY_PAGE then
				clone.isSeenSummaryPage = true
			end
		end

		return clone
	end,
	EMPTY_LOGGING_STATE = {
		platform = "",
		dialogEntryPoint = "",
		selectItemCount = 0,
		backButtonClickCount = 0,
		isSeenSummaryPage = false
	},
	sendEventData = function(p2, p3)
		if p2.platform ~= "" and p2.dialogEntryPoint ~= "" then
			EventIngestService:SendEventDeferred(p2.platform, p2.dialogEntryPoint, p3, p2)
		end
	end,
	ActionTypes = v5
}
