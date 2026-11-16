local SessionService = game:GetService("SessionService")

local str = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill").String

local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppSessionization").SessionType

local defineFastString = game:DefineFastString("AppChatSessionName", "ChatPage")

local count = 0
local reservations = 0

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

local function destroyL3Session(object)
	if object:SessionExists(defineFastString) then
		object:RemoveSession(defineFastString)
	end
end

return {
	acquire = function(p2)
		local v6 = p2 or SessionService

		if reservations > 0 then
			reservations -= 1
			return
		end

		count += 1

		if count == 1 then
			createL3Session(v6)
		end
	end,
	release = function(p2)
		local v6 = p2 or SessionService
		count -= 1

		if count == 0 and v6:SessionExists(defineFastString) then
			v6:RemoveSession(defineFastString)
		end
	end,
	reserve = function(p2)
		local v6 = p2 or SessionService
		reservations += 1
		count += 1

		if count == 1 then
			createL3Session(v6)
		end
	end,
	getCount = function()
		return count
	end,
	getReservations = function()
		return reservations
	end,
	_resetForTesting = function()
		count = 0
		reservations = 0
	end
}
