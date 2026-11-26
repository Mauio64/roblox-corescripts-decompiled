local AppStorageService = game:GetService("AppStorageService")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/PermissionsProtocol").PermissionsProtocol.default
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/Promise")

local fFlagPushPermissionRequestOpensAndroidSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").FFlagPushPermissionRequestOpensAndroidSettings

local NotificationsUpsellConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NotificationsUpsellConstants")
local PushNotificationsUpsellUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Util/PushNotificationsUpsellUtils")
local pushPermissionRequestEnvironment = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Util/pushPermissionRequestEnvironment")

local function requestOsPrompt()
	return default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p2)
		PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(AppStorageService, os.time())
		PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(
			AppStorageService,
			NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount
		)

		return p2
	end)
end

local function settleWithin(fn)
	return Promise.new(function(callback)
		Promise.try(fn):andThen(callback, function()
			callback(nil)
		end)
		task.delay(pushPermissionRequestEnvironment.statusReadTimeoutSeconds, callback, nil)
	end)
end

local function isHidden(p2): boolean
	return typeof(p2) == "table" and p2.upsellStatus == default.UpsellStatus.HIDE
end

local function shouldOpenSettings()
	local success, result = pcall(pushPermissionRequestEnvironment.getPlatform)

	if not success or result ~= Enum.Platform.Android then
		return Promise.resolve(false)
	end

	local success2, result2 = pcall(default.isOpenNotificationSettingsSupported)

	if not success2 or result2 ~= true then
		return Promise.resolve(false)
	end

	local v5 = { default.Permissions.POST_NOTIFICATIONS }

	local function fn()
		return default:getPushNotificationsEnabled()
	end

	local function fn2()
		return default:shouldShowUpsell(v5)
	end

	return Promise.all({
		Promise.new(function(callback)
			Promise.try(fn):andThen(callback, function()
				callback(nil)
			end)
			task.delay(pushPermissionRequestEnvironment.statusReadTimeoutSeconds, callback, nil)
		end),
		Promise.new(function(callback)
			Promise.try(fn2):andThen(callback, function()
				callback(nil)
			end)
			task.delay(pushPermissionRequestEnvironment.statusReadTimeoutSeconds, callback, nil)
		end),
		settleWithin(function()
			return default:shouldShowRationale(v5)
		end)
	}):andThen(function(list)
		local item = list[1]
		local v7

		if typeof(item) == "table" and item.enabled == false then
			local item2 = list[2]
			v7 = typeof(item2) == "table" and item2.upsellStatus == default.UpsellStatus.HIDE

			if v7 then
				local item3 = list[3]
				v7 = typeof(item3) == "table" and item3.upsellStatus == default.UpsellStatus.HIDE
			end
		else
			v7 = false
		end

		return v7
	end)
end

local function openNotificationSettings()
	local openSettingsStatus = default.OpenSettingsStatus
	return default:openNotificationSettings():andThen(function(p2)
		local v5

		if typeof(p2) == "table" and p2.status ~= nil then
			v5 = p2.status
		else
			v5 = openSettingsStatus.FAILED
		end

		if v5 == openSettingsStatus.FAILED then
			return Promise.reject({ openSettingsStatus = v5 })
		end

		return { openSettingsStatus = v5 }
	end)
end

return function(p2)
	if fFlagPushPermissionRequestOpensAndroidSettings and p2 ~= nil and p2.allowOpenSettings == true then
		return shouldOpenSettings():andThen(function(p3)
			if p3 then
				return openNotificationSettings()
			end

			return requestOsPrompt()
		end)
	end

	return requestOsPrompt()
end
