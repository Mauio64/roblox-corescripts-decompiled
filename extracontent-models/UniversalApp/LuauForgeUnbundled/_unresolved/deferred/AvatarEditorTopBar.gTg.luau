local CorePackages = game:GetService("CorePackages")

local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local isVRAppBuild = AppCommonLib.IsVRAppBuild
local module2 = require("@luauforge/bundled/dCp")
local React = require(CorePackages.Packages.React)

local compositionTags = require("@luauforge/bundled/gns").CompositionTags

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious

local module3 = require("@luauforge/bundled/fox")
local module4 = require("@luauforge/deferred/fos")

local v5 = if require("@luauforge/deferred/gTh")() then require("@luauforge/deferred/gTi") else require("@luauforge/deferred/gTk")
local module5 = require("@luauforge/deferred/gTl")
local module6 = require("@luauforge/deferred/gTm")
local module7 = require("@luauforge/deferred/gTn")

local module8 = require("@luauforge/deferred/gmX")

local module9 = require("@luauforge/deferred/gTp")

local fFlagAXAvatarSharingEntryPoint = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarSharingEntryPoint
local fFlagAXMeTabTopScrim = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMeTabTopScrim

local fFlagFlyoutNavigationInMarketplace = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFlyoutNavigationInMarketplace
local module10 = require("@luauforge/bundled/dHC")

local v6 = if fFlagFlyoutNavigationInMarketplace and module10 then require("@luauforge/deferred/gTq") else nil

local function selectIsPortrait(p2): boolean
	return p2.DeviceOrientation == deviceOrientationMode.Portrait
end

local function selectIsCurrentUserAllowedToCreateShares(p2)
	return p2.AvatarExperience.Catalog.Metadata.isCurrentUserAllowedToCreateShares
end

local function AvatarEditorTopBar(props)
	local v7 = useSelector(selectIsPortrait)
	local v8 = useSelector(selectIsCurrentUserAllowedToCreateShares)

	local navigation = props.navigation
	local v9 = useLocalization({ title = "Feature.Catalog.Action.Customize" })

	local current = React.useRef(module4()).current
	local showManageOutfitButton = props.showManageOutfitButton

	local v10 = React.useCallback(function()
		navigation.navigate(module2.Home)
	end, { navigation })

	React.useEffect(function()
		if module8(props) then
			current.connect(v10)
		end

		return function()
			current.disconnect()
		end
	end, { props.navigation, props.avatarRoute, current, v10 })

	local v11 = usePrevious(props)
	React.useEffect(function()
		if not v11 then
			return
		end

		if module8(v11) or not module8(props) then
			if module8(v11) and not module8(props) then
				current.disconnect()
			end
		else
			current.connect(v10)
		end
	end, { props.navigation, props.avatarRoute, v11, current })

	local v12 = module5(v10)
	local v13

	if isVRAppBuild() then
		v12 = nil
	else
		if fFlagFlyoutNavigationInMarketplace and module10 then
			v12 = v6
		end

		v13 = v5

		if showManageOutfitButton then
			local v14 = { module6 }
		end
	end

	local v14 = (v8 or module9()) and not fFlagAXAvatarSharingEntryPoint and { module7 } or {}

	return React.createElement(module3.Container, {
		transparentBackground = v7,
		showTopScrim = if fFlagAXMeTabTopScrim then v7 else nil,
		tag = compositionTags.ContentRegion.Header,
		sideMarginOverride = 0,
		hideSiteMessageBanner = v7,
		ref = props.topBarRef,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionRight = props.NextSelectionRight,
		titleText = v9.title,
		leftItem = v12,
		centerItem = v13,
		rightItems = v14,
		useParentSizeForCenterItem = true
	})
end

return AvatarEditorTopBar
