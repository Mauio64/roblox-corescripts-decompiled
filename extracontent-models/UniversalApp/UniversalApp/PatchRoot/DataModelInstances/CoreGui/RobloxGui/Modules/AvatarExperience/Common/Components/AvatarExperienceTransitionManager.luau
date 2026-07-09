local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local FaceAnimatorService = game:GetService("FaceAnimatorService")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local ResetSortAndFilters = require(Modules.AvatarExperience.Catalog.Actions.ResetSortAndFilters)
local ResetSortAndFiltersThunk = require(Modules.AvatarExperience.Catalog.Thunks.ResetSortAndFiltersThunk)
local StoreAndClearTryOns = require(Modules.AvatarExperience.Common.Thunks.StoreAndClearTryOns)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetCameraButtonStatus = AvatarExperienceRodux.Actions.SetCameraButtonStatus
local SetCameraButtonErrorOccurred = AvatarExperienceRodux.Actions.SetCameraButtonErrorOccurred
local mutedError = require(Modules.LuaApp.mutedError)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local getCameraOptIn = require(CorePackages.Workspace.Packages.CameraOptIn).getCameraOptIn
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local UniversalAppCameraIXPTest = require(Modules.AvatarExperience.Flags.UniversalAppCameraIXPTest)
local FFlagAXResetAnalyticsMetadataOnFilterReset = require(Modules.AvatarExperience.Flags.FFlagAXResetAnalyticsMetadataOnFilterReset)
local v28 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.transition")
local t1 = {
	toastMessage = "Feature.FaceChat.Subtitle.FeatureDisabled",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local u30 = nil

local function AvatarExperienceTransitionManager(_) -- line: 58
	-- upvalues: useDispatch (copy), useSelector (copy), Utils (copy), getUseSelectorDeepEquals (copy), usePrevious (copy), useAvatarRoute (copy), useRoactService (copy), RoactNetworking (copy), IxpUtils (copy), UniversalAppCameraIXPTest (copy), v28 (copy), AvatarScreenProperties (copy), FFlagAXMISEnableMultiShopping (copy), StoreAndClearTryOns (copy), FFlagAXResetAnalyticsMetadataOnFilterReset (copy), ResetSortAndFiltersThunk (copy), ResetSortAndFilters (copy), getCameraOptIn (copy), u30 (ref), FaceAnimatorService (copy), SetCameraButtonStatus (copy), SetCameraButtonErrorOccurred (copy), SetCurrentToastMessage (copy), t1 (copy), mutedError (copy), React (copy)
	local v33 = useDispatch()
	local v34 = useSelector(Utils.isAvatarExperienceRoute, getUseSelectorDeepEquals())
	local v35 = usePrevious(v34)
	local v36 = useAvatarRoute()
	local v37 = usePrevious(v36)
	local v38 = useRoactService(RoactNetworking)
	local v39 = IxpUtils.useTestVariables(UniversalAppCameraIXPTest.EnabledForUser)

	local function onLeaveAvatarExperience() -- line: 68
		-- upvalues: v28 (copy), v37 (copy), AvatarScreenProperties (copy), FFlagAXMISEnableMultiShopping (copy), v33 (copy), StoreAndClearTryOns (copy), FFlagAXResetAnalyticsMetadataOnFilterReset (copy), ResetSortAndFiltersThunk (copy), ResetSortAndFilters (copy)
		v28:debug("Leaving AvatarExperience")

		local v43 = if not v37 then nil else v37.opaque.name
		local v44 = v43 and (AvatarScreenProperties[v43] and AvatarScreenProperties[v43].isMultiTryOn)

		if not FFlagAXMISEnableMultiShopping and v44 then
			v33(StoreAndClearTryOns())
		end

		if FFlagAXResetAnalyticsMetadataOnFilterReset then
			v33(ResetSortAndFiltersThunk())

			return
		end

		v33(ResetSortAndFilters())
	end
	local function onEnterAvatarExperience() -- line: 85
		-- upvalues: v28 (copy)
		v28:debug("Entering AvatarExperience")
	end
	local function handleTransitions() -- line: 89
		-- upvalues: v35 (copy), v34 (copy), onLeaveAvatarExperience (copy), v39 (copy), Utils (copy), getCameraOptIn (copy), v38 (copy), u30 (ref), FaceAnimatorService (copy), v33 (copy), SetCameraButtonStatus (copy), SetCameraButtonErrorOccurred (copy), SetCurrentToastMessage (copy), t1 (copy), mutedError (copy), v28 (copy)
		if v35 and not v34 then
			onLeaveAvatarExperience()

			return
		end

		if v34 and not v35 then
			if v39 and Utils.isUserCameraEligible() then
				getCameraOptIn(v38, true):andThen(function(b1: boolean) -- line: 96
					-- upvalues: u30 (ref), FaceAnimatorService (copy), v33 (copy), SetCameraButtonStatus (copy), SetCameraButtonErrorOccurred (copy), SetCurrentToastMessage (copy), t1 (copy), mutedError (copy)
					if b1 ~= u30 then
						FaceAnimatorService:Init(b1, false)
						FaceAnimatorService.TrackerError:Connect(function(p2) -- line: 100
							-- upvalues: v33 (copy), SetCameraButtonStatus (copy), SetCameraButtonErrorOccurred (copy), SetCurrentToastMessage (copy), t1 (copy), mutedError (copy)
							v33(SetCameraButtonStatus(false))
							v33(SetCameraButtonErrorOccurred(true))
							v33(SetCurrentToastMessage(t1))
							mutedError(string.format("Universal App Camera FaceAnimatorService TrackerError: %s", (tostring(p2))))
						end)
						u30 = b1
					end
				end)
			end

			v28:debug("Entering AvatarExperience")
		end
	end

	React.useEffect(handleTransitions, {
		v34,
		v35,
		v37
	})

	return nil
end

return AvatarExperienceTransitionManager
