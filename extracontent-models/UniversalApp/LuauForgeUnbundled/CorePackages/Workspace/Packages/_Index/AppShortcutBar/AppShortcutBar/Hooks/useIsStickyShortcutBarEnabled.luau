local UserInputService = game:GetService("UserInputService")

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/ReactFocusNavigation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Responsive")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/RoactUtils")
local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/GuiObjectUtils").useProperty
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SignalsReact").useSignalState
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/RobloxAppEnums")
local loginStatus = RobloxAppEnums.LoginStatus
local appPage = RobloxAppEnums.AppPage

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useIsTvRemoteDevice = RoactUtils.Hooks.useIsTvRemoteDevice
local useIsRealGamepadConnected = RoactUtils.Hooks.useIsRealGamepadConnected

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local fFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput
local fFlagStickyShortcutBarTvRemoteWithGamepad = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FFlagStickyShortcutBarTvRemoteWithGamepad
local fFlagUnifyShortcutBarQA = SharedFlags.FFlagUnifyShortcutBarQA
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/AuthenticationStatus").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local function selectUserLoggedIn(p2)
	return p2.AuthenticationStatus and p2.AuthenticationStatus.status == loginStatus.LOGGED_IN
end

local function useIsStickyShortcutBarEnabled(p2)
	local v5 = ReactFocusNavigation.useFocusedGuiObject() ~= nil
	local v6 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v7 = Responsive.useOrientation() == Responsive.Keys.Portrait

	if fFlagUnifyShortcutBarQA then
		local v8 = useProperty(UserInputService, "TouchEnabled")
		v7 = v7 and v8
	end

	local v8

	if fFlagStickyShortcutBarTvRemoteWithGamepad then
		v8 = useIsTvRemoteDevice()
	elseif fFlagLuaSupportMicroGamepadPreferredInput then
		v8 = useProperty(UserInputService, "PreferredInput") == Enum.PreferredInput.MicroGamepad
	else
		v8 = useIsTvRemoteDevice()
	end

	local v9 = if fFlagStickyShortcutBarTvRemoteWithGamepad then useIsRealGamepadConnected() else false
	local v10

	if fFlagUseSignalsForAuthenticationStatus then
		v10 = useSignalState(getAuthenticationStatusStore(false).getStatus) == loginStatus.LOGGED_IN
	else
		v10 = useSelector(selectUserLoggedIn)
	end

	if v5 or v6 then
		if v10 then
			v10 = not (p2 == appPage.AdjustScreen) and (not v7 and (not v8 or v9))
		end
	else
		v10 = v6
	end

	return v10
end

return useIsStickyShortcutBarEnabled
