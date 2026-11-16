local parent = script:FindFirstAncestor("ExpChat").Parent

local PermissionsProtocol = require(parent.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default

local permissionStatus = {
	Granted = "granted",
	Denied = "denied",
	AlreadyAllowed = "already_allowed"
}

return {
	requestMicPermission = function()
		return default:hasPermissions({ default.Permissions.MICROPHONE_ACCESS }):andThen(function(p)
			if p.status == default.Status.AUTHORIZED then
				return { status = permissionStatus.AlreadyAllowed }
			end

			return default:requestPermissions({ default.Permissions.MICROPHONE_ACCESS }):andThen(function(p2)
				if p2.status == default.Status.AUTHORIZED then
					return { status = permissionStatus.Granted }
				end

				return { status = permissionStatus.Denied }
			end)
		end):catch(function(p)
			return { status = permissionStatus.Denied, error = tostring(p) }
		end)
	end,
	PermissionStatus = permissionStatus
}
