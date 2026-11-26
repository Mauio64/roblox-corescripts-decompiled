local UserInputService = game:GetService("UserInputService")

local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/PermissionsProtocol").PermissionsProtocol
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/Promise")
local systemInfoProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SystemInfoProtocol").SystemInfoProtocol

local FIntStreamPushPermissionClientAttributesTimeoutMs = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Flags/FIntStreamPushPermissionClientAttributesTimeoutMs")

local v5 = {
	PERMISSION_STATUS = "pushNotificationPermissionStatus",
	UPSELL_STATUS = "pushNotificationUpsellStatus",
	RATIONALE_STATUS = "pushNotificationRationaleStatus",
	PUSH_NOTIFICATIONS_ENABLED = "pushNotificationsEnabled",
	CAN_OPEN_NOTIFICATION_SETTINGS = "canOpenNotificationSettings",
	ANDROID_SDK_LEVEL = "androidSdkLevel"
}

local v6 = {
	["Keys"] = v5,
	UNKNOWN = "UNKNOWN",
	_getPlatform = function()
		return UserInputService:GetPlatform()
	end,
	_permissionsProtocol = permissionsProtocol,
	_systemInfoProtocol = systemInfoProtocol
}

local function toAttributeValue(value)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return "UNKNOWN"
end

local function getField(p2, p3)
	if typeof(p2) == "table" then
		return p2[p3]
	end

	return nil
end

local function getPlatform()
	local success, result = pcall(v6._getPlatform)

	if success then
		return result
	end

	return nil
end

local function readCanOpenNotificationSettings(): string
	local success, result = pcall(v6._permissionsProtocol.isOpenNotificationSettingsSupported)

	if not success then
		return "UNKNOWN"
	end

	if result == true then
		return "true"
	end

	return "false"
end

local function readAndroidSdkLevel()
	local systemInfoProtocol2 = v6._systemInfoProtocol
	local success, result = pcall(function()
		return systemInfoProtocol2.default:getSystemInfo({ systemInfoProtocol2.InfoNames.SYSTEM_VERSION })
	end)
	local systemVersion = if success and typeof(result) == "table" then result.systemVersion else nil

	if typeof(systemVersion) == "string" and systemVersion ~= "" then
		return systemVersion
	end

	return "UNKNOWN"
end

local function settleWithin(read)
	return Promise.new(function(callback)
		Promise.try(read):andThen(function(value)
			callback((typeof(value) ~= "string" or value == "") and "UNKNOWN" or value)
		end, function()
			callback("UNKNOWN")
		end)
		task.delay(FIntStreamPushPermissionClientAttributesTimeoutMs / 1000, callback, "UNKNOWN")
	end)
end

function v6.build()
	local success, result = pcall(v6._getPlatform)

	if not success then
		result = nil
	end

	local v7 = result == Enum.Platform.Android

	if result ~= Enum.Platform.IOS and not v7 then
		return Promise.resolve({})
	end

	local permissionsProtocol2 = v6._permissionsProtocol
	local v8 = { permissionsProtocol2.Permissions.POST_NOTIFICATIONS }
	local success2, result2 = pcall(v6._permissionsProtocol.isOpenNotificationSettingsSupported)

	local v9 = success2 and (result2 == true and "true" or "false") or "UNKNOWN"

	local result3 = { [v5.CAN_OPEN_NOTIFICATION_SETTINGS] = v9 }

	if v7 then
		local ANDROID_SDK_LEVEL = v5.ANDROID_SDK_LEVEL
		local systemInfoProtocol2 = v6._systemInfoProtocol
		local success3, result4 = pcall(function()
			return systemInfoProtocol2.default:getSystemInfo({ systemInfoProtocol2.InfoNames.SYSTEM_VERSION })
		end)
		local systemVersion = if success3 and typeof(result4) == "table" then result4.systemVersion else nil
		result3[ANDROID_SDK_LEVEL] = (typeof(systemVersion) ~= "string" or systemVersion == "")
			and "UNKNOWN"
			or systemVersion
	end

	local v10 = {
		{
			key = v5.PERMISSION_STATUS,
			read = function()
				return permissionsProtocol2.default:hasPermissions(v8):andThen(function(p2)
					if typeof(p2) == "table" then
						return p2.status
					end

					return nil
				end)
			end
		},
		{
			key = v5.UPSELL_STATUS,
			read = function()
				return permissionsProtocol2.default:shouldShowUpsell(v8):andThen(function(p2)
					if typeof(p2) == "table" then
						return p2.upsellStatus
					end

					return nil
				end)
			end
		},
		{
			key = v5.RATIONALE_STATUS,
			read = function()
				return permissionsProtocol2.default:shouldShowRationale(v8):andThen(function(p2)
					if typeof(p2) == "table" then
						return p2.upsellStatus
					end

					return nil
				end)
			end
		}
	}

	if v7 and v9 == "true" then
		table.insert(v10, {
			key = v5.PUSH_NOTIFICATIONS_ENABLED,
			read = function()
				return permissionsProtocol2.default:getPushNotificationsEnabled():andThen(function(p2): nil | string
					local enabled = if typeof(p2) == "table" then p2.enabled else nil

					if enabled == true then
						return "true"
					elseif enabled == false then
						return "false"
					end

					return nil
				end)
			end
		})
	end

	local v11 = {}

	for k, v12 in v10 do
		table.insert(v11, settleWithin(v12.read))
	end

	return Promise.all(v11):andThen(function(p2)
		for k, v12 in v10 do
			result3[v12.key] = p2[k]
		end

		return result3
	end)
end

return v6
