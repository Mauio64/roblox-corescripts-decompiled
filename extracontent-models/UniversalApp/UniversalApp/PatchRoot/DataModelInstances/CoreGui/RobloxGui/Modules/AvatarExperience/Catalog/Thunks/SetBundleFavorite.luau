local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetBundleFavorite = require(Modules.AvatarExperience.Catalog.Actions.SetBundleFavorite)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function keyMapper(p1) -- line: 24
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.SetFavoriteBundleKey .. p1
end

return function(p2, p3) -- line: 28
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), Promise (copy), SetBundleFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), SetNetworkingErrorToast (copy)
	ArgCheck.isType(p2, "string", "SetBundleFavorite thunk expects assetId")
	ArgCheck.isType(p3, "boolean", "SetBundleFavorite thunk expects isFavorited")

	return function(p4, p5) -- line: 32
		-- upvalues: PerformFetch (copy), p2 (copy), CatalogConstants (copy), Promise (copy), p3 (copy), SetBundleFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), SetNetworkingErrorToast (copy)
		local avatarEditorService = p5.avatarEditorService
		local Single = PerformFetch.Single
		local v20 = p2

		return Single(CatalogConstants.SetFavoriteBundleKey .. v20, function(p6) -- line: 34
			-- upvalues: Promise (copy), avatarEditorService (copy), p2 (copy), p3 (copy), SetBundleFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), SetNetworkingErrorToast (copy)
			return Promise.new(function(resolve, reject) -- line: 35
				-- upvalues: avatarEditorService (copy), p2 (copy), p3 (copy), p6 (copy), SetBundleFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), SetNetworkingErrorToast (copy)
				local v24 = avatarEditorService:NoPromptSetFavorite(p2, Enum.AvatarItemType.Bundle, p3)

				while not v24 do
					avatarEditorService.PromptSetFavoriteCompleted:Wait()
					v24 = avatarEditorService:NoPromptSetFavorite(p2, Enum.AvatarItemType.Bundle, p3)
				end

				if avatarEditorService.PromptSetFavoriteCompleted:Wait() == Enum.AvatarPromptResult.Success then
					p6:dispatch(SetBundleFavorite(p2, p3))
					resolve()

					return
				end

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants.Counter.AvatarEditorServiceErrors.SetBundleFavorite)
				end

				p6:dispatch(SetNetworkingErrorToast({
					HttpError = Enum.HttpError.OK
				}))
				reject()
			end)
		end)(p4)
	end
end
