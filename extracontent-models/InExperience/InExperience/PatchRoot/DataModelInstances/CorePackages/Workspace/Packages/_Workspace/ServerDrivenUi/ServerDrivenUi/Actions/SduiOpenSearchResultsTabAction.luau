local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local SearchTypes = RobloxAppEnums.SearchTypes

local DiscoveryTypes = require(parent.DiscoveryTypes)
local SearchSourceEvent = DiscoveryTypes.SearchSourceEvent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local SearchPageTabSwitchBridge = require(ServerDrivenUi.System.SearchPageTabSwitchBridge)

local function reportInvalidParam(p, message: string, propName: string?) -- 4 equivalent calls inferred from this helper
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.OpenSearchResultsTab, message = message, propName = propName },
		p.appPage
	)
end

local function SduiOpenSearchResultsTabAction(p, _, p2, _)
	local actionParams

	if p then
		actionParams = p.actionParams
	end

	if actionParams == nil then
		reportInvalidParam(p2, "Missing actionParams") -- inferred equivalent call
		return
	end

	local searchType = actionParams.searchType

	if typeof(searchType) == "string" and searchType ~= "" then
		if SearchTypes[searchType] == nil then
			reportInvalidParam(p2, `Unknown searchType: {searchType}`, "searchType") -- inferred equivalent call
		else
			local sourceEvent = actionParams.sourceEvent
			local v

			if sourceEvent == nil then
				v = SearchSourceEvent.SeeAll
			elseif typeof(sourceEvent) == "string" and SearchSourceEvent[sourceEvent] ~= nil then
				v = SearchSourceEvent[sourceEvent]
			else
				reportInvalidParam(p2, `Unknown sourceEvent: {tostring(sourceEvent)}`, "sourceEvent") -- inferred equivalent call
				return
			end

			SearchPageTabSwitchBridge.switchTab(searchType, v)
		end
	else
		reportInvalidParam(p2, `Invalid or missing searchType: {tostring(searchType)}`, "searchType") -- inferred equivalent call
	end
end

return SduiOpenSearchResultsTabAction
