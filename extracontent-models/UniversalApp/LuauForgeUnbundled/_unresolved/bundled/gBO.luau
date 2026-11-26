local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local apiFetchThumbnails = require("@game/CorePackages/Workspace/Packages/Http").Utils.ApiFetchThumbnails
local module = require("@luauforge/bundled/gBP")
local module2 = require("@luauforge/bundled/dBx")

return function(p2, list)
	return function(object)
		local passesThumbnails = object:getState().PassesThumbnails

		local v5 = {}

		if passesThumbnails then
			for i, item in ipairs(list) do
				if passesThumbnails[tostring(item)] == nil then
					table.insert(v5, item)
				end
			end
		else
			v5 = list
		end

		if #v5 == 0 then
			return Promise.resolve()
		end

		return apiFetchThumbnails.Fetch(p2, v5, "150x150", "Pass", module, module2, object)
	end
end
