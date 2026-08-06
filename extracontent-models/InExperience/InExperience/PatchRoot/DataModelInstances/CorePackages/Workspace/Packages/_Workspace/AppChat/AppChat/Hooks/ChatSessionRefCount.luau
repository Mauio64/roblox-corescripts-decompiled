local SessionService = game:GetService("SessionService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local String = require(Parent.LuauPolyfill).String
local SessionType = require(Parent.RobloxAppSessionization).SessionType
local v5 = game:DefineFastString("AppChatSessionName", "ChatPage")
local n1 = 0
local n2 = 0
local t1 = {}

local function createL3Session(p1) -- line: 23
	-- upvalues: SessionType (copy), v5 (copy), String (copy)
	local Level2a = SessionType.StructuralIdentifier.Level2a

	if p1:SessionExists(Level2a) then
		p1:SetSession(Level2a, v5, v5)

		local SessionTag = p1:GetSessionTag(Level2a)

		if game:GetEngineFeature("SessionGetSessionID") and String.startsWith(SessionTag, "ingame") then
			local SessionID = p1:GetSessionID(Level2a)

			p1:SetMetadata(v5, "InGameSessionId", SessionID)
		end
	end
end
local function destroyL3Session(p2) -- line: 39
	-- upvalues: v5 (copy)
	if p2:SessionExists(v5) then
		p2:RemoveSession(v5)
	end
end

function t1.acquire(p3) -- line: 45
	-- upvalues: SessionService (copy), n2 (ref), n1 (ref), createL3Session (copy)
	local v17 = p3 or SessionService

	if n2 > 0 then
		n2 -= 1

		return
	end

	n1 += 1

	if n1 == 1 then
		createL3Session(v17)
	end
end
function t1.release(p4) -- line: 57
	-- upvalues: SessionService (copy), n1 (ref), v5 (copy)
	local v19 = p4 or SessionService

	n1 -= 1

	if n1 == 0 and v19:SessionExists(v5) then
		v19:RemoveSession(v5)
	end
end
function t1.reserve(p5) -- line: 68
	-- upvalues: SessionService (copy), n2 (ref), n1 (ref), createL3Session (copy)
	local v21 = p5 or SessionService

	n2 += 1
	n1 += 1

	if n1 == 1 then
		createL3Session(v21)
	end
end
function t1.getCount() -- line: 77
	-- upvalues: n1 (ref)
	return n1
end
function t1.getReservations() -- line: 81
	-- upvalues: n2 (ref)
	return n2
end
function t1._resetForTesting() -- line: 85
	-- upvalues: n1 (ref), n2 (ref)
	n1 = 0
	n2 = 0
end

return t1
