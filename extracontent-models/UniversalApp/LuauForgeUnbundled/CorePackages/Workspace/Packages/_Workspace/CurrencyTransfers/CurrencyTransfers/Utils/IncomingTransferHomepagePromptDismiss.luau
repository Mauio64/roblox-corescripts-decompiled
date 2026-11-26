local setPromptDismissedInPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/PromptsServerDrivenUi").setPromptDismissedInPageScope

local fFlagSduiDismissPromptPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags").FFlagSduiDismissPromptPageScope

local v5 = { "HomeIncomingRobuxTransferParentalGateBanner", "HomeIncomingRobuxTransferAgeGateBanner" }

local function dismissPromptTypes(dismissEntry, items)
	local set = {}
	local result = {}

	for k, item in items do
		local v6 = dismissEntry(item)

		for k2, v7 in v6 do
			if set[v7] then
				continue
			end

			set[v7] = true
			table.insert(result, v7)
		end
	end

	return result
end

local fn = fFlagSduiDismissPromptPageScope and function(value, items)
	if typeof(value) ~= "string" or value == "" then
		return
	end

	for k, item in items do
		setPromptDismissedInPageScope(value, item)
	end
end or nil

local function reportDismissForAllPromptTypes(reportPromptDismiss, networking, items, promptId)
	local v6 = nil

	for k, item in items do
		local v7 = reportPromptDismiss(networking, item, promptId)

		if v6 == nil then
			v6 = v7
		else
			v6 = v6:andThen(function()
				return v7
			end)
		end
	end

	return v6
end

return {
	createCallbacks = function(data)
		local promptId = data.promptId
		local onReportPromptDismissFailed = data.onReportPromptDismissFailed
		local v6 = v5

		return {
			optimisticHide = function()
				local dismissEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SduiSharedUtilities").getSduiApiStore().dismissEntry

				if not fFlagSduiDismissPromptPageScope and dismissEntry == nil then
					return
				end

				local optimisticHidePromptType = data.optimisticHidePromptType

				if typeof(optimisticHidePromptType) == "string" and optimisticHidePromptType ~= "" then
					if not fFlagSduiDismissPromptPageScope then
						dismissEntry(optimisticHidePromptType)
						return
					end

					if dismissEntry ~= nil then
						dismissEntry(optimisticHidePromptType)
					end

					fn(data.configKey, { optimisticHidePromptType })
				else
					if not fFlagSduiDismissPromptPageScope then
						dismissPromptTypes(dismissEntry, v6)

						return
					end

					if dismissEntry ~= nil then
						dismissPromptTypes(dismissEntry, v6)
					end

					fn(data.configKey, v6)
				end
			end,
			commitDismiss = function()
				local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SduiSharedUtilities")
				local sduiApiStore = SduiSharedUtilities.getSduiApiStore()
				local dismissEntry = sduiApiStore.dismissEntry
				local v7 = {}

				if fFlagSduiDismissPromptPageScope then
					fn(data.configKey, v6)
				end

				if dismissEntry ~= nil then
					v7 = dismissPromptTypes(dismissEntry, v6)
				end

				local networking = data.networking

				if networking == nil then
					return
				end

				reportDismissForAllPromptTypes(
					require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SduiSharedContent").reportPromptDismiss,
					networking,
					v6,
					promptId
				):andThen(function()
					if dismissEntry ~= nil then
						for k, v8 in v7 do
							sduiApiStore.refreshFromApi({
								configKey = v8,
								loadTimer = SduiSharedUtilities.SduiLoadTimer.createLoadTimer(v8)
							})
						end
					end
				end):catch(function(p2)
					if onReportPromptDismissFailed then
						onReportPromptDismissFailed(p2)
					end
				end)
			end
		}
	end,
	INCOMING_TRANSFER_HOMEPAGE_BANNER_PROMPT_TYPES = v5
}
