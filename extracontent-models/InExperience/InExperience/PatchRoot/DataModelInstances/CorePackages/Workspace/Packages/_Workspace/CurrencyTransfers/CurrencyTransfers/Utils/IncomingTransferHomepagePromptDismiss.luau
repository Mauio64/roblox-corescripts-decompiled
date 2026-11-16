local parent = script:FindFirstAncestor("CurrencyTransfers").Parent
local PromptsServerDrivenUi = require(parent.PromptsServerDrivenUi)
local setPromptDismissedInPageScope = PromptsServerDrivenUi.setPromptDismissedInPageScope

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDismissPromptPageScope = SharedFlags.FFlagSduiDismissPromptPageScope

local v = { "HomeIncomingRobuxTransferParentalGateBanner", "HomeIncomingRobuxTransferAgeGateBanner" }

local function dismissPromptTypes(dismissEntry, items)
	local set = {}
	local result = {}

	for _, item in items do
		local v2 = dismissEntry(item)

		for _, v3 in v2 do
			if set[v3] then
				continue
			end

			set[v3] = true
			table.insert(result, v3)
		end
	end

	return result
end

local fn = FFlagSduiDismissPromptPageScope and function(value: string?, items)
	if typeof(value) ~= "string" or value == "" then
		return
	end

	for _, item in items do
		setPromptDismissedInPageScope(value, item)
	end
end or nil

local function reportDismissForAllPromptTypes(reportPromptDismiss, networking, items, promptId: string?)
	local v2 = nil

	for _, item in items do
		local v3 = reportPromptDismiss(networking, item, promptId)

		if v2 == nil then
			v2 = v3
		else
			v2 = v2:andThen(function()
				return v3
			end)
		end
	end

	return v2
end

return {
	createCallbacks = function(data)
		local promptId = data.promptId
		local onReportPromptDismissFailed = data.onReportPromptDismissFailed
		local v2 = v

		return {
			optimisticHide = function()
				local SduiSharedUtilities = require(parent.SduiSharedUtilities)
				local dismissEntry = SduiSharedUtilities.getSduiApiStore().dismissEntry

				if not FFlagSduiDismissPromptPageScope and dismissEntry == nil then
					return
				end

				local optimisticHidePromptType = data.optimisticHidePromptType

				if typeof(optimisticHidePromptType) == "string" and optimisticHidePromptType ~= "" then
					if not FFlagSduiDismissPromptPageScope then
						dismissEntry(optimisticHidePromptType)
						return
					end

					if dismissEntry ~= nil then
						dismissEntry(optimisticHidePromptType)
					end

					fn(data.configKey, { optimisticHidePromptType })
				else
					if not FFlagSduiDismissPromptPageScope then
						dismissPromptTypes(dismissEntry, v2)

						return
					end

					if dismissEntry ~= nil then
						dismissPromptTypes(dismissEntry, v2)
					end

					fn(data.configKey, v2)
				end
			end,
			commitDismiss = function()
				local SduiSharedUtilities = require(parent.SduiSharedUtilities)
				local sduiApiStore = SduiSharedUtilities.getSduiApiStore()
				local dismissEntry = sduiApiStore.dismissEntry
				local v3 = {}

				if FFlagSduiDismissPromptPageScope then
					fn(data.configKey, v2)
				end

				if dismissEntry ~= nil then
					v3 = dismissPromptTypes(dismissEntry, v2)
				end

				local networking = data.networking

				if networking == nil then
					return
				end

				local SduiSharedContent = require(parent.SduiSharedContent)
				reportDismissForAllPromptTypes(SduiSharedContent.reportPromptDismiss, networking, v2, promptId):andThen(function()
					if dismissEntry ~= nil then
						for _, configKey in v3 do
							sduiApiStore.refreshFromApi({
								configKey = configKey,
								loadTimer = SduiSharedUtilities.SduiLoadTimer.createLoadTimer(configKey)
							})
						end
					end
				end):catch(function(p)
					if onReportPromptDismissFailed then
						onReportPromptDismissFailed(p)
					end
				end)
			end
		}
	end,
	INCOMING_TRANSFER_HOMEPAGE_BANNER_PROMPT_TYPES = v
}
