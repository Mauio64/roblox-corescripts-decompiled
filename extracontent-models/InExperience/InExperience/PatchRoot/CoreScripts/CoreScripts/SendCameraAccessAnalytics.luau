local CorePackages = game:GetService("CorePackages")
game:GetService("VideoCaptureService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")

local Cryo = require(CorePackages.Packages.Cryo)
local getCamMicPermissions = require(CoreGui.RobloxGui.Modules.Settings.getCamMicPermissions)
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default
local cameraDevicesHelper = require(CoreGui.RobloxGui.Modules.Settings.cameraDevicesHelper)

local devices = cameraDevicesHelper.GetDevices()
local hasEligibleCamera = not Cryo.isEmpty(devices)

if hasEligibleCamera then
	getCamMicPermissions(function(p)
		RbxAnalyticsService:SendEventDeferred("client", "avatarChat", "CameraDevicePermissionResponse", {
			hasAccessToCamera = p.hasCameraPermissions,
			hasEligibleCamera = hasEligibleCamera
		})
	end, { default.Permissions.CAMERA_ACCESS }, true)
else
	RbxAnalyticsService:SendEventDeferred("client", "avatarChat", "CameraDevicePermissionResponse", {
		hasAccessToCamera = false,
		hasEligibleCamera = hasEligibleCamera
	})
end
