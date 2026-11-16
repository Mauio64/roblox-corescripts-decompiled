local SessionService = game:GetService("SessionService")

local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local useEffect = React.useEffect
local useRef = React.useRef

local LuauPolyfill = require(parent.LuauPolyfill)
local String = LuauPolyfill.String

local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local ChatSessionRefCount = require(script.Parent.ChatSessionRefCount)

local defineFastString = game:DefineFastString("AppChatSessionName", "ChatPage")

local function createL3Session(object)
	local level2a = SessionType.StructuralIdentifier.Level2a

	if object:SessionExists(level2a) then
		object:SetSession(level2a, defineFastString, defineFastString)

		local sessionTag = object:GetSessionTag(level2a)

		if game:GetEngineFeature("SessionGetSessionID") and String.startsWith(sessionTag, "ingame") then
			object:SetMetadata(defineFastString, "InGameSessionId", (object:GetSessionID(level2a)))
		end
	end
end

return function(flag: boolean?, p)
	local v = flag == nil or flag
	local v2 = p or SessionService

	if not FFlagExpChatEnableFriendsTab then
		useEffect(function()
			if v then
				createL3Session(v2)
			elseif v2:SessionExists(defineFastString) then
				v2:RemoveSession(defineFastString)
			end

			return function() end
		end, { flag, v2 })

		return
	end

	local v3 = useRef(false)

	if v then
		if not v3.current then
			ChatSessionRefCount.acquire(v2)
			v3.current = true
		end
	elseif v3.current then
		ChatSessionRefCount.release(v2)
		v3.current = false
	end

	useEffect(function()
		return function()
			if v3.current then
				ChatSessionRefCount.release(v2)
				v3.current = false
			end
		end
	end, {})
end
