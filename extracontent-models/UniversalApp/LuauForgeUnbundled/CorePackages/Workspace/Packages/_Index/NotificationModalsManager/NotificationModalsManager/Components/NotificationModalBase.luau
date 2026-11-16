local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/ReactRoblox")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/ReactOtter")
local useState = React.useState
local useEffect = React.useEffect
local useMemo = React.useMemo

local localization = require("@game/CorePackages/Workspace/Packages/_Index/NotificationModalsManager/InExperienceLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/Localization").LocalizationProvider
local styleProviderWithDefaultTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/Style").StyleProviderWithDefaultTheme

local settingsShowSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/CoreScriptsCommon").SettingsShowSignal

local GetFFlagManagerAddDisplayOrderAndBackgroundDismiss = require("@game/CorePackages/Workspace/Packages/_Index/NotificationModalsManager/NotificationModalsManager/Flags/GetFFlagManagerAddDisplayOrderAndBackgroundDismiss")

local getFFlagEnablePushNotificationsUpsellModal = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/SharedFlags").GetFFlagEnablePushNotificationsUpsellModal
local getFFlagNotificationModalSetMenuIsOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/SharedFlags").GetFFlagNotificationModalSetMenuIsOpen

local v5 = { stiffness = 400, damping = 40, mass = 1 }

return function(props)
	local state, setState = useState({})
	local state2, setState2 = useState(GuiService.MenuIsOpen)

	useEffect(function()
		local connection

		if getFFlagNotificationModalSetMenuIsOpen() then
			connection = settingsShowSignal:connect(function(p2)
				if not p2 then
					setState2(false)

					return
				end

				if props.CloseModal then
					props.CloseModal()
				end

				setState2(true)
			end)
		else
			connection = GuiService.MenuOpened:Connect(function()
				if props.CloseModal then
					props.CloseModal()
				end

				setState2(true)
			end)
		end

		local menuClosedConnection

		if getFFlagNotificationModalSetMenuIsOpen() then
			menuClosedConnection = nil
		else
			menuClosedConnection = GuiService.MenuClosed:Connect(function()
				setState2(false)
			end)
		end

		return function()
			if getFFlagNotificationModalSetMenuIsOpen() then
				connection:disconnect()
				return
			end

			connection:Disconnect()

			if menuClosedConnection ~= nil then
				menuClosedConnection:Disconnect()
			end
		end
	end, {})

	local v6, v7 = ReactOtter.useAnimatedBinding(0, function()
		if state ~= props then
			setState(props)
		end
	end)

	useEffect(function()
		local inputBeganConnection

		if props.ModalKey then
			setState(props)

			inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
				if
					(input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.ButtonB)
					and UserInputService:GetFocusedTextBox() == nil
					and props.CloseModal
				then
					props.CloseModal()
				end
			end)
		else
			inputBeganConnection = nil
		end

		return function()
			if inputBeganConnection then
				inputBeganConnection:Disconnect()
			end
		end
	end, { props })

	local v8 = useMemo(function(): number
		if props.ModalKey == nil or state2 then
			return 0
		end

		return 1
	end, { props.ModalKey, state2 })

	useEffect(function()
		v7(ReactOtter.spring(v8, v5))

		if getFFlagNotificationModalSetMenuIsOpen() then
			if props.Params and props.Params.BlockNonCoreUserInput and v8 == 1 then
				GuiService:SetMenuIsOpen(true, "NotificationModal")
			else
				GuiService:SetMenuIsOpen(false, "NotificationModal")
			end
		end
	end, { v8 })

	local createElement = React.createElement
	local v10 = {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		DisplayOrder = GetFFlagManagerAddDisplayOrderAndBackgroundDismiss() and state.Params and state.Params.DisplayOrder or 0,
		Enabled = v6:map(function(p2): boolean
			return p2 > 0
		end)
	}

	local v11 = {
		Background = React.createElement("Frame", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 1,
			BackgroundTransparency = v6:map(function(p2)
				return 1 - p2 * 0.5
			end),
			ZIndex = 0
		}),
		Container = 0
	}

	local createElement2 = React.createElement
	local v13 = {
		ZIndex = 1,
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Modal = true,
		Selectable = false,
		Position = v6:map(function(p2)
			return UDim2.new(0, 0, 1 - p2, 0)
		end),
		[ReactRoblox.Event.Activated] = function()
			local v14 = if GetFFlagManagerAddDisplayOrderAndBackgroundDismiss() then state.Params and state.Params.DisableBackgroundDismiss else nil

			if props.CloseModal and not v14 then
				props.CloseModal()
			end
		end
	}

	local createElement3 = React.createElement
	local v17 = if getFFlagEnablePushNotificationsUpsellModal() then state.Params and state.Params.Localization or localization.new(LocalizationService.RobloxLocaleId) else localization.new(LocalizationService.RobloxLocaleId)

	local createElement4 = React.createElement
	local v22 = if state.Component then React.createElement(
		state.Component,
		state.Params and state.Params.Props or {}
	) else nil
	v11.Container = createElement2("TextButton", v13, {
		LocalizationProvider = createElement3(localizationProvider, {
			localization = v17
		}, {
			StyleProvider = createElement4(styleProviderWithDefaultTheme, {}, {
				ModalComponent = v22
			})
		})
	})
	return createElement("ScreenGui", v10, v11)
end
