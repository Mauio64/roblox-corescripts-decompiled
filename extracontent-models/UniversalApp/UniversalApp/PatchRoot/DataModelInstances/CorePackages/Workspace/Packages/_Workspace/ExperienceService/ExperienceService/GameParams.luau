require(script.Parent.GameProtocolTypes)

local t1 = {
	new = function() -- line: 9
		return {
			referralPage = "LuaChat"
		}
	end
}

function t1.fromPlaceId(p1, b1: boolean?) -- line: 17
	-- upvalues: t1 (copy)
	local v4 = t1.new()

	v4.placeId = p1
	v4.isTeamTest = b1

	return v4
end
function t1.fromUserId(p2, p3) -- line: 26
	-- upvalues: t1 (copy)
	local v7 = t1.new()

	v7.userId = p2
	v7.placeId = p3

	return v7
end
function t1.fromPlaceInstance(p4, s1: string) -- line: 33
	-- upvalues: t1 (copy)
	local v10 = t1.new()

	v10.placeId = p4
	v10.gameInstanceId = s1

	return v10
end
function t1.fromConversationId(p5, s2: string) -- line: 42
	-- upvalues: t1 (copy)
	local v13 = t1.new()

	v13.placeId = p5
	v13.conversationId = s2

	return v13
end
function t1.fromParams(p6) -- line: 51
	-- upvalues: t1 (copy)
	local v15 = t1.new()

	for k, v in pairs(p6) do
		v15[k] = v
	end

	return v15
end

return t1
