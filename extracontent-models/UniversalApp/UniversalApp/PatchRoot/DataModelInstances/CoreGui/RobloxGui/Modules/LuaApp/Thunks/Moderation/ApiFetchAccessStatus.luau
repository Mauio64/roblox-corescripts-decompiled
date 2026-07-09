local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local GetAccessStatus = require(Modules.LuaApp.Http.Requests.UserAccess.GetAccessStatus)
local tutils = require(CorePackages.Packages.tutils)
local SetModerationStatus = require(Modules.LuaApp.Actions.Moderation.SetModerationStatus)
local SetUserAccessRestrictionDetail = require(Modules.LuaApp.Actions.UserAccess.SetUserAccessRestrictionDetail)
local ApiFetchModerationDetails = require(Modules.LuaApp.Thunks.Moderation.ApiFetchModerationDetails)
local RestrictionDetail = require(Modules.LuaApp.Models.UserModerationApi.RestrictionDetail)
local RestrictionSource = require(Modules.LuaApp.Models.UserModerationApi.RestrictionSource)

return function(p1) -- line: 17
	-- upvalues: PerformFetch (copy), GetAccessStatus (copy), RestrictionDetail (copy), Logging (copy), tutils (copy), Promise (copy), SetModerationStatus (copy), SetUserAccessRestrictionDetail (copy), RestrictionSource (copy), ApiFetchModerationDetails (copy)
	return PerformFetch.Single("luaapp.usermoderationapi.UserModeration.get_v2_not_approved", function(p2) -- line: 18
		-- upvalues: GetAccessStatus (copy), p1 (copy), RestrictionDetail (copy), Logging (copy), tutils (copy), Promise (copy), SetModerationStatus (copy), SetUserAccessRestrictionDetail (copy), RestrictionSource (copy), ApiFetchModerationDetails (copy)
		return GetAccessStatus(p1):andThen(function(p3) -- line: 19
			-- upvalues: RestrictionDetail (copy), Logging (copy), tutils (copy), Promise (copy), p2 (copy), SetModerationStatus (copy), SetUserAccessRestrictionDetail (copy), RestrictionSource (copy), ApiFetchModerationDetails (copy), p1 (copy)
			local responseBody = p3.responseBody
			local v17, v18 = RestrictionDetail.fromJsonData(responseBody):unwrap()

			if v17 == false then
				Logging.warn("Failed to parse Use detail. Data: " .. tutils.toString(responseBody))

				return Promise.reject(p3)
			end

			if v18.restriction == nil then
				p2:dispatch(SetModerationStatus(false))
				p2:dispatch(SetUserAccessRestrictionDetail(nil))

				return Promise.resolve(nil)
			end

			p2:dispatch(SetUserAccessRestrictionDetail(v18.restriction))

			if v18.restriction.source == RestrictionSource.Moderation then
				p2:dispatch(ApiFetchModerationDetails(p1))
			end

			return Promise.resolve(v18.restriction)
		end, function(p4) -- line: 43
			-- upvalues: Logging (copy), tutils (copy), Promise (copy)
			Logging.warn(tutils.print(p4))

			return Promise.reject(p4)
		end)
	end)
end
