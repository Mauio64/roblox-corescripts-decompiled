local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useTokens = Foundation.Hooks.useTokens
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useHeadRefinementPageProps = require(script.Parent.Hooks.useHeadRefinementPageProps)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local getMappedStyleTokens = AvatarExperienceHeadRefinement.Utils.getMappedStyleTokens
local getHeadShapeListHeight = AvatarExperienceHeadRefinement.Utils.getHeadShapeListHeight
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local getFoundationMappedStyleTokens = AvatarExperienceHeadRefinement.Utils.getFoundationMappedStyleTokens
local HeadShapePicker = AvatarExperienceHeadRefinement.Features.HeadShapePicker
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local RefinementNavBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementNavBar)
local RefinementControlBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementControlBar)
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXEnableResponsiveHeadRefinementMenu = AvatarExperienceFlags.FFlagAXEnableResponsiveHeadRefinementMenu

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local v37 = game:DefineFastFlag("AXHeadRefinementResizeFix", false)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

local function selectGlobalGuiInset(p1) -- line: 65
	return p1.GlobalGuiInset
end
local function selectScreenSize(p2) -- line: 69
	return p2.ScreenSize
end
local function HeadRefinementPage(t1: {[any]: any}) -- line: 78
	-- upvalues: useDesignTokens (copy), FFlagAXEnableResponsiveHeadRefinementMenu (copy), useTokens (copy), getFoundationMappedStyleTokens (copy), getMappedStyleTokens (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), useLocalization (copy), useSelector (copy), selectIsPortrait (copy), selectGlobalGuiInset (copy), v37 (copy), DeviceOrientationMode (copy), useDeviceOrientation (copy), useTopBarHeight (copy), React (copy), useHeadRefinementPageProps (copy), selectScreenSize (copy), getHeadShapeListHeight (copy), GetFFlagAXEnableSlotBasedEditor (copy), AvatarScreen (copy), Focusable (copy), GamepadFocusHandlerForPage (copy), TopBar (copy), RefinementControlBar (copy), RefinementNavBar (copy), SceneInteractionFrame (copy), FFlagRenameDeprecatedUIBloxTokens (copy), HeadShapePicker (copy), FFlagHeadRefinementFacialAnimationToggle (copy)
	local v45 = useDesignTokens()
	local v46 = if not FFlagAXEnableResponsiveHeadRefinementMenu then nil else useTokens()
	local v47 = if not FFlagAXEnableResponsiveHeadRefinementMenu then getMappedStyleTokens(v45) else getFoundationMappedStyleTokens(v46)
	local v48 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v49 = useLocalization({
		topBarTitle = "Feature.Avatar.Label.HeadRefinement.Adjust.Title"
	})
	local v50 = useSelector(selectIsPortrait)
	local v51 = useSelector(selectGlobalGuiInset)
	local v52 = if not v37 then useDeviceOrientation() or DeviceOrientationMode.Portrait else if not v50 then DeviceOrientationMode.Landscape else DeviceOrientationMode.Portrait
	local v53 = useTopBarHeight()
	local v54 = v47.largeTileContainerSize * 4 + v47.tileListPaddingBetweenItems * 3 + v47.tileListPaddingLeft + v47.tileListPaddingRight
	local v55 = React.useRef(nil)
	local v56 = React.useRef(nil)
	local v57, v58, v59, v60, v61 = useHeadRefinementPageProps()
	local v62 = nil

	if FFlagAXEnableResponsiveHeadRefinementMenu then
		local v63 = useSelector(selectScreenSize)

		v62 = getHeadShapeListHeight({
			tokens = v46,
			itemCount = not v57 and 0 or #v57,
			availableViewportHeight = v63.Y - v53 - v51.bottom
		})
	end

	local function onBackButtonPressed() -- line: 119
		-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), t1 (copy), AvatarScreen (copy)
		if GetFFlagAXEnableSlotBasedEditor() then
			t1.navigation.pop()

			return
		end

		t1.navigation.navigate(AvatarScreen.AvatarRefinement)
	end

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v48 else nil,
		defaultChild = v55
	}, {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = v48
		}) else nil,
		HeadRefinementPageTopBar = React.createElement(TopBar.Container, {
			transparentBackground = true,
			ZIndex = 3,
			titleText = v49.topBarTitle,
			leftItem = TopBar.makeBackButton(onBackButtonPressed),
			ref = v55,
			NextSelectionDown = v56
		}),
		RefinementNavBar = if not v50 then nil else React.createElement(if not GetFFlagAXEnableSlotBasedEditor() then RefinementNavBar else RefinementControlBar, {}),
		HeadRefinementPageContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -v53 + v51.bottom),
			Position = UDim2.fromOffset(0, v53)
		}, {
			HeadShapePickerUIListLayout = if v37 or not v50 then nil else React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			HeadRefinementPageSceneInteractionFrame = React.createElement(SceneInteractionFrame),
			HeadRefinementPageControlPanel = React.createElement(Focusable.Frame, {
				BackgroundTransparency = 1,
				ZIndex = 3,
				AnchorPoint = if not v50 then Vector2.new(0, 0.5) else Vector2.new(0, 1),
				Position = if not v50 then UDim2.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v45.Global.Size_450 else v45.Size.Size_900, 0.5, 0) else UDim2.new(0, 0, 1, 0),
				Size = if not v50 then UDim2.new(0, v54, 0, 0) else UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				HeadShapePicker = React.createElement(Focusable[HeadShapePicker], {
					isUnsupported = v58,
					items = v57,
					orientation = v52,
					tileSize = v52 ~= DeviceOrientationMode.Portrait and "large" or "small",
					isLoading = v59,
					containerRef = v56,
					NextSelectionUp = v55,
					isFacialAnimationEnabled = if not FFlagHeadRefinementFacialAnimationToggle then nil else v60,
					onFacialAnimationToggle = if not FFlagHeadRefinementFacialAnimationToggle then nil else v61,
					headShapeListMaxHeight = if not FFlagAXEnableResponsiveHeadRefinementMenu or v52 ~= DeviceOrientationMode.Landscape then nil else v62
				}),
				HeadRefinementPageBottomFiller = if not v50 then nil else React.createElement("Frame", {
					BorderSizePixel = 0,
					Size = if not v37 then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, v51.bottom),
					Position = if not v37 then UDim2.new(0, 0, 0, v51.bottom) else UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v45.Semantic.Color.Background.Default else v45.Color.Surface.Surface_0)).Color3,
					BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v45.Semantic.Color.Background.Default else v45.Color.Surface.Surface_0)).Transparency,
					ZIndex = if not v37 then nil else 0
				})
			})
		})
	})
end

return (withStackVisibilityWrapper((withAppRoute(HeadRefinementPage))))
