local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local Promise = require(ParentParent.Promise)
local t = require(ParentParent.t)
local GetFFlagLuaEnableShowUpsellMethod = require(ParentParent.SharedFlags).GetFFlagLuaEnableShowUpsellMethod
local v6 = game:DefineFastFlag("ScopedSubscribersForPermissionsProtocol2", false)

require(script.Parent.PermissionsProtocolTypes)
game:DefineFastFlag("DebugRomarkAudioPermissionsBypass", false)

local t1 = {
	CAMERA_ACCESS = "CAMERA_ACCESS",
	MICROPHONE_ACCESS = "MICROPHONE_ACCESS",
	LOCAL_NETWORK = "LOCAL_NETWORK",
	CONTACTS_ACCESS = "CONTACTS_ACCESS",
	WRITE_MEDIA_STORAGE = "WRITE_MEDIA_STORAGE",
	POST_NOTIFICATIONS = "POST_NOTIFICATIONS"
}
local t2 = {
	AUTHORIZED = "AUTHORIZED",
	DENIED = "DENIED",
	RESTRICTED = "RESTRICTED",
	UNSUPPORTED = "UNSUPPORTED"
}
local t3 = {
	SHOW = "SHOW",
	HIDE = "HIDE",
	UNSUPPORTED = "UNSUPPORTED"
}
local v10 = t.array(t.valueOf(t1))
local v11 = t.valueOf(t2)
local v12 = t.valueOf(t3)
local t4 = {
	Permissions = t1,
	Status = t2,
	UpsellStatus = t3,
	PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "PermissionsRequest",
		validateParams = t.strictInterface({
			permissions = v10
		})
	},
	PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "PermissionsRequest",
		validateParams = t.strictInterface({
			status = v11,
			missingPermissions = v10
		})
	},
	HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "HasPermissions",
		validateParams = t.strictInterface({
			permissions = v10
		})
	},
	HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "HasPermissions",
		validateParams = t.strictInterface({
			status = v11,
			missingPermissions = v10
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
		validateParams = t.strictInterface({
			permissions = v10
		})
	},
	SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "ShouldShowPermissionUpsell",
		validateParams = t.strictInterface({
			permissions = v10
		})
	},
	SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "ShouldShowPermissionUpsell",
		validateParams = t.strictInterface({
			hiddenUpsellPermissions = v10,
			upsellStatus = v12
		})
	},
	SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "ShouldShowRequestPermissionRationale",
		validateParams = t.strictInterface({
			permissions = v10
		})
	},
	SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = {
		protocolName = "PermissionsProtocol",
		methodName = "ShouldShowRequestPermissionRationale",
		validateParams = t.strictInterface({
			hiddenUpsellPermissions = v10,
			upsellStatus = v12
		})
	}
}

t4.__index = t4

local function getPermissionRequestTelemetryData(p1) -- line: 145
	-- upvalues: t4 (copy)
	local t5 = {}

	for _, v in pairs(p1) do
		if v == t4.Permissions.CAMERA_ACCESS then
			t5.camera_access_requested = ""
		end

		if v == t4.Permissions.MICROPHONE_ACCESS then
			t5.microphone_access_requested = ""
		end

		if v == t4.Permissions.LOCAL_NETWORK then
			t5.local_network_requested = ""
		end

		if v == t4.Permissions.CONTACTS_ACCESS then
			t5.contacts_access_requested = ""
		end
	end

	return t5
end
local function createSequencedProtocolMethodCall(t6: {[any]: any}, p2, p3, p4, p5) -- line: 164
	-- upvalues: Promise (copy), MessageBus (copy)
	assert(p3.validateParams(p4))

	local v25 = (t6[p2] or Promise.resolve()):finally(function() -- line: 175
		-- upvalues: Promise (copy), MessageBus (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy)
		return Promise.new(function(resolve) -- line: 176
			-- upvalues: MessageBus (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy)
			local v80 = MessageBus.Subscriber.new()

			v80:subscribeProtocolMethodResponse(p2, function(p6) -- line: 178
				-- upvalues: v80 (copy), p2 (copy), resolve (copy)
				v80:unsubscribeToProtocolMethodResponse(p2)
				resolve(p6)
			end)
			MessageBus.publishProtocolMethodRequest(p3, p4, p5)
		end)
	end)

	t6[p2] = v25

	return v25
