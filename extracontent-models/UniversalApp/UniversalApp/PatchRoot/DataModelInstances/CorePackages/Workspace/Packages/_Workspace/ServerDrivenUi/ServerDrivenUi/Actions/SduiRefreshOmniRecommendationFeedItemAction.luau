local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local refreshOmniRecommendationFeedItem = require(ServerDrivenUi.Actions.refreshOmniRecommendationFeedItem)

local function reportInvalidActionParams(p1, s1: string, s2: string?) -- line: 14
	-- upvalues: SduiErrorType (copy), SduiActionType (copy)
	p1.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
		name = SduiActionType.RefreshOmniRecommendationFeedItem,
		message = s1,
		propName = s2
	}, p1.appPage)
end

return function(p2, _, p4) -- line: 24
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), refreshOmniRecommendationFeedItem (copy)
	local v14 = p2 and p2.actionParams or nil

	if v14 == nil then
		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			propName = nil,
			name = SduiActionType.RefreshOmniRecommendationFeedItem
		}, p4.appPage)

		return
	end

	assert(v14, "actionParams must exist")

	local topicId = v14.topicId

	if typeof(topicId) ~= "string" or topicId == "" then
		local v16 = `Invalid or missing topicId: { topicId }`

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "topicId",
			name = SduiActionType.RefreshOmniRecommendationFeedItem,
			message = v16
		}, p4.appPage)

		return
	end

	local feedItemKey = v14.feedItemKey

	if typeof(feedItemKey) ~= "string" or feedItemKey == "" then
		local v18 = `Invalid or missing feedItemKey: { feedItemKey }`

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "feedItemKey",
			name = SduiActionType.RefreshOmniRecommendationFeedItem,
			message = v18
		}, p4.appPage)

		return
	end

	local requestIntent = v14.requestIntent

	if typeof(requestIntent) ~= "string" or requestIntent == "" then
		local v20 = `Invalid requestIntent: { requestIntent }`

		p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "requestIntent",
			name = SduiActionType.RefreshOmniRecommendationFeedItem,
			message = v20
		}, p4.appPage)
	end

	local t1 = nil
	local selectedOption = v14.selectedOption

	if selectedOption ~= nil then
		if typeof(selectedOption) ~= "string" or selectedOption == "" then
			local v23 = `Invalid selectedOption: { selectedOption }`

			p4.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
				propName = "selectedOption",
				name = SduiActionType.RefreshOmniRecommendationFeedItem,
				message = v23
			}, p4.appPage)
		else
			t1 = {
				selected_option = selectedOption
			}
		end
	end

	return refreshOmniRecommendationFeedItem(p4.dependencies.networking, p4.appPage, topicId, feedItemKey, requestIntent, function(p5, p6) -- line: 74
		-- upvalues: p4 (copy)
		p4.dependencies.logger.reportError(p5, p6, p4.appPage)
	end, {
		contextFeatures = t1
	})
end
