local SessionService = game:GetService("SessionService")

local parent = script:FindFirstAncestor("AppChat").Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local String = LuauPolyfill.String

local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType

local defineFastString = game:DefineFastString("AppChatSessionName", "ChatPage")

local count = 0
local reservations = 0

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

local function destroyL3Session(object) -- 1 equivalent call inferred from this helper
	if object:SessionExists(defineFastString) then
		object:RemoveSession(defineFastString)
	end
end

local ChatSessionRefCount = {}

function ChatSessionRefCount.acquire(p)
	local v = p or SessionService

	if reservations > 0 then
		reservations -= 1
		return
	end

	count += 1

	if count == 1 then
		createL3Session(v)
	end
end

function ChatSessionRefCount.release(p)
	local v = p or SessionService
	count -= 1

	if count == 0 then
		destroyL3Session(v) -- inferred equivalent call
	end
end

function ChatSessionRefCount.reserve(p)
	local v = p or SessionService
	reservations += 1
	count += 1

	if count == 1 then
		createL3Session(v)
	end
end

function ChatSessionRefCount.getCount()
	return count
end

function ChatSessionRefCount.getReservations()
	return reservations
end

function ChatSessionRefCount._resetForTesting()
	count = 0
	reservations = 0
end

return ChatSessionRefCount
