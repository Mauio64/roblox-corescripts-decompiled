local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local Promise = require(parent.Promise)
local t = require(parent.t)

local isVersionAtLeast = require(script.Parent.isVersionAtLeast)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaEnableShowUpsellMethod = SharedFlags.GetFFlagLuaEnableShowUpsellMethod

local defineFastFlag = game:DefineFastFlag("ScopedSubscribersForPermissionsProtocol2", false)

require(script.Parent.PermissionsProtocolTypes)

game:DefineFastFlag("DebugRomarkAudioPermissionsBypass", false)

game:DefineFastFlag("EnableAndroidOpenNotificationSettings", false)
game:DefineFastString("AndroidOpenNotificationSettingsMinVersion", "")
game:DefineFastFlag("PermissionsProtocolNonStickyResponses", false)

local permissions2 = {
	CAMERA_ACCESS = "CAMERA_ACCESS",
	MICROPHONE_ACCESS = "MICROPHONE_ACCESS",
	LOCAL_NETWORK = "LOCAL_NETWORK",
	CONTACTS_ACCESS = "CONTACTS_ACCESS",
	WRITE_MEDIA_STORAGE = "WRITE_MEDIA_STORAGE",
	POST_NOTIFICATIONS = "POST_NOTIFICATIONS"
}

local status = {
	AUTHORIZED = "AUTHORIZED",
	DENIED = "DENIED",
	RESTRICTED = "RESTRICTED",
	UNSUPPORTED = "UNSUPPORTED"
}

local upsellStatus = { SHOW = "SHOW", HIDE = "HIDE", UNSUPPORTED = "UNSUPPORTED" }

local openSettingsStatus = {
	OPENED_NOTIFICATION_SETTINGS = "OPENED_NOTIFICATION_SETTINGS",
	OPENED_APP_SETTINGS = "OPENED_APP_SETTINGS",
	FAILED = "FAILED"
}

local array = t.array(t.valueOf(permissions2))
local status2 = t.valueOf(status)
local upsellStatus2 = t.valueOf(upsellStatus)

local PermissionsProtocol = {
	Permissions = permissions2,
	Status = status,
	UpsellStatus = upsellStatus,
	OpenSettingsStatus = openSettingsStatus,
	PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "PermissionsRequest",
		validateParams = t.strictInterface({ permissions = array })
	},
	PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "PermissionsRequest",
		validateParams = t.strictInterface({ status = status2, missingPermissions = array })
	},
	HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "HasPermissions",
		validateParams = t.strictInterface({ permissions = array })
	},
	HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "HasPermissions",
		validateParams = t.strictInterface({ status = status2, missingPermissions = array })
	},
	SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "SupportsPermissions",
		validateParams = t.strictInterface({ includeStatus = t.literal(false) })
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
			upsellStatus = upsellStatus2
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
			upsellStatus = upsellStatus2
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
		validateParams = t.strictInterface({ status = t.valueOf(openSettingsStatus) })
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

PermissionsProtocol.__index = PermissionsProtocol

local function getPermissionRequestTelemetryData(items)
	local permissionRequestTelemetryData = {}

	for _, item in pairs(items) do
		if item == PermissionsProtocol.Permissions.CAMERA_ACCESS then
			permissionRequestTelemetryData.camera_access_requested = ""
		end

		if item == PermissionsProtocol.Permissions.MICROPHONE_ACCESS then
			permissionRequestTelemetryData.microphone_access_requested = ""
		end

		if item == PermissionsProtocol.Permissions.LOCAL_NETWORK then
			permissionRequestTelemetryData.local_network_requested = ""
		end

		if item == PermissionsProtocol.Permissions.CONTACTS_ACCESS then
			permissionRequestTelemetryData.contacts_access_requested = ""
		end
	end

	return permissionRequestTelemetryData
end

local function createSequencedProtocolMethodCall(activeCalls, p, p2, p3, p4, flag: boolean?)
	assert(p2.validateParams(p3))

	local sequencedProtocolMethodCall = (activeCalls[p] or Promise.resolve()):finally(function()
		return Promise.new(function(callback)
			local subscriber = messageBus.Subscriber.new()
			subscriber:subscribeProtocolMethodResponse(p, function(p5)
				subscriber:unsubscribeToProtocolMethodResponse(p)
				callback(p5)
			end, flag)
			messageBus.publishProtocolMethodRequest(p2, p3, p4)
		end)
	end)

	activeCalls[p] = sequencedProtocolMethodCall
	return sequencedProtocolMethodCall
end

