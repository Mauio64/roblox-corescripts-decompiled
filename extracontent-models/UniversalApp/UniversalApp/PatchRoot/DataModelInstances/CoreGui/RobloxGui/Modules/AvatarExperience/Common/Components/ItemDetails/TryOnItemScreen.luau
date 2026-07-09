local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local Dash = require(CorePackages.Packages.Dash)
local ItemDetails = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemDetails)
local ItemDetails_DEPRECATED = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemDetails_DEPRECATED)
local LookDetailsPeekView = require(Modules.AvatarExperience.Catalog.Components.LookDetails.LookDetailsPeekView)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local VRAvatarRotateHandler = require(Modules.AvatarExperience.Common.Components.Scene.VRAvatarRotateHandler)
local AvatarVRPanelWrapper = require(Modules.AvatarExperience.Common.Components.AvatarVRPanelWrapper)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local TryOnLookV2 = require(Modules.AvatarExperience.Common.Thunks.TryOnLookV2)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXAvatarSortInDiscoveryUnifiedPurchase = SharedFlags.FFlagAXAvatarSortInDiscoveryUnifiedPurchase
local FFlagAXTryOnScreenImprovements = SharedFlags.FFlagAXTryOnScreenImprovements
local FFlagAXFixTryOnItemVR = AvatarExperienceFlags.FFlagAXFixTryOnItemVR
local v33 = FFlagAXMigrateAXToGlobalAutofocus and game:DefineFastFlag("AXMigrateTryOnItemScreenToAutofocus", false)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useEffect = React.useEffect
local useTryOnAvatarAnimations = require(Modules.AvatarExperience.Catalog.Hooks.useTryOnAvatarAnimations)
local SetTabBarVisible = require(CorePackages.Workspace.Packages.AppTabBarRodux).Actions.SetTabBarVisible
local useSelectorSignal = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.useSelectorSignal
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceSave = require(CorePackages.Workspace.Packages.AvatarExperienceSave)
local v43 = if not FFlagAXTryOnScreenImprovements then nil else AvatarExperienceSave.Selectors.selectCharacterData
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2

local function useHideTabBarForHomeTryOn(t1: {[any]: any}) -- line: 75
	-- upvalues: useDispatch (copy), useEffect (copy), SetTabBarVisible (copy)
	local v49 = useDispatch()
	local params = nil

	if t1.navigation and (t1.navigation.state and t1.navigation.state.params) then
		params = t1.navigation.state.params
	end

	useEffect(function() -- line: 83
		-- upvalues: params (ref), v49 (copy), SetTabBarVisible (copy)
		if params and params.fromHome then
			v49(SetTabBarVisible(false))
		end
	end, { params })
end
local function useHideTabBarParam(t2: {[any]: any}) -- line: 90
	-- upvalues: FFlagAXTryOnScreenImprovements (copy), useDispatch (copy), useEffect (copy), SetTabBarVisible (copy)
	if not FFlagAXTryOnScreenImprovements then
		return
	end

	local v52 = useDispatch()
	local params = nil

	if t2.navigation and t2.navigation.state and t2.navigation.state.params then
		params = t2.navigation.state.params
	end

	useEffect(function() -- line: 101
		-- upvalues: params (ref), v52 (copy), SetTabBarVisible (copy)
		if params and params.hideTab then
			v52(SetTabBarVisible(false))
		end
	end, { params })
