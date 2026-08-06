local SessionService = game:GetService("SessionService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local useEffect = React.useEffect
local useRef = React.useRef
local String = require(Parent.LuauPolyfill).String
local SessionType = require(Parent.RobloxAppSessionization).SessionType
local FFlagExpChatEnableFriendsTab = require(Parent.SharedFlags).FFlagExpChatEnableFriendsTab
local ChatSessionRefCount = require(script.Parent.ChatSessionRefCount)
local v10 = game:DefineFastString("AppChatSessionName", "ChatPage")

local function createL3Session(p1) -- line: 23
	-- upvalues: SessionType (copy), v10 (copy), String (copy)
	local Level2a = SessionType.StructuralIdentifier.Level2a

	if p1:SessionExists(Level2a) then
		p1:SetSession(Level2a, v10, v10)

		local SessionTag = p1:GetSessionTag(Level2a)

		if game:GetEngineFeature("SessionGetSessionID") and String.startsWith(SessionTag, "ingame") then
			local SessionID = p1:GetSessionID(Level2a)

			p1:SetMetadata(v10, "InGameSessionId", SessionID)
		end
	end
end

return function(b1: boolean?, p2) -- line: 36
	-- upvalues: SessionService (copy), FFlagExpChatEnableFriendsTab (copy), useRef (copy), ChatSessionRefCount (copy), useEffect (copy), createL3Session (copy), v10 (copy)
	local v18 = b1 == nil or b1
	local v19 = p2 or SessionService

	if FFlagExpChatEnableFriendsTab then
		local v20 = useRef(false)

		if v18 then
			if not v20.current then
				ChatSessionRefCount.acquire(v19)
				v20.current = true
			end
		elseif v20.current then
			ChatSessionRefCount.release(v19)
			v20.current = false
		end

		useEffect(function() -- line: 55
			-- upvalues: v20 (copy), ChatSessionRefCount (copy), v19 (copy)
			return function() -- line: 56
				-- upvalues: v20 (copy), ChatSessionRefCount (copy), v19 (copy)
				if v20.current then
					ChatSessionRefCount.release(v19)
					v20.current = false
				end
			end
		end, {})

		return
	end

	useEffect(function() -- line: 64
		-- upvalues: v18 (copy), createL3Session (copy), v19 (copy), v10 (copy)
		if v18 then
			createL3Session(v19)
		elseif v19:SessionExists(v10) then
			v19:RemoveSession(v10)
		end

		return function() -- line: 74
		end
	end, {
		b1,
		v19
	})
end
