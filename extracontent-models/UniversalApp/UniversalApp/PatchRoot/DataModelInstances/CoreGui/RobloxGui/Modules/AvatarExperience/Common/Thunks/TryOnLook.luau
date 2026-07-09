local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetTryOnManagerPeekViewState = AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)

require(Modules.AvatarExperience.Common.Types)

local AddLookDetails = require(Modules.AvatarExperience.Common.Actions.AddLookDetails)
local TryOnLooksOutfit = AvatarExperienceRodux.Actions.TryOnLooksOutfit
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Promise = require(Modules.LuaApp.Promise)
local Cryo = require(CorePackages.Packages.Cryo)

local function keyMapper(s1: string) -- line: 33
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.FetchLookDetailInfoKey .. s1
end

return function(p1, p2, p3, s2: string) -- line: 37
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), WebApi (copy), Logging (copy), SetCurrentToastMessage (copy), ToastType (copy), AddLookDetails (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), TryOnLooksOutfit (copy), Cryo (copy), NavigationUtils (copy), AvatarScreen (copy), NavigateWithLock (copy), Promise (copy)
	return function(p4) -- line: 38
		-- upvalues: PerformFetch (copy), s2 (copy), CatalogConstants (copy), WebApi (copy), p1 (copy), Logging (copy), SetCurrentToastMessage (copy), ToastType (copy), AddLookDetails (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), TryOnLooksOutfit (copy), p3 (copy), Cryo (copy), p2 (copy), NavigationUtils (copy), AvatarScreen (copy), NavigateWithLock (copy), Promise (copy)
		local Single = PerformFetch.Single
		local v27 = s2

		return Single(CatalogConstants.FetchLookDetailInfoKey .. v27, function(p5) -- line: 39
			-- upvalues: WebApi (copy), p1 (copy), s2 (copy), Logging (copy), SetCurrentToastMessage (copy), ToastType (copy), AddLookDetails (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), TryOnLooksOutfit (copy), p3 (copy), Cryo (copy), p2 (copy), NavigationUtils (copy), AvatarScreen (copy), NavigateWithLock (copy), Promise (copy)
			return WebApi.GetLookDetails(p1, s2):andThen(function(p6) -- line: 40
				-- upvalues: Logging (copy), p5 (copy), SetCurrentToastMessage (copy), ToastType (copy), AddLookDetails (copy), s2 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), TryOnLooksOutfit (copy), p3 (copy), Cryo (copy), p2 (copy), NavigationUtils (copy), AvatarScreen (copy), NavigateWithLock (copy), Promise (copy)
				local look = p6.responseBody.look

				if look == nil then
					Logging.warn("Unexpectedly received an empty response from Look Details")
					p5:dispatch(SetCurrentToastMessage({
						isLocalized = false,
						toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
						toastType = ToastType.NetworkingError
					}))

					return
				end

				p5:dispatch(AddLookDetails(s2, look.totalPrice, look.totalPremiumPrice, look.items))

				local t1 = {}

				for _, v33 in look.items do
					table.insert(t1, {
						itemType = "Asset",
						itemSubType = tostring(v33.assetType),
						itemId = tostring(v33.id)
					})
				end

				p5:dispatch(SetTryOnManagerPeekViewState(PeekViewState.SuperBrief))
				p5:dispatch(TryOnLooksOutfit({
					assetItemIdTypeAndSubtype = t1,
					lookId = s2,
					analyticsInfo = p3,
					lookType = Cryo.None
				}))

				if p2 ~= nil then
					p5:dispatch(NavigateWithLock(function() -- line: 79
						-- upvalues: NavigationUtils (copy), p2 (copy), AvatarScreen (copy)
						NavigationUtils.closeFiltersAndItemDetails(p2)
						NavigationUtils.closeTryOnManager(p2, { AvatarScreen.LookDetails })
						p2.navigate(AvatarScreen.TryOnManager)
					end))
				end

				return Promise.resolve()
			end, function(_) -- line: 88
				-- upvalues: Logging (copy), p5 (copy), SetCurrentToastMessage (copy), ToastType (copy)
				Logging.warn("Error in TryOnLook thunk")
				p5:dispatch(SetCurrentToastMessage({
					isLocalized = false,
					toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
					toastType = ToastType.NetworkingError
				}))
			end)
		end)(p4)
	end
end