local function getResponseSticky(): nil | boolean -- 10 equivalent calls inferred from this helper
	if game:GetFastFlag("PermissionsProtocolNonStickyResponses") then
		return false
	end

	return nil
end

local function getPlatform() -- 3 equivalent calls inferred from this helper
	local success, result = pcall(PermissionsProtocol._getPlatform)
	return if success then result else nil
end

local function isAndroidNotificationSettingsGateOpen() -- 2 equivalent calls inferred from this helper
	return game:GetFastFlag("EnableAndroidOpenNotificationSettings")
		and isVersionAtLeast(
			PermissionsProtocol._getVersion(),
			game:GetFastString("AndroidOpenNotificationSettingsMinVersion")
		)
end

local function callPushNotificationSettingsMethod(p, p2, p3)
	local permissions = { PermissionsProtocol.Permissions.POST_NOTIFICATIONS }
	local v = { permissions = permissions }

	local permissionRequestTelemetryData = getPermissionRequestTelemetryData(permissions)

	if defineFastFlag then
		return createSequencedProtocolMethodCall(p.activeCalls, p3, p2, v, permissionRequestTelemetryData, false)
	end

	local v2 = Promise.new(function(callback, _)
		p.subscriber:subscribeProtocolMethodResponse(p3, function(p4)
			p.subscriber:unsubscribeToProtocolMethodResponse(p3)
			callback(p4)
		end, false)
	end)
	messageBus.publishProtocolMethodRequest(p2, v, permissionRequestTelemetryData)
	return v2
end

function PermissionsProtocol.new()
	local v = {
		activeCalls = defineFastFlag and {} or nil,
		subscriber = 0
	}
	local subscriber

	if not defineFastFlag then
		subscriber = messageBus.Subscriber.new()
	end

	v.subscriber = subscriber
	return (setmetatable(v, PermissionsProtocol))
end

function PermissionsProtocol:hasPermissions(permissions)
	if defineFastFlag then
		local HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = self.HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		return createSequencedProtocolMethodCall(
			self.activeCalls,
			HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = permissions },
			getPermissionRequestTelemetryData(permissions),
			getResponseSticky() -- inferred equivalent call
		)
	else
		local v = Promise.new(function(callback, _)
			local HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local function fn(p)
				self.subscriber:unsubscribeToProtocolMethodResponse(HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p)
			end

			self.subscriber:subscribeProtocolMethodResponse(
				HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				getResponseSticky() -- inferred equivalent call
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = permissions },
			getPermissionRequestTelemetryData(permissions)
		)
		return v
	end
end

function PermissionsProtocol:requestPermissions(permissions)
	if game:GetFastFlag("DebugRomarkAudioPermissionsBypass") then
		local v = {}
		v.missingPermissions = {}
		v.status = PermissionsProtocol.Status.AUTHORIZED
		return Promise.resolve(v)
	elseif defineFastFlag then
		local PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = self.PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		return createSequencedProtocolMethodCall(
			self.activeCalls,
			PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = permissions },
			getPermissionRequestTelemetryData(permissions),
			getResponseSticky() -- inferred equivalent call
		)
	else
		local v = Promise.new(function(callback, _)
			local PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local function fn(p)
				self.subscriber:unsubscribeToProtocolMethodResponse(PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p)
			end

			self.subscriber:subscribeProtocolMethodResponse(
				PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				getResponseSticky() -- inferred equivalent call
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = permissions },
			getPermissionRequestTelemetryData(permissions)
		)
		return v
	end
end

function PermissionsProtocol:getSupportedPermissionsList()
	if defineFastFlag then
		local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = self.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		return createSequencedProtocolMethodCall(
			self.activeCalls,
			SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{},
			getResponseSticky() -- inferred equivalent call
		)
	else
		local v = Promise.new(function(callback, _)
			local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = self.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local function fn(p)
				self.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p)
			end

			self.subscriber:subscribeProtocolMethodResponse(
				SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				getResponseSticky() -- inferred equivalent call
			)
		end)
		messageBus.publishProtocolMethodRequest(
			self.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ includeStatus = false },
			{}
		)
		return v
	end
end

function PermissionsProtocol:supportsPermissions(items)
	assert(array(items))

	return (self:getSupportedPermissionsList():andThen(function(p)
		local permissions = p and p.permissions

		if not permissions then
			return Promise.reject()
		end

		for _, item in pairs(items) do
			local v = false

			for _, permission in pairs(permissions) do
				if item == permission then
					v = true
					break
				end
			end

			if not v then
				return Promise.resolve(false)
			end
		end

		return Promise.resolve(true)
	end))