end

function t4.new() -- line: 190
	-- upvalues: v6 (copy), MessageBus (copy), t4 (copy)
	return (setmetatable({
		activeCalls = if not v6 then nil else {},
		subscriber = if not v6 then MessageBus.Subscriber.new() else nil
	}, t4))
end
function t4.hasPermissions(p7, p8) -- line: 208
	-- upvalues: v6 (copy), createSequencedProtocolMethodCall (copy), getPermissionRequestTelemetryData (copy), Promise (copy), MessageBus (copy)
	if v6 then
		local HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p7.HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = p7.HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR

		return (createSequencedProtocolMethodCall(p7.activeCalls, HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
			permissions = p8
		}, (getPermissionRequestTelemetryData(p8))))
	end

	local v30 = Promise.new(function(resolve, _) -- line: 217
		-- upvalues: p7 (copy)
		local HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p7.HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p7.subscriber:subscribeProtocolMethodResponse(HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p10) -- line: 219
			-- upvalues: p7 (copy), HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p7.subscriber:unsubscribeToProtocolMethodResponse(HAS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(p10)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p7.HAS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
		permissions = p8
	}, (getPermissionRequestTelemetryData(p8)))

	return v30
end
function t4.requestPermissions(p11, p12) -- line: 239
	-- upvalues: t4 (copy), Promise (copy), v6 (copy), createSequencedProtocolMethodCall (copy), getPermissionRequestTelemetryData (copy), MessageBus (copy)
	if game:GetFastFlag("DebugRomarkAudioPermissionsBypass") then
		local t7 = {
			missingPermissions = {},
			status = t4.Status.AUTHORIZED
		}

		return Promise.resolve(t7)
	end

	if v6 then
		local PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p11.PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = p11.PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR

		return (createSequencedProtocolMethodCall(p11.activeCalls, PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
			permissions = p12
		}, (getPermissionRequestTelemetryData(p12))))
	end

	local v36 = Promise.new(function(resolve, _) -- line: 256
		-- upvalues: p11 (copy)
		local PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p11.PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p11.subscriber:subscribeProtocolMethodResponse(PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p14) -- line: 258
			-- upvalues: p11 (copy), PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p11.subscriber:unsubscribeToProtocolMethodResponse(PERMISSION_REQUEST_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(p14)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p11.PERMISSION_REQUEST_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
		permissions = p12
	}, (getPermissionRequestTelemetryData(p12)))

	return v36
end
function t4.getSupportedPermissionsList(p15) -- line: 276
	-- upvalues: v6 (copy), createSequencedProtocolMethodCall (copy), Promise (copy), MessageBus (copy)
	if v6 then
		local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p15.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = p15.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR

		return (createSequencedProtocolMethodCall(p15.activeCalls, SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
			includeStatus = false
		}, {}))
	end

	local v40 = Promise.new(function(resolve, _) -- line: 285
		-- upvalues: p15 (copy)
		local SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p15.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p15.subscriber:subscribeProtocolMethodResponse(SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p17) -- line: 287
			-- upvalues: p15 (copy), SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p15.subscriber:unsubscribeToProtocolMethodResponse(SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(p17)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p15.SUPPORTS_PERMISSIONS_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
		includeStatus = false
	}, {})

	return v40
