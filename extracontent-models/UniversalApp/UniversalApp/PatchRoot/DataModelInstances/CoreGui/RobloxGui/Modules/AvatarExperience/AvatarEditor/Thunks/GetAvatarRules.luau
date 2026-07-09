local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

return function(p1, p2) -- line: 20
	-- upvalues: PerformFetch (copy), Constants (copy), Promise (copy), Utils (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy)
	local avatarEditorService = p2.avatarEditorService

	return PerformFetch.Single(Constants.GetAvatarRulesKey, function(_) -- line: 22
		-- upvalues: Promise (copy), avatarEditorService (copy), Utils (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy)
		return Promise.new(function(resolve, reject) -- line: 23
			-- upvalues: avatarEditorService (copy), Utils (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy)
			local ok, result = pcall(function() -- line: 24
				-- upvalues: avatarEditorService (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return avatarEditorService:GetAvatarRulesAsync()
				end

				return avatarEditorService:GetAvatarRules()
			end)

			if ok then
				resolve((Utils.tableToCamelCaseKeys(result)))

				return
			end

			if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
				reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.GetAvatarRules)
			end

			Logging.warn("WebApi failure in GetAvatarRules")
			reject({
				HttpError = Enum.HttpError.OK
			})
		end)
	end)(p1)
end
