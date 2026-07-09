local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Modules = CoreGui.RobloxGui.Modules
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)
local SetBundleFavorite = require(Modules.AvatarExperience.Catalog.Actions.SetBundleFavorite)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function keyMapper(p1) -- line: 25
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.GetFavoriteBundleKey .. p1
end

return function(p2) -- line: 29
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), Promise (copy), SetBundleFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy)
	ArgCheck.isType(p2, "string", "GetBundleFavorite thunk expects bundleId")

	return function(p3, p4) -- line: 32
		-- upvalues: PerformFetch (copy), p2 (copy), CatalogConstants (copy), Promise (copy), SetBundleFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy)
		local avatarEditorService = p4.avatarEditorService
		local Single = PerformFetch.Single
		local v20 = p2

		return Single(CatalogConstants.GetFavoriteBundleKey .. v20, function(p5) -- line: 34
			-- upvalues: Promise (copy), avatarEditorService (copy), p2 (copy), SetBundleFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy)
			return Promise.new(function(resolve, reject) -- line: 35
				-- upvalues: avatarEditorService (copy), p2 (copy), p5 (copy), SetBundleFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), Logging (copy)
				local ok, result = pcall(function() -- line: 36
					-- upvalues: avatarEditorService (copy), p2 (copy)
					if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
						return avatarEditorService:GetFavoriteAsync(p2, Enum.AvatarItemType.Bundle)
					end

					return avatarEditorService:GetFavorite(p2, Enum.AvatarItemType.Bundle)
				end)

				if ok then
					p5:dispatch(SetBundleFavorite(p2, result))
					resolve()

					return
				end

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants.Counter.AvatarEditorServiceErrors.GetBundleFavorite)
				end

				Logging.warn("GetBundleFavorite failure: " .. tostring(result))
				reject()
			end)
		end)(p3)
	end
end
