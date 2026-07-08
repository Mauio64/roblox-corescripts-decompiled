local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Cryo)

local Types = require(script.Parent.Parent.Types)
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)
local AddMessage = require(script.Parent.AddMessage)
local RemoveMessage = require(script.Parent.RemoveMessage)
local getSettingsForMessage = require(script.Parent.Parent.Helpers.getSettingsForMessage)
local v8 = game:DefineFastInt("BubbleChatAddMessageRolloutPercent", 100)

local function addMessageWithTimeout(p1) -- line: 13
	-- upvalues: maybeAssert (copy), Types (copy), AddMessage (copy), getSettingsForMessage (copy), RemoveMessage (copy), RbxAnalyticsService (copy), v8 (copy)
	maybeAssert(Types.IMessage(p1))

	return function(p2) -- line: 16
		-- upvalues: AddMessage (copy), p1 (copy), getSettingsForMessage (copy), RemoveMessage (copy), RbxAnalyticsService (copy), v8 (copy)
		p2:dispatch(AddMessage(p1))

		local v12 = getSettingsForMessage(p2:getState().chatSettings, p1)
		local v13 = p2:getState().userMessages[p1.userId]
		local messages = p2:getState().messages

		for i = 1, #v13 - v12.MaxBubbles do
			p2:dispatch(RemoveMessage(messages[v13[i]]))
		end

		RbxAnalyticsService:ReportCounter("RoactBubbleChat-MessagesSent")

		if v8 >= math.random(1, 100) then
			RbxAnalyticsService:SendEventDeferred("client", "bubbleChatMetric", "messageAdded", {
				placeId = game.PlaceId,
				senderUserId = p1.userId
			})
		end

		wait(v12.BubbleDuration)
		p2:dispatch(RemoveMessage(p1))
	end
end

return addMessageWithTimeout
