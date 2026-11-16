local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Foundation = require(CorePackages.Packages.Foundation)
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local enums = require("@game/CorePackages/Workspace/Packages/NetworkingFriends").Enums
local module2 = require("@luauforge/bundled/eef")
local profileTypes = module2.ProfileTypes
local screens = module2.Screens
local profileTabVariants = module2.ProfileTabVariants
local enums2 = require("@luauforge/bundled/gVI").Enums

local module3 = require("@luauforge/bundled/dCp")
local module4 = require("@luauforge/deferred/gTl")
local module5 = require("@luauforge/bundled/dTM")
local module6 = require("@luauforge/bundled/gfm")
local module7 = require("@luauforge/deferred/gVJ")
require("@luauforge/deferred/gVF")

local fFlagFlyoutNavigationInMarketplace = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFlyoutNavigationInMarketplace
local fFlagAXUseProfileIconEntryPoint = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseProfileIconEntryPoint
local module8 = require("@luauforge/bundled/dHC")
local module9 = require("@luauforge/deferred/gVG")

local module10 = require("@luauforge/deferred/goT")

local v5 = if fFlagFlyoutNavigationInMarketplace and module8 then require("@luauforge/deferred/gTq") else nil

local function selectLocalUserId(p2)
	return (tostring(p2.LocalUserId))
end

local function makeProfileCloseButton(onActivated)
	local function ProfileCloseButton(p2)
		React.useEffect(function()
			p2.setVisible(true)
		end, { p2.setVisible })

		return React.createElement(iconButton, {
			icon = iconName.X,
			isCircular = true,
			onActivated = onActivated,
			ref = p2.buttonRef
		})
	end

	return ProfileCloseButton
end

local function useProfileTabPageViewModel(p2)
	local v6 = useNavigation()
	local v7 = useAvatarRoute()

	local state = p2.navigation and p2.navigation.state
	local v8 = state and state.routes and state.routes[state.index]
	local routeName = v8 and v8.routeName
	local v9 = routeName == nil or routeName == screens.ProfileMain

	local v10 = module9 and routeName == enums2.Screens.EditProfileImageProfilePlatform

	local v11 = (v7 and v7.current and v7.current.name) == avatarScreen.ItemDetails

	local v12 = useSelector(selectLocalUserId)
	local v13 = useSelector(module6)

	local entryOrigin = if fFlagAXUseProfileIconEntryPoint then v7.opaque.params.entryOrigin else nil
	local v15

	if module10 then
		local v16 = if v10 then v10 else not (entryOrigin == nil) and not v9
		v15 = not v16
	end

	local useCallback = React.useCallback
	local function fn()
		if fFlagAXUseProfileIconEntryPoint and not v9 then
			v6.pop()
		elseif fFlagAXUseProfileIconEntryPoint and entryOrigin then
			module5.restoreEntryOrigin(v6, module3.Home)
			v6.setParams({ entryOrigin = RoactNavigation.None })
		else
			v6.navigate(module3.Home)
		end
	end

	local v17 = if fFlagAXUseProfileIconEntryPoint then v9 else nil
	local v19 = useCallback(fn, { v6, v17, if fFlagAXUseProfileIconEntryPoint then entryOrigin else nil })

	module7({ navigation = v6, avatarRoute = v7, onBack = v19 })

	local function fn2()
		if fFlagAXUseProfileIconEntryPoint and entryOrigin then
			local v20 = v19

			local function ProfileCloseButton(p3)
				React.useEffect(function()
					p3.setVisible(true)
				end, { p3.setVisible })

				return React.createElement(iconButton, {
					icon = iconName.X,
					isCircular = true,
					onActivated = v20,
					ref = p3.buttonRef
				})
			end

			return ProfileCloseButton
		elseif fFlagFlyoutNavigationInMarketplace and module8 then
			return v5
		else
			return module4(v19)
		end
	end

	local v22 = React.useMemo(fn2, { v19, if fFlagAXUseProfileIconEntryPoint then entryOrigin else nil })

	local v23 = React.useMemo(function()
		local v24 = {
			profileId = v12,
			profileType = profileTypes.User,
			source = "AvatarProfileTab",
			contextualInfoType = "",
			friendshipOriginSourceType = enums.FriendshipOriginSourceType.UserProfile.rawValue(),
			mountAsFullView = true,
			forceFullView = true,
			headerVariant = 0,
			currentlyWearingVariant = 0,
			itemDetailsFullView = true
		}

		local v25 = if v13 then profileTabVariants.Default else profileTabVariants.MeTab
		v24.headerVariant = v25

		v24.currentlyWearingVariant = profileTabVariants.MeTab
		return v24
	end, { v12, v13 })

	local clone = table.clone(p2)
	clone.embedded = true
	clone.embedNavigationProps = v23

	local v24 = {
		isPortrait = v13,
		isAtProfileRoot = v9,
		hideAvatarScene = v10,
		isOverlayTopBarVisible = v13 and v9 and not v11,
		isLandscapeTopBarVisible = v15,
		showSegmentedMenu = nil,
		leftItem = nil,
		topBarTransparent = nil,
		wrapperProps = nil
	}
	local v25 = if fFlagAXUseProfileIconEntryPoint then entryOrigin == nil else nil
	v24.showSegmentedMenu = v25
	v24.leftItem = v22
	v24.topBarTransparent = v13
	v24.wrapperProps = clone
	return v24
end

return useProfileTabPageViewModel
