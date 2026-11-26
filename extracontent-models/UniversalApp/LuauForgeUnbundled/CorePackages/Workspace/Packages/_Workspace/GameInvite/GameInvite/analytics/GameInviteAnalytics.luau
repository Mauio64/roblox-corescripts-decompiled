local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Cryo")

game:DefineFastFlag("GameInviteModalIncludeLinkIdInShareButton", false)

local class = {}
class.__index = class

class.ButtonName = {
	SettingsHub = "settingsHub",
	ModalPrompt = "modalPrompt",
	GameDetailsMoreMenu = "uaGameDetailsMoreMenu",
	GameDetailsPlayWithFriendsMenu = "uaGameDetailsPlayWithFriendsMenu"
}

class.EventName = {
	InviteSent = "inputShareGameInviteSent",
	EntryPoint = "inputShareGameEntryPoint",
	LinkGenerated = "linkGenerated",
	ShareButtonClick = "buttonClick",
	InviteSearchFocused = "inviteSearchFocused",
	GameInviteModal = "gameInviteModal"
}

class.ActionType = {
	ModalOpen = "modalOpen",
	InviteTriggered = "inviteTriggered",
	ModalClose = "modalClose",
	InviteFailure = "inviteFailure"
}

local v5 = {
	EntryPoint = {
		[class.ButtonName.SettingsHub] = settings():GetFVariable("LuaShareGameSettingsHubEntryCounter"),
		[class.ButtonName.ModalPrompt] = settings():GetFVariable("LuaShareGameModalPromptEntryCounter")
	},
	InviteSent = 0
}

local fVariables2 = {
	[class.ButtonName.SettingsHub] = settings():GetFVariable("LuaShareGameSettingsHubInviteCounter"),
	[class.ButtonName.ModalPrompt] = settings():GetFVariable("LuaShareGameModalPromptInviteCounter")
}
v5.InviteSent = fVariables2
class.DiagCounters = v5

function class.new()
	local v6 = { _eventStreamImpl = nil, _diagImpl = nil, _buttonName = nil }

	setmetatable(v6, class)

	return v6
end

function class:withEventStream(eventStreamImpl)
	self._eventStreamImpl = eventStreamImpl
	return self
end

function class:withDiag(diagImpl)
	self._diagImpl = diagImpl
	return self
end

function class:withButtonName(buttonName)
	self._buttonName = buttonName
	return self
end

function class:onActivatedInviteSent(p2, p3, list, p4, p5)
	local buttonName = self:_getButtonName()

	local v6 = self:_getIsUniversalApp() and "inApp" or "inGame"

	local inviteSent = class.EventName.InviteSent
	local joined = table.concat(list, ",")
	local v7, v8

	if self:_getIsUniversalApp() then
		v7 = tostring(p4)
		v8 = tostring(p5)
	else
		v7 = tostring(game.PlaceId)
		v8 = tostring(game.GameId)
	end

	local v9 = {
		btn = buttonName,
		placeId = v7,
		gameId = v8,
		conversationId = tostring(p3),
		participants = joined
	}

	self:_getEventStream():setRBXEventStream(v6, inviteSent, v9)

	local v10 = class.DiagCounters.InviteSent[self:_getButtonName()]

	if v10 then
		self:_getDiag():reportCounter(v10, 1)
	end
end

function class:inputShareGameEntryPoint(p2, p3)
	local buttonName = self:_getButtonName()

	local v6 = self:_getIsUniversalApp() and "inApp" or "inGame"

	local entryPoint = class.EventName.EntryPoint
	local v7, v8

	if self:_getIsUniversalApp() then
		v7 = tostring(p2)
		v8 = tostring(p3)
	else
		v7 = tostring(game.PlaceId)
		v8 = tostring(game.GameId)
	end

	self:_getEventStream():setRBXEventStream(v6, entryPoint, {
		btn = buttonName,
		placeId = v7,
		gameId = v8
	})

	local v9 = class.DiagCounters.EntryPoint[self:_getButtonName()]

	if v9 then
		self:_getDiag():reportCounter(v9, 1)
	end
end

function class:linkGenerated(p2)
	local linkGenerated = class.EventName.LinkGenerated

	local v6 = {
		linkType = p2.linkType,
		linkId = p2.linkId,
		page = "inGameMenu",
		subpage = "inviteFriendsPage"
	}

	self:_getEventStream():setRBXEventStream("shareLinks", linkGenerated, v6)
end

function class:onShareButtonClick(linkId)
	local shareButtonClick = class.EventName.ShareButtonClick

	if not game:GetFastFlag("GameInviteModalIncludeLinkIdInShareButton") then
		linkId = nil
	end

	self:_getEventStream():setRBXEventStream("shareLinks", shareButtonClick, {
		btn = "shareServerInviteLink",
		page = "inGameMenu",
		subpage = "inviteFriendsPage",
		linkId = linkId,
		isShortUrlEnabled = true
	})
end

function class:onSearchFocused()
	local inviteSearchFocused = class.EventName.InviteSearchFocused

	local v6 = {
		btn = self:_getButtonName(),
		page = "inGameMenu",
		subpage = "inviteFriendsPage"
	}
	local v7

	if self:_getIsUniversalApp() then
		v6.page = "inAppGameDetails"
		v7 = "inApp"
	else
		v7 = "inGame"
	end

	self:_getEventStream():setRBXEventStream(v7, inviteSearchFocused, v6)
end

function class:sendEvent(p2, p3, p4)
	local join = Cryo.Dictionary.join
	local args = p3.Args
	local v7 = if self:_getIsUniversalApp() and p4 and p4.place_id then p4.place_id else game.PlaceId
	local joined = join(args, { placeId = v7 })

	if p4 then
		joined = Cryo.Dictionary.join(joined, p4)
	end

	self:_getEventStream():setRBXEventStream(p2, p3.Type, joined)
end

function class:sendGameInviteModalEvent(p2, p3)
	local v6 = if self:_getIsUniversalApp() and p3 and p3.place_id then p3.place_id else game.PlaceId
	local joined = { place_id = v6 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	self:_getEventStream():setRBXEventStream(p2, class.EventName.GameInviteModal, joined)
end

function class:_getEventStream()
	assert(
		self._eventStreamImpl,
		"EventStream implementation not found. Did you forget to construct withEventStream?"
	)
	return self._eventStreamImpl
end

function class:_getDiag()
	assert(self._diagImpl, "Diag implementation not found. Did you forget to construct withDiag?")
	return self._diagImpl
end

function class:_getButtonName()
	assert(self._buttonName, "ButtonName not found. Did you forget to construct withButtonName?")
	return self._buttonName
end

function class:_getIsUniversalApp(): boolean
	assert(self._buttonName, "ButtonName not found. Did you forget to construct withButtonName?")
	return self._buttonName == class.ButtonName.GameDetailsMoreMenu
		or self._buttonName == class.ButtonName.GameDetailsPlayWithFriendsMenu
end

return class
