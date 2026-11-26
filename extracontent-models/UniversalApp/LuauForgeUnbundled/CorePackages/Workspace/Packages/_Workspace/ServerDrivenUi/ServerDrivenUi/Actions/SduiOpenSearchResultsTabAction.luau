local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").SearchTypes

local searchSourceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryTypes").SearchSourceEvent

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local SearchPageTabSwitchBridge = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/System/SearchPageTabSwitchBridge")

local function reportInvalidParam(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.OpenSearchResultsTab, message = p3, propName = p4 },
		p2.appPage
	)
end

local function SduiOpenSearchResultsTabAction(p2, p3, p4, p5)
	local actionParams = if p2 then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSearchResultsTab,
				message = "Missing actionParams",
				propName = nil
			},
			p4.appPage
		)

		return
	end

	local searchType = actionParams.searchType

	if typeof(searchType) == "string" and searchType ~= "" then
		if searchTypes[searchType] == nil then
			local formatted = `Unknown searchType: {searchType}`
			p4.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.OpenSearchResultsTab,
					message = formatted,
					propName = "searchType"
				},
				p4.appPage
			)
		else
			local sourceEvent = actionParams.sourceEvent
			local v5

			if sourceEvent == nil then
				v5 = searchSourceEvent.SeeAll
			elseif typeof(sourceEvent) == "string" and searchSourceEvent[sourceEvent] ~= nil then
				v5 = searchSourceEvent[sourceEvent]
			else
				local formatted = `Unknown sourceEvent: {tostring(sourceEvent)}`
				p4.dependencies.logger.reportError(
					sduiErrorType.InvalidActionParams,
					{
						name = sduiActionType.OpenSearchResultsTab,
						message = formatted,
						propName = "sourceEvent"
					},
					p4.appPage
				)

				return
			end

			SearchPageTabSwitchBridge.switchTab(searchType, v5)
		end
	else
		local formatted = `Invalid or missing searchType: {tostring(searchType)}`
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSearchResultsTab,
				message = formatted,
				propName = "searchType"
			},
			p4.appPage
		)
	end
end

return SduiOpenSearchResultsTabAction
