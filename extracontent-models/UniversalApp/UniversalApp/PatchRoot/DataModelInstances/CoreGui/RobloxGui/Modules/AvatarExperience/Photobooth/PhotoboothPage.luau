local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local AvatarExperienceControlBar = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar)
local IconOnlyMenu = AvatarExperienceControlBar.IconOnlyMenu
local MenuItemEnum = AvatarExperienceControlBar.Enums.MenuItemEnum
local AdaptiveScrollingView = require(Modules.AvatarExperience.Common.Components.AdaptiveScrollingView)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local useFullView = require(Modules.AvatarExperience.Common.Hooks.useFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local BottomInsetBackground = require(Modules.AvatarExperience.Common.Components.BottomInsetBackground)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local PhotoboothScenesContainer = require(Modules.AvatarExperience.Photobooth.Components.Scenes.PhotoboothScenesContainer)
local PhotoboothAnimationsContainer = require(Modules.AvatarExperience.Photobooth.Components.Animations.PhotoboothAnimationsContainer)
local PhotoboothShareModal = require(Modules.AvatarExperience.Photobooth.Components.PhotoboothShareModal)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPhotoboothBugBashFixes = AvatarExperienceFlags.FFlagAXPhotoboothBugBashFixes
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXPhotoboothShareModal = AvatarExperienceFlags.FFlagAXPhotoboothShareModal
local Focusable = RoactGamepad.Focusable
local v35 = if not FFlagAXPhotoboothBugBashFixes then Constants.PeekHeaderHeight + Constants.MainNavHeight + Constants.SubNavHeight else Constants.PeekHeaderHeight + Constants.MainNavPhotoboothHeight

local function selectGlobalGuiInset(p1) -- line: 63
	return p1.GlobalGuiInset
end
local function selectScreenSize(p2) -- line: 67
	return p2.ScreenSize
end

local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p3, p4: ((...any) -> ...any)) -- line: 96
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v45 = ReactFocusNavigation.useEventMap(t1, p3)
	local v46 = React.useMemo(function() -- line: 98
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p4 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p5) -- line: 101
					-- upvalues: p4 (copy)
					p5.cancelled = true
					p4()
				end)
			}
		}
	end, { p4 })

	return ReactFocusNavigation.useEventHandlerMap(v46, v45)
