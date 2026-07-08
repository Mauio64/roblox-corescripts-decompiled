local t1 = {}

t1.__index = t1
t1.ButtonName = {
	LuaChatInputBar = "luaChatInputBar",
	LuaGameDetails = "luaGameDetails"
}
t1.EventName = {
	InviteSent = "inputShareGameInviteSent",
	EntryPoint = "inputShareGameEntryPoint"
}
t1.DiagCounters = {
	EntryPoint = {
		[t1.ButtonName.LuaChatInputBar] = game:DefineFastString("LuaShareGameLuaChatInputBarEntryCounter", "LuaShareGameLuaChatInputBarEntryCounter"),
		[t1.ButtonName.LuaGameDetails] = game:DefineFastString("LuaShareGameLuaGameDetailsEntryCounter", "LuaShareGameLuaGameDetailsEntryCounter")
	},
	InviteSent = {
		[t1.ButtonName.LuaChatInputBar] = game:DefineFastString("LuaShareGameLuaChatInputBarInviteCounter", "LuaShareGameLuaChatInputBarInviteCounter"),
		[t1.ButtonName.LuaGameDetails] = game:DefineFastString("LuaShareGameLuaGameDetailsInviteCounter", "LuaShareGameLuaGameDetailsInviteCounter")
	}
}

function t1.new(p1, p2, p3) -- line: 38
	-- upvalues: t1 (copy)
	assert(p1, "EventStream implementation not found.")
	assert(p2, "Diag implementation not found.")
	assert(p3, "ButtonName not found.")

	return (setmetatable({
		_eventStreamImpl = p1,
		_diagImpl = p2,
		_buttonName = p3
	}, t1))
end
function t1.onActivatedInviteSent(p4, p5, p6, p7, p8, p9) -- line: 50
	-- upvalues: t1 (copy)
	local v11 = p4:_getButtonName()
	local InviteSent = t1.EventName.InviteSent
	local v13 = table.concat(p9, ",")
	local t2 = {
		btn = v11,
		placeId = tostring(p5),
		gameId = tostring(p6),
		senderId = p7,
		conversationId = tostring(p8),
		participants = v13
	}

	p4:_getEventStream():setRBXEventStream("touch", InviteSent, t2)

	local v15 = t1.DiagCounters.InviteSent[p4:_getButtonName()]

	if v15 then
		p4:_getDiag():reportCounter(v15, 1)
	end
end
function t1.inputShareGameEntryPoint(p10, p11, p12) -- line: 71
	-- upvalues: t1 (copy)
	local v19 = p10:_getButtonName()
	local EntryPoint = t1.EventName.EntryPoint
	local t3 = {
		btn = v19,
		placeId = p11 and tostring(p11),
		gameId = p12 and tostring(p12)
	}

	p10:_getEventStream():setRBXEventStream("touch", EntryPoint, t3)

	local v22 = t1.DiagCounters.EntryPoint[p10:_getButtonName()]

	if v22 then
		p10:_getDiag():reportCounter(v22, 1)
	end
end
function t1._getEventStream(p13) -- line: 89
	return p13._eventStreamImpl
end
function t1._getDiag(p14) -- line: 93
	return p14._diagImpl
end
function t1._getButtonName(p15) -- line: 97
	return p15._buttonName
end

return t1
