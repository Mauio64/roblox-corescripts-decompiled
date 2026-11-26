local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/PermissionsProtocol/MessageBus").MessageBus
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PermissionsProtocol/Promise")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PermissionsProtocol/t")

local isVersionAtLeast = require("@game/CorePackages/Workspace/Packages/_Workspace/PermissionsProtocol/PermissionsProtocol/isVersionAtLeast")

local getFFlagLuaEnableShowUpsellMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/PermissionsProtocol/SharedFlags").GetFFlagLuaEnableShowUpsellMethod

local defineFastFlag = game:DefineFastFlag("ScopedSubscribersForPermissionsProtocol2", false)

require("@game/CorePackages/Workspace/Packages/_Workspace/PermissionsProtocol/PermissionsProtocol/PermissionsProtocolTypes")

game:DefineFastFlag("DebugRomarkAudioPermissionsBypass", false)

game:DefineFastFlag("EnableAndroidOpenNotificationSettings", false)
game:DefineFastString("AndroidOpenNotificationSettingsMinVersion", "")
game:DefineFastFlag("PermissionsProtocolNonStickyResponses", false)

local v5 = {
	CAMERA_ACCESS = "CAMERA_ACCESS",
	MICROPHONE_ACCESS = "MICROPHONE_ACCESS",
	LOCAL_NETWORK = "LOCAL_NETWORK",
	CONTACTS_ACCESS = "CONTACTS_ACCESS",
	WRITE_MEDIA_STORAGE = "WRITE_MEDIA_STORAGE",
	POST_NOTIFICATIONS = "POST_NOTIFICATIONS"
}

local v6 = {
	AUTHORIZED = "AUTHORIZED",
	DENIED = "DENIED",
	RESTRICTED = "RESTRICTED",
	UNSUPPORTED = "UNSUPPORTED"
}

local v7 = { SHOW = "SHOW", HIDE = "HIDE", UNSUPPORTED = "UNSUPPORTED" }

local v8 = {
	OPENED_NOTIFICATION_SETTINGS = "OPENED_NOTIFICATION_SETTINGS",
	OPENED_APP_SETTINGS = "OPENED_APP_SETTINGS",
	FAILED = "FAILED"
}

local array = t.array(t.valueOf(v5))
local value = t.valueOf(v6)
local value2 = t.valueOf(v7)

local v9 = {
	Permissions = v5,
	Status = v6,
	UpsellStatus = v7,
	OpenSettingsStatus = v8,
	PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "PermissionsRequest",
		validateParams = t.strictInterface({ permissions = array })
	},
	PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "PermissionsRequest",
		validateParams = t.strictInterface({
			status = value,
			missingPermissions = array
		})
	},
	HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "HasPermissions",
		validateParams = t.strictInterface({ permissions = array })
	},
	HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "HasPermissions",
		validateParams = t.strictInterface({
			status = value,
			missingPermissions = array
		})
	},
	SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "SupportsPermissions",
		validateParams = t.strictInterface({
			includeStatus = t.literal(false)
		})
	},
	SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "SupportsPermissions",
		validateParams = t.strictInterface({ permissions = array })
	},
	SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "ShouldShowPermissionUpsell",
		validateParams = t.strictInterface({ permissions = array })
	},
	SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "ShouldShowPermissionUpsell",
		validateParams = t.strictInterface({
			hiddenUpsellPermissions = array,
			upsellStatus = value2
		})
	},
	SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "ShouldShowRequestPermissionRationale",
		validateParams = t.strictInterface({ permissions = array })
	},
	SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "ShouldShowRequestPermissionRationale",
		validateParams = t.strictInterface({
			hiddenUpsellPermissions = array,
			upsellStatus = value2
		})
	},
	OPEN_NOTIFICATION_SETTINGS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "OpenNotificationSettings",
		validateParams = t.strictInterface({ permissions = array })
	},
	OPEN_NOTIFICATION_SETTINGS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "OpenNotificationSettings",
		validateParams = t.strictInterface({ status = t.valueOf(v8) })
	},
	GET_PUSH_NOTIFICATIONS_ENABLED_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "GetPushNotificationsEnabled",
		validateParams = t.strictInterface({ permissions = array })
	},
	GET_PUSH_NOTIFICATIONS_ENABLED_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "GetPushNotificationsEnabled",
		validateParams = t.strictInterface({ enabled = t.boolean })
	},
	_getPlatform = function()
		return UserInputService:GetPlatform()
	end,
	_getVersion = function()
		return RunService:GetRobloxVersion()
	end,
	_openNotificationSettingsTimeoutSeconds = 5,
	_getPushNotificationsEnabledTimeoutSeconds = 1
}

v9.__index = v9

local function getPermissionRequestTelemetryData(items)
	local permissionRequestTelemetryData = {}

	for k, item in pairs(items) do
		if item == v9.Permissions.CAMERA_ACCESS then
			permissionRequestTelemetryData.camera_access_requested = ""
		end

		if item == v9.Permissions.MICROPHONE_ACCESS then
			permissionRequestTelemetryData.microphone_access_requested = ""
		end

		if item == v9.Permissions.LOCAL_NETWORK then
			permissionRequestTelemetryData.local_network_requested = ""
		end

		if item == v9.Permissions.CONTACTS_ACCESS then
			permissionRequestTelemetryData.contacts_access_requested = ""
		end
	end

	return permissionRequestTelemetryData
