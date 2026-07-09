local Parent = script:FindFirstAncestor("CameraOptIn").Parent
local Promise = require(Parent.Promise)

require(Parent.LuauPolyfill)

local default = require(Parent.PermissionsProtocol).PermissionsProtocol.default
local u4 = nil

return function() -- line: 16
	-- upvalues: u4 (ref), Promise (copy), default (copy)
	local v5 = if u4 == nil then nil else u4:getStatus()

	if u4 and v5 ~= Promise.Status.Cancelled then
		return u4
	end

	u4 = default:hasPermissions({ default.Permissions.CAMERA_ACCESS }):andThen(function(p1) -- line: 23
		-- upvalues: default (copy), Promise (copy)
		if p1.status == default.Status.AUTHORIZED then
			return Promise.resolve(true)
		end

		return default:requestPermissions({ default.Permissions.CAMERA_ACCESS }):andThen(function(p2) -- line: 31
			-- upvalues: Promise (copy), default (copy)
			return Promise.resolve(p2.status == default.Status.AUTHORIZED)
		end, function(p3) -- line: 34
			-- upvalues: Promise (copy)
			return Promise.reject(p3)
		end)
	end)

	return u4
end
