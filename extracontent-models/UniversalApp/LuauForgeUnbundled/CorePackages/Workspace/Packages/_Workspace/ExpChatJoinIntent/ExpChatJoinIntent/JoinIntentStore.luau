local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")

local getGameLaunchPlaceId = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatJoinIntent/ExpChatJoinIntent/getGameLaunchPlaceId")
local parseNotificationTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatJoinIntent/ExpChatJoinIntent/parseNotificationTypes")

local class = {}
class.__index = class

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
	local v5 = {
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

	v5.notificationId = notificationId

	if type(chatTarget) ~= "string" then
		chatTarget = nil
	end

	v5.chatTarget = chatTarget
	v5.placeId = result.placeId
	v5.createdAt = result.createdAt
	return v5
end

function class.new(p2)
	return (setmetatable({
		notificationTypes = parseNotificationTypes(p2.notificationTypes),
		now = p2.now or os.time,
		cachedRead = nil
	}, class))
end

function class:handleDeeplinkTap(data)
	local notificationType = data.notificationType

	if notificationType == nil then
		return
	end

	local notificationType2 = self.notificationTypes[notificationType]

	if notificationType2 == nil then
		return
	end

	local v5 = getGameLaunchPlaceId(data.url)

	if v5 == nil then
		return
	end

	MemStorageService:SetItem("ExpChatJoinIntent", HttpService:JSONEncode({
		version = 1,
		source = data.source,
		notificationType = notificationType,
		notificationId = data.notificationId,
		chatTarget = notificationType2.chatTarget,
		placeId = v5,
		createdAt = self.now()
	}))
end

function class:read(p2)
	local cachedRead = self.cachedRead

	if cachedRead then
		return cachedRead
	end

	local item = MemStorageService:GetItem("ExpChatJoinIntent")
	local v5

	if item == "" then
		v5 = { result = "none" }
	else
		MemStorageService:SetItem("ExpChatJoinIntent", "")
		local success, result = pcall(HttpService.JSONDecode, HttpService, item)
		local v6 = if success then toJoinIntent(result) else nil

		if v6 == nil then
			v5 = { result = "invalid" }
		elseif self.now() - v6.createdAt > 300 then
			v5 = { result = "expired", intent = v6 }
		elseif v6.placeId == p2 then
			v5 = { result = "accepted", intent = v6 }
		else
			v5 = { result = "placeMismatch", intent = v6 }
		end
	end

	self.cachedRead = v5
	return v5
end

function class.getIntent(p2)
	local cachedRead = p2.cachedRead

	if cachedRead and cachedRead.result == "accepted" then
		return cachedRead.intent
	end

	return nil
end

return class
