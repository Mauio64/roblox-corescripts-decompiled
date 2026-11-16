local NotificationsUpsellConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NotificationsUpsellConstants")

return {
	getPushUpsellPromptedCount = function(object, p2)
		local success, result = pcall(function()
			return object:GetItem(p2)
		end)

		if not success then
			return -1
		end

		local v5 = tonumber(result)

		if v5 == nil then
			return 0
		end

		return v5
	end,
	getPushSysUpsellPromptTimestamp = function(object)
		local success, result = pcall(function()
			return object:GetItem(NotificationsUpsellConstants.LocalStorageKeys.SysPromptShownTimestamp)
		end)

		if not success then
			return -1
		end

		local v5 = tonumber(result)

		if v5 == nil then
			return 0
		end

		return v5
	end,
	getPushEduUpsellResponseTimestamp = function(object)
		local success, result = pcall(function()
			return object:GetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponseTimestamp)
		end)

		if not success then
			return -1
		end

		local v5 = tonumber(result)

		if v5 == nil then
			return 0
		end

		return v5
	end,
	incrementPushUpsellPromptedCount = function(object, p2)
		local success, result = pcall(function()
			return object:GetItem(p2)
		end)

		if success then
			local v5 = tonumber(result) or 0
			pcall(function()
				object:SetItem(p2, (tostring(v5 + 1)))
				object:Flush()
			end)
		end
	end,
	setPushSysUpsellPromptTimestamp = function(object, p2)
		pcall(function()
			object:SetItem(NotificationsUpsellConstants.LocalStorageKeys.SysPromptShownTimestamp, (tostring(p2)))

			object:Flush()
		end)
	end,
	setPushEduUpsellResponseTimestamp = function(object, p2)
		pcall(function()
			object:SetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponseTimestamp, (tostring(p2)))

			object:Flush()
		end)
	end,
	setPushEduUpsellResponse = function(object, p2)
		pcall(function()
			object:SetItem(NotificationsUpsellConstants.LocalStorageKeys.EduPromptResponse, p2)
			object:Flush()
		end)
	end
}
