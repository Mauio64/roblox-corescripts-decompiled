local Parent = script:FindFirstAncestor("GameInvite").Parent
local Cryo = require(Parent.Cryo)

game:DefineFastFlag("GameInviteModalIncludeLinkIdInShareButton", false)

local t1 = {}

t1.__index = t1
t1.ButtonName = {
	SettingsHub = "settingsHub",
	ModalPrompt = "modalPrompt",
	GameDetailsMoreMenu = "uaGameDetailsMoreMenu",
	GameDetailsPlayWithFriendsMenu = "uaGameDetailsPlayWithFriendsMenu"
}
t1.EventName = {
	InviteSent = "inputShareGameInviteSent",
	EntryPoint = "inputShareGameEntryPoint",
	LinkGenerated = "linkGenerated",
	ShareButtonClick = "buttonClick",
	InviteSearchFocused = "inviteSearchFocused",
	GameInviteModal = "gameInviteModal"
}
t1.ActionType = {
	ModalOpen = "modalOpen",
	InviteTriggered = "inviteTriggered",
	ModalClose = "modalClose",
	InviteFailure = "inviteFailure"
}
t1.DiagCounters = {
	EntryPoint = {
		[t1.ButtonName.SettingsHub] = settings():GetFVariable("LuaShareGameSettingsHubEntryCounter"),
		[t1.ButtonName.ModalPrompt] = settings():GetFVariable("LuaShareGameModalPromptEntryCounter")
	},
	InviteSent = {
		[t1.ButtonName.SettingsHub] = settings():GetFVariable("LuaShareGameSettingsHubInviteCounter"),
		[t1.ButtonName.ModalPrompt] = settings():GetFVariable("LuaShareGameModalPromptInviteCounter")
	}
}

function t1.new() -- line: 47
	-- upvalues: t1 (copy)
	local t2 = {
		_eventStreamImpl = nil,
		_diagImpl = nil,
		_buttonName = nil
	}

	setmetatable(t2, t1)

	return t2
end
function t1.withEventStream(p1, p2) -- line: 58
	p1._eventStreamImpl = p2

	return p1
end
function t1.withDiag(p3, p4) -- line: 63
	p3._diagImpl = p4

	return p3
end
function t1.withButtonName(p5, p6) -- line: 68
	p5._buttonName = p6

	return p5
end
function t1.onActivatedInviteSent(p7, _, p9, p10, p11, p12) -- line: 73
	-- upvalues: t1 (copy)
	local v17 = p7:_getButtonName()
	local s1 = "inGame"

	if p7:_getIsUniversalApp() then
		s1 = "inApp"
	end

	local InviteSent = t1.EventName.InviteSent
	local v20 = table.concat(p10, ",")
	local str, str2

	if p7:_getIsUniversalApp() then
		str = tostring(p11)
		str2 = tostring(p12)
	else
		str = tostring(game.PlaceId)
		str2 = tostring(game.GameId)
	end

	local t3 = {
		btn = v17,
		placeId = str,
		gameId = str2,
		conversationId = tostring(p9),
		participants = v20
	}

	p7:_getEventStream():setRBXEventStream(s1, InviteSent, t3)

	local v24 = t1.DiagCounters.InviteSent[p7:_getButtonName()]

	if v24 then
		p7:_getDiag():reportCounter(v24, 1)
	end
end
function t1.inputShareGameEntryPoint(p13, p14, p15) -- line: 105
	-- upvalues: t1 (copy)
	local v28 = p13:_getButtonName()
	local s2 = "inGame"

	if p13:_getIsUniversalApp() then
		s2 = "inApp"
	end

	local EntryPoint = t1.EventName.EntryPoint
	local str, str3

	if p13:_getIsUniversalApp() then
		str = tostring(p14)
		str3 = tostring(p15)
	else
		str = tostring(game.PlaceId)
		str3 = tostring(game.GameId)
	end

	local t4 = {
		btn = v28,
		placeId = str,
		gameId = str3
	}

	p13:_getEventStream():setRBXEventStream(s2, EntryPoint, t4)

	local v34 = t1.DiagCounters.EntryPoint[p13:_getButtonName()]

	if v34 then
		p13:_getDiag():reportCounter(v34, 1)
	end
