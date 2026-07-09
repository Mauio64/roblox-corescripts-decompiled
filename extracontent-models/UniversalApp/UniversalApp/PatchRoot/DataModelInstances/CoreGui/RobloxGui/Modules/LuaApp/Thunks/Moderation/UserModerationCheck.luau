local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local ApiFetchModerationDetails = require(Modules.LuaApp.Thunks.Moderation.ApiFetchModerationDetails)
local SetModerationStatus = require(Modules.LuaApp.Actions.Moderation.SetModerationStatus)
local DetectModeratedUser = require(Modules.LuaApp.Thunks.Moderation.DetectModeratedUser)
local ApiFetchAccessStatus = require(Modules.LuaApp.Thunks.Moderation.ApiFetchAccessStatus)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local FFlagEnableUserAccessServiceIntegration = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUserAccessServiceIntegration
local FFlagCheckUserModerationAfterLogin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCheckUserModerationAfterLogin

return function(p1, p2) -- line: 17
	-- upvalues: FFlagCheckUserModerationAfterLogin (copy), LoginStatus (copy), DetectModeratedUser (copy), Logging (copy), SetModerationStatus (copy), FFlagEnableUserAccessServiceIntegration (copy), ApiFetchAccessStatus (copy), ApiFetchModerationDetails (copy)
	return function(p3) -- line: 18
		-- upvalues: FFlagCheckUserModerationAfterLogin (copy), LoginStatus (copy), DetectModeratedUser (copy), p2 (copy), Logging (copy), SetModerationStatus (copy), FFlagEnableUserAccessServiceIntegration (copy), ApiFetchAccessStatus (copy), p1 (copy), ApiFetchModerationDetails (copy)
		local Moderation = p3:getState().Moderation

		if not not Moderation and (Moderation.userModerated or false) then
			return
		end

		if FFlagCheckUserModerationAfterLogin and p3:getState().AuthenticationStatus.status ~= LoginStatus.LOGGED_IN then
			return
		end

		if DetectModeratedUser(p2) then
			Logging.warn("The user is moderated.")
			p3:dispatch(SetModerationStatus(true))

			if FFlagEnableUserAccessServiceIntegration then
				p3:dispatch(ApiFetchAccessStatus(p1))

				return
			end

			p3:dispatch(ApiFetchModerationDetails(p1))
		end
	end
end
