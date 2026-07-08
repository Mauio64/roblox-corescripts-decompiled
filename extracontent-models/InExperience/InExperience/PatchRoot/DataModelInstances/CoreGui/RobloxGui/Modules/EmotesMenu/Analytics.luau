local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local t1 = {}

t1.__index = t1
t1.EventName = {
	MenuOpened = "emoteMenuOpened",
	EmotePlayed = "emoteTriggered",
	EmoteFailed = "emoteTriggerFailed"
}

function t1.new() -- line: 13
	-- upvalues: t1 (copy)
	local t2 = {
		eventStreamImpl = nil
	}

	setmetatable(t2, t1)

	return t2
end
function t1.withEventStream(p1, p2) -- line: 22
	p1.eventStreamImpl = p2

	return p1
end
function t1.onMenuOpened(p3) -- line: 27
	-- upvalues: Players (copy), Stats (copy)
	local MenuOpened = p3.EventName.MenuOpened
	local t3 = {
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId()
	}

	p3:_getEventStream():setRBXEventStream("emoteMenu", MenuOpened, t3)
end
function t1.onEmotePlayed(p4, p5, p6) -- line: 40
	-- upvalues: Players (copy), Stats (copy)
	local EmotePlayed = p4.EventName.EmotePlayed
	local t4 = {
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId(),
		slotNumber = p5,
		assetID = p6
	}

	p4:_getEventStream():setRBXEventStream("emoteMenu", EmotePlayed, t4)
end
function t1.onEmoteFailed(p7, p8, p9, p10) -- line: 55
	-- upvalues: Players (copy), Stats (copy)
	local EmoteFailed = p7.EventName.EmoteFailed
	local t5 = {
		invokedByCoreGui = true,
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId(),
		slotNumber = p8,
		assetID = p9,
		errorType = p10
	}

	p7:_getEventStream():setRBXEventStream("emoteMenu", EmoteFailed, t5)
end
function t1._getEventStream(p11) -- line: 72
	assert(p11.eventStreamImpl, "EventStream implementation not found. Did you forget to construct withEventStream?")

	return p11.eventStreamImpl
end

return t1
