local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local refreshOmniRecommendationFeedItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/refreshOmniRecommendationFeedItem")
local refreshHomePageFeedItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Home/refreshHomePageFeedItem")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local fFlagSduiRefreshFeedItemIsOmissionExpected = SharedFlags.FFlagSduiRefreshFeedItemIsOmissionExpected

local function reportInvalidActionParams(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{
			name = sduiActionType.RefreshOmniRecommendationFeedItem,
			message = p3,
			propName = p4
		},
		p2.appPage
	)
end

return function(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshOmniRecommendationFeedItem,
				message = "Missing actionParams",
				propName = nil
			},
			p4.appPage
		)

		return
	end

	assert(actionParams, "actionParams must exist")

	local topicId = actionParams.topicId

	if typeof(topicId) == "string" and topicId ~= "" then
		local feedItemKey = actionParams.feedItemKey

		if typeof(feedItemKey) == "string" and feedItemKey ~= "" then
			local requestIntent = actionParams.requestIntent

			if typeof(requestIntent) ~= "string" or requestIntent == "" then
				local formatted = `Invalid requestIntent: {requestIntent}`
				p4.dependencies.logger.reportError(
					sduiErrorType.InvalidActionParams,
					{
						name = sduiActionType.RefreshOmniRecommendationFeedItem,
						message = formatted,
						propName = "requestIntent"
					},
					p4.appPage
				)
			end

			local v5 = nil

			local selectedOption = actionParams.selectedOption

			if selectedOption ~= nil then
				if typeof(selectedOption) == "string" and selectedOption ~= "" then
					v5 = { selected_option = selectedOption }
				else
					local formatted = `Invalid selectedOption: {selectedOption}`
					p4.dependencies.logger.reportError(
						sduiErrorType.InvalidActionParams,
						{
							name = sduiActionType.RefreshOmniRecommendationFeedItem,
							message = formatted,
							propName = "selectedOption"
						},
						p4.appPage
					)
				end
			end

			local v6 = nil

			if fFlagSduiRefreshFeedItemIsOmissionExpected then
				local isOmissionExpected = actionParams.isOmissionExpected

				if isOmissionExpected == nil or typeof(isOmissionExpected) == "boolean" then
					v6 = isOmissionExpected
				else
					local formatted = `Invalid isOmissionExpected: {isOmissionExpected}`
					p4.dependencies.logger.reportError(
						sduiErrorType.InvalidActionParams,
						{
							name = sduiActionType.RefreshOmniRecommendationFeedItem,
							message = formatted,
							propName = "isOmissionExpected"
						},
						p4.appPage
					)
				end
			end

			if not fFlagLuaAppEnableSduiHomePage then
				return refreshOmniRecommendationFeedItem(
					p4.dependencies.networking,
					p4.appPage,
					topicId,
					feedItemKey,
					requestIntent,
					function(p5, p6)
						p4.dependencies.logger.reportError(p5, p6, p4.appPage)
					end,
					{ contextFeatures = v5 }
				)
			end

			local function fn(p5, p6)
				p4.dependencies.logger.reportError(p5, p6, p4.appPage)
			end

			if not fFlagSduiRefreshFeedItemIsOmissionExpected then
				v6 = nil
			end

			return refreshHomePageFeedItem(topicId, feedItemKey, requestIntent, fn, {
				contextFeatures = v5,
				isOmissionExpected = v6
			})
		else
			local formatted = `Invalid or missing feedItemKey: {feedItemKey}`
			p4.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.RefreshOmniRecommendationFeedItem,
					message = formatted,
					propName = "feedItemKey"
				},
				p4.appPage
			)
		end
	else
		local formatted = `Invalid or missing topicId: {topicId}`
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshOmniRecommendationFeedItem,
				message = formatted,
				propName = "topicId"
			},
			p4.appPage
		)
	end
end
