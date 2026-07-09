local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Constants = require(Modules.AvatarExperience.Common.Constants)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)
local ApplyProfileConfiguration = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ApplyProfileConfiguration

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.LuaApp.Types.RoduxTypes)

return function(p1, p2) -- line: 27
	-- upvalues: Players (copy), PerformFetch (copy), Promise (copy), ApplyProfileConfiguration (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy)
	local v13 = p2.players or Players

	return PerformFetch.Single("avatareditor.getprofileconfiguration", function(p3) -- line: 29
		-- upvalues: Promise (copy), v13 (copy), ApplyProfileConfiguration (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy)
		return Promise.new(function(resolve, reject) -- line: 30
			-- upvalues: v13 (copy), p3 (copy), ApplyProfileConfiguration (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy)
			local v17 = v13.LocalPlayer and v13.LocalPlayer.UserId
			local ok, result = pcall(function() -- line: 32
				-- upvalues: v13 (copy), v17 (copy)
				return v13:GetProfileConfigurationFromUserIdAsync(v17)
			end)

			if ok and result then
				p3:dispatch(ApplyProfileConfiguration({
					BackgroundAssetId = result.BackgroundAssetId
				}))
				resolve(result)

				return
			end

			if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
				reportAvatarEventCounterNoAnalyticsArgument(Constants.Counter.AvatarEditorServiceErrors.GetProfileConfiguration)
			end

			Logging.warn("WebApi failure in GetProfileConfiguration")
			reject({
				HttpError = Enum.HttpError.OK
			})
		end)
	end)(p1)
end
