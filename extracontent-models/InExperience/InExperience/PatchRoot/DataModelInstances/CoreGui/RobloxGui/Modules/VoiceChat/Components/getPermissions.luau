local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local getCamMicPermissions = require(Modules.Settings.getCamMicPermissions)

local CorePackages = game:GetService("CorePackages")
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default

return function(callback, p: string?, flag: boolean?)
	local v = nil

	if p then
		if p == "camera" then
			v = { default.Permissions.CAMERA_ACCESS }
		else
			v = p == "microphone" and { default.Permissions.MICROPHONE_ACCESS } or v
		end
	end

	getCamMicPermissions(function(p2)
		callback(p2.hasCameraPermissions, p2.hasMicPermissions)
	end, v, flag, "ExperienceChat.getPermissions")
end
