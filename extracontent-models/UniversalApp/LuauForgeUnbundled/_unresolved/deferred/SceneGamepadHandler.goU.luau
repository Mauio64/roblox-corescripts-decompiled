local CorePackages = game:GetService("CorePackages")

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local gamepadUtils = require("@luauforge/bundled/fuE").Gamepad.GamepadUtils
local UIBlox = require(CorePackages.Packages.UIBlox)
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local module = require("@luauforge/bundled/eeo")
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local useFocusRegistryEntry = module.FocusNavigableSurfaceRegistry.useFocusRegistryEntry
local focusNavigableSurfaceIdentifierEnum = module.FocusNavigableSurfaceIdentifierEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module3 = require("@luauforge/bundled/gnZ")
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView
local module4 = require("@luauforge/bundled/fuD")
local module5 = require("@luauforge/bundled/goV")

local defineFastFlag = game:DefineFastFlag("AXAdjustmentFullscreenFix", false)
local defineFastFlag2 = game:DefineFastFlag("AXDisableGamepadPanning", false)
local defineFastFlag3 = game:DefineFastFlag("AXRemoveExtraButtonText", false)

local defineFastFlag4 = game:DefineFastFlag("AXSceneGamepadHandlerOnlySelectDescendantOfGame", false)

local function useSceneGamepadHandlerFocusNavigationBindings(data, p2)
	React.useEffect(function()
		local v5 = nil
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if v5 then
				if v5.KeyCode == Enum.KeyCode.Thumbstick1 and data.onPanAvatar then
					data.onPanAvatar(v5, dt)
				elseif v5.KeyCode == Enum.KeyCode.Thumbstick2 then
					data.onRotateAndZoomAvatar(v5, dt)
				end
			end
		end)
		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.Thumbstick1 or input.KeyCode == Enum.KeyCode.Thumbstick2 then
				if input.UserInputState == Enum.UserInputState.Change then
					v5 = input
				elseif input.UserInputState == Enum.UserInputState.End then
					v5 = nil
				end
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
			inputChangedConnection:Disconnect()
		end
	end, { data.onPanAvatar, data.onRotateAndZoomAvatar })

	local v5 = React.useMemo(function()
		local v6 = {
			[Enum.KeyCode.Thumbstick2] = focusNavigationEventNameEnum.RotateAndZoomAvatar,
			[Enum.KeyCode.Thumbstick1] = focusNavigationEventNameEnum.PanAvatar
		}
		local buttonR3 = Enum.KeyCode.ButtonR3
		local v7

		if data.onEnterAvatarFullView then
			v7 = focusNavigationEventNameEnum.EnterAvatarFullView
		elseif data.onExitAvatarFullView then
			v7 = focusNavigationEventNameEnum.ExitAvatarFullView
		end

		v6[buttonR3] = v7

		v6[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack
		v6[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
		return v6
	end, { data.onEnterAvatarFullView, data.onExitAvatarFullView })

	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.RotateAndZoomAvatar] = {
				handler = InputHandlers.onRelease(function() end)
			},
			[focusNavigationEventNameEnum.PanAvatar] = data.onPanAvatar and {
				handler = InputHandlers.onRelease(function() end)
			} or nil,
			[focusNavigationEventNameEnum.EnterAvatarFullView] = data.onEnterAvatarFullView and {
				handler = InputHandlers.onRelease(data.onEnterAvatarFullView)
			} or nil,
			[focusNavigationEventNameEnum.ExitAvatarFullView] = data.onExitAvatarFullView and {
				handler = InputHandlers.onRelease(data.onExitAvatarFullView)
			} or nil,
			[focusNavigationEventNameEnum.NavigateBack] = data.onGoBack and {
				handler = InputHandlers.onRelease(data.onGoBack)
			} or nil
		}
	end, {
		data.onRotateAndZoomAvatar,
		data.onPanAvatar,
		data.onEnterAvatarFullView,
		data.onExitAvatarFullView,
		data.onGoBack
	})

	local v7 = ReactFocusNavigation.useEventMap(v5, p2)
	return ReactFocusNavigation.useEventHandlerMap(v6, v7)
