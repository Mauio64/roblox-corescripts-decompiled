local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local useScreenSize = require(CorePackages.Workspace.Packages.RobloxAppHooks).useScreenSize
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v14 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local FetchMySharedAvatars = require(Modules.AvatarExperience.AvatarEditor.Thunks.FetchMySharedAvatars)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local NavOverlayContainer = require(Modules.AvatarExperience.Common.Components.NavOverlayContainer)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection

local function CommunityAvatarEntryMenu(t1: {[any]: any}) -- line: 60
	-- upvalues: useScreenSize (copy), useNavigation (copy), useLocalization (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), React (copy), useAvatarRoute (copy), FFlagSignalsNavP3gAvatarExperience (copy), v14 (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), NavigationUtils (copy), AvatarScreen (copy), FetchMySharedAvatars (copy), Images (copy), Roact (copy), NavOverlayContainer (copy), Focusable (copy), ContextualMenu (copy), MenuDirection (copy)
	local v32 = useScreenSize()
	local v33 = useNavigation()
	local v34 = useLocalization({
		shareAvatar = "Feature.Avatar.Action.ShareAvatar",
		mySharedAvatar = "Feature.Avatar.Action.MySharedAvatars"
	})
	local v35 = useDispatch()
	local v36 = useRoactService(RoactNetworking)
	local _, v38 = React.createBinding(UDim2.fromOffset(0, 0))
	local v39 = useAvatarRoute()
	local u41

	if FFlagSignalsNavP3gAvatarExperience then
		local v40 = v14(false)

		u41 = useSignalState(v40.getHistory)
	else
		u41 = useSelector(function(p1) -- line: 78
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return Selectors.selectLegacyHistory(p1)
			end

			return p1.Navigation.history
		end)
	end

	local v42 = React.useCallback(function() -- line: 86
		-- upvalues: NavigationUtils (copy), v33 (copy), AvatarScreen (copy), v39 (copy), u41 (ref)
		NavigationUtils.closeOverlay(v33)
		NavigationUtils.closeMySharedAvatars(v33)
		NavigationUtils.navigateFromOverlay(v33, AvatarScreen.LookComposerPage, {
			prevNavPage = if not v39 then nil else v39.opaque.name,
			prevNavHistory = u41
		})
	end, { v33 })
	local v43 = React.useCallback(function() -- line: 95
		-- upvalues: v35 (copy), FetchMySharedAvatars (copy), v36 (copy), NavigationUtils (copy), v33 (copy), AvatarScreen (copy)
		v35(FetchMySharedAvatars(v36))
		NavigationUtils.navigateFromOverlay(v33, AvatarScreen.MySharedAvatars)
	end, {
		v35,
		v33,
		v36
	})
	local v44 = React.useMemo(function() -- line: 100
		-- upvalues: v34 (copy), Images (copy), v42 (copy), v43 (copy)
		return {
			{
				iconSize = 36,
				inputBindingKey = "CommonUI.Controls.Action.Confirm",
				text = v34.shareAvatar,
				icon = Images["icons/common/plus"],
				onActivated = v42
			},
			{
				iconSize = 36,
				inputBindingKey = "CommonUI.Controls.Action.Confirm",
				text = v34.mySharedAvatar,
				icon = Images["icons/actions/friend_sort/my_profile"],
				onActivated = v43
			}
		}
	end, {
		v34,
		v42,
		v43
	})
	local v45 = React.useCallback(function(p2) -- line: 119
		-- upvalues: v38 (copy)
		v38(UDim2.fromOffset(-p2.AbsolutePosition.X, -p2.AbsolutePosition.Y))
	end, {})
	local uDim2 = UDim2.fromOffset(t1.entryButtonPosition.X - 300, 0)
	local uDim2_2 = UDim2.new(0, 324, 1, 0)
	local v48 = t1.entryButtonPosition.Y + 25

	return Roact.createElement(NavOverlayContainer, {
		onAbsolutePositionChanged = v45
	}, {
		SizeFrame = Roact.createElement(Focusable.Frame, {
			BackgroundTransparency = 1,
			Position = uDim2,
			Size = uDim2_2,
			ref = t1.defaultChildRef
		}, {
			PositionOffsetFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				ContextMenu = Roact.createElement(ContextualMenu, {
					open = true,
					closeBackgroundVisible = true,
					buttonProps = v44,
					contextMenuWidthOverride = UDim.new(0, 300),
					menuDirection = MenuDirection.Down,
					openPositionY = UDim.new(0, v48),
					screenSize = v32
				})
			})
		})
	})
end

return (withMappedNavigationParams((withOverlayFocusHandling(CommunityAvatarEntryMenu))))
