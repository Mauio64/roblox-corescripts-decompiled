local parent = script:FindFirstAncestor("GameInvite").Parent

local Cryo = require(parent.Cryo)

game:DefineFastFlag("GameInviteModalIncludeLinkIdInShareButton", false)

local GameInviteAnalytics = {}
GameInviteAnalytics.__index = GameInviteAnalytics

GameInviteAnalytics.ButtonName = {
	SettingsHub = "settingsHub",
	ModalPrompt = "modalPrompt",
	GameDetailsMoreMenu = "uaGameDetailsMoreMenu",
	GameDetailsPlayWithFriendsMenu = "uaGameDetailsPlayWithFriendsMenu"
}

GameInviteAnalytics.EventName = {
	InviteSent = "inputShareGameInviteSent",
	EntryPoint = "inputShareGameEntryPoint",
	LinkGenerated = "linkGenerated",
	ShareButtonClick = "buttonClick",
	InviteSearchFocused = "inviteSearchFocused",
	GameInviteModal = "gameInviteModal"
}

GameInviteAnalytics.ActionType = {
	ModalOpen = "modalOpen",
	InviteTriggered = "inviteTriggered",
	ModalClose = "modalClose",
	InviteFailure = "inviteFailure"
}

local diagCounters = {
	EntryPoint = {
		[GameInviteAnalytics.ButtonName.SettingsHub] = settings():GetFVariable("LuaShareGameSettingsHubEntryCounter"),
		[GameInviteAnalytics.ButtonName.ModalPrompt] = settings():GetFVariable("LuaShareGameModalPromptEntryCounter")
	},
	InviteSent = 0
}

local fVariables = {
	[GameInviteAnalytics.ButtonName.SettingsHub] = settings():GetFVariable("LuaShareGameSettingsHubInviteCounter"),
	[GameInviteAnalytics.ButtonName.ModalPrompt] = settings():GetFVariable("LuaShareGameModalPromptInviteCounter")
}
diagCounters.InviteSent = fVariables
GameInviteAnalytics.DiagCounters = diagCounters

function GameInviteAnalytics.new()
	local v = { _eventStreamImpl = nil, _diagImpl = nil, _buttonName = nil }

	setmetatable(v, GameInviteAnalytics)

	return v
end

function GameInviteAnalytics:withEventStream(eventStreamImpl)
	self._eventStreamImpl = eventStreamImpl
	return self
end

function GameInviteAnalytics:withDiag(diagImpl)
	self._diagImpl = diagImpl
	return self
end

function GameInviteAnalytics:withButtonName(buttonName)
	self._buttonName = buttonName
	return self
end

function GameInviteAnalytics:onActivatedInviteSent(_, p, list, p2, p3)
	local buttonName = self:_getButtonName()

	local v = self:_getIsUniversalApp() and "inApp" or "inGame"

	local inviteSent = GameInviteAnalytics.EventName.InviteSent
	local joined = table.concat(list, ",")
	local placeId, gameId

	if self:_getIsUniversalApp() then
		placeId = tostring(p2)
		gameId = tostring(p3)
	else
		placeId = tostring(game.PlaceId)
		gameId = tostring(game.GameId)
	end

	local v2 = {
		btn = buttonName,
		placeId = placeId,
		gameId = gameId,
		conversationId = tostring(p),
		participants = joined
	}

	self:_getEventStream():setRBXEventStream(v, inviteSent, v2)

	local v3 = GameInviteAnalytics.DiagCounters.InviteSent[self:_getButtonName()]

	if v3 then
		self:_getDiag():reportCounter(v3, 1)
	end
end

function GameInviteAnalytics:inputShareGameEntryPoint(p, p2)
	local buttonName = self:_getButtonName()

	local v = self:_getIsUniversalApp() and "inApp" or "inGame"

	local entryPoint = GameInviteAnalytics.EventName.EntryPoint
	local placeId, gameId

	if self:_getIsUniversalApp() then
		placeId = tostring(p)
		gameId = tostring(p2)
	else
		placeId = tostring(game.PlaceId)
		gameId = tostring(game.GameId)
	end

	self:_getEventStream():setRBXEventStream(v, entryPoint, {
		btn = buttonName,
		placeId = placeId,
		gameId = gameId
	})

	local v2 = GameInviteAnalytics.DiagCounters.EntryPoint[self:_getButtonName()]

	if v2 then
		self:_getDiag():reportCounter(v2, 1)
	end
end

function GameInviteAnalytics:linkGenerated(p)
	local linkGenerated = GameInviteAnalytics.EventName.LinkGenerated

	local v = {
		linkType = p.linkType,
		linkId = p.linkId,
		page = "inGameMenu",
		subpage = "inviteFriendsPage"
	}

	self:_getEventStream():setRBXEventStream("shareLinks", linkGenerated, v)
end

function GameInviteAnalytics:onShareButtonClick(linkId: number?)
	local shareButtonClick = GameInviteAnalytics.EventName.ShareButtonClick

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

function GameInviteAnalytics:onSearchFocused()
	local inviteSearchFocused = GameInviteAnalytics.EventName.InviteSearchFocused

	local v = { btn = self:_getButtonName(), page = "inGameMenu", subpage = "inviteFriendsPage" }
	local v2

	if self:_getIsUniversalApp() then
		v.page = "inAppGameDetails"
		v2 = "inApp"
	else
		v2 = "inGame"
	end

	self:_getEventStream():setRBXEventStream(v2, inviteSearchFocused, v)
end

function GameInviteAnalytics:sendEvent(p, p2, p3)
	local join = Cryo.Dictionary.join
	local args = p2.Args
	local placeId

	if self:_getIsUniversalApp() and p3 and p3.place_id then
		placeId = p3.place_id
	else
		placeId = game.PlaceId
	end

	local joined = join(args, { placeId = placeId })

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	self:_getEventStream():setRBXEventStream(p, p2.Type, joined)
end

function GameInviteAnalytics:sendGameInviteModalEvent(p, p2)
	local place_id

	if self:_getIsUniversalApp() and p2 and p2.place_id then
		place_id = p2.place_id
	else
		place_id = game.PlaceId
	end

	local joined = { place_id = place_id }

	if p2 then
		joined = Cryo.Dictionary.join(joined, p2)
	end

	self:_getEventStream():setRBXEventStream(p, GameInviteAnalytics.EventName.GameInviteModal, joined)
end

function GameInviteAnalytics:_getEventStream()
	assert(self._eventStreamImpl, "EventStream implementation not found. Did you forget to construct withEventStream?")
	return self._eventStreamImpl
end

function GameInviteAnalytics:_getDiag()
	assert(self._diagImpl, "Diag implementation not found. Did you forget to construct withDiag?")
	return self._diagImpl
end

function GameInviteAnalytics:_getButtonName()
	assert(self._buttonName, "ButtonName not found. Did you forget to construct withButtonName?")
	return self._buttonName
end

function GameInviteAnalytics:_getIsUniversalApp(): boolean
	assert(self._buttonName, "ButtonName not found. Did you forget to construct withButtonName?")
	return self._buttonName == GameInviteAnalytics.ButtonName.GameDetailsMoreMenu
		or self._buttonName == GameInviteAnalytics.ButtonName.GameDetailsPlayWithFriendsMenu
end

return GameInviteAnalytics