end

local function createSequencedProtocolMethodCall(activeCalls, p2, p3, p4, permissionRequestTelemetryData, p5)
	assert(p3.validateParams(p4))

	local sequencedProtocolMethodCall = (activeCalls[p2] or Promise.resolve()):finally(function()
		return Promise.new(function(callback)
			local subscriber = messageBus.Subscriber.new()
			subscriber:subscribeProtocolMethodResponse(p2, function(p6)
				subscriber:unsubscribeToProtocolMethodResponse(p2)
				callback(p6)
			end, p5)
			messageBus.publishProtocolMethodRequest(p3, p4, permissionRequestTelemetryData)
		end)
	end)

	activeCalls[p2] = sequencedProtocolMethodCall
	return sequencedProtocolMethodCall
end

local function getResponseSticky(): nil | boolean
	if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then
		return false
	end

	return nil
end

local function getPlatform()
	local success, result = pcall(v9._getPlatform)

	if success then
		return result
	end

	return nil
end

local function isAndroidNotificationSettingsGateOpen()
	return game:GetFastFlag("EnableAndroidOpenNotificationSettings")
		and isVersionAtLeast(v9._getVersion(), game:GetFastString("AndroidOpenNotificationSettingsMinVersion"))
end

local function callPushNotificationSettingsMethod(p2, p3, p4)
	local v10 = { v9.Permissions.POST_NOTIFICATIONS }
	local v11 = { permissions = v10 }

	local permissionRequestTelemetryData = getPermissionRequestTelemetryData(v10)

	if defineFastFlag then
		return createSequencedProtocolMethodCall(
			p2.activeCalls,
			p4,
			p3,
			v11,
			permissionRequestTelemetryData,
			false
		)
	end

	local v12 = Promise.new(function(callback, p5)
		p2.subscriber:subscribeProtocolMethodResponse(p4, function(p6)
			p2.subscriber:unsubscribeToProtocolMethodResponse(p4)
			callback(p6)
		end, false)
	end)
	messageBus.publishProtocolMethodRequest(p3, v11, permissionRequestTelemetryData)
	return v12
end

function v9.new()
	local v10 = {
		activeCalls = defineFastFlag and {} or nil,
		subscriber = 0
	}
	local v11 = if not defineFastFlag then messageBus.Subscriber.new() else nil
	v10.subscriber = v11
	return (setmetatable(v10, v9))
end

function v9:hasPermissions(p2)
	if defineFastFlag then
		local HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = self.HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		local activeCalls = self.activeCalls

		local permissionRequestTelemetryData = getPermissionRequestTelemetryData(p2)
		local v12 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

		return createSequencedProtocolMethodCall(
			activeCalls,
			HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = p2 },
			permissionRequestTelemetryData,
			v12
		)
	else
		local v10 = Promise.new(function(callback, p3)
			local HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local subscriber = self.subscriber
			local function fn(p4)
				self.subscriber:unsubscribeToProtocolMethodResponse(HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p4)
			end

			local v11 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

			subscriber:subscribeProtocolMethodResponse(
				HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				v11
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = p2 },
			getPermissionRequestTelemetryData(p2)
		)
		return v10
	end
end

function v9.requestPermissions(data, p2)
	if game:GetFastFlag("DebugRomarkAudioPermissionsBypass") then
		local v10 = {}
		v10.missingPermissions = {}
		v10.status = v9.Status.AUTHORIZED
		return Promise.resolve(v10)
	elseif defineFastFlag then
		local PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = data.PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		local activeCalls = data.activeCalls

		local permissionRequestTelemetryData = getPermissionRequestTelemetryData(p2)
		local v12 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

		return createSequencedProtocolMethodCall(
			activeCalls,
			PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = p2 },
			permissionRequestTelemetryData,
			v12
		)
	else
		local v10 = Promise.new(function(callback, p3)
			local PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local subscriber = data.subscriber
			local function fn(p4)
				data.subscriber:unsubscribeToProtocolMethodResponse(PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p4)
			end

			local v11 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

			subscriber:subscribeProtocolMethodResponse(
				PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				v11
			)
		end)
		messageBus.publishProtocolMethodRequest(
			data.PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = p2 },
			getPermissionRequestTelemetryData(p2)
		)
		return v10
	end
end

function v9:getSupportedPermissionsList()
	if defineFastFlag then
		local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = self.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		local activeCalls = self.activeCalls
		local v13 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

		return createSequencedProtocolMethodCall(
			activeCalls,
			SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{},
			v13
		)
	else
		local v10 = Promise.new(function(callback, p2)
			local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local subscriber = self.subscriber
			local function fn(p3)
				self.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p3)
			end

			local v11 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

			subscriber:subscribeProtocolMethodResponse(
				SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				v11
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)
		return v10
	end
end

