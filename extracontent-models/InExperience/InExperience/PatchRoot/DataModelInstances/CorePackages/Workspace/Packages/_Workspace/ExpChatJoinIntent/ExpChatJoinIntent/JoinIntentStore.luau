local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")

local parent = script.Parent
local getGameLaunchPlaceId = require(parent.getGameLaunchPlaceId)
local parseNotificationTypes = require(parent.parseNotificationTypes)

local JoinIntentStore = {}
JoinIntentStore.__index = JoinIntentStore

local function toJoinIntent(result)
	if type(result) ~= "table" then
		return nil
	end

	if
		result.version ~= 1
		or type(result.source) ~= "string"
		or type(result.notificationType) ~= "string"
		or type(result.placeId) ~= "number"
		or type(result.createdAt) ~= "number"
	then
		return nil
	end

	local notificationId = result.notificationId
	local chatTarget = result.chatTarget
	local v = {
		version = 1,
		source = result.source,
		notificationType = result.notificationType,
		notificationId = 0,
		chatTarget = 0,
		placeId = 0,
		createdAt = 0
	}

	if type(notificationId) ~= "string" then
		notificationId = nil
	end

	v.notificationId = notificationId

	if type(chatTarget) ~= "string" then
		chatTarget = nil
	end

	v.chatTarget = chatTarget
	v.placeId = result.placeId
	v.createdAt = result.createdAt
	return v
end

function JoinIntentStore.new(p)
	return (setmetatable({
		notificationTypes = parseNotificationTypes(p.notificationTypes),
		now = p.now or os.time,
		cachedRead = nil
	}, JoinIntentStore))
end

function JoinIntentStore.handleDeeplinkTap(p, data)
	local notificationType = data.notificationType

	if notificationType == nil then
		return
	end

	local notificationType2 = p.notificationTypes[notificationType]

	if notificationType2 == nil then
		return
	end

	local gameLaunchPlaceId = getGameLaunchPlaceId(data.url)

	if gameLaunchPlaceId == nil then
		return
	end

	MemStorageService:SetItem("ExpChatJoinIntent", HttpService:JSONEncode({
		version = 1,
		source = data.source,
		notificationType = notificationType,
		notificationId = data.notificationId,
		chatTarget = notificationType2.chatTarget,
		placeId = gameLaunchPlaceId,
		createdAt = p.now()
	}))
end

function JoinIntentStore:read(p: number)
	local cachedRead = self.cachedRead

	if cachedRead then
		return cachedRead
	end

	local item = MemStorageService:GetItem("ExpChatJoinIntent")
	local cachedRead2

	if item == "" then
		cachedRead2 = { result = "none" }
	else
		MemStorageService:SetItem("ExpChatJoinIntent", "")
		local success, result = pcall(HttpService.JSONDecode, HttpService, item)
		local intent

		if success then
			intent = toJoinIntent(result)
		end

		if intent == nil then
			cachedRead2 = { result = "invalid" }
		elseif self.now() - intent.createdAt > 300 then
			cachedRead2 = { result = "expired", intent = intent }
		elseif intent.placeId == p then
			cachedRead2 = { result = "accepted", intent = intent }
		else
			cachedRead2 = { result = "placeMismatch", intent = intent }
		end
	end

	self.cachedRead = cachedRead2
	return cachedRead2
end

function JoinIntentStore.getIntent(p)
	local cachedRead = p.cachedRead

	if cachedRead and cachedRead.result == "accepted" then
		return cachedRead.intent
	end

	return nil
end

return JoinIntentStore