end
function t4.supportsPermissions(p18, p19) -- line: 306
	-- upvalues: v10 (copy), Promise (copy)
	assert(v10(p19))

	return (p18:getSupportedPermissionsList():andThen(function(p20) -- line: 309
		-- upvalues: p19 (copy), Promise (copy)
		local v65 = p20 and p20.permissions

		if v65 then
			for _, v in pairs(p19) do
				local v68 = false

				for _, v2 in pairs(v65) do
					if v == v2 then
						v68 = true

						break
					end
				end

				if not v68 then
					return Promise.resolve(false)
				end
			end

			return Promise.resolve(true)
		end

		return Promise.reject()
	end))
end
function t4.checkOrRequestPermissions(p21, p22) -- line: 348
	-- upvalues: v10 (copy), Promise (copy), t4 (copy)
	assert(v10(p22))

	return p21:supportsPermissions(p22):andThen(function(p23) -- line: 351
		-- upvalues: Promise (copy), t4 (copy), p21 (copy), p22 (copy)
		if not p23 then
			return Promise.resolve(t4.Status.UNSUPPORTED)
		end

		return (p21:hasPermissions(p22):andThen(function(p24) -- line: 358
			-- upvalues: t4 (copy), Promise (copy), p21 (copy), p22 (copy)
			if p24.status == t4.Status.AUTHORIZED then
				return Promise.resolve(p24.status)
			end

			return p21:requestPermissions(p22):andThen(function(p25) -- line: 364
				-- upvalues: Promise (copy)
				return Promise.resolve(p25.status)
			end)
		end))
	end, function(_) -- line: 370
		-- upvalues: Promise (copy), t4 (copy)
		return Promise.resolve(t4.Status.UNSUPPORTED)
	end)
end
function t4.shouldShowUpsell(p27, p28) -- line: 385
	-- upvalues: GetFFlagLuaEnableShowUpsellMethod (copy), Promise (copy), v6 (copy), createSequencedProtocolMethodCall (copy), getPermissionRequestTelemetryData (copy), MessageBus (copy)
	if not GetFFlagLuaEnableShowUpsellMethod() then
		return Promise.resolve({})
	end

	if v6 then
		local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p27.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = p27.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR

		return (createSequencedProtocolMethodCall(p27.activeCalls, SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
			permissions = p28
		}, (getPermissionRequestTelemetryData(p28))))
	end

	local v49 = Promise.new(function(resolve, _) -- line: 398
		-- upvalues: p27 (copy)
		local SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p27.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p27.subscriber:subscribeProtocolMethodResponse(SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p30) -- line: 400
			-- upvalues: p27 (copy), SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p27.subscriber:unsubscribeToProtocolMethodResponse(SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(p30)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p27.SHOULD_SHOW_PERMISSION_UPSELL_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
		permissions = p28
	}, (getPermissionRequestTelemetryData(p28)))

	return v49
end
function t4.shouldShowRationale(p31, p32) -- line: 421
	-- upvalues: v6 (copy), createSequencedProtocolMethodCall (copy), getPermissionRequestTelemetryData (copy), Promise (copy), MessageBus (copy)
	if v6 then
		local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p31.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR
		local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR = p31.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR

		return (createSequencedProtocolMethodCall(p31.activeCalls, SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
			permissions = p32
		}, (getPermissionRequestTelemetryData(p32))))
	end

	local v54 = Promise.new(function(resolve, _) -- line: 430
		-- upvalues: p31 (copy)
		local SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR = p31.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR

		p31.subscriber:subscribeProtocolMethodResponse(SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR, function(p34) -- line: 432
			-- upvalues: p31 (copy), SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR (copy), resolve (copy)
			p31.subscriber:unsubscribeToProtocolMethodResponse(SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_RESPONSE_DESCRIPTOR)
			resolve(p34)
		end)
	end)

	MessageBus.publishProtocolMethodRequest(p31.SHOULD_SHOW_PERMISSION_RATIONALE_PROTOCOL_METHOD_REQUEST_DESCRIPTOR, {
		permissions = p32
	}, (getPermissionRequestTelemetryData(p32)))

	return v54
end

t4.default = t4.new()

return t4
