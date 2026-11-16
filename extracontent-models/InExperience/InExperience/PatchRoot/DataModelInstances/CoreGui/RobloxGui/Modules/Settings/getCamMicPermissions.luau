local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local VideoCaptureService = game:GetService("VideoCaptureService")

local Cryo = require(CorePackages.Packages.Cryo)
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default

local cameraDevicePermissionGrantedSignal = require(CoreGui.RobloxGui.Modules.Settings.cameraDevicePermissionGrantedSignal)

local MicrophoneDevicePermissionsLogging = require(CoreGui.RobloxGui.Modules.Settings.Resources.MicrophoneDevicePermissionsLogging)

local Promise = require(CorePackages.Packages.Promise)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagAvatarChatServiceEnabled = SharedFlags.GetFFlagAvatarChatServiceEnabled

local getFFlagEnableAnalyticsForCameraDevicePermissions = require(RobloxGui.Modules.Flags.getFFlagEnableAnalyticsForCameraDevicePermissions)

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagJoinWithoutMicPermissions = SharedFlags2.GetFFlagJoinWithoutMicPermissions

local defineFastFlag = game:DefineFastFlag("CheckCameraAvailabilityBeforePermissions", false)
local defineFastFlag2 = game:DefineFastFlag("DebugSkipVoicePermissionCheck", false)
local AvatarChatService

if GetFFlagAvatarChatServiceEnabled() then
	AvatarChatService = game:GetService("AvatarChatService")
else
	AvatarChatService = nil
end

local v = nil
local didAuthorize = nil
local v2 = {}
local flag = false

local function removePermissionsBasedOnUserSetting(p, p2, flag2: boolean?)
	if not p.isCameraEnabled and Cryo.List.find(p2, default.Permissions.CAMERA_ACCESS) then
		p2 = Cryo.List.removeValue(p2, default.Permissions.CAMERA_ACCESS)
	end

	if GetFFlagJoinWithoutMicPermissions() then
		if not p.isVoiceEnabled and Cryo.List.find(p2, default.Permissions.MICROPHONE_ACCESS) or flag2 == nil then
			p2 = Cryo.List.removeValue(p2, default.Permissions.MICROPHONE_ACCESS)
		end
	elseif not p.isVoiceEnabled and Cryo.List.find(p2, default.Permissions.MICROPHONE_ACCESS) then
		p2 = Cryo.List.removeValue(p2, default.Permissions.MICROPHONE_ACCESS)
	end

	if defineFastFlag2 and Cryo.List.find(p2, default.Permissions.MICROPHONE_ACCESS) then
		p2 = Cryo.List.removeValue(p2, default.Permissions.MICROPHONE_ACCESS)
	end

	if defineFastFlag and Cryo.List.find(p2, default.Permissions.CAMERA_ACCESS) then
		local cameraDevices = VideoCaptureService:GetCameraDevices()

		if Cryo.isEmpty(cameraDevices) then
			p2 = Cryo.List.removeValue(p2, default.Permissions.CAMERA_ACCESS)
		end
	end

	return p2
end

