local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/ecV")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/ecW")

local module3 = require("@luauforge/bundled/dBd")
local module4 = require("@luauforge/deferred/fYK")

local function fetchKeymapper(p2)
	return "luaapp.asset-text-filter-settings.get-settings" .. p2
end

return {
	Fetch = function(p2, p3)
		return performFetch.Single("luaapp.asset-text-filter-settings.get-settings" .. p3, function(object)
			return module4(p2, p3):andThen(function(p4)
				local responseBody = p4.responseBody

				if responseBody == nil then
					object:dispatch(module3(p3, false))
					return module.reject({ HttpError = Enum.HttpError.OK })
				end

				if responseBody.Profanity == nil then
					logging.warn("Failed to parse GetAssetTextFilterSettings for `" .. p3 .. "`")
					return module.reject(false)
				end

				local profanity = responseBody.Profanity

				object:dispatch(module3(p3, profanity))
				return module.resolve(profanity)
			end, function(p4)
				object:dispatch(module3(p3, false))
				object:dispatch(module2(p4))
				return module.reject(p4)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.asset-text-filter-settings.get-settings" .. p3)
	end
}
