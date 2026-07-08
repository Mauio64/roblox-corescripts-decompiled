local Modules = game:GetService("CoreGui").RobloxGui.Modules
local getCamMicPermissions = require(Modules.Settings.getCamMicPermissions)
local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default

return function(p1, s1: string?, b1: boolean?) -- line: 13
	-- upvalues: default (copy), getCamMicPermissions (copy)
	local t1 = nil

	if s1 then
		if s1 == "camera" then
			t1 = { default.Permissions.CAMERA_ACCESS }
		elseif s1 == "microphone" then
			t1 = { default.Permissions.MICROPHONE_ACCESS }
		end
	end

	getCamMicPermissions(function(p2) -- line: 24
		-- upvalues: p1 (copy)
		p1(p2.hasCameraPermissions, p2.hasMicPermissions)
	end, t1, b1, "ExperienceChat.getPermissions")
end
