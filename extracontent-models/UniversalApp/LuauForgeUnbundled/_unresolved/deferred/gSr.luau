local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local clearTryOns = require("@luauforge/bundled/dKU").Actions.ClearTryOns
local module = require("@luauforge/bundled/fDz")
local module2 = require("@luauforge/bundled/fDf")
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local Dash = require(CorePackages.Packages.Dash)

local module3 = require("@luauforge/deferred/gOT")
local module4 = require("@luauforge/deferred/gSs")

local module5 = require("@luauforge/deferred/gSZ")
local module6 = require("@luauforge/bundled/gTf")
local module7 = require("@luauforge/deferred/gTm")
local module8 = require("@luauforge/deferred/gJL")

local module9 = require("@luauforge/deferred/gRz")
local module10 = require("@luauforge/bundled/eie")
local module11 = require("@luauforge/bundled/egx")
local module12 = require("@luauforge/bundled/dPN")
local module13 = require("@luauforge/bundled/ehL")
local useFocusNavigableSurfaceRegistryConnection = module13.useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = module13.FocusNavigableSurfaceIdentifierEnum

local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute

local module14 = require("@luauforge/deferred/gTn")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local fFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags.FFlagAXEnableUnifiedLoggingAvatarMoment

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useEffect = React.useEffect
local module17 = require("@luauforge/deferred/gTr")
local setTabBarVisible = require("@luauforge/bundled/dzQ").Actions.SetTabBarVisible
local useSelectorSignal = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useSelectorSignal

local tutils = require(CorePackages.Packages.tutils)
local selectCharacterData = require("@luauforge/bundled/gKz").Selectors.selectCharacterData

local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

local function useHideTabBarParam(p2)
	local v5 = useDispatch()
	local params

	if p2.navigation and p2.navigation.state and p2.navigation.state.params then
		params = p2.navigation.state.params
	else
		params = nil
	end

	useEffect(function()
		if params and params.hideTab then
			v5(setTabBarVisible(false))
		end
	end, { params })
end

local function TryOnItemScreen(p2)
	local v5 = useDispatch()
	local v6 = module10(module2)

	local v7 = useSelectorSignal(selectCharacterData, tutils.deepEqual)

	local v8 = module17()

	local itemType = nil

	local v9 = useAvatarRoute()
	local v10 = module10(module11)

	local params = nil
	local v11 = nil
	local v12 = if fFlagMomentsAvatarLookTryOn then false else nil

	if p2.navigation and p2.navigation.state and p2.navigation.state.params then
		params = p2.navigation.state.params

		itemType = params.itemType

		if fFlagMomentsAvatarLookTryOn then
			v12 = params.fromMoments == true
		end

		v11 = params.simpleView == nil or params.simpleView
	end

	React.useEffect(function()
		local v13 = v7(false)

		return function()
			v5(clearTryOns())

			for k, tryOnItem in v13.tryOn.OutfitTryOn.TryOnItems do
				v5(module(
					v10,
					v6,
					tryOnItem.itemType,
					tryOnItem.itemSubType,
					tryOnItem.itemId,
					true,
					nil,
					p2.navigation
				))

				if v8 then
					v8(tryOnItem.itemId, tryOnItem.itemType, tryOnItem.itemSubType)
				end
			end
		end
	end, {})

	useHideTabBarParam(p2)

	local v13 = {
		avatarRoute = v9,
		navigation = p2.navigation,
		isTryOn = true,
		initialPeekViewState = peekViewState.SuperBrief,
		showPeekViewInSuperBrief = true
	}

	useEffectOnMount(function()
		sendAXCounterV2(module12.Counter.TryOnItemView)

		local itemId = params.itemId
		local v14 = params.itemSubType
		local itemSubTypeName = params.itemSubTypeName

		if v14 == nil then
			if itemType == "Asset" then
				v14 = module12.AssetTypeIdStrings[itemSubTypeName]
			elseif itemType == "Bundle" then
				v14 = module12.BundleTypeNameToIdStringForCatalogHydration[itemSubTypeName]
			end
		end

		if itemType == "Look" then
			local v15 = {
				itemId = itemId,
				itemType = itemType,
				surface = params.fromSurface,
				shopMetadata = 0
			}

			local v16 = if fFlagAXEnableUnifiedLoggingAvatarMoment then params.shopMetadata else nil
			v15.shopMetadata = v16

			v5(module14(v10, nil, v15, itemId, peekViewState.SuperBrief))
		elseif itemId and itemType and v14 then
			v5(module(v10, v6, itemType, v14, itemId, true, nil, p2.navigation))

			if v8 then
				v8(itemId, itemType, v14)
			end
		end
	end)

	local ref = React.useRef(nil)
	useFocusNavigableSurfaceRegistryConnection(
		ref.current,
		focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		true
	)

	local createElement = Roact.createElement
	local v15 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v16 = {
		SceneInteractionFrame = Roact.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 1
			},
			Roact.createElement(module6)
		),
		ItemDetails = 0,
		VRAvatarRotateHandler = 0
	}

	local createElement2 = Roact.createElement
	local v18 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
		ref = ref
	}
	local v20

	if fFlagMomentsAvatarLookTryOn and itemType == "Look" and v12 then
		v20 = Roact.createElement(module5, { navigation = p2.navigation })
	elseif itemType == "Look" then
		v20 = Roact.createElement(module4, v13)
	else
		v20 = Roact.createElement(module3, Dash.join(p2, { simpleView = v11 }))
	end

	v16.ItemDetails = createElement2("Frame", v18, { Content = v20 })

	local v21 = if isVRAppBuild() then Roact.createElement(
		module8,
		{ roundedCornersFrame = false, panelPlacement = "Center" },
		{ VRAvatarRotateHandler = Roact.createElement(module7) }
	) else nil
	v16.VRAvatarRotateHandler = v21
	return createElement("Frame", v15, v16)
end

return module9(TryOnItemScreen)
