local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Cryo)
local Types = require(script.Parent.Parent.Types)
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)
local AddMessage = require(script.Parent.AddMessage)
local RemoveMessage = require(script.Parent.RemoveMessage)
local getSettingsForMessage = require(script.Parent.Parent.Helpers.getSettingsForMessage)

local defineFastInt = game:DefineFastInt("BubbleChatAddMessageRolloutPercent", 100)

local function addMessageWithTimeout(p)
	maybeAssert(Types.IMessage(p))

	return function(object)
		object:dispatch(AddMessage(p))

		local settingsForMessage = getSettingsForMessage(object:getState().chatSettings, p)
		local userMessage = object:getState().userMessages[p.userId]
		local messages = object:getState().messages

		for i = 1, #userMessage - settingsForMessage.MaxBubbles do
			object:dispatch(RemoveMessage(messages[userMessage[i]]))
		end

		RbxAnalyticsService:ReportCounter("RoactBubbleChat-MessagesSent")

		if defineFastInt >= math.random(1, 100) then
			RbxAnalyticsService:SendEventDeferred("client", "bubbleChatMetric", "messageAdded", {
				placeId = game.PlaceId,
				senderUserId = p.userId
			})
		end

		wait(settingsForMessage.BubbleDuration)

		object:dispatch(RemoveMessage(p))
	end
end

return addMessageWithTimeout
