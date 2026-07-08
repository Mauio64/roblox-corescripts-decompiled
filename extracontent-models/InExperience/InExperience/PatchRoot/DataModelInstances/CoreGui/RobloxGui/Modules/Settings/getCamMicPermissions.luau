local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local VideoCaptureService = game:GetService("VideoCaptureService")
local Cryo = require(CorePackages.Packages.Cryo)
local default = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default
local cameraDevicePermissionGrantedSignal = require(CoreGui.RobloxGui.Modules.Settings.cameraDevicePermissionGrantedSignal)
local MicrophoneDevicePermissionsLogging = require(CoreGui.RobloxGui.Modules.Settings.Resources.MicrophoneDevicePermissionsLogging)
local Promise = require(CorePackages.Packages.Promise)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GetFFlagAvatarChatServiceEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarChatServiceEnabled
local getFFlagEnableAnalyticsForCameraDevicePermissions = require(RobloxGui.Modules.Flags.getFFlagEnableAnalyticsForCameraDevicePermissions)
local GetFFlagJoinWithoutMicPermissions = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagJoinWithoutMicPermissions
local v15 = game:DefineFastFlag("CheckCameraAvailabilityBeforePermissions", false)
local v16 = game:DefineFastFlag("DebugSkipVoicePermissionCheck", false)
local v17 = if not GetFFlagAvatarChatServiceEnabled() then nil else game:GetService("AvatarChatService")
local u18 = nil
local u19 = nil
local t1 = {}
local u21 = false

local function removePermissionsBasedOnUserSetting(t2: {[any]: any}, t3: {[any]: any}, b1: boolean?) -- line: 66
	-- upvalues: Cryo (copy), default (copy), GetFFlagJoinWithoutMicPermissions (copy), v16 (copy), v15 (copy), VideoCaptureService (copy)
	if not t2.isCameraEnabled and Cryo.List.find(t3, default.Permissions.CAMERA_ACCESS) then
		t3 = Cryo.List.removeValue(t3, default.Permissions.CAMERA_ACCESS)
	end

	if GetFFlagJoinWithoutMicPermissions() then
		if not t2.isVoiceEnabled and Cryo.List.find(t3, default.Permissions.MICROPHONE_ACCESS) or b1 == nil then
			t3 = Cryo.List.removeValue(t3, default.Permissions.MICROPHONE_ACCESS)
		end
	elseif not t2.isVoiceEnabled and Cryo.List.find(t3, default.Permissions.MICROPHONE_ACCESS) then
		t3 = Cryo.List.removeValue(t3, default.Permissions.MICROPHONE_ACCESS)
	end

	if v16 and Cryo.List.find(t3, default.Permissions.MICROPHONE_ACCESS) then
		t3 = Cryo.List.removeValue(t3, default.Permissions.MICROPHONE_ACCESS)
	end

	if v15 and Cryo.List.find(t3, default.Permissions.CAMERA_ACCESS) then
		local CameraDevices = VideoCaptureService:GetCameraDevices()

		if Cryo.isEmpty(CameraDevices) then
			t3 = Cryo.List.removeValue(t3, default.Permissions.CAMERA_ACCESS)
		end
	end

	return t3