end
local function PhotoboothPage(t2: {[any]: any}) -- line: 111
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), useLocalization (copy), useFullView (copy), FFlagAXPhotoboothBugBashFixes (copy), FullView (copy), useSelector (copy), selectGlobalGuiInset (copy), selectScreenSize (copy), getSafeAreaSize (copy), Constants (copy), MenuItemEnum (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), AdaptiveScrollingView (copy), v35 (copy), Foundation (copy), PhotoboothAnimationsContainer (copy), PhotoboothScenesContainer (copy), Focusable (copy), GamepadFocusHandlerForPage (copy), TopBar (copy), SceneInteractionFrame (copy), IconOnlyMenu (copy), BottomInsetBackground (copy), FFlagAXPhotoboothShareModal (copy), PhotoboothShareModal (copy)
	local tokens = t2.tokens
	local v49 = if not FFlagAXMigrateAXToGlobalAutofocus then t2.focusController else nil
	local v50 = React.useRef(nil)
	local v51 = useLocalization({
		Photobooth = "Feature.Avatar.Label.Photobooth"
	})
	local _, v53 = useFullView()
	local v54 = React.useCallback(function() -- line: 124
		-- upvalues: FFlagAXPhotoboothBugBashFixes (copy), t2 (copy), v53 (copy), FullView (copy)
		if FFlagAXPhotoboothBugBashFixes and t2.isPortrait then
			v53(FullView.None)
		end
	end, {
		v53,
		t2.isPortrait
	})
	local v55 = useSelector(selectGlobalGuiInset)
	local v56 = useSelector(selectScreenSize)
	local v57 = React.useMemo(function() -- line: 134
		-- upvalues: v56 (copy), v55 (copy), t2 (copy)
		return v56.Y - v55.bottom - t2.topBarHeight
	end, {
		v56.Y,
		v55.bottom,
		t2.topBarHeight
	})
	local v58 = v57 - React.useMemo(function() -- line: 138
		-- upvalues: getSafeAreaSize (copy), v56 (copy), v55 (copy), Constants (copy)
		return getSafeAreaSize(v56, v55).Y.Offset * Constants.PortraitSceneHeight
	end, {
		v56,
		v55
	})
	local v59, v60 = React.useState(Vector2.new(0, 0))
	local v61 = React.useCallback(function(p6) -- line: 149
		-- upvalues: v60 (copy)
		v60(Vector2.new(p6.AbsoluteSize.X, p6.AbsoluteSize.Y))
	end, {})
	local v62 = React.useCallback(function() -- line: 153
		-- upvalues: t2 (copy)
		t2.onBackButtonPressed()
	end, { t2.onBackButtonPressed })

	React.useEffect(function() -- line: 158
		-- upvalues: FFlagAXPhotoboothBugBashFixes (copy), t2 (copy), v53 (copy), FullView (copy), MenuItemEnum (copy)
		if FFlagAXPhotoboothBugBashFixes and not t2.isPortrait then
			v53(FullView.SceneFullView)

			return
		end

		if t2.activeMenuItemId == "" then
			v53(FullView.SceneFullView)

			return
		end

		if FFlagAXPhotoboothBugBashFixes and ((t2.activeMenuItemId == MenuItemEnum.Photobooth.Animations or t2.activeMenuItemId == MenuItemEnum.Photobooth.Scenes) and t2.isPortrait) then
			v53(FullView.None)
		end
	end, {
		t2.activeMenuItemId,
		t2.isPortrait
	})

	local v63 = useFocusNavigationBindings(nil, v62)
	local v64 = useTableWrappedCallbackRef(v63)
	local v65 = FFlagAXPhotoboothBugBashFixes and (t2.isPortrait and (v55.bottom > 0 and t2.activeMenuItemId ~= ""))
	local v66 = React.useMemo(function() -- line: 181
		-- upvalues: t2 (copy), MenuItemEnum (copy), React (copy), AdaptiveScrollingView (copy), v57 (copy), v58 (copy), v35 (copy), FFlagAXPhotoboothBugBashFixes (copy), Foundation (copy), tokens (copy), PhotoboothAnimationsContainer (copy), v54 (copy), PhotoboothScenesContainer (copy), v59 (copy)
		if t2.isPortrait then
			if t2.activeMenuItemId == MenuItemEnum.Photobooth.Animations then
				return (React.createElement(AdaptiveScrollingView, {
					fullHeight = v57,
					midHeight = v58,
					alwaysShowingHeight = v35,
					topBarHeight = t2.topBarHeight,
					fullHeightOptions = {
						opaqueBackground = true,
						draggerToDivider = not FFlagAXPhotoboothBugBashFixes
					}
				}, {
					AnimationContent = React.createElement(Foundation.View, {
						tag = "padding-x-large col gap-small",
						backgroundStyle = {
							Transparency = 0,
							Color3 = tokens.Color.OverMedia.OverMedia_0.Color3
						},
						Size = UDim2.new(1, 0, 1, 0)
					}, {
						PhotoboothAnimationsContainer = React.createElement(PhotoboothAnimationsContainer, {
							Position = UDim2.fromOffset(0, 0),
							onTileClicked = v54
						})
					})
				}))
			end

			if t2.activeMenuItemId == MenuItemEnum.Photobooth.Scenes then
				return (React.createElement(AdaptiveScrollingView, {
					fullHeight = v57,
					midHeight = v58,
					alwaysShowingHeight = v35,
					topBarHeight = t2.topBarHeight,
					fullHeightOptions = {
						opaqueBackground = true,
						draggerToDivider = not FFlagAXPhotoboothBugBashFixes
					}
				}, {
					ScenesContent = React.createElement(Foundation.View, {
						tag = "padding-x-large col gap-small",
						backgroundStyle = {
							Transparency = 0,
							Color3 = tokens.Color.OverMedia.OverMedia_0.Color3
						},
						Size = UDim2.new(1, 0, 1, 0)
					}, {
						ScenesContainer = React.createElement(PhotoboothScenesContainer, {
							Position = UDim2.fromOffset(0, 0),
							onTileClicked = v54
						})
					})
				}))
			end
		else
			if t2.activeMenuItemId == MenuItemEnum.Photobooth.Animations then
				return (React.createElement(Foundation.View, {
					tag = "padding-y-medium padding-x-large radius-medium col gap-small",
					backgroundStyle = tokens.Color.OverMedia.OverMedia_0,
					Size = UDim2.new(0.4, 0, 0.7, 0),
					Position = UDim2.fromOffset(v59.X + (tokens.Size.Size_500 + tokens.Size.Size_300), t2.topBarHeight)
				}, {
					AnimationContent = React.createElement(PhotoboothAnimationsContainer, {
						Position = UDim2.fromOffset(0, 0),
						onTileClicked = v54
					})
				}))
			end

			if t2.activeMenuItemId == MenuItemEnum.Photobooth.Scenes then
				return (React.createElement(Foundation.View, {
					tag = "padding-y-medium padding-x-large radius-medium col gap-small",
					backgroundStyle = tokens.Color.OverMedia.OverMedia_0,
					Size = UDim2.new(0.4, 0, 0.7, 0),
					Position = UDim2.fromOffset(v59.X + (tokens.Size.Size_500 + tokens.Size.Size_300), t2.topBarHeight)
				}, {
					ScenesContent = React.createElement(PhotoboothScenesContainer, {
						Position = UDim2.fromOffset(0, 0),
						onTileClicked = v54
					})
				}))
			end
		end

		return (React.createElement(Foundation.View, {}))
	end, {
		t2.activeMenuItemId,
		t2.isPortrait,
		v59,
		t2.topBarHeight,
		tokens
	})

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v49 else nil,
		defaultChild = v50,
		ref = v64
	}, {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = v49
		}) else nil,
		PhotoboothTopBar = React.createElement(TopBar.Container, {
			transparentBackground = true,
			ZIndex = 4,
			titleText = v51.Photobooth,
			leftItem = TopBar.makeBackButton(t2.onBackButtonPressed),
			ref = v50
		}),
		SceneInteraction = React.createElement(SceneInteractionFrame),
		PBControlBarContainer = React.createElement(Foundation.View, {
			tag = "auto-xy col gap-small",
			ZIndex = 2,
			Position = UDim2.fromOffset(tokens.Size.Size_500, t2.topBarHeight),
			onAbsoluteSizeChanged = v61
		}, {
			FirstMenu = React.createElement(IconOnlyMenu, {
				direction = "vertical",
				LayoutOrder = 1,
				items = t2.firstMenuItems,
				activeItemId = t2.activeMenuItemId,
				onItemActivated = t2.onMenuItemActivated
			}),
			SecondMenu = React.createElement(IconOnlyMenu, {
				direction = "vertical",
				LayoutOrder = 2,
				items = t2.secondMenuItems,
				activeItemId = t2.activeMenuItemId,
				onItemActivated = t2.onMenuItemActivated
			})
		}),
		FlashOverlay = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 10000,
			Visible = true,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = tokens.Color.OverMedia.OverMedia_0.Color3,
			ref = t2.flashRef
		}),
		ActiveComponent = React.createElement(Foundation.View, {
			tag = "size-full-full",
			ZIndex = 3
		}, {
			Content = v66
		}),
		BottomInsetBackground = if not FFlagAXPhotoboothBugBashFixes or not v65 then nil else React.createElement(BottomInsetBackground, {
			globalGuiInset = v55
		}),
		ShareModal = if not FFlagAXPhotoboothShareModal or (not t2.isShareModalVisible or not t2.onShareModalClose) then nil else React.createElement(PhotoboothShareModal, {
			isVisible = t2.isShareModalVisible or false,
			screenshotPath = t2.screenshotPath,
			onClose = t2.onShareModalClose
		})
	})
end

return PhotoboothPage
