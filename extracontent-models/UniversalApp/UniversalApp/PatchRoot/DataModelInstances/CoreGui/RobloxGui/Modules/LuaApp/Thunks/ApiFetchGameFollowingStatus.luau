local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local FollowingsGetStatus = require(Modules.LuaApp.Http.Requests.FollowingsGetStatus)
local SetGameFollowingStatus = require(Modules.LuaApp.Actions.SetGameFollowingStatus)
local SetExperienceNotificationsEnabledCount = require(Modules.LuaApp.Actions.Games.SetExperienceNotificationsEnabledCount)
local SetExperienceNotificationsEnabledLimit = require(Modules.LuaApp.Actions.Games.SetExperienceNotificationsEnabledLimit)

return function(p1, p2) -- line: 13
	-- upvalues: PerformFetch (copy), FollowingsGetStatus (copy), SetGameFollowingStatus (copy), SetExperienceNotificationsEnabledCount (copy), SetExperienceNotificationsEnabledLimit (copy), Promise (copy), Logging (copy)
	if type(p2) ~= "string" then
		error("ApiFetchGameFollowingStatus thunk expects universeId to be a string")
	end

	return PerformFetch.Single("ApiFetchGameFollowingStatus" .. p2, function(p3) -- line: 18
		-- upvalues: FollowingsGetStatus (copy), p1 (copy), p2 (copy), SetGameFollowingStatus (copy), SetExperienceNotificationsEnabledCount (copy), SetExperienceNotificationsEnabledLimit (copy), Promise (copy), Logging (copy)
		local LocalUserId = p3:getState().LocalUserId

		return FollowingsGetStatus(p1, LocalUserId, p2):andThen(function(p4) -- line: 20
			-- upvalues: p3 (copy), SetGameFollowingStatus (copy), p2 (copy), SetExperienceNotificationsEnabledCount (copy), SetExperienceNotificationsEnabledLimit (copy), Promise (copy), Logging (copy)
			local responseBody = p4.responseBody

			if responseBody ~= nil and (responseBody.CanFollow ~= nil and responseBody.IsFollowing ~= nil) then
				p3:dispatch(SetGameFollowingStatus(p2, responseBody.CanFollow, responseBody.IsFollowing))

				local v16 = responseBody.FollowingCountByType == nil and 0 or tonumber(responseBody.FollowingCountByType)
				local v17 = responseBody.FollowingLimitByType == nil and 0 or tonumber(responseBody.FollowingLimitByType)

				p3:dispatch(SetExperienceNotificationsEnabledCount(v16))
				p3:dispatch(SetExperienceNotificationsEnabledLimit(v17))

				return Promise.resolve(p4)
			end

			Logging.warn("Response from FollowingsGetStatus is malformed!")

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end)
	end)
end