end

function PermissionsProtocol:checkOrRequestPermissions(p)
	assert(array(p))

	return self:supportsPermissions(p):andThen(function(p2)
		if p2 then
			return (self:hasPermissions(p):andThen(function(p3)
				if p3.status == PermissionsProtocol.Status.AUTHORIZED then
					return Promise.resolve(p3.status)
				end

				return self:requestPermissions(p):andThen(function(p4)
					return Promise.resolve(p4.status)
				end)
			end))
		end

		return Promise.resolve(PermissionsProtocol.Status.UNSUPPORTED)
	end, function(_)
		return Promise.resolve(PermissionsProtocol.Status.UNSUPPORTED)
	end)
end

function PermissionsProtocol.shouldShowUpsell(data, permissions)
	if not GetFFlagLuaEnableShowUpsellMethod() then
		return Promise.resolve({})
	end

	if defineFastFlag then
		local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = data.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		return createSequencedProtocolMethodCall(
			data.activeCalls,
			SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = permissions },
			getPermissionRequestTelemetryData(permissions),
			getResponseSticky() -- inferred equivalent call
		)
	else
		local v = Promise.new(function(callback, _)
			local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local function fn(p)
				data.subscriber:unsubscribeToProtocolMethodResponse(SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p)
			end

			data.subscriber:subscribeProtocolMethodResponse(
				SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				getResponseSticky() -- inferred equivalent call
			)
		end)
		messageBus.publishProtocolMethodRequest(
			data.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = permissions },
			getPermissionRequestTelemetryData(permissions)
		)
		return v
	end
end

function PermissionsProtocol.shouldShowRationale(data, permissions)
	if defineFastFlag then
		local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = data.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR
		return createSequencedProtocolMethodCall(
			data.activeCalls,
			SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
			SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = permissions },
			getPermissionRequestTelemetryData(permissions),
			getResponseSticky() -- inferred equivalent call
		)
	else
		local v = Promise.new(function(callback, _)
			local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = data.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
			local function fn(p)
				data.subscriber:unsubscribeToProtocolMethodResponse(SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
				callback(p)
			end

			data.subscriber:subscribeProtocolMethodResponse(
				SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR,
				fn,
				getResponseSticky() -- inferred equivalent call
			)
		end)
		messageBus.publishProtocolMethodRequest(
			data.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
			{ permissions = permissions },
			getPermissionRequestTelemetryData(permissions)
		)
		return v
	end
end

function PermissionsProtocol.isOpenNotificationSettingsSupported()
	local platform = getPlatform() -- inferred equivalent call

	if platform == Enum.Platform.IOS then
		return true
	end

	if platform == Enum.Platform.Android then
		return isAndroidNotificationSettingsGateOpen() -- inferred equivalent call
	end

	return false
end

function PermissionsProtocol:openNotificationSettings()
	if not PermissionsProtocol.isOpenNotificationSettingsSupported() then
		return Promise.resolve({ status = openSettingsStatus.FAILED })
	end

	if getPlatform() == Enum.Platform.IOS then -- inferred equivalent call
		return self:requestPermissions({ PermissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(function()
			return { status = openSettingsStatus.OPENED_APP_SETTINGS }
		end, function()
			return { status = openSettingsStatus.FAILED }
		end)
	end

	return callPushNotificationSettingsMethod(
		self,
		self.OPEN_NOTIFICATION_SETTINGS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		self.OPEN_NOTIFICATION_SETTINGS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
	):timeout(PermissionsProtocol._openNotificationSettingsTimeoutSeconds):andThen(
		function(p)
			return { status = p.status }
		end,
		function()
			return { status = openSettingsStatus.FAILED }
		end
	)
end

function PermissionsProtocol.getPushNotificationsEnabled(p)
	if getPlatform() ~= Enum.Platform.Android or not isAndroidNotificationSettingsGateOpen() then -- inferred equivalent call
		return Promise.reject("UNSUPPORTED")
	end

	return callPushNotificationSettingsMethod(
		p,
		p.GET_PUSH_NOTIFICATIONS_ENABLED_PROTOCOL_METHOD_REQUEST_DESCRIPTOR,
		p.GET_PUSH_NOTIFICATIONS_ENABLED_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
	):timeout(
		PermissionsProtocol._getPushNotificationsEnabledTimeoutSeconds,
		"TIMEOUT"
	):andThen(function(p2)
		return { enabled = p2.enabled }
	end)
end

PermissionsProtocol.default = PermissionsProtocol.new()

return PermissionsProtocol
