local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local Analytics = {}
Analytics.__index = Analytics

Analytics.EventName = {
	MenuOpened = "emoteMenuOpened",
	EmotePlayed = "emoteTriggered",
	EmoteFailed = "emoteTriggerFailed"
}

function Analytics.new()
	local v = { eventStreamImpl = nil }

	setmetatable(v, Analytics)

	return v
end

function Analytics:withEventStream(eventStreamImpl)
	self.eventStreamImpl = eventStreamImpl
	return self
end

function Analytics:onMenuOpened()
	local menuOpened = self.EventName.MenuOpened

	local v = {
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId()
	}

	self:_getEventStream():setRBXEventStream("emoteMenu", menuOpened, v)
end

function Analytics:onEmotePlayed(slotNumber, assetID)
	local emotePlayed = self.EventName.EmotePlayed

	local v = {
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId(),
		slotNumber = slotNumber,
		assetID = assetID
	}

	self:_getEventStream():setRBXEventStream("emoteMenu", emotePlayed, v)
end

function Analytics:onEmoteFailed(slotNumber, assetID, errorType)
	local emoteFailed = self.EventName.EmoteFailed

	local v = {
		pid = tostring(game.PlaceId),
		uid = tostring(Players.LocalPlayer.UserId),
		btid = Stats:GetBrowserTrackerId(),
		slotNumber = slotNumber,
		assetID = assetID,
		errorType = errorType,
		invokedByCoreGui = true
	}

	self:_getEventStream():setRBXEventStream("emoteMenu", emoteFailed, v)
end

function Analytics:_getEventStream()
	assert(self.eventStreamImpl, "EventStream implementation not found. Did you forget to construct withEventStream?")
	return self.eventStreamImpl
end

return Analytics
