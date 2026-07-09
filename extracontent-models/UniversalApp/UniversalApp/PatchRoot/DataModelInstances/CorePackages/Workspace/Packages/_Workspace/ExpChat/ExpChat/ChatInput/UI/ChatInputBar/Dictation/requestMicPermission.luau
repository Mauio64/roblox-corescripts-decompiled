local Parent = script:FindFirstAncestor("ExpChat").Parent
local default = require(Parent.PermissionsProtocol).PermissionsProtocol.default
local t1 = {
	Granted = "granted",
	Denied = "denied",
	AlreadyAllowed = "already_allowed"
}

return {
	requestMicPermission = function() -- line: 23
		-- upvalues: default (copy), t1 (copy)
		return default:hasPermissions({ default.Permissions.MICROPHONE_ACCESS }):andThen(function(p1) -- line: 25
			-- upvalues: default (copy), t1 (copy)
			if p1.status == default.Status.AUTHORIZED then
				return {
					status = t1.AlreadyAllowed
				}
			end

			return default:requestPermissions({ default.Permissions.MICROPHONE_ACCESS }):andThen(function(p2) -- line: 30
				-- upvalues: default (copy), t1 (copy)
				if p2.status == default.Status.AUTHORIZED then
					return {
						status = t1.Granted
					}
				end

				return {
					status = t1.Denied
				}
			end)
		end):catch(function(p3) -- line: 37
			-- upvalues: t1 (copy)
			return {
				status = t1.Denied,
				error = tostring(p3)
			}
		end)
	end,
	PermissionStatus = t1
}
