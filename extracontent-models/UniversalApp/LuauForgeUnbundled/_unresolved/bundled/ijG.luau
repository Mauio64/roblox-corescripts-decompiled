local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/ijH")
local module3 = require("@luauforge/bundled/dCC")

return function(p2, value)
	if type(value) ~= "string" then
		error("ApiFetchGameIsFavorite thunk expects universeId to be a string")
	end

	return function(object)
		return module2(p2, value):andThen(function(p3)
			local responseBody = p3.responseBody

			if responseBody == nil or responseBody.isFavorited == nil then
				logging.warn("Response from GameGetIsFavorite is malformed!")
				return module.reject({ HttpError = Enum.HttpError.OK })
			end

			object:dispatch(module3(value, responseBody.isFavorited))
			return p3
		end)
	end
end
