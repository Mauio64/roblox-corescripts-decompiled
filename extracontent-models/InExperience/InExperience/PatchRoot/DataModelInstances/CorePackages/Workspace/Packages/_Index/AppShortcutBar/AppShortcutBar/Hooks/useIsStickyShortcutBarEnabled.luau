local UserInputService = game:GetService("UserInputService")

local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Responsive = require(parent.Responsive)
local RoactUtils = require(parent.RoactUtils)
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RobloxAppEnums = require(parent.RobloxAppEnums)
local LoginStatus = RobloxAppEnums.LoginStatus
local AppPage = RobloxAppEnums.AppPage

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useIsTvRemoteDevice = RoactUtils.Hooks.useIsTvRemoteDevice
local useIsRealGamepadConnected = RoactUtils.Hooks.useIsRealGamepadConnected

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput
local Flags = require(AppShortcutBar.Flags)
local FFlagStickyShortcutBarTvRemoteWithGamepad = Flags.FFlagStickyShortcutBarTvRemoteWithGamepad
local FFlagUnifyShortcutBarQA = SharedFlags.FFlagUnifyShortcutBarQA
local getAuthenticationStatusStore

if FFlagUseSignalsForAuthenticationStatus then
	local AuthenticationStatus = require(parent.AuthenticationStatus)
	getAuthenticationStatusStore = AuthenticationStatus.GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local function selectUserLoggedIn(p)
	return p.AuthenticationStatus and p.AuthenticationStatus.status == LoginStatus.LOGGED_IN
end

local function useIsStickyShortcutBarEnabled(p: string?)
	local v = ReactFocusNavigation.useFocusedGuiObject() ~= nil
	local v2 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v3 = Responsive.useOrientation() == Responsive.Keys.Portrait

	if FFlagUnifyShortcutBarQA then
		local v4 = useProperty(UserInputService, "TouchEnabled")
		v3 = v3 and v4
	end

	local v4

	if FFlagStickyShortcutBarTvRemoteWithGamepad then
		v4 = useIsTvRemoteDevice()
	elseif FFlagLuaSupportMicroGamepadPreferredInput then
		v4 = useProperty(UserInputService, "PreferredInput") == Enum.PreferredInput.MicroGamepad
	else
		v4 = useIsTvRemoteDevice()
	end

	local v5

	if FFlagStickyShortcutBarTvRemoteWithGamepad then
		v5 = useIsRealGamepadConnected()
	else
		v5 = false
	end

	local v6

	if FFlagUseSignalsForAuthenticationStatus then
		v6 = useSignalState(getAuthenticationStatusStore(false).getStatus) == LoginStatus.LOGGED_IN
	else
		v6 = useSelector(selectUserLoggedIn)
	end

	if v or v2 then
		if v6 then
			if p == AppPage.AdjustScreen then
				return false
			end

			return not v3 and (not v4 or v5)
		end
	else
		return v2
	end

	return v6
end

return useIsStickyShortcutBarEnabled
