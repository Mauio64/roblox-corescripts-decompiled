local module = require("@luauforge/bundled/gfe")

local module2 = require("@luauforge/bundled/gfj")

local module3 = require("@luauforge/bundled/gfm")
local module4 = require("@luauforge/bundled/gfp")
local module5 = require("@luauforge/bundled/gfs")
local module6 = require("@luauforge/bundled/gfv")
local module7 = require("@luauforge/bundled/gfy")

return function(p2)
	return function(object)
		local v5 = {}

		table.insert(v5, object:dispatch(module2(p2)))

		if not module7 then
			table.insert(v5, object:dispatch(module3(p2)))
		end

		table.insert(v5, object:dispatch(module4(p2)))
		table.insert(v5, object:dispatch(module5(p2)))
		table.insert(v5, object:dispatch(module6(p2)))

		return module.Batch(v5):andThen(function(p3)
			local failureCount = module.CountResults(p3).failureCount

			if failureCount ~= 0 then
				warn(string.format("%d of %d notification count fetching failed!", failureCount, #v5))
			end
		end)
	end
end
