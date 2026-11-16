local NotificationsUpsellConstants = require(script.Parent.Parent.NotificationsUpsellConstants)
local PushNotificationsUpsellUtils = {}

function PushNotificationsUpsellUtils.getPushUpsellPromptedCount(object, p: string)
	local success, result = pcall(function()
		return object:GetItem(p)
	end)

	if not success then
		return -1
	end

	local v = tonumber(result)
	return if v == nil then 0 else v
end

function PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(object)
	local success, result = pcall(function()
		return object:GetItem(NotificationsUpsellConstants.LocalStorageKeys.SysPromptShownTimestamp)
	end)

	if not success then
		return -1
	end

	local v = tonumber(result)
	return if v == nil then 0 else v
end

function PushNotificationsUpsellUtils.getPushEduUpsellResponseTimestamp(object)
	local success, result = pcall(function()
		return object:GetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponseTimestamp)
	end)

	if not success then
		return -1
	end

	local v = tonumber(result)
	return if v == nil then 0 else v
end

function PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(object, p: string)
	local success, result = pcall(function()
		return object:GetItem(p)
	end)

	if success then
		local v = tonumber(result) or 0
		pcall(function()
			object:SetItem(p, (tostring(v + 1)))
			object:Flush()
		end)
	end
end

function PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(object, p: number)
	pcall(function()
		object:SetItem(NotificationsUpsellConstants.LocalStorageKeys.SysPromptShownTimestamp, (tostring(p)))

		object:Flush()
	end)
end

function PushNotificationsUpsellUtils.setPushEduUpsellResponseTimestamp(object, p: number)
	pcall(function()
		object:SetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponseTimestamp, (tostring(p)))

		object:Flush()
	end)
end

function PushNotificationsUpsellUtils.setPushEduUpsellResponse(object, p: string)
	pcall(function()
		object:SetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponse, p)
		object:Flush()
	end)
end

return PushNotificationsUpsellUtils
