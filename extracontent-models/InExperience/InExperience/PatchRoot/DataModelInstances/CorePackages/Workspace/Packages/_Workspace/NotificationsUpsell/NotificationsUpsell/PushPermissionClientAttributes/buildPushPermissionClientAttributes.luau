local UserInputService = game:GetService("UserInputService")

local NotificationsUpsell = script:FindFirstAncestor("NotificationsUpsell")
local parent = NotificationsUpsell.Parent

local PermissionsProtocol = require(parent.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol
local Promise = require(parent.Promise)
local SystemInfoProtocol = require(parent.SystemInfoProtocol)
local systemInfoProtocol = SystemInfoProtocol.SystemInfoProtocol

local FIntStreamPushPermissionClientAttributesTimeoutMs = require(NotificationsUpsell.Flags.FIntStreamPushPermissionClientAttributesTimeoutMs)

local keys = {
	PERMISSION_STATUS = "pushNotificationPermissionStatus",
	UPSELL_STATUS = "pushNotificationUpsellStatus",
	RATIONALE_STATUS = "pushNotificationRationaleStatus",
	PUSH_NOTIFICATIONS_ENABLED = "pushNotificationsEnabled",
	CAN_OPEN_NOTIFICATION_SETTINGS = "canOpenNotificationSettings",
	ANDROID_SDK_LEVEL = "androidSdkLevel"
}

local BuildPushPermissionClientAttributes = {
	["Keys"] = keys,
	UNKNOWN = "UNKNOWN",
	_getPlatform = function()
		return UserInputService:GetPlatform()
	end,
	_permissionsProtocol = permissionsProtocol,
	_systemInfoProtocol = systemInfoProtocol
}

local function toAttributeValue(value) -- 2 equivalent calls inferred from this helper
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return "UNKNOWN"
end

local function getField(p, p2: string) -- 4 equivalent calls inferred from this helper
	if typeof(p) == "table" then
		return p[p2]
	end

	return nil
end

local function getPlatform() -- 1 equivalent call inferred from this helper
	local success, result = pcall(BuildPushPermissionClientAttributes._getPlatform)
	return if success then result else nil
end

local function readCanOpenNotificationSettings(): string -- 1 equivalent call inferred from this helper
	local success, result = pcall(BuildPushPermissionClientAttributes._permissionsProtocol.isOpenNotificationSettingsSupported)

	if not success then
		return "UNKNOWN"
	end

	return if result == true then "true" else "false"
end

local function readAndroidSdkLevel() -- 1 equivalent call inferred from this helper
	local _systemInfoProtocol = BuildPushPermissionClientAttributes._systemInfoProtocol
	local success, result = pcall(function()
		return _systemInfoProtocol.default:getSystemInfo({ _systemInfoProtocol.InfoNames.SYSTEM_VERSION })
	end)
	local v

	if success and typeof(result) == "table" then
		v = result.systemVersion
	end

	return toAttributeValue(v) -- inferred equivalent call
end

local function settleWithin(read)
	return Promise.new(function(callback)
		Promise.try(read):andThen(function(value)
			callback(toAttributeValue(value)) -- inferred equivalent call
		end, function()
			callback("UNKNOWN")
		end)
		task.delay(FIntStreamPushPermissionClientAttributesTimeoutMs / 1000, callback, "UNKNOWN")
	end)
end

function BuildPushPermissionClientAttributes.build()
	local platform = getPlatform() -- inferred equivalent call
	local v = platform == Enum.Platform.Android

	if platform ~= Enum.Platform.IOS and not v then
		return Promise.resolve({})
	end

	local _permissionsProtocol = BuildPushPermissionClientAttributes._permissionsProtocol
	local v2 = { _permissionsProtocol.Permissions.POST_NOTIFICATIONS }
	local canOpenNotificationSettings = readCanOpenNotificationSettings() -- inferred equivalent call
	local result = { [keys.CAN_OPEN_NOTIFICATION_SETTINGS] = canOpenNotificationSettings }

	if v then
		local ANDROID_SDK_LEVEL = keys.ANDROID_SDK_LEVEL
		result[ANDROID_SDK_LEVEL] = readAndroidSdkLevel() -- inferred equivalent call
	end

	local v3 = {
		{
			key = keys.PERMISSION_STATUS,
			read = function()
				return _permissionsProtocol.default:hasPermissions(v2):andThen(function(p)
					return getField(p, "status") -- inferred equivalent call
				end)
			end
		},
		{
			key = keys.UPSELL_STATUS,
			read = function()
				return _permissionsProtocol.default:shouldShowUpsell(v2):andThen(function(p)
					return getField(p, "upsellStatus") -- inferred equivalent call
				end)
			end
		},
		{
			key = keys.RATIONALE_STATUS,
			read = function()
				return _permissionsProtocol.default:shouldShowRationale(v2):andThen(function(p)
					return getField(p, "upsellStatus") -- inferred equivalent call
				end)
			end
		}
	}

	if v and canOpenNotificationSettings == "true" then
		table.insert(v3, {
			key = keys.PUSH_NOTIFICATIONS_ENABLED,
			read = function()
				return _permissionsProtocol.default:getPushNotificationsEnabled():andThen(function(p): nil | string
					local field = getField(p, "enabled") -- inferred equivalent call

					if field == true then
						return "true"
					elseif field == false then
						return "false"
					end

					return nil
				end)
			end
		})
	end

	local v4 = {}

	for _, v5 in v3 do
		table.insert(v4, settleWithin(v5.read))
	end

	return Promise.all(v4):andThen(function(p)
		for k, v5 in v3 do
			result[v5.key] = p[k]
		end

		return result
	end)
end

return BuildPushPermissionClientAttributes
