local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local Types = require(script.Parent.Parent.Types)
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)
local AddMessageWithTimeout = require(script.Parent.AddMessageWithTimeout)

local function addMessageFromEvent(p1) -- line: 17
	-- upvalues: maybeAssert (copy), Types (copy), Players (copy), ExpChat (copy), AddMessageWithTimeout (copy)
	maybeAssert(Types.IMessageData(p1))

	return function(p2) -- line: 20
		-- upvalues: Players (copy), p1 (copy), ExpChat (copy), AddMessageWithTimeout (copy)
		local ok, result = pcall(function() -- line: 21
			-- upvalues: Players (copy), p1 (copy)
			return Players:GetPlayerByUserId(p1.SpeakerUserId)
		end)

		if ok and result then
			local Character = result.Character

			if Character then
				local t1 = {
					id = tostring(p1.ID),
					userId = tostring(p1.SpeakerUserId),
					name = p1.FromSpeaker,
					text = p1.Message or "",
					timestamp = p1.Time,
					adornee = Character
				}

				ExpChat.Events.LegacyBubbleCreated(t1)

				return p2:dispatch(AddMessageWithTimeout(t1))
			end
		end
	end
end

return addMessageFromEvent