local function requestPermissions(p, callback, invokeNextRequest, p2, flag2: boolean?, uiContext: string?)
	local v3 = Cryo.List.find(p2, default.Permissions.CAMERA_ACCESS) ~= nil
	local v4 = Cryo.List.find(p2, default.Permissions.MICROPHONE_ACCESS) ~= nil

	local v5 = removePermissionsBasedOnUserSetting(p, p2, flag2)
	local hasCameraPermissions = Cryo.List.find(v5, default.Permissions.CAMERA_ACCESS) ~= nil
	local hasMicPermissions = Cryo.List.find(v5, default.Permissions.MICROPHONE_ACCESS) ~= nil

	if v5 and not (#v5 <= 0) then
		if flag2 == true then
			return Promise.new(function(callback2, _)
				local v6 = {}

				for _, v7 in ipairs(v5) do
					local v8, v9 = default:hasPermissions({ v7 }):await()

					if v8 then
						v6[v7] = v9.status == default.Status.AUTHORIZED
					else
						v6[v7] = false
					end
				end

				callback({
					hasCameraPermissions = v6[default.Permissions.CAMERA_ACCESS] or false,
					hasMicPermissions = v6[default.Permissions.MICROPHONE_ACCESS] or false
				})
				flag = false
				invokeNextRequest()

				callback2(v6)
			end)
		end

		return default:hasPermissions(v5):andThen(function(p3)
			if p3.status == default.Status.AUTHORIZED then
				callback({
					hasCameraPermissions = hasCameraPermissions,
					hasMicPermissions = hasMicPermissions
				})
				flag = false
				invokeNextRequest()
				return p3
			end

			if hasMicPermissions and uiContext then
				MicrophoneDevicePermissionsLogging:logPromptImpression({
					didAuthorize = false,
					uiContext = uiContext
				})
			end

			return default:requestPermissions(v5):andThen(function(p4)
				if typeof(p4) == "table" then
					local v6 = hasCameraPermissions
						and (p4.status == default.Status.AUTHORIZED or not Cryo.List.find(
							p4.missingPermissions,
							default.Permissions.CAMERA_ACCESS
						))

					local v7 = hasMicPermissions
						and (p4.status == default.Status.AUTHORIZED or not Cryo.List.find(
							p4.missingPermissions,
							default.Permissions.MICROPHONE_ACCESS
						))

					if not v3 then
						v6 = nil
					end

					v = v6

					if not v4 then
						v7 = nil
					end

					didAuthorize = v7

					if v then
						cameraDevicePermissionGrantedSignal:fire()
					end
				elseif p4 == default.Status.AUTHORIZED then
					cameraDevicePermissionGrantedSignal:fire()
					v = hasCameraPermissions
					didAuthorize = hasMicPermissions
				else
					v = false
					didAuthorize = false
				end

				local v6 = {
					hasCameraPermissions = v or false,
					hasMicPermissions = didAuthorize or false
				}

				if getFFlagEnableAnalyticsForCameraDevicePermissions() and hasCameraPermissions then
					local didAuthorize2 = v or false
					RbxAnalyticsService:SendEventDeferred(
						RunService:IsStudio() and "studio" or "client",
						"avatarChat",
						"CameraDevicePermissionPrompted",
						{ didAuthorize = didAuthorize2 }
					)
				end

				if hasMicPermissions and uiContext then
					MicrophoneDevicePermissionsLogging:logPromptInteraction({
						didAuthorize = didAuthorize,
						uiContext = uiContext
					})
				end

				callback(v6)
				flag = false
				invokeNextRequest()

				return p4
			end)
		end)
	end

	callback({ hasCameraPermissions = false, hasMicPermissions = false })
	flag = false
	invokeNextRequest()
end

local function tryGetCachedResults(items)
	if defineFastFlag2 then
		didAuthorize = true
	end

	if v == nil or didAuthorize == nil then
		return nil
	end

	local flag2 = false

	for _, item in items do
		if item ~= default.Permissions.MICROPHONE_ACCESS and item ~= default.Permissions.CAMERA_ACCESS then
			flag2 = true
		end
	end

	if flag2 then
		return nil
	end

	return {
		hasCameraPermissions = v or false,
		hasMicPermissions = didAuthorize or false
	}
end

local function getCamMicPermissions(callback, permissionsToRequest, shouldNotRequestPerms: boolean?, context: string?, getRawPermission: boolean?)
	local v3 = permissionsToRequest or { default.Permissions.MICROPHONE_ACCESS, default.Permissions.CAMERA_ACCESS }

	local function invokeNextRequest() -- 2 equivalent calls inferred from this helper
		if v2[1] then
			local v4 = v2[1]
			table.remove(v2, 1)
			getCamMicPermissions(
				v4.callback,
				v4.permissionsToRequest,
				v4.shouldNotRequestPerms,
				v4.context,
				v4.getRawPermission
			)
		end
	end

	local v4 = not getRawPermission and tryGetCachedResults(v3)

	if v4 then
		callback(v4)
		invokeNextRequest() -- inferred equivalent call
	else
		if flag then
			table.insert(v2, {
				callback = callback,
				permissionsToRequest = permissionsToRequest,
				shouldNotRequestPerms = shouldNotRequestPerms,
				context = context,
				getRawPermission = getRawPermission
			})

			return
		end

		flag = true

		if getRawPermission then
			return default:hasPermissions(v3):andThen(function(p)
				callback(p)
				flag = false
				invokeNextRequest() -- inferred equivalent call
			end)
		end

		if GetFFlagAvatarChatServiceEnabled() then
			return Promise.new(function(callback2, _)
				if AvatarChatService.ClientFeaturesInitialized then
					callback2({
						isVoiceEnabled = AvatarChatService:IsEnabled(
							AvatarChatService.ClientFeatures,
							Enum.AvatarChatServiceFeature.UserAudio
						),
						isCameraEnabled = AvatarChatService:IsEnabled(
							AvatarChatService.ClientFeatures,
							Enum.AvatarChatServiceFeature.UserVideo
						)
					})
					return
				end

				local clientFeaturesChangedConnection = nil
				clientFeaturesChangedConnection = AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Connect(function()
					clientFeaturesChangedConnection:Disconnect()
					callback2({
						isVoiceEnabled = AvatarChatService:IsEnabled(
							AvatarChatService.ClientFeatures,
							Enum.AvatarChatServiceFeature.UserAudio
						),
						isCameraEnabled = AvatarChatService:IsEnabled(
							AvatarChatService.ClientFeatures,
							Enum.AvatarChatServiceFeature.UserVideo
						)
					})
				end)
			end):andThen(function(p)
				requestPermissions(p, callback, invokeNextRequest, v3, shouldNotRequestPerms, context)
			end)
		end

		return Promise.new(function(callback2, _)
			callback2({ isVoiceEnabled = false, isCameraEnabled = false })
		end)
	end
end

return getCamMicPermissions
