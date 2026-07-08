local SessionService = game:GetService("SessionService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local useEffect = require(Parent.React).useEffect
local String = require(Parent.LuauPolyfill).String
local SessionType = require(Parent.RobloxAppSessionization).SessionType
local v6 = game:DefineFastString("AppChatSessionName", "ChatPage")

return function(b1: boolean, p1) -- line: 19
	-- upvalues: SessionService (copy), useEffect (copy), SessionType (copy), v6 (copy), String (copy)
	local v9 = p1 or SessionService

	useEffect(function() -- line: 22
		-- upvalues: b1 (copy), SessionType (copy), v9 (copy), v6 (copy), String (copy)
		if b1 then
			local Level2a = SessionType.StructuralIdentifier.Level2a

			if v9:SessionExists(Level2a) then
				v9:SetSession(Level2a, v6, v6)

				local SessionTag = v9:GetSessionTag(Level2a)

				if game:GetEngineFeature("SessionGetSessionID") and String.startsWith(SessionTag, "ingame") then
					local SessionID = v9:GetSessionID(Level2a)

					v9:SetMetadata(v6, "InGameSessionId", SessionID)
				end
			end
		elseif v9:SessionExists(v6) then
			v9:RemoveSession(v6)
		end

		return function() -- line: 43
		end
	end, {
		b1,
		v9
	})
end
