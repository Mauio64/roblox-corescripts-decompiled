local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local refreshOmniRecommendationFeedItem = require(ServerDrivenUi.Actions.refreshOmniRecommendationFeedItem)
local refreshHomePageFeedItem = require(parent.Home.refreshHomePageFeedItem)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FFlagSduiRefreshFeedItemIsOmissionExpected = SharedFlags.FFlagSduiRefreshFeedItemIsOmissionExpected

local function reportInvalidActionParams(p, message: string, propName: string?) -- 6 equivalent calls inferred from this helper
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{
			name = SduiActionType.RefreshOmniRecommendationFeedItem,
			message = message,
			propName = propName
		},
		p.appPage
	)
end

return function(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		reportInvalidActionParams(p2, "Missing actionParams") -- inferred equivalent call
		return
	end

	assert(actionParams, "actionParams must exist")

	local topicId = actionParams.topicId

	if typeof(topicId) == "string" and topicId ~= "" then
		local feedItemKey = actionParams.feedItemKey

		if typeof(feedItemKey) == "string" and feedItemKey ~= "" then
			local requestIntent = actionParams.requestIntent

			if typeof(requestIntent) ~= "string" or requestIntent == "" then
				reportInvalidActionParams(p2, `Invalid requestIntent: {requestIntent}`, "requestIntent") -- inferred equivalent call
			end

			local contextFeatures = nil

			local selectedOption = actionParams.selectedOption

			if selectedOption ~= nil then
				if typeof(selectedOption) == "string" and selectedOption ~= "" then
					contextFeatures = { selected_option = selectedOption }
				else
					reportInvalidActionParams(p2, `Invalid selectedOption: {selectedOption}`, "selectedOption") -- inferred equivalent call
				end
			end

			local isOmissionExpected2 = nil

			if FFlagSduiRefreshFeedItemIsOmissionExpected then
				local isOmissionExpected = actionParams.isOmissionExpected

				if isOmissionExpected == nil or typeof(isOmissionExpected) == "boolean" then
					isOmissionExpected2 = isOmissionExpected
				else
					reportInvalidActionParams( -- inferred equivalent call
						p2,
						`Invalid isOmissionExpected: {isOmissionExpected}`,
						"isOmissionExpected"
					)
				end
			end

			if not FFlagLuaAppEnableSduiHomePage then
				return refreshOmniRecommendationFeedItem(
					p2.dependencies.networking,
					p2.appPage,
					topicId,
					feedItemKey,
					requestIntent,
					function(p3, p4)
						p2.dependencies.logger.reportError(p3, p4, p2.appPage)
					end,
					{ contextFeatures = contextFeatures }
				)
			end

			local function fn(p3, p4)
				p2.dependencies.logger.reportError(p3, p4, p2.appPage)
			end

			if not FFlagSduiRefreshFeedItemIsOmissionExpected then
				isOmissionExpected2 = nil
			end

			return refreshHomePageFeedItem(topicId, feedItemKey, requestIntent, fn, {
				contextFeatures = contextFeatures,
				isOmissionExpected = isOmissionExpected2
			})
		end

		reportInvalidActionParams(p2, `Invalid or missing feedItemKey: {feedItemKey}`, "feedItemKey") -- inferred equivalent call
	else
		reportInvalidActionParams(p2, `Invalid or missing topicId: {topicId}`, "topicId") -- inferred equivalent call
	end
end