end

local function SceneGamepadHandler(p2)
	local v5 = useAvatarRoute()
	local name = v5.opaque.name
	local v6 = useRoactService(avatarExperienceAnalyticsService)
	local ref = React.useRef(nil)
	local v7 = useSelectionCursor(cursorKind.Invisible)
	local v8 = module5()
	local v9 = useSelector((React.useCallback(function(p3)
		return module4.getIsSceneFullViewFromState(p3, v5)
	end, { v5 })))
	local v10 = useDispatch()

	local v11 = React.useCallback(function(p3, p4)
		gamepadUtils.rotateAndZoom(
			p3,
			p4,
			v8.setAngularVelocityByPixels,
			v8.rotateByRadians,
			v8.zoomStraight
		)
	end, { v8.setAngularVelocityByPixels, v8.rotateByRadians, v8.zoomStraight })

	local v12 = React.useCallback(function(p3, p4)
		local stickByDeadzone = gamepadUtils.normalizeStickByDeadzone(Vector2.new(p3.Position.X, p3.Position.Y))

		if stickByDeadzone == Vector2.new(0, 0) then
			return
		end

		if v8.panByDistance then
			local v13 = p4 * stickByDeadzone * 5
			v8.panByDistance(v13)
		end
	end, { v8.panByDistance })

	local v13 = name == avatarScreen.AvatarEditor
		or name == avatarScreen.MySharedAvatars
		or name == avatarScreen.Catalog
		or name == avatarScreen.CatalogSearch
		or name == avatarScreen.ProfilePictureEditorEmotes

	local ref2 = React.useRef(nil)
	local v14 = useFocusGuiObject()
	local v15

	if defineFastFlag4 then
		v15 = useFocusRegistryEntry(focusNavigableSurfaceIdentifierEnum.SubRouterView)
	else
		v15 = nil
	end

	local function fn()
		if v9 then
			if v14 and ref2.current and (not defineFastFlag4 or ref2.current:IsDescendantOf(game)) then
				v14(ref2.current)
			elseif defineFastFlag4 and v15 then
				v15()
			end

			ref2.current = nil
		else
			ref2.current = GuiService.SelectedCoreObject

			if v14 and ref.current then
				v14(ref.current)
			end
		end

		local v16 = if v9 then fullView.None else fullView.SceneFullView
		v10(module3(v6, name, v16))
	end

	local v18 = React.useCallback(fn, {
		v9,
		v10,
		name,
		v6,
		v14,
		if defineFastFlag4 then v15 else nil
	})

	local v20 = {
		onGoBack = if v9 then v18 else nil,
		onEnterAvatarFullView = nil,
		onExitAvatarFullView = nil,
		onPanAvatar = nil,
		onRotateAndZoomAvatar = nil
	}
	local v22 = if not (v9 or not v13) then v18 else nil
	v20.onEnterAvatarFullView = v22

	if defineFastFlag then
		if not (v9 and v13) then
			v18 = nil
		end
	elseif not v9 then
		v18 = nil
	end

	v20.onExitAvatarFullView = v18

	if defineFastFlag2 then
		v12 = nil
	elseif not v9 then
		v12 = nil
	end

	v20.onPanAvatar = v12
	v20.onRotateAndZoomAvatar = v11
	local v23 = useSceneGamepadHandlerFocusNavigationBindings(v20)

	return React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ref = v23 },
		Cryo.Dictionary.join(p2.children, {
			FocusIsolate = React.createElement("TextButton", {
				Text = defineFastFlag3 and "" or nil,
				BackgroundTransparency = 1,
				SelectionImageObject = v7,
				ref = ref,
				SelectionGroup = true,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			})
		})
	)
end

return SceneGamepadHandler
