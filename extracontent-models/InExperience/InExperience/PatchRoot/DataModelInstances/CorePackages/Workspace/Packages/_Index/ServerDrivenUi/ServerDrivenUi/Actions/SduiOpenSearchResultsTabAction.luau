local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local SearchTypes = require(ServerDrivenUiParent.RobloxAppEnums).SearchTypes
local SearchSourceEvent = require(ServerDrivenUiParent.DiscoveryTypes).SearchSourceEvent
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SearchPageTabSwitchBridge = require(ServerDrivenUi.System.SearchPageTabSwitchBridge)

local function reportInvalidParam(p1, s1: string, s2: string?) -- line: 31
	-- upvalues: SduiErrorType (copy), SduiActionType (copy)
	p1.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
		name = SduiActionType.OpenSearchResultsTab,
		message = s1,
		propName = s2
	}, p1.appPage)
end
local function SduiOpenSearchResultsTabAction(p2, _, p4, _) -- line: 39
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), SearchTypes (copy), SearchSourceEvent (copy), SearchPageTabSwitchBridge (copy)
	local v18 = if not p2 then nil else p2.actionParams

	if v18 == nil then
		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			propName = nil,
			name = SduiActionType.OpenSearchResultsTab
		}, p4.appPage)

		return
	end

	local searchType = v18.searchType

	if typeof(searchType) ~= "string" or searchType == "" then
		local v20 = `Invalid or missing searchType: { tostring(searchType) }`

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "searchType",
			name = SduiActionType.OpenSearchResultsTab,
			message = v20
		}, p4.appPage)

		return
	end

	if SearchTypes[searchType] == nil then
		local v21 = `Unknown searchType: { searchType }`

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "searchType",
			name = SduiActionType.OpenSearchResultsTab,
			message = v21
		}, p4.appPage)

		return
	end

	local sourceEvent = v18.sourceEvent
	local SeeAll

	if sourceEvent == nil then
		SeeAll = SearchSourceEvent.SeeAll
	else
		if typeof(sourceEvent) ~= "string" or SearchSourceEvent[sourceEvent] == nil then
			local v24 = `Unknown sourceEvent: { tostring(sourceEvent) }`

			p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
				propName = "sourceEvent",
				name = SduiActionType.OpenSearchResultsTab,
				message = v24
			}, p4.appPage)

			return
		end

		SeeAll = SearchSourceEvent[sourceEvent]
	end

	SearchPageTabSwitchBridge.switchTab(searchType, SeeAll)
end

return SduiOpenSearchResultsTabAction
