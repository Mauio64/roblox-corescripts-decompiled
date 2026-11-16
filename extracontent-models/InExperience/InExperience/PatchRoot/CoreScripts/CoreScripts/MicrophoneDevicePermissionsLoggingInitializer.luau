local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local getCamMicPermissions = require(CoreGui.RobloxGui.Modules.Settings.getCamMicPermissions)

local MicrophoneDevicePermissionsLogging = require(CoreGui.RobloxGui.Modules.Settings.Resources.MicrophoneDevicePermissionsLogging)
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
getCamMicPermissions(function(p)
	MicrophoneDevicePermissionsLogging:init(p.hasMicPermissions)
end, { PermissionsProtocol.PermissionsProtocol.default.Permissions.MICROPHONE_ACCESS }, true)
