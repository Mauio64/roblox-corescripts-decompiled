local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local mutedError = require(Modules.LuaApp.mutedError)
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ModerationDetail = require(Modules.LuaApp.Models.UserModerationApi.ModerationDetail)
local GetModerationDetail = require(Modules.LuaApp.Http.Requests.ModerationAPI.GetModerationDetail)
local SetModerationDetail = require(Modules.LuaApp.Actions.Moderation.SetModerationDetail)
local tutils = require(CorePackages.Packages.tutils)
local SetModerationStatus = require(Modules.LuaApp.Actions.Moderation.SetModerationStatus)

return function(p1) -- line: 16
	-- upvalues: PerformFetch (copy), GetModerationDetail (copy), Logging (copy), SetModerationStatus (copy), Promise (copy), ModerationDetail (copy), mutedError (copy), tutils (copy), SetModerationDetail (copy)
	return PerformFetch.Single("luaapp.usermoderationapi.UserModeration.get_v1_not_approved", function(p2) -- line: 17
		-- upvalues: GetModerationDetail (copy), p1 (copy), Logging (copy), SetModerationStatus (copy), Promise (copy), ModerationDetail (copy), mutedError (copy), tutils (copy), SetModerationDetail (copy)
		return GetModerationDetail(p1):andThen(function(p3) -- line: 18
			-- upvalues: Logging (copy), p2 (copy), SetModerationStatus (copy), Promise (copy), ModerationDetail (copy), mutedError (copy), tutils (copy), SetModerationDetail (copy)
			local responseBody = p3.responseBody

			Logging.warn("The user is moderated with type: `" .. tostring(responseBody.punishmentTypeDescription) .. "`")
			Logging.warn("Verification category is: `" .. tostring(responseBody.verificationCategory) .. "`")

			if responseBody.punishmentTypeDescription == nil then
				p2:dispatch(SetModerationStatus(false))

				return Promise.resolve()
			end

			local v16 = ModerationDetail.fromJsonData(responseBody)
			local v17, v18 = v16:unwrap()

			if v17 == false then
				Logging.warn("Failed to parse moderation detail.")
				mutedError("(Moderation) Failed to parse moderation detail. Data: " .. tutils.toString(responseBody))

				return Promise.reject(p3)
			end

			p2:dispatch(SetModerationDetail(v18))

			return Promise.resolve(v16)
		end, function(p4) -- line: 41
			-- upvalues: Logging (copy), tutils (copy), mutedError (copy), Promise (copy)
			Logging.warn("Failed to get moderation detail: ")
			Logging.warn(tutils.print(p4))
			mutedError("(Moderation) Failed to get moderation detail: " .. tutils.toString(p4))

			return Promise.reject(p4)
		end)
	end)
end
