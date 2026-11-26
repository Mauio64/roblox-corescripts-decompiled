local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/fAI")
require("@game/CorePackages/Workspace/Packages/Http")
local getFStringVNGWebshopUrl = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFStringVNGWebshopUrl

return function(p2)
	return function(p3)
		return module2(p2):andThen(function(list)
			if list == nil or list[1] == nil then
				local v5 = { vngShopRedirectUrl = getFStringVNGWebshopUrl() }

				return module.resolve(v5)
			end

			local v5 = { vngShopRedirectUrl = list[1].vngShopRedirectUrl }

			return module.resolve(v5)
		end):catch(function(p4)
			local v5 = { vngShopRedirectUrl = getFStringVNGWebshopUrl() }

			return module.resolve(v5)
		end)
	end
end
