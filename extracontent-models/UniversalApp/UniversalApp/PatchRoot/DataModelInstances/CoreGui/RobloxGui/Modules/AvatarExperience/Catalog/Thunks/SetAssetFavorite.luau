local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Modules = CoreGui.RobloxGui.Modules
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetAssetFavorite = require(Modules.AvatarExperience.Catalog.Actions.SetAssetFavorite)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function keyMapper(p1) -- line: 25
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.SetFavoriteAssetKey .. p1
end

return function(p2, p3) -- line: 29
	-- upvalues: ArgCheck (copy), PerformFetch (copy), CatalogConstants (copy), Promise (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), SetAssetFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), SetNetworkingErrorToast (copy)
	ArgCheck.isType(p2, "string", "SetAssetFavorite thunk expects assetId")
	ArgCheck.isType(p3, "boolean", "SetAssetFavorite thunk expects isFavorited")

	return function(p4, p5) -- line: 33
		-- upvalues: PerformFetch (copy), p2 (copy), CatalogConstants (copy), Promise (copy), p3 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), SetAssetFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), SetNetworkingErrorToast (copy)
		local avatarEditorService = p5.avatarEditorService
		local Single = PerformFetch.Single
		local v21 = p2

		return Single(CatalogConstants.SetFavoriteAssetKey .. v21, function(p6) -- line: 35
			-- upvalues: Promise (copy), avatarEditorService (copy), p2 (copy), p3 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), SetAssetFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), SetNetworkingErrorToast (copy)
			return Promise.new(function(resolve, reject) -- line: 36
				-- upvalues: avatarEditorService (copy), p2 (copy), p3 (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants (copy), p6 (copy), SetAssetFavorite (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), SetNetworkingErrorToast (copy)
				local v25 = avatarEditorService:NoPromptSetFavorite(p2, Enum.AvatarItemType.Asset, p3)

				while not v25 do
					avatarEditorService.PromptSetFavoriteCompleted:Wait()
					v25 = avatarEditorService:NoPromptSetFavorite(p2, Enum.AvatarItemType.Asset, p3)
					reportAvatarEventCounterNoAnalyticsArgument(Constants.Counter.AvatarEditorServiceErrors.NoPromptSetFavorite)
				end

				if avatarEditorService.PromptSetFavoriteCompleted:Wait() == Enum.AvatarPromptResult.Success then
					p6:dispatch(SetAssetFavorite(p2, p3))
					resolve()

					return
				end

				if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
					reportAvatarEventCounterNoAnalyticsArgument(Constants.Counter.AvatarEditorServiceErrors.SetAssetFavorite)
				end

				p6:dispatch(SetNetworkingErrorToast({
					HttpError = Enum.HttpError.OK
				}))
				reject()
			end)
		end)(p4)
	end
end
