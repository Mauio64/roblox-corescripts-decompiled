local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local UIBlox = require(CorePackages.Packages.UIBlox)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useFocusRegistryEntry
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local Utils = require(Modules.AvatarExperience.Common.Utils)
local useSceneInteractionCallbacks = require(Modules.AvatarExperience.Common.Context.useSceneInteractionCallbacks)
local v30 = game:DefineFastFlag("AXAdjustmentFullscreenFix", false)
local v31 = game:DefineFastFlag("AXDisableGamepadPanning", false)
local v32 = game:DefineFastFlag("AXRemoveExtraButtonText", false)
local v33 = game:DefineFastFlag("AXSceneGamepadHandlerOnlySelectDescendantOfGame", false)

local function useSceneGamepadHandlerFocusNavigationBindings(t1: {[any]: any}, p1) -- line: 51
	-- upvalues: React (copy), RunService (copy), UserInputService (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy)
	React.useEffect(function() -- line: 52
		-- upvalues: RunService (copy), t1 (copy), UserInputService (copy)
		local u59 = nil
		local connection = RunService.Heartbeat:Connect(function(dt) -- line: 54
			-- upvalues: u59 (ref), t1 (copy)
			if u59 then
				if u59.KeyCode == Enum.KeyCode.Thumbstick1 and t1.onPanAvatar then
					t1.onPanAvatar(u59, dt)

					return
				end

				if u59.KeyCode == Enum.KeyCode.Thumbstick2 then
					t1.onRotateAndZoomAvatar(u59, dt)
				end
			end
		end)
		local connection2 = UserInputService.InputChanged:Connect(function(input, _) -- line: 63
			-- upvalues: u59 (ref)
			if input.KeyCode == Enum.KeyCode.Thumbstick1 or input.KeyCode == Enum.KeyCode.Thumbstick2 then
				if input.UserInputState == Enum.UserInputState.Change then
					u59 = input

					return
				end

				if input.UserInputState == Enum.UserInputState.End then
					u59 = nil
				end
			end
		end)

		return function() -- line: 73
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		t1.onPanAvatar,
		t1.onRotateAndZoomAvatar
	})

	local v38 = React.useMemo(function() -- line: 79
		-- upvalues: FocusNavigationEventNameEnum (copy), t1 (copy)
		return {
			[Enum.KeyCode.Thumbstick2] = FocusNavigationEventNameEnum.RotateAndZoomAvatar,
			[Enum.KeyCode.Thumbstick1] = FocusNavigationEventNameEnum.PanAvatar,
			[Enum.KeyCode.ButtonR3] = if not t1.onEnterAvatarFullView then if not t1.onExitAvatarFullView then nil else FocusNavigationEventNameEnum.ExitAvatarFullView else FocusNavigationEventNameEnum.EnterAvatarFullView,
			[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
		}
	end, {
		t1.onEnterAvatarFullView,
		t1.onExitAvatarFullView
	})
	local v39 = React.useMemo(function() -- line: 93
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), t1 (copy)
		return {
			[FocusNavigationEventNameEnum.RotateAndZoomAvatar] = {
				handler = InputHandlers.onRelease(function() -- line: 96
				end)
			},
			[FocusNavigationEventNameEnum.PanAvatar] = if not t1.onPanAvatar then nil else {
				handler = InputHandlers.onRelease(function() -- line: 103
				end)
			},
			[FocusNavigationEventNameEnum.EnterAvatarFullView] = if not t1.onEnterAvatarFullView then nil else {
				handler = InputHandlers.onRelease(t1.onEnterAvatarFullView)
			},
			[FocusNavigationEventNameEnum.ExitAvatarFullView] = if not t1.onExitAvatarFullView then nil else {
				handler = InputHandlers.onRelease(t1.onExitAvatarFullView)
			},
			[FocusNavigationEventNameEnum.NavigateBack] = if not t1.onGoBack then nil else {
				handler = InputHandlers.onRelease(t1.onGoBack)
			}
		}
	end, {
		t1.onRotateAndZoomAvatar,
		t1.onPanAvatar,
		t1.onEnterAvatarFullView,
		t1.onExitAvatarFullView,
		t1.onGoBack
	})
	local v40 = ReactFocusNavigation.useEventMap(v38, p1)

	return ReactFocusNavigation.useEventHandlerMap(v39, v40)