end
local function TryOnItemScreen(t3: {[any]: any}) -- line: 108
	-- upvalues: useDispatch (copy), useRoactService (copy), Analytics (copy), FFlagAXTryOnScreenImprovements (copy), useSelectorSignal (copy), v43 (copy), tutils (copy), React (copy), ClearTryOns (copy), useTryOnAvatarAnimations (copy), useAvatarRoute (copy), RoactNetworking (copy), ToggleTryOnThunk (copy), useHideTabBarParam (copy), useHideTabBarForHomeTryOn (copy), PeekViewState (copy), useEffectOnMount (copy), sendAXCounterV2 (copy), Constants (copy), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), TryOnLookV2 (copy), v33 (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), Roact (copy), SceneInteractionFrame (copy), LookDetailsPeekView (copy), FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation (copy), ItemDetails (copy), ItemDetails_DEPRECATED (copy), Dash (copy), FFlagAXFixTryOnItemVR (copy), IsVRAppBuild (copy), AvatarVRPanelWrapper (copy), VRAvatarRotateHandler (copy)
	local v55 = useDispatch()
	local v56 = useRoactService(Analytics)
	local v57 = if not FFlagAXTryOnScreenImprovements then nil else useSelectorSignal(v43, tutils.deepEqual)

	if not FFlagAXTryOnScreenImprovements then
		React.useEffect(function() -- line: 122
			-- upvalues: v55 (copy), ClearTryOns (copy)
			return function() -- line: 123
				-- upvalues: v55 (copy), ClearTryOns (copy)
				v55(ClearTryOns())
			end
		end, {})
	end

	local v58 = useTryOnAvatarAnimations()
	local itemType = nil
	local v60 = useAvatarRoute()
	local v61 = useRoactService(RoactNetworking)
	local params = nil
	local v63 = nil

	if t3.navigation and t3.navigation.state and t3.navigation.state.params then
		params = t3.navigation.state.params

		if params and (FFlagAXTryOnScreenImprovements or params.fromHome) then
			itemType = params.itemType
		end

		if FFlagAXTryOnScreenImprovements then
			v63 = params.simpleView == nil or params.simpleView
		end
	end

	if FFlagAXTryOnScreenImprovements then
		React.useEffect(function() -- line: 157
			-- upvalues: v57 (copy), v55 (copy), ClearTryOns (copy), ToggleTryOnThunk (copy), v61 (copy), v56 (copy), t3 (copy), v58 (copy)
			local v66 = v57(false)

			return function() -- line: 160
				-- upvalues: v55 (copy), ClearTryOns (copy), v66 (copy), ToggleTryOnThunk (copy), v61 (copy), v56 (copy), t3 (copy), v58 (copy)
				v55(ClearTryOns())

				for _, v72 in v66.tryOn.OutfitTryOn.TryOnItems do
					v55(ToggleTryOnThunk(v61, v56, v72.itemType, v72.itemSubType, v72.itemId, true, nil, t3.navigation))

					if v58 then
						v58(v72.itemId, v72.itemType, v72.itemSubType)
					end
				end
			end
		end, {})
	end

	if FFlagAXTryOnScreenImprovements then
		useHideTabBarParam(t3)
	else
		useHideTabBarForHomeTryOn(t3)
	end

	local t4 = {
		isTryOn = true,
		showPeekViewInSuperBrief = true,
		avatarRoute = v60,
		navigation = t3.navigation,
		initialPeekViewState = PeekViewState.SuperBrief
	}

	useEffectOnMount(function() -- line: 198
		-- upvalues: FFlagAXTryOnScreenImprovements (copy), sendAXCounterV2 (copy), Constants (copy), params (ref), v56 (copy), itemType (ref), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), v55 (copy), TryOnLookV2 (copy), v61 (copy), PeekViewState (copy), ToggleTryOnThunk (copy), t3 (copy), v58 (copy)
		if FFlagAXTryOnScreenImprovements then
			sendAXCounterV2(Constants.Counter.TryOnItemView)
		end

		if not FFlagAXTryOnScreenImprovements and (params == nil or not params.fromHome) then
			return
		end

		if not FFlagAXTryOnScreenImprovements then
			v56.homepageWidgetItemClick(params.itemId, params.itemType)
		end

		local itemId = params.itemId
		local itemSubType = params.itemSubType
		local itemSubTypeName = params.itemSubTypeName

		if itemSubType == nil then
			if itemType == "Asset" then
				itemSubType = Constants.AssetTypeIdStrings[itemSubTypeName]
			elseif itemType == "Bundle" then
				itemSubType = Constants.BundleTypeNameToIdStringForCatalogHydration[itemSubTypeName]
			end
		end

		if itemType == "Look" then
			local t5 = {
				itemId = itemId,
				itemType = itemType,
				surface = if not FFlagAXAvatarSortInDiscoveryUnifiedPurchase then nil else params.fromSurface
			}

			v55(TryOnLookV2(v61, nil, t5, itemId, PeekViewState.SuperBrief))

			return
		end

		if itemId and itemType and itemSubType then
			v55(ToggleTryOnThunk(v61, v56, itemType, itemSubType, itemId, true, nil, t3.navigation))

			if v58 then
				v58(itemId, itemType, itemSubType)
			end
		end
	end)

	local v65 = nil

	if v33 then
		v65 = React.useRef(nil)
		useFocusNavigableSurfaceRegistryConnection(v65.current, FocusNavigableSurfaceIdentifierEnum.CentralOverlay, true)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1)
	}, {
		SceneInteractionFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1)
		}, Roact.createElement(SceneInteractionFrame)),
		ItemDetails = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			ref = if not v33 then nil else v65
		}, {
			Content = if itemType ~= "Look" then Roact.createElement(if not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation then ItemDetails_DEPRECATED else ItemDetails, if not FFlagAXTryOnScreenImprovements then t3 else Dash.join(t3, {
				simpleView = v63
			})) else Roact.createElement(LookDetailsPeekView, t4)
		}),
		VRAvatarRotateHandler = if not FFlagAXFixTryOnItemVR or not IsVRAppBuild() then nil else Roact.createElement(AvatarVRPanelWrapper, {
			roundedCornersFrame = false,
			panelPlacement = "Center"
		}, {
			VRAvatarRotateHandler = Roact.createElement(VRAvatarRotateHandler)
		})
	})
end

return withStackVisibilityWrapper(TryOnItemScreen)
