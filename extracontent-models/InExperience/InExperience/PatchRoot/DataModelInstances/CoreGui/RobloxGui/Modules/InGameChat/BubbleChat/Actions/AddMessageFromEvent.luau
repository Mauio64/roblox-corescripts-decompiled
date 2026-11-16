local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)

local Types = require(script.Parent.Parent.Types)
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)
local AddMessageWithTimeout = require(script.Parent.AddMessageWithTimeout)

local function addMessageFromEvent(data)
	maybeAssert(Types.IMessageData(data))

	return function(object)
		local success, result = pcall(function()
			return Players:GetPlayerByUserId(data.SpeakerUserId)
		end)

		local character = success and result and result.Character

		if not character then
			return
		end

		local v = {
			id = tostring(data.ID),
			userId = tostring(data.SpeakerUserId),
			name = data.FromSpeaker,
			text = data.Message or "",
			timestamp = data.Time,
			adornee = character
		}

		ExpChat.Events.LegacyBubbleCreated(v)

		return object:dispatch(AddMessageWithTimeout(v))
	end
end

return addMessageFromEvent
