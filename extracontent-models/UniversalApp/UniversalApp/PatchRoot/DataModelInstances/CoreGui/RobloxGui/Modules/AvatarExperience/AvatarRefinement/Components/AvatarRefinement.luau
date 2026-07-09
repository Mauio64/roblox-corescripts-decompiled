local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Focusable = RoactGamepad.Focusable
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local RefinementNavBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementNavBar)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local UnlockCharacterUpdates = require(Modules.AvatarExperience.LayeredClothingSort.Actions.UnlockCharacterUpdates)
local RefinementControlBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementControlBar)
local SceneGamepadHandler = require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXMigrateSceneGamepadHandlerInputBindings = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSceneGamepadHandlerInputBindings

local function selectIsPortrait(p1) -- line: 49
	-- upvalues: DeviceOrientationMode (copy)
	return p1.DeviceOrientation == DeviceOrientationMode.Portrait
end
local function AvatarRefinement(t1: {[any]: any}) -- line: 54
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), React (copy), useSelector (copy), selectIsPortrait (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), useLocalization (copy), SetFullView (copy), AvatarScreen (copy), FullView (copy), UnlockCharacterUpdates (copy), TopBar (copy), Roact (copy), GetFFlagAXEnableSlotBasedEditor (copy), RefinementControlBar (copy), RefinementNavBar (copy), GamepadFocusHandlerForPage (copy), Focusable (copy), FFlagAXMigrateSceneGamepadHandlerInputBindings (copy), SceneGamepadHandler (copy)
	local v32 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v33 = React.useRef(nil)
	local v34 = React.useRef(nil)
	local v35 = useSelector(selectIsPortrait)
	local v36 = useDispatch()
	local v37 = useRoactService(Analytics)
	local v38 = useLocalization({
		titleText = "Feature.Avatar.Title.AvatarRefinement"
	})

	v36(SetFullView(v37, AvatarScreen.AvatarRefinement, FullView.SceneFullView))
	React.useEffect(function() -- line: 66
		-- upvalues: v36 (copy), UnlockCharacterUpdates (copy)
		return function() -- line: 67
			-- upvalues: v36 (copy), UnlockCharacterUpdates (copy)
			v36(UnlockCharacterUpdates())
		end
	end, {})

	local t2 = {
		TopBar = React.createElement(TopBar.Container, {
			titleText = v38.titleText,
			NextSelectionDown = v33,
			transparentBackground = true,
			hideSiteMessageBanner = v35,
			leftItem = TopBar.makeBackButton(function() -- line: 79
				-- upvalues: v36 (copy), UnlockCharacterUpdates (copy), t1 (copy)
				v36(UnlockCharacterUpdates())
				t1.navigation.pop()
			end),
			[Roact.Ref] = v34
		}),
		RefinementNavBar = React.createElement(if not GetFFlagAXEnableSlotBasedEditor() then RefinementNavBar else RefinementControlBar, {
			ref = v33,
			NextSelectionUp = v34
		}),
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = v32
		}) else nil
	}

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v32 else nil,
		defaultChild = v33
	}, if not FFlagAXMigrateSceneGamepadHandlerInputBindings then t2 else React.createElement(SceneGamepadHandler, nil, t2))
end

return (withStackVisibilityWrapper((withAppRoute(AvatarRefinement))))
