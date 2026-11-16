local SessionService = game:GetService("SessionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useEffect = React.useEffect
local useRef = React.useRef

local str = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill").String

local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppSessionization").SessionType

local fFlagExpChatEnableFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagExpChatEnableFriendsTab

local ChatSessionRefCount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/ChatSessionRefCount")

local defineFastString = game:DefineFastString("AppChatSessionName", "ChatPage")

local function createL3Session(object)
	local level2a = sessionType.StructuralIdentifier.Level2a

	if object:SessionExists(level2a) then
		object:SetSession(level2a, defineFastString, defineFastString)

		local sessionTag = object:GetSessionTag(level2a)

		if game:GetEngineFeature("SessionGetSessionID") and str.startsWith(sessionTag, "ingame") then
			object:SetMetadata(defineFastString, "InGameSessionId", (object:GetSessionID(level2a)))
		end
	end
end

return function(p2, p3)
	local v5 = p2 == nil or p2
	local v6 = p3 or SessionService

	if not fFlagExpChatEnableFriendsTab then
		useEffect(function()
			if v5 then
				createL3Session(v6)
			elseif v6:SessionExists(defineFastString) then
				v6:RemoveSession(defineFastString)
			end

			return function() end
		end, { p2, v6 })

		return
	end

	local v7 = useRef(false)

	if v5 then
		if not v7.current then
			ChatSessionRefCount.acquire(v6)
			v7.current = true
		end
	elseif v7.current then
		ChatSessionRefCount.release(v6)
		v7.current = false
	end

	useEffect(function()
		return function()
			if v7.current then
				ChatSessionRefCount.release(v6)
				v7.current = false
			end
		end
	end, {})
end