end
local function requestPermissions(t4: {[any]: any}, p1, p2, p3, b2: boolean?, s1: string?) -- line: 120
	-- upvalues: Cryo (copy), default (copy), removePermissionsBasedOnUserSetting (copy), u21 (ref), Promise (copy), MicrophoneDevicePermissionsLogging (copy), u18 (ref), u19 (ref), cameraDevicePermissionGrantedSignal (copy), getFFlagEnableAnalyticsForCameraDevicePermissions (copy), RunService (copy), RbxAnalyticsService (copy)
	local v36 = Cryo.List.find(p3, default.Permissions.CAMERA_ACCESS) ~= nil
	local v37 = Cryo.List.find(p3, default.Permissions.MICROPHONE_ACCESS) ~= nil
	local v38 = removePermissionsBasedOnUserSetting(t4, p3, b2)
	local v39 = Cryo.List.find(v38, default.Permissions.CAMERA_ACCESS) ~= nil
	local v40 = Cryo.List.find(v38, default.Permissions.MICROPHONE_ACCESS) ~= nil

	if not v38 or #v38 <= 0 then
		p1({
			hasCameraPermissions = false,
			hasMicPermissions = false
		})
		u21 = false
		p2()

		return
	end

	if b2 == true then
		return Promise.new(function(resolve, _) -- line: 150
			-- upvalues: v38 (copy), default (copy), p1 (copy), u21 (ref), p2 (copy)
			local t5 = {}

			for _, v in ipairs(v38) do
				local v59, v60 = default:hasPermissions({ v }):await()

				if v59 then
					t5[v] = v60.status == default.Status.AUTHORIZED
				else
					t5[v] = false
				end
			end

			local t6 = {
				hasCameraPermissions = t5[default.Permissions.CAMERA_ACCESS] or false,
				hasMicPermissions = t5[default.Permissions.MICROPHONE_ACCESS] or false
			}

			p1(t6)
			u21 = false
			p2()
			resolve(t5)
		end)
	end

	return default:hasPermissions(v38):andThen(function(p5) -- line: 178
		-- upvalues: default (copy), v39 (copy), v40 (copy), p1 (copy), u21 (ref), p2 (copy), s1 (copy), MicrophoneDevicePermissionsLogging (copy), v38 (copy), Cryo (copy), u18 (ref), v36 (copy), u19 (ref), v37 (copy), cameraDevicePermissionGrantedSignal (copy), getFFlagEnableAnalyticsForCameraDevicePermissions (copy), RunService (copy), RbxAnalyticsService (copy)
		if p5.status == default.Status.AUTHORIZED then
			local t7 = {
				hasCameraPermissions = v39,
				hasMicPermissions = v40
			}

			p1(t7)
			u21 = false
			p2()

			return p5
		end

		if v40 and s1 then
			MicrophoneDevicePermissionsLogging:logPromptImpression({
				didAuthorize = false,
				uiContext = s1
			})
		end

		return default:requestPermissions(v38):andThen(function(p6) -- line: 198
			-- upvalues: v39 (copy), default (copy), Cryo (copy), v40 (copy), u18 (ref), v36 (copy), u19 (ref), v37 (copy), cameraDevicePermissionGrantedSignal (copy), getFFlagEnableAnalyticsForCameraDevicePermissions (copy), RunService (copy), RbxAnalyticsService (copy), s1 (copy), MicrophoneDevicePermissionsLogging (copy), p1 (copy), u21 (ref), p2 (copy)
			if typeof(p6) == "table" then
				local v74 = v39 and (p6.status == default.Status.AUTHORIZED or not Cryo.List.find(p6.missingPermissions, default.Permissions.CAMERA_ACCESS))
				local v75 = v40 and (p6.status == default.Status.AUTHORIZED or not Cryo.List.find(p6.missingPermissions, default.Permissions.MICROPHONE_ACCESS))

				u18 = if not v36 then nil else v74
				u19 = if not v37 then nil else v75

				if u18 then
					cameraDevicePermissionGrantedSignal:fire()
				end
			elseif p6 == default.Status.AUTHORIZED then
				cameraDevicePermissionGrantedSignal:fire()
				u18 = v39
				u19 = v40
			else
				u18 = false
				u19 = false
			end

			local t8 = {
				hasCameraPermissions = u18 or false,
				hasMicPermissions = u19 or false
			}

			if getFFlagEnableAnalyticsForCameraDevicePermissions() and v39 then
				local v77 = u18 or false
				local v78 = not RunService:IsStudio() and "client" or "studio"

				RbxAnalyticsService:SendEventDeferred(v78, "avatarChat", "CameraDevicePermissionPrompted", {
					didAuthorize = v77
				})
			end

			if v40 and s1 then
				MicrophoneDevicePermissionsLogging:logPromptInteraction({
					didAuthorize = u19,
					uiContext = s1
				})
			end

			p1(t8)
			u21 = false
			p2()

			return p6
		end)
	end)