end
local function SceneGamepadHandler(p3) -- line: 143
	-- upvalues: useAvatarRoute (copy), useRoactService (copy), Analytics (copy), React (copy), useSelectionCursor (copy), CursorKind (copy), useSceneInteractionCallbacks (copy), Utils (copy), useSelector (copy), useDispatch (copy), GamepadUtils (copy), AvatarScreen (copy), useFocusGuiObject (copy), v33 (copy), useFocusRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), GuiService (copy), FullView (copy), SetFullView (copy), useSceneGamepadHandlerFocusNavigationBindings (copy), v30 (copy), v31 (copy), Cryo (copy), v32 (copy)
	local v42 = useAvatarRoute()
	local name = v42.opaque.name
	local v44 = useRoactService(Analytics)
	local v45 = React.useRef(nil)
	local v46 = useSelectionCursor(CursorKind.Invisible)
	local v47 = useSceneInteractionCallbacks()
	local v48 = React.useCallback(function(p4) -- line: 150
		-- upvalues: Utils (copy), v42 (copy)
		return Utils.getIsSceneFullViewFromState(p4, v42)
	end, { v42 })
	local v49 = useSelector(v48)
	local v50 = useDispatch()
	local v51 = React.useCallback(function(p5, p6) -- line: 157
		-- upvalues: GamepadUtils (copy), v47 (copy)
		GamepadUtils.rotateAndZoom(p5, p6, v47.setAngularVelocityByPixels, v47.rotateByRadians, v47.zoomStraight)
	end, {
		v47.setAngularVelocityByPixels,
		v47.rotateByRadians,
		v47.zoomStraight
	})
	local v52 = React.useCallback(function(p7, n1: number) -- line: 173
		-- upvalues: GamepadUtils (copy), v47 (copy)
		local v67 = GamepadUtils.normalizeStickByDeadzone(Vector2.new(p7.Position.X, p7.Position.Y))

		if v67 == Vector2.new(0, 0) then
			return
		end

		if v47.panByDistance then
			local v68 = n1 * v67 * 5

			v47.panByDistance(v68)
		end
	end, { v47.panByDistance })
	local v53 = name == AvatarScreen.AvatarEditor or (name == AvatarScreen.MySharedAvatars or (name == AvatarScreen.Catalog or (name == AvatarScreen.CatalogSearch or name == AvatarScreen.ProfilePictureEditorEmotes)))
	local v54 = React.useRef(nil)
	local v55 = useFocusGuiObject()
	local v56 = if not v33 then nil else useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SubRouterView)
	local v57 = React.useCallback(function() -- line: 198
		-- upvalues: v49 (copy), v55 (copy), v54 (copy), v33 (copy), v56 (copy), GuiService (copy), v45 (copy), FullView (copy), v50 (copy), SetFullView (copy), v44 (copy), name (copy)
		if v49 then
			if v55 and v54.current and (not v33 or v54.current:IsDescendantOf(game)) then
				v55(v54.current)
			elseif v33 and v56 then
				v56()
			end

			v54.current = nil
		else
			v54.current = GuiService.SelectedCoreObject

			if v55 and v45.current then
				v55(v45.current)
			end
		end

		local v69 = if not v49 then FullView.SceneFullView else FullView.None

		v50(SetFullView(v44, name, v69))
	end, {
		v49,
		v50,
		name,
		v44,
		v55,
		if not v33 then nil else v56
	})
	local v58 = useSceneGamepadHandlerFocusNavigationBindings({
		onGoBack = if not v49 then nil else v57,
		onEnterAvatarFullView = if v49 or not v53 then nil else v57,
		onExitAvatarFullView = if not v30 then if not v49 then nil else v57 else if not v49 or not v53 then nil else v57,
		onPanAvatar = if not v31 then if not v49 then nil else v52 else nil,
		onRotateAndZoomAvatar = v51
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ref = v58
	}, Cryo.Dictionary.join(p3.children, {
		FocusIsolate = React.createElement("TextButton", {
			BackgroundTransparency = 1,
			SelectionGroup = true,
			Text = if not v32 then nil else "",
			SelectionImageObject = v46,
			ref = v45,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		})
	}))
end

return SceneGamepadHandler
