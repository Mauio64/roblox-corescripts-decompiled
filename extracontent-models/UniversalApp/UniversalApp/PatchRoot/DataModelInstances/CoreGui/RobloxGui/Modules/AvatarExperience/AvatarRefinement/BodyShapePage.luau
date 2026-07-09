local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useTopBarHeight = require(CorePackages.Workspace.Packages.RobloxAppHooks).useTopBarHeight
local useTokens = Foundation.Hooks.useTokens
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local debounce = require(Modules.LuaApp.Util.debounce)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local RefinementControlBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementControlBar)
local ScalesPage = require(Modules.AvatarExperience.AvatarEditor.Components.ScalesPage)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v24 = Constants.PeekHeaderHeight + Constants.MainNavHeight + Constants.SubNavHeight

local function BodyShapePage() -- line: 45
	-- upvalues: useTokens (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), React (copy), useSelector (copy), selectIsPortrait (copy), useTopBarHeight (copy), useNavigation (copy), useLocalization (copy), debounce (copy), Focusable (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ScalesPage (copy), Foundation (copy), v24 (copy), GamepadFocusHandlerForPage (copy), TopBar (copy), RefinementControlBar (copy), SceneInteractionFrame (copy)
	local v26 = useTokens()
	local v27 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v28, v29 = React.useState(true)
	local v30 = useSelector(selectIsPortrait)
	local v31 = useTopBarHeight()
	local v32 = useNavigation()
	local v33 = useLocalization({
		title = "Feature.Avatar.Label.Title.BodyShape"
	})
	local v34 = React.useRef(nil)
	local v35 = React.useRef(nil)
	local v36 = React.useCallback(function() -- line: 60
		-- upvalues: v29 (copy)
		v29(true)
	end, {})
	local v37 = React.useCallback(function() -- line: 64
		-- upvalues: v29 (copy)
		v29(false)
	end, {})
	local v38 = React.useCallback(debounce(function() -- line: 69
		-- upvalues: v29 (copy)
		v29(true)
	end, 1), {})
	local v39 = React.useCallback(function() -- line: 75
		-- upvalues: v29 (copy), v38 (copy)
		v29(false)
		v38()
	end, { v38 })

	local function onBackButtonPressed() -- line: 81
		-- upvalues: v32 (copy)
		v32.pop()
	end
	local function renderLandscapeBodyShapePanel() -- line: 85
		-- upvalues: React (copy), Focusable (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v26 (copy), v31 (copy), ScalesPage (copy), v37 (copy), v36 (copy), v39 (copy), v34 (copy)
		return React.createElement(Focusable.Frame, {
			ZIndex = 2,
			BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v26.Semantic.Color.Background.Default else v26.Color.Surface.Surface_0)).Color3,
			Position = UDim2.fromOffset(v26.Size.Size_2400, v31 + v26.Size.Size_500),
			Size = UDim2.new(0.5, -v26.Size.Size_2400, 0.8, 0)
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v26.Size.Size_200)
			}),
			ScalesPage = React.createElement(ScalesPage, {
				enableNavigation = true,
				lockNavigationCallback = v37,
				unlockNavigationCallback = v36,
				onCanvasPositionChanged = v39,
				NextSelectionUp = v34
			})
		})
	end
	local function renderPortraitBodyShapePanel() -- line: 107
		-- upvalues: React (copy), Foundation (copy), v28 (copy), ScalesPage (copy), v37 (copy), v36 (copy), v24 (copy)
		return React.createElement(Foundation.View, {
			tag = "size-full-full",
			ZIndex = 2
		}, {
			ScalesPageContainer = React.createElement(Foundation.ScrollView, {
				tag = "bg-surface-0 anchor-bottom-left position-bottom-left auto-xy",
				scroll = {
					ScrollingDirection = Enum.ScrollingDirection.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.Y
				},
				Size = UDim2.new(1, 0, 0.4, 0),
				isDisabled = not v28
			}, {
				ScalesPage = React.createElement(ScalesPage, {
					lockNavigationCallback = v37,
					unlockNavigationCallback = v36,
					enableNavigation = v28
				})
			}),
			BodyShapePageBottomFiller = React.createElement(Foundation.View, {
				tag = "bg-surface-0 position-bottom-left",
				Size = UDim2.new(1, 0, 0, v24)
			})
		})
	end

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		inputBindings = nil,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v27 else nil,
		defaultChild = v34
	}, {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = v27
		}) else nil,
		BodyShapePageTopBar = React.createElement(TopBar.Container, {
			transparentBackground = true,
			ZIndex = 3,
			titleText = v33.title,
			leftItem = TopBar.makeBackButton(onBackButtonPressed),
			ref = v34,
			NextSelectionDown = v35
		}),
		RefinementControlBar = React.createElement(RefinementControlBar),
		BodyShapePageSceneInteractionFrame = if not v28 then nil else React.createElement(SceneInteractionFrame),
		BodyShapePageControlPanel = if not v30 then renderLandscapeBodyShapePanel() else renderPortraitBodyShapePanel()
	})
end

return (withStackVisibilityWrapper(BodyShapePage))
