local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local ReactOtter = require(parent.ReactOtter)
local useState = React.useState
local useEffect = React.useEffect
local useMemo = React.useMemo

local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal

local GetFFlagManagerAddDisplayOrderAndBackgroundDismiss = require(script.Parent.Parent.Flags.GetFFlagManagerAddDisplayOrderAndBackgroundDismiss)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnablePushNotificationsUpsellModal = SharedFlags.GetFFlagEnablePushNotificationsUpsellModal
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagNotificationModalSetMenuIsOpen = SharedFlags2.GetFFlagNotificationModalSetMenuIsOpen

local v = { stiffness = 400, damping = 40, mass = 1 }

return function(props)
	local state, setState = useState({})
	local state2, setState2 = useState(GuiService.MenuIsOpen)

	useEffect(function()
		local connection

		if GetFFlagNotificationModalSetMenuIsOpen() then
			connection = SettingsShowSignal:connect(function(flag: boolean)
				if not flag then
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

		if GetFFlagNotificationModalSetMenuIsOpen() then
			menuClosedConnection = nil
		else
			menuClosedConnection = GuiService.MenuClosed:Connect(function()
				setState2(false)
			end)
		end

		return function()
			if GetFFlagNotificationModalSetMenuIsOpen() then
				connection:disconnect()
				return
			end

			connection:Disconnect()

			if menuClosedConnection ~= nil then
				menuClosedConnection:Disconnect()
			end
		end
	end, {})

	local v2, v3 = ReactOtter.useAnimatedBinding(0, function()
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

	local v4 = useMemo(function(): number
		return if props.ModalKey == nil or state2 then 0 else 1
	end, { props.ModalKey, state2 })

	useEffect(function()
		v3(ReactOtter.spring(v4, v))

		if GetFFlagNotificationModalSetMenuIsOpen() then
			if props.Params and props.Params.BlockNonCoreUserInput and v4 == 1 then
				GuiService:SetMenuIsOpen(true, "NotificationModal")
			else
				GuiService:SetMenuIsOpen(false, "NotificationModal")
			end
		end
	end, { v4 })

	local createElement = React.createElement
	local v5 = {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		DisplayOrder = GetFFlagManagerAddDisplayOrderAndBackgroundDismiss() and state.Params and state.Params.DisplayOrder or 0,
		Enabled = v2:map(function(p): boolean
			return p > 0
		end)
	}

	local v6 = {
		Background = React.createElement("Frame", {
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 1,
			BackgroundTransparency = v2:map(function(p: number)
				return 1 - p * 0.5
			end),
			ZIndex = 0
		}),
		Container = 0
	}

	local createElement2 = React.createElement
	local v7 = {
		ZIndex = 1,
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Modal = true,
		Selectable = false,
		Position = v2:map(function(p)
			return UDim2.new(0, 0, 1 - p, 0)
		end),
		[ReactRoblox.Event.Activated] = function()
			local v7

			if GetFFlagManagerAddDisplayOrderAndBackgroundDismiss() then
				v7 = state.Params and state.Params.DisableBackgroundDismiss
			end

			if props.CloseModal and not v7 then
				props.CloseModal()
			end
		end
	}

	local createElement3 = React.createElement
	local localization

	if GetFFlagEnablePushNotificationsUpsellModal() then
		localization = state.Params and state.Params.Localization
			or Localization.new(LocalizationService.RobloxLocaleId)
	else
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	end

	local createElement4 = React.createElement
	local modalComponent

	if state.Component then
		modalComponent = React.createElement(state.Component, state.Params and state.Params.Props or {})
	end

	v6.Container = createElement2("TextButton", v7, {
		LocalizationProvider = createElement3(LocalizationProvider, { localization = localization }, {
			StyleProvider = createElement4(StyleProviderWithDefaultTheme, {}, {
				ModalComponent = modalComponent
			})
		})
	})
	return createElement("ScreenGui", v5, v6)
end
