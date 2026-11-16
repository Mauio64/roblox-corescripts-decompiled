local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/fYC")
local module3 = require("@luauforge/bundled/dym")

local module4 = require("@luauforge/bundled/dyp")

local module5 = require("@luauforge/bundled/dyq")

return function(p2, value)
	if type(value) ~= "string" then
		error("ApiFetchGameFollowingStatus thunk expects universeId to be a string")
	end

	return performFetch.Single("ApiFetchGameFollowingStatus" .. value, function(object)
		return module2(p2, object:getState().LocalUserId, value):andThen(function(p3)
			local responseBody = p3.responseBody

			if responseBody == nil or responseBody.CanFollow == nil or responseBody.IsFollowing == nil then
				logging.warn("Response from FollowingsGetStatus is malformed!")
				return module.reject({ HttpError = Enum.HttpError.OK })
			end

			object:dispatch(module3(value, responseBody.CanFollow, responseBody.IsFollowing))
			local v5 = responseBody.FollowingCountByType == nil and 0
				or tonumber(responseBody.FollowingCountByType)
			local v6 = responseBody.FollowingLimitByType == nil and 0
				or tonumber(responseBody.FollowingLimitByType)
			object:dispatch(module4(v5))
			object:dispatch(module5(v6))
			return module.resolve(p3)
		end)
	end)
end
