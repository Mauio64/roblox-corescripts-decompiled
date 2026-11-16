local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)

local function wrapDispatchTable(p2)
	return Dash.map(p2, function(callback)
		return function(...)
			return callback(...)
		end
	end)
end

return wrapDispatchTable
