local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local Enums = require(CorePackages.Workspace.Packages.FriendsNetworking).Enums
local Enums2 = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local ProfileTypes = Enums2.ProfileTypes
local Screens = Enums2.Screens
local ProfileTabVariants = Enums2.ProfileTabVariants
local AppPage = require(Modules.LuaApp.AppPage)
local makeAvatarBackButton = require(Modules.AvatarExperience.Common.Components.TopBar.makeAvatarBackButton)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local useAvatarHardwareBackButton = require(Modules.AvatarExperience.Common.Hooks.useAvatarHardwareBackButton)

require(Modules.AvatarExperience.Common.Components.Profile.ProfileTabPageView)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local FFlagFlyoutNavigationInMarketplace = SharedFlags.FFlagFlyoutNavigationInMarketplace
local FFlagAXOpaqueMarketplaceTopbar = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXOpaqueMarketplaceTopbar
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local v24 = if not FFlagFlyoutNavigationInMarketplace or not FFlagEnableFlyoutSidePanel then nil else require(Modules.AvatarExperience.Common.Components.TopBar.MeTabFlyoutLeftItem)

local function selectLocalUserId(p1) -- line: 48
	return (tostring(p1.LocalUserId))
end
local function useProfileTabPageViewModel(t1: {[any]: any}) -- line: 58
	-- upvalues: useNavigation (copy), useAvatarRoute (copy), Screens (copy), AvatarScreen (copy), useSelector (copy), selectLocalUserId (copy), selectIsPortrait (copy), React (copy), AppPage (copy), useAvatarHardwareBackButton (copy), FFlagFlyoutNavigationInMarketplace (copy), FFlagEnableFlyoutSidePanel (copy), v24 (copy), makeAvatarBackButton (copy), ProfileTypes (copy), Enums (copy), ProfileTabVariants (copy), FFlagAXOpaqueMarketplaceTopbar (copy), FFlagEnableLeftNavOnConsole (copy)
	local v29 = useNavigation()
	local v30 = useAvatarRoute()
	local v31 = t1.navigation and t1.navigation.state
	local v32 = v31 and (v31.routes and v31.routes[v31.index])
	local v33 = v32 and v32.routeName
	local v34 = v33 == nil or v33 == Screens.ProfileMain
	local v35 = (v30 and (v30.current and v30.current.name)) == AvatarScreen.ItemDetails
	local v36 = useSelector(selectLocalUserId)
	local v37 = useSelector(selectIsPortrait)
	local v38 = v37 and (v34 and not v35)
	local v39 = React.useCallback(function() -- line: 90
		-- upvalues: v29 (copy), AppPage (copy)
		v29.navigate(AppPage.Home)
	end, { v29 })

	useAvatarHardwareBackButton({
		navigation = v29,
		avatarRoute = v30,
		onBack = v39
	})

	local v40 = React.useMemo(function() -- line: 104
		-- upvalues: FFlagFlyoutNavigationInMarketplace (copy), FFlagEnableFlyoutSidePanel (copy), v24 (copy), makeAvatarBackButton (copy), v39 (copy)
		if FFlagFlyoutNavigationInMarketplace and FFlagEnableFlyoutSidePanel then
			return v24
		end

		return makeAvatarBackButton(v39)
	end, { v39 })
	local v41 = React.useMemo(function() -- line: 114
		-- upvalues: v36 (copy), ProfileTypes (copy), Enums (copy), v37 (copy), ProfileTabVariants (copy)
		return {
			source = "AvatarProfileTab",
			contextualInfoType = "",
			mountAsFullView = true,
			forceFullView = true,
			itemDetailsFullView = true,
			profileId = v36,
			profileType = ProfileTypes.User,
			friendshipOriginSourceType = Enums.FriendshipOriginSourceType.UserProfile.rawValue(),
			headerVariant = if not v37 then ProfileTabVariants.MeTab else ProfileTabVariants.Default,
			currentlyWearingVariant = ProfileTabVariants.MeTab
		}
	end, {
		v36,
		v37
	})
	local v42 = table.clone(t1)

	v42.embedded = true
	v42.embedNavigationProps = v41

	local v43 = (FFlagAXOpaqueMarketplaceTopbar or FFlagEnableLeftNavOnConsole) and not v37

	return {
		isPortrait = v37,
		isAtProfileRoot = v34,
		isOverlayTopBarVisible = v38,
		leftItem = v40,
		topBarTransparent = not v43,
		wrapperProps = v42
	}
end

return useProfileTabPageViewModel