end
local function tryGetCachedResults(p7) -- line: 276
	-- upvalues: v16 (copy), u19 (ref), u18 (ref), default (copy)
	if v16 then
		u19 = true
	end

	if u18 == nil or u19 == nil then
		return nil
	end

	local v42 = false

	for _, v44 in p7 do
		if v44 ~= default.Permissions.MICROPHONE_ACCESS and v44 ~= default.Permissions.CAMERA_ACCESS then
			v42 = true
		end
	end

	if v42 then
		return nil
	end

	return {
		hasCameraPermissions = u18 or false,
		hasMicPermissions = u19 or false
	}
end
local function getCamMicPermissions(p8, t9: {[any]: any}?, b3: boolean?, s2: string?, b4: boolean?) -- line: 308
	-- upvalues: default (copy), t1 (copy), getCamMicPermissions (copy), tryGetCachedResults (copy), u21 (ref), GetFFlagAvatarChatServiceEnabled (copy), Promise (copy), v17 (copy), requestPermissions (copy)
	local u50 = t9 or {
		default.Permissions.MICROPHONE_ACCESS,
		default.Permissions.CAMERA_ACCESS
	}

	local function invokeNextRequest() -- line: 326
		-- upvalues: t1 (copy), getCamMicPermissions (copy)
		if t1[1] then
			local v64 = t1[1]

			table.remove(t1, 1)
			getCamMicPermissions(v64.callback, v64.permissionsToRequest, v64.shouldNotRequestPerms, v64.context, v64.getRawPermission)
		end
	end

	if not b4 then
		local v52 = tryGetCachedResults(u50)

		if v52 then
			p8(v52)

			if t1[1] then
				local v53 = t1[1]

				table.remove(t1, 1)
				getCamMicPermissions(v53.callback, v53.permissionsToRequest, v53.shouldNotRequestPerms, v53.context, v53.getRawPermission)
			end

			return
		end
	end

	if u21 then
		table.insert(t1, {
			callback = p8,
			permissionsToRequest = t9,
			shouldNotRequestPerms = b3,
			context = s2,
			getRawPermission = b4
		})

		return
	end

	u21 = true

	if b4 then
		return default:hasPermissions(u50):andThen(function(p9) -- line: 365
			-- upvalues: p8 (copy), u21 (ref), t1 (copy), getCamMicPermissions (copy)
			p8(p9)
			u21 = false

			if t1[1] then
				local v66 = t1[1]

				table.remove(t1, 1)
				getCamMicPermissions(v66.callback, v66.permissionsToRequest, v66.shouldNotRequestPerms, v66.context, v66.getRawPermission)
			end
		end)
	end

	if GetFFlagAvatarChatServiceEnabled() then
		return Promise.new(function(resolve, _) -- line: 373
			-- upvalues: v17 (copy)
			if v17.ClientFeaturesInitialized then
				resolve({
					isVoiceEnabled = v17:IsEnabled(v17.ClientFeatures, Enum.AvatarChatServiceFeature.UserAudio),
					isCameraEnabled = v17:IsEnabled(v17.ClientFeatures, Enum.AvatarChatServiceFeature.UserVideo)
				})

				return
			end

			local connection = nil

			connection = v17:GetPropertyChangedSignal("ClientFeatures"):Connect(function() -- line: 389
				-- upvalues: connection (ref), v17 (copy), resolve (copy)
				connection:Disconnect()

				local t10 = {
					isVoiceEnabled = v17:IsEnabled(v17.ClientFeatures, Enum.AvatarChatServiceFeature.UserAudio),
					isCameraEnabled = v17:IsEnabled(v17.ClientFeatures, Enum.AvatarChatServiceFeature.UserVideo)
				}

				resolve(t10)
			end)
		end):andThen(function(p11) -- line: 404
			-- upvalues: requestPermissions (copy), p8 (copy), invokeNextRequest (copy), u50 (ref), b3 (copy), s2 (copy)
			requestPermissions(p11, p8, invokeNextRequest, u50, b3, s2)
		end)
	end

	return Promise.new(function(resolve, _) -- line: 416
		resolve({
			isVoiceEnabled = false,
			isCameraEnabled = false
		})
	end)
end

return getCamMicPermissions
