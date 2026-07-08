local CorePackages = game:GetService("CorePackages")

game:GetService("VideoCaptureService")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local Cryo = require(CorePackages.Packages.Cryo)
local getCamMicPermissions = require(CoreGui.RobloxGui.Modules.Settings.getCamMicPermissions)
local default = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default
local v7 = require(CoreGui.RobloxGui.Modules.Settings.cameraDevicesHelper).GetDevices()
local v8 = not Cryo.isEmpty(v7)

if v8 then
	getCamMicPermissions(function(p1) -- line: 14
		-- upvalues: RbxAnalyticsService (copy), v8 (copy)
		local hasCameraPermissions = p1.hasCameraPermissions

		RbxAnalyticsService:SendEventDeferred("client", "avatarChat", "CameraDevicePermissionResponse", {
			hasAccessToCamera = hasCameraPermissions,
			hasEligibleCamera = v8
		})
	end, { default.Permissions.CAMERA_ACCESS }, true)

	return
end

RbxAnalyticsService:SendEventDeferred("client", "avatarChat", "CameraDevicePermissionResponse", {
	hasAccessToCamera = false,
	hasEligibleCamera = v8
})