end
function t1.linkGenerated(t5: {[any]: any}, t6: {[any]: any}) -- line: 133
	-- upvalues: t1 (copy)
	local LinkGenerated = t1.EventName.LinkGenerated
	local t7 = {
		page = "inGameMenu",
		subpage = "inviteFriendsPage",
		linkType = t6.linkType,
		linkId = t6.linkId
	}

	t5:_getEventStream():setRBXEventStream("shareLinks", LinkGenerated, t7)
end
function t1.onShareButtonClick(t8: {[any]: any}, n1: number?) -- line: 145
	-- upvalues: t1 (copy)
	local ShareButtonClick = t1.EventName.ShareButtonClick
	local t9 = {
		btn = "shareServerInviteLink",
		page = "inGameMenu",
		subpage = "inviteFriendsPage",
		isShortUrlEnabled = true,
		linkId = if not game:GetFastFlag("GameInviteModalIncludeLinkIdInShareButton") then nil else n1
	}

	t8:_getEventStream():setRBXEventStream("shareLinks", ShareButtonClick, t9)
end
function t1.onSearchFocused(p16) -- line: 158
	-- upvalues: t1 (copy)
	local InviteSearchFocused = t1.EventName.InviteSearchFocused
	local s3 = "inGame"
	local t10 = {
		page = "inGameMenu",
		subpage = "inviteFriendsPage",
		btn = p16:_getButtonName()
	}

	if p16:_getIsUniversalApp() then
		s3 = "inApp"
		t10.page = "inAppGameDetails"
	end

	p16:_getEventStream():setRBXEventStream(s3, InviteSearchFocused, t10)
end
function t1.sendEvent(p17, p18, p19, p20) -- line: 173
	-- upvalues: Cryo (copy)
	local v51 = Cryo.Dictionary.join(p19.Args, {
		placeId = if not p17:_getIsUniversalApp() or (not p20 or not p20.place_id) then game.PlaceId else p20.place_id
	})

	if p20 then
		v51 = Cryo.Dictionary.join(v51, p20)
	end

	p17:_getEventStream():setRBXEventStream(p18, p19.Type, v51)
end
function t1.sendGameInviteModalEvent(p21, p22, p23) -- line: 187
	-- upvalues: Cryo (copy), t1 (copy)
	local t11 = {
		place_id = if not p21:_getIsUniversalApp() or (not p23 or not p23.place_id) then game.PlaceId else p23.place_id
	}

	if p23 then
		t11 = Cryo.Dictionary.join(t11, p23)
	end

	p21:_getEventStream():setRBXEventStream(p22, t1.EventName.GameInviteModal, t11)
end
function t1._getEventStream(p24) -- line: 201
	assert(p24._eventStreamImpl, "EventStream implementation not found. Did you forget to construct withEventStream?")

	return p24._eventStreamImpl
end
function t1._getDiag(p25) -- line: 206
	assert(p25._diagImpl, "Diag implementation not found. Did you forget to construct withDiag?")

	return p25._diagImpl
end
function t1._getButtonName(p26) -- line: 211
	assert(p26._buttonName, "ButtonName not found. Did you forget to construct withButtonName?")

	return p26._buttonName
end
function t1._getIsUniversalApp(p27) -- line: 216
	-- upvalues: t1 (copy)
	assert(p27._buttonName, "ButtonName not found. Did you forget to construct withButtonName?")

	return p27._buttonName == t1.ButtonName.GameDetailsMoreMenu or p27._buttonName == t1.ButtonName.GameDetailsPlayWithFriendsMenu
end

return t1