function v9:supportsPermissions(items)
	assert(array(items))

	return (self:getSupportedPermissionsList():andThen(function(p2)
		local permissions = p2 and p2.permissions

		if not permissions then
			return Promise.reject()
		end

		for k, item in pairs(items) do
			local v10 = false

			for k2, permission in pairs(permissions) do
				if item == permission then
					v10 = true
					break
				end
			end

			if not v10 then
				return Promise.resolve(false)
			end
		end

		return Promise.resolve(true)
	end))
end

function v9:checkOrRequestPermissions(p2)
	assert(array(p2))

	return self:supportsPermissions(p2):andThen(function(p3)
		if p3 then
			return (self:hasPermissions(p2):andThen(function(p4)
				if p4.status == v9.Status.AUTHORIZED then
					return Promise.resolve(p4.status)
				end

				return self:requestPermissions(p2):andThen(function(p5)
					return Promise.resolve(p5.status)
				end)
			end))
		end

		return Promise.resolve(v9.Status.UNSUPPORTED)
	end, function(p3)
		return Promise.resolve(v9.Status.UNSUPPORTED)
	end)
end

function v9:shouldShowUpsell(p2)
	if not getFFlagLuaEnableShowUpsellMethod() then
		return Promise.resolve({})
	end

	if defineFastFlag then
		local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = self.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		local activeCalls = self.activeCalls

		local permissionRequestTelemetryData = getPermissionRequestTelemetryData(p2)
		local v12 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

		return createSequencedProtocolMethodCall(
			activeCalls,
			SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = p2 },
			permissionRequestTelemetryData,
			v12
		)
	else
		local v10 = Promise.new(function(callback, p3)
			local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local subscriber = self.subscriber
			local function fn(p4)
				self.subscriber:unsubscribeToProtocolMethodResponse(SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p4)
			end

			local v11 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

			subscriber:subscribeProtocolMethodResponse(
				SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				v11
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = p2 },
			getPermissionRequestTelemetryData(p2)
		)
		return v10
	end
end

function v9:shouldShowRationale(p2)
	if defineFastFlag then
		local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = self.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		local activeCalls = self.activeCalls

		local permissionRequestTelemetryData = getPermissionRequestTelemetryData(p2)
		local v12 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

		return createSequencedProtocolMethodCall(
			activeCalls,
			SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = p2 },
			permissionRequestTelemetryData,
			v12
		)
	else
		local v10 = Promise.new(function(callback, p3)
			local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local subscriber = self.subscriber
			local function fn(p4)
				self.subscriber:unsubscribeToProtocolMethodResponse(SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p4)
			end

			local v11 = if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then false else nil

			subscriber:subscribeProtocolMethodResponse(
				SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				v11
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = p2 },
			getPermissionRequestTelemetryData(p2)
		)
		return v10
	end
end

function v9.isOpenNotificationSettingsSupported()
	local success, result = pcall(v9._getPlatform)

	if not success then
		result = nil
	end

	if result == Enum.Platform.IOS then
		return true
	end

	if result == Enum.Platform.Android then
		return game:GetFastFlag("EnableAndroidOpenNotificationSettings")
			and isVersionAtLeast(v9._getVersion(), game:GetFastString("AndroidOpenNotificationSettingsMinVersion"))
	end

	return false
end

function v9:openNotificationSettings()
	if not v9.isOpenNotificationSettingsSupported() then
		return Promise.resolve({ status = v8.FAILED })
	end

	local success, result = pcall(v9._getPlatform)

	if not success then
		result = nil
	end

	if result == Enum.Platform.IOS then
		return self:requestPermissions({ v9.Permissions.POST_NOTIFICATIONS }):andThen(function()
			return { status = v8.OPENED_APP_SETTINGS }
		end, function()
			return { status = v8.FAILED }
		end)
	end

	return callPushNotificationSettingsMethod(
		self,
		self.OPEN_NOTIFICATION_SETTINGS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		self.OPEN_NOTIFICATION_SETTINGS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
	):timeout(v9._openNotificationSettingsTimeoutSeconds):andThen(
		function(p2)
			return { status = p2.status }
		end,
		function()
			return { status = v8.FAILED }
		end
	)
end

function v9:getPushNotificationsEnabled()
	local success, result = pcall(v9._getPlatform)

	if not success then
		result = nil
	end

	if
		result ~= Enum.Platform.Android
		or not (game:GetFastFlag("EnableAndroidOpenNotificationSettings") and isVersionAtLeast(
			v9._getVersion(),
			game:GetFastString("AndroidOpenNotificationSettingsMinVersion")
		))
	then
		return Promise.reject("UNSUPPORTED")
	end

	return callPushNotificationSettingsMethod(
		self,
		self.GET_PUSH_NOTIFICATIONS_ENABLED_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		self.GET_PUSH_NOTIFICATIONS_ENABLED_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
	):timeout(
		v9._getPushNotificationsEnabledTimeoutSeconds,
		"TIMEOUT"
	):andThen(function(p3)
		return { enabled = p3.enabled }
	end)
end

v9.default = v9.new()

return v9
