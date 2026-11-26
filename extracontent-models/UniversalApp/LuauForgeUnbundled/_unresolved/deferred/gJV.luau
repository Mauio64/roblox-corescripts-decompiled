local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module2 = require("@luauforge/bundled/eie")
local module3 = require("@luauforge/bundled/egx")
local module4 = require("@luauforge/deferred/gJW")

local module5 = require("@luauforge/deferred/gJH")
local module6 = require("@luauforge/bundled/dXh")

local module7 = require("@luauforge/deferred/gJI")
local module8 = require("@luauforge/deferred/gJR")

local module9 = require("@luauforge/deferred/gJX")

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection

local function CommunityAvatarEntryMenu(p2)
	local v5 = useScreenSize()
	local v6 = useNavigation()
	local v7 = useLocalization({
		shareAvatar = "Feature.Avatar.Action.ShareAvatar",
		mySharedAvatar = "Feature.Avatar.Action.MySharedAvatars"
	})

	local v8 = useDispatch()
	local v9 = module2(module3)
	local binding, v10 = React.createBinding(UDim2.fromOffset(0, 0))

	local v11 = useAvatarRoute()
	local v12

	if fFlagSignalsNavP3gAvatarExperience then
		v12 = nil
	else
		v12 = useSelector(function(p3)
			if fFlagUseNavigationSelectors then
				return selectors.selectLegacyHistory(p3)
			end

			return p3.Navigation.history
		end)
	end

	local v13 = React.useCallback(function()
		local v14

		if fFlagSignalsNavP3gAvatarExperience then
			v14 = getLegacyNavigationStore(false).getHistory(false)
		else
			v14 = v12
		end

		module6.closeOverlay(v6)
		module6.closeMySharedAvatars(v6)
		local navigateFromOverlay = module6.navigateFromOverlay
		local lookComposerPage = avatarScreen.LookComposerPage
		local v17 = if v11 then v11.opaque.name else nil
		navigateFromOverlay(v6, lookComposerPage, {
			prevNavPage = v17,
			prevNavHistory = v14
		})
	end, { v6 })

	local v14 = React.useCallback(function()
		v8(module4(v9))
		module6.navigateFromOverlay(v6, avatarScreen.MySharedAvatars)
	end, { v8, v6, v9 })
	local v15

	if module9 then
		v15 = React.useCallback(function()
			module6.closeOverlay(v6)
		end, { v6 })
	end

	local v16 = React.useMemo(function()
		return {
			{
				text = v7.shareAvatar,
				icon = images["icons/common/plus"],
				iconSize = 36,
				inputBindingKey = "CommonUI.Controls.Action.Confirm",
				onActivated = v13
			},
			{
				text = v7.mySharedAvatar,
				icon = images["icons/actions/friend_sort/my_profile"],
				iconSize = 36,
				inputBindingKey = "CommonUI.Controls.Action.Confirm",
				onActivated = v14
			}
		}
	end, { v7, v13, v14 })

	local v17 = React.useCallback(function(p3)
		v10(UDim2.fromOffset(-p3.AbsolutePosition.X, -p3.AbsolutePosition.Y))
	end, {})

	local udim = UDim2.fromOffset(p2.entryButtonPosition.X - 300, 0)
	local udim2 = UDim2.new(0, 324, 1, 0)
	local v18 = p2.entryButtonPosition.Y + 25

	local createElement = Roact.createElement

	local createElement2 = Roact.createElement
	local frame = focusable.Frame
	local v22 = {
		BackgroundTransparency = 1,
		Position = udim,
		Size = udim2,
		ref = p2.defaultChildRef
	}

	local createElement3 = Roact.createElement
	local v25 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

	local createElement4 = Roact.createElement
	local v28 = {
		buttonProps = v16,
		contextMenuWidthOverride = UDim.new(0, 300),
		open = true,
		menuDirection = menuDirection.Down,
		openPositionY = UDim.new(0, v18),
		closeBackgroundVisible = true,
		screenSize = v5,
		onDismiss = 0
	}

	if not module9 then
		v15 = nil
	end

	v28.onDismiss = v15
	return createElement(module8, { onAbsolutePositionChanged = v17 }, {
		SizeFrame = createElement2(frame, v22, {
			PositionOffsetFrame = createElement3("Frame", v25, {
				ContextMenu = createElement4(contextualMenu, v28)
			})
		})
	})
end

return (module5((module7(CommunityAvatarEntryMenu))))
