local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local NavigateBack = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateBack
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local startFacialAgeEstimation = require(CorePackages.Workspace.Packages.SocialUpsell).Thunks.startFacialAgeEstimation
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local GetFaeFeatureAccessStore = require(Modules.AvatarExperience.Catalog.Stores.GetFaeFeatureAccessStore)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local v19 = game:DefineFastInt("AXFaeFeatureAccessRefetchDelayMs", 0)
local v20 = game:DefineFastFlag("AXEnableFaeSuccessToastDurationSeconds", false)
local v21 = game:DefineFastInt("AXFaeFeatureAccessToastDurationSeconds", 3)

local function useOpenFAEPage(s1: string?, s2: string, s3: string?, b1: boolean?, s4: string?) -- line: 43
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), useAvatarRoute (copy), useNavigation (copy), useLocalization (copy), React (copy), startFacialAgeEstimation (copy), SetCurrentToastMessage (copy), ToastType (copy), v20 (copy), v21 (copy), v19 (copy), GetFaeFeatureAccessStore (copy), ToggleTryOnThunk (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateBack (copy)
	local v28 = useDispatch()
	local v29 = useRoactService(RoactNetworking)
	local v30 = useRoactService(Analytics)
	local v31 = useAvatarRoute()
	local v32 = useNavigation()
	local v33 = useLocalization({
		ageVerificationComplete = {
			"Feature.MarketplaceFAEUpsell.Message.AgeCheckCompleteItem",
			itemName = s4
		}
	})

	return React.useCallback(function() -- line: 64
		-- upvalues: v28 (copy), startFacialAgeEstimation (copy), SetCurrentToastMessage (copy), v33 (copy), ToastType (copy), v20 (copy), v21 (copy), v19 (copy), GetFaeFeatureAccessStore (copy), v29 (copy), b1 (copy), s3 (copy), s1 (copy), ToggleTryOnThunk (copy), v30 (copy), s2 (copy), v31 (copy), v32 (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateBack (copy)
		v28(startFacialAgeEstimation("MarketplaceUpsell", function() -- line: 65
			-- upvalues: v28 (copy), SetCurrentToastMessage (copy), v33 (copy), ToastType (copy), v20 (copy), v21 (copy), v19 (copy), GetFaeFeatureAccessStore (copy), v29 (copy), b1 (copy), s3 (copy), s1 (copy), ToggleTryOnThunk (copy), v30 (copy), s2 (copy), v31 (copy), v32 (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateBack (copy)
			v28(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v33.ageVerificationComplete,
				toastType = ToastType.SuccessConfirmation,
				duration = if not v20 then nil else v21
			}))
			task.delay(v19 / 1000, function() -- line: 74
				-- upvalues: GetFaeFeatureAccessStore (copy), v29 (copy)
				GetFaeFeatureAccessStore.getFaeFeatureAccessStore().fetch(v29)
			end)

			if b1 and (s3 and s1) then
				v28(ToggleTryOnThunk(v29, v30, s2, s3, s1, false, v31, v32, nil))
			end

			if FFlagSignalsNavP3Dispatch then
				v10.back()

				return
			end

			v28(NavigateBack())
		end, function() -- line: 97
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v10 (copy), v28 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				v10.back()

				return
			end

			v28(NavigateBack())
		end, "MarketplaceUpsell"))
	end, {
		v28,
		v33,
		v29,
		v30,
		v31,
		v32,
		s1,
		s2,
		s3,
		b1
	})
end

return useOpenFAEPage
