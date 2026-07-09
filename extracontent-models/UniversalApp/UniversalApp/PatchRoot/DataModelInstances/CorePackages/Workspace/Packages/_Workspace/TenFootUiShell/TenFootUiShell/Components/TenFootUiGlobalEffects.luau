local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local React = require(TenFootUiShellParent.React)
local Constants = require(TenFootUiShell.Constants)
local TenFootUiScene = require(TenFootUiShell.Hooks.TenFootUiScene)
local useInitializeCrossPlaySettings = require(TenFootUiShellParent.CrossPlay).Hooks.useInitializeCrossPlaySettings
local SetCentralOverlay = require(TenFootUiShellParent.CentralOverlay).Actions.SetCentralOverlay
local RoactUtils = require(TenFootUiShellParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local usePrevious = RoactUtils.Hooks.usePrevious
local useRoactService = require(TenFootUiShellParent.RobloxAppHooks).useRoactService
local AppPage = require(TenFootUiShellParent.RobloxAppEnums).AppPage
local CentralOverlayType = require(TenFootUiShellParent.RobloxAppEnums).CentralOverlayType
local useHideMouseCursorEffect = require(TenFootUiShell.Hooks.useHideMouseCursorEffect)
local useForceNotificationServiceThemeEffect = require(TenFootUiShell.Hooks.useForceNotificationServiceThemeEffect)
local useGamepadDisconnectOverlayEffect = require(TenFootUiShellParent.InputUi).Gamepad.useGamepadDisconnectOverlayEffect
local Navigation = require(TenFootUiShellParent.Navigation)
local useNavigation = Navigation.useNavigation
local getRouteIsActive = Navigation.getRouteIsActive
local AppEventIngestService = require(TenFootUiShellParent.RoactServiceTags).AppEventIngestService
local FFlagEnableLeftNavOnConsole = require(TenFootUiShellParent.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagDontUseCrossPlayGlobalEffect = require(TenFootUiShellParent.SharedFlags).FFlagDontUseCrossPlayGlobalEffect

local function useAppGamepadDisconnectListener() -- line: 25
	-- upvalues: useDispatch (copy), React (copy), SetCentralOverlay (copy), CentralOverlayType (copy), useRoactService (copy), AppEventIngestService (copy), useGamepadDisconnectOverlayEffect (copy)
	local v31 = useDispatch()
	local v32 = React.useCallback(function() -- line: 28
		-- upvalues: v31 (copy), SetCentralOverlay (copy)
		v31(SetCentralOverlay())
	end, { v31 })
	local v33 = React.useCallback(function() -- line: 32
		-- upvalues: v31 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		v31(SetCentralOverlay(CentralOverlayType.GamepadDisconnected))
	end, { v31 })
	local v34 = useRoactService(AppEventIngestService)

	useGamepadDisconnectOverlayEffect(v33, v32, v34, "InApp")
end
local function getAvatarRouteIsActive(p1) -- line: 40
	-- upvalues: getRouteIsActive (copy), AppPage (copy)
	return getRouteIsActive(p1, AppPage.AvatarExperienceRoot)
end
local function setSceneTransparency(p2, n1: number) -- line: 44
	if p2 then
		for _, child in ipairs(p2:GetChildren()) do
			if child:IsA("BasePart") then
				child.Transparency = n1
			end
		end
	end
end
local function applyAvatarCameraFix(p3, p4) -- line: 58
	-- upvalues: getRouteIsActive (copy), AppPage (copy), Constants (copy)
	local v42 = getRouteIsActive(p3, AppPage.AvatarExperienceRoot)
	local v43 = getRouteIsActive(p4, AppPage.AvatarExperienceRoot)

	if v42 and (not v43 and workspace.CurrentCamera) then
		workspace.CurrentCamera.CFrame = CFrame.new(Constants.CAMERA_POSITION)
	end
end
local function applySceneSwitch(p5) -- line: 66
	-- upvalues: TenFootUiScene (copy), getRouteIsActive (copy), AppPage (copy), setSceneTransparency (copy)
	local v45 = TenFootUiScene.getBackgroundInstance()

	if v45 then
		local v46 = getRouteIsActive(p5, AppPage.AvatarExperienceRoot)
		local v47 = not v46 and 0 or 1

		if v46 then
			task.spawn(function() -- line: 76
				-- upvalues: setSceneTransparency (copy), v45 (copy), v47 (copy)
				if workspace:WaitForChild("AvatarSceneNew") then
					setSceneTransparency(v45, v47)
				end
			end)

			return
		end

		setSceneTransparency(v45, v47)
	end
end
local function useAvatarSceneEffects() -- line: 88
	-- upvalues: useNavigation (copy), usePrevious (copy), React (copy), getRouteIsActive (copy), AppPage (copy), Constants (copy), applySceneSwitch (copy)
	local state = useNavigation().state
	local v49 = usePrevious(state) or state

	React.useEffect(function() -- line: 93
		-- upvalues: v49 (copy), state (copy), getRouteIsActive (copy), AppPage (copy), Constants (copy), applySceneSwitch (copy)
		local v51 = v49
		local v52 = state
		local v53 = getRouteIsActive(v51, AppPage.AvatarExperienceRoot)
		local v54 = getRouteIsActive(v52, AppPage.AvatarExperienceRoot)

		if v53 and (not v54 and workspace.CurrentCamera) then
			workspace.CurrentCamera.CFrame = CFrame.new(Constants.CAMERA_POSITION)
		end

		applySceneSwitch(state)
	end, { state })
end
local function useTenFootUiScene() -- line: 99
	-- upvalues: React (copy), TenFootUiScene (copy)
	React.useLayoutEffect(function() -- line: 100
		-- upvalues: TenFootUiScene (copy)
		TenFootUiScene.initialize()

		return function() -- line: 102
			-- upvalues: TenFootUiScene (copy)
			TenFootUiScene.deinitialize()
		end
	end, {})
end
local function GlobalEffects(p6) -- line: 108
	-- upvalues: FFlagEnableLeftNavOnConsole (copy), useAvatarSceneEffects (copy), useForceNotificationServiceThemeEffect (copy), useHideMouseCursorEffect (copy), FFlagDontUseCrossPlayGlobalEffect (copy), useInitializeCrossPlaySettings (copy), useAppGamepadDisconnectListener (copy), React (copy), TenFootUiScene (copy)
	if not FFlagEnableLeftNavOnConsole then
		useAvatarSceneEffects()
	end

	useForceNotificationServiceThemeEffect()
	useHideMouseCursorEffect()

	if not FFlagDontUseCrossPlayGlobalEffect then
		useInitializeCrossPlaySettings()
	end

	useAppGamepadDisconnectListener()

	if not FFlagEnableLeftNavOnConsole then
		React.useLayoutEffect(function() -- line: 100
			-- upvalues: TenFootUiScene (copy)
			TenFootUiScene.initialize()

			return function() -- line: 102
				-- upvalues: TenFootUiScene (copy)
				TenFootUiScene.deinitialize()
			end
		end, {})
	end

	return React.createElement(React.Fragment, nil, p6.children)
end

return GlobalEffects
