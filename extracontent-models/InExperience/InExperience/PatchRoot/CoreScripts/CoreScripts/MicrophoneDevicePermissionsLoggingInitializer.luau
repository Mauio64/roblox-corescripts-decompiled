local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local getCamMicPermissions = require(CoreGui.RobloxGui.Modules.Settings.getCamMicPermissions)
local MicrophoneDevicePermissionsLogging = require(CoreGui.RobloxGui.Modules.Settings.Resources.MicrophoneDevicePermissionsLogging)

getCamMicPermissions(function(p1) -- line: 13
	-- upvalues: MicrophoneDevicePermissionsLogging (copy)
	MicrophoneDevicePermissionsLogging:init(p1.hasMicPermissions)
end, { require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default.Permissions.MICROPHONE_ACCESS }, true)
