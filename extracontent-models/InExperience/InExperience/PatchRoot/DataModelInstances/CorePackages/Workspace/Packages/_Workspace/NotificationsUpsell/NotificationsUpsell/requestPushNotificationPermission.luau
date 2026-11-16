local AppStorageService = game:GetService("AppStorageService")

local parent = script.Parent.Parent
local PermissionsProtocol = require(parent.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default
local Promise = require(parent.Promise)

local SharedFlags = require(parent.SharedFlags)
local FFlagPushPermissionRequestOpensAndroidSettings = SharedFlags.FFlagPushPermissionRequestOpensAndroidSettings

local NotificationsUpsellConstants = require(script.Parent.NotificationsUpsellConstants)
local PushNotificationsUpsellUtils = require(script.Parent.Util.PushNotificationsUpsellUtils)
local pushPermissionRequestEnvironment = require(script.Parent.Util.pushPermissionRequestEnvironment)

local function requestOsPrompt()
	return default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p)
		PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(AppStorageService, os.time())
		PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(
			AppStorageService,
			NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount
		)

		return p
	end)
end

local function settleWithin(fn) -- 1 equivalent call inferred from this helper
	return Promise.new(function(callback)
		Promise.try(fn):andThen(callback, function()
			callback(nil)
		end)
		task.delay(pushPermissionRequestEnvironment.statusReadTimeoutSeconds, callback, nil)
	end)
end

local function isHidden(p): boolean -- 2 equivalent calls inferred from this helper
	return typeof(p) == "table" and p.upsellStatus == default.UpsellStatus.HIDE
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

	local v = { default.Permissions.POST_NOTIFICATIONS }

	local function fn()
		return default:getPushNotificationsEnabled()
	end

	local function fn2()
		return default:shouldShowUpsell(v)
	end

	return Promise.all({
		Promise.new(function(callback)
			Promise.try(fn):andThen(callback, function()
				callback(nil)
			end)
			task.delay(pushPermissionRequestEnvironment.statusReadTimeoutSeconds, callback, nil)
		end),
		settleWithin(fn2), -- inferred equivalent call
		settleWithin(function()
			return default:shouldShowRationale(v)
		end)
	}):andThen(function(list)
		local item = list[1]
		return typeof(item) == "table" and item.enabled == false and isHidden(list[2]) and isHidden(list[3]) -- inferred equivalent call
	end)
end

local function openNotificationSettings()
	local openSettingsStatus = default.OpenSettingsStatus
	return default:openNotificationSettings():andThen(function(p)
		local openSettingsStatus2

		if typeof(p) == "table" and p.status ~= nil then
			openSettingsStatus2 = p.status
		else
			openSettingsStatus2 = openSettingsStatus.FAILED
		end

		if openSettingsStatus2 == openSettingsStatus.FAILED then
			return Promise.reject({ openSettingsStatus = openSettingsStatus2 })
		end

		return { openSettingsStatus = openSettingsStatus2 }
	end)
end

return function(p)
	if FFlagPushPermissionRequestOpensAndroidSettings and p ~= nil and p.allowOpenSettings == true then
		return shouldOpenSettings():andThen(function(p2)
			if p2 then
				return openNotificationSettings()
			end

			return requestOsPrompt()
		end)
	end

	return requestOsPrompt()
end
