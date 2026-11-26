local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local fFlagAXFavoritesManagerNavEntry = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFavoritesManagerNavEntry

local module = require("@luauforge/bundled/fvR")

local function selectIsPortrait(p2): boolean
	return p2.DeviceOrientation == deviceOrientationMode.Portrait
end

local function FavoritesSavedTopBar(p2)
	if not fFlagAXFavoritesManagerNavEntry then
		return nil
	end

	local v5 = useNavigation()
	local v6 = useSelector(selectIsPortrait)
	local v7 = useLocalization({ title = "Feature.Catalog.Label.Favorites" })

	local v8 = React.useCallback(function()
		v5.navigate(avatarScreen.Catalog)
	end, { v5 })

	local v9 = React.useMemo(function()
		return module.makeBackButton(v8, true)
	end, { v8 })

	return React.createElement(module.Container, {
		tag = compositionTags.ContentRegion.Header,
		sideMarginOverride = 0,
		transparentBackground = v6,
		hideSiteMessageBanner = v6,
		ref = p2.topBarRef,
		titleText = v7.title,
		leftItem = v9,
		rightItems = {}
	})
end

return FavoritesSavedTopBar
