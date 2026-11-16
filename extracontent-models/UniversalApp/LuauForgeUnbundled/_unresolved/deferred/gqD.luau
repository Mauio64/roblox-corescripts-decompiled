local module = require("@luauforge/deferred/gqB")
require("@luauforge/deferred/gqC")
local default = require("@luauforge/deferred/gqE").PermissionsProtocol.default

local v5 = nil

return function()
	local v6 = if v5 ~= nil then v5:getStatus() else nil

	if v5 and v6 ~= module.Status.Cancelled then
		return v5
	end

	v5 = default:hasPermissions({ default.Permissions.CAMERA_ACCESS }):andThen(function(p2)
		if p2.status == default.Status.AUTHORIZED then
			return module.resolve(true)
		end

		return default:requestPermissions({ default.Permissions.CAMERA_ACCESS }):andThen(function(p3)
			return module.resolve(p3.status == default.Status.AUTHORIZED)
		end, function(p3)
			return module.reject(p3)
		end)
	end)

	return v5
end
