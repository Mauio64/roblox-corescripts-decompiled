local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local focusable = RoactGamepad.Focusable
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module2 = require("@luauforge/bundled/gTh")

local module3 = require("@luauforge/deferred/gRz")
local module4 = require("@luauforge/bundled/fvR")
local module5 = require("@luauforge/deferred/hhY")
local module6 = require("@luauforge/bundled/gSD")
local fullView = AvatarExperienceCommon.Enums.FullView
local module7 = require("@luauforge/bundled/eie")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local module8 = require("@luauforge/bundled/dXe")
local fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice
local module9 = require("@luauforge/deferred/hic")
local module10 = require("@luauforge/deferred/gTx")

local module11 = require("@luauforge/bundled/dRs")

local function selectIsPortrait(p2): boolean
	return p2.DeviceOrientation == deviceOrientationMode.Portrait
end

local function AvatarRefinement(p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v5 = useSelector(selectIsPortrait)
	local v6 = useDispatch()
	local v7 = module7(avatarExperienceAnalyticsService)
	local v8 = useLocalization({ titleText = "Feature.Avatar.Title.AvatarRefinement" })

	v6(module6(v7, avatarScreen.AvatarRefinement, fullView.SceneFullView))

	React.useEffect(function()
		return function()
			if not fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
				v6(module8())
			end
		end
	end, {})

	local children = {
		TopBar = React.createElement(module4.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = v8.titleText,
			NextSelectionDown = ref,
			transparentBackground = true,
			hideSiteMessageBanner = v5,
			leftItem = module4.makeBackButton(function()
				if not fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
					v6(module8())
				end

				p2.navigation.pop()
			end),
			[Roact.Ref] = ref2
		}),
		RefinementNavBar = 0
	}

	local createElement2 = React.createElement
	local v9 = if module11() then module9 else module5
	children.RefinementNavBar = createElement2(v9, { ref = ref, NextSelectionUp = ref2 })

	return React.createElement(
		focusable.Frame,
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, defaultChild = ref },
		React.createElement(module10, nil, children)
	)
end

return (module3((module2(AvatarRefinement))))
