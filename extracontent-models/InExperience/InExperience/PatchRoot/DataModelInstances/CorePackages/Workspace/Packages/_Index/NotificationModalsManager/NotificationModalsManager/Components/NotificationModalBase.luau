local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local ReactRoblox = require(ParentParent.ReactRoblox)
local ReactOtter = require(ParentParent.ReactOtter)
local useState = React.useState
local useEffect = React.useEffect
local useMemo = React.useMemo
local Localization = require(ParentParent.InExperienceLocales).Localization
local LocalizationProvider = require(ParentParent.Localization).LocalizationProvider
local StyleProviderWithDefaultTheme = require(ParentParent.Style).StyleProviderWithDefaultTheme
local SettingsShowSignal = require(ParentParent.CoreScriptsCommon).SettingsShowSignal
local GetFFlagManagerAddDisplayOrderAndBackgroundDismiss = require(script.Parent.Parent.Flags.GetFFlagManagerAddDisplayOrderAndBackgroundDismiss)
local GetFFlagEnablePushNotificationsUpsellModal = require(ParentParent.SharedFlags).GetFFlagEnablePushNotificationsUpsellModal
local GetFFlagNotificationModalSetMenuIsOpen = require(ParentParent.SharedFlags).GetFFlagNotificationModalSetMenuIsOpen
local t1 = {
	stiffness = 400,
	damping = 40,
	mass = 1
}

return function(t2: {[any]: any}) -- line: 46
	-- upvalues: useState (copy), GuiService (copy), useEffect (copy), GetFFlagNotificationModalSetMenuIsOpen (copy), SettingsShowSignal (copy), ReactOtter (copy), UserInputService (copy), useMemo (copy), t1 (copy), React (copy), GetFFlagManagerAddDisplayOrderAndBackgroundDismiss (copy), ReactRoblox (copy), LocalizationProvider (copy), GetFFlagEnablePushNotificationsUpsellModal (copy), Localization (copy), LocalizationService (copy), StyleProviderWithDefaultTheme (copy)
	local v20, v21 = useState({})
	local v22, v23 = useState(GuiService.MenuIsOpen)

	useEffect(function() -- line: 54
		-- upvalues: GetFFlagNotificationModalSetMenuIsOpen (copy), SettingsShowSignal (copy), t2 (copy), v23 (copy), GuiService (copy)
		local u27 = if not GetFFlagNotificationModalSetMenuIsOpen() then GuiService.MenuOpened:Connect(function() -- line: 68
			-- upvalues: t2 (copy), v23 (copy)
			if t2.CloseModal then
				t2.CloseModal()
			end

			v23(true)
		end) else SettingsShowSignal:connect(function(b1: boolean) -- line: 57
			-- upvalues: t2 (copy), v23 (copy)
			if b1 then
				if t2.CloseModal then
					t2.CloseModal()
				end

				v23(true)

				return
			end

			v23(false)
		end)
		local v28 = if not GetFFlagNotificationModalSetMenuIsOpen() then GuiService.MenuClosed:Connect(function() -- line: 77
			-- upvalues: v23 (copy)
			v23(false)
		end) else nil

		return function() -- line: 81
			-- upvalues: GetFFlagNotificationModalSetMenuIsOpen (copy), u27 (ref), v28 (copy)
			if GetFFlagNotificationModalSetMenuIsOpen() then
				u27:disconnect()

				return
			end

			u27:Disconnect()

			if v28 ~= nil then
				v28:Disconnect()
			end
		end
	end, {})

	local v24, v25 = ReactOtter.useAnimatedBinding(0, function() -- line: 93
		-- upvalues: v20 (copy), t2 (copy), v21 (copy)
		if v20 ~= t2 then
			v21(t2)
		end
	end)

	useEffect(function() -- line: 102
		-- upvalues: t2 (copy), v21 (copy), UserInputService (copy)
		local connection = nil

		if t2.ModalKey then
			v21(t2)
			connection = UserInputService.InputBegan:Connect(function(input) -- line: 112
				-- upvalues: UserInputService (copy), t2 (copy)
				if (input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.ButtonB) and (UserInputService:GetFocusedTextBox() == nil and t2.CloseModal) then
					t2.CloseModal()
				end
			end)
		end

		return function() -- line: 123
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { t2 })

	local v26 = useMemo(function() -- line: 130
		-- upvalues: t2 (copy), v22 (copy)
		if t2.ModalKey ~= nil and not v22 then
			return 1
		end

		return 0
	end, {
		t2.ModalKey,
		v22
	})

	useEffect(function() -- line: 134
		-- upvalues: v25 (copy), ReactOtter (copy), v26 (copy), t1 (copy), GetFFlagNotificationModalSetMenuIsOpen (copy), t2 (copy), GuiService (copy)
		v25(ReactOtter.spring(v26, t1))

		if GetFFlagNotificationModalSetMenuIsOpen() then
			if t2.Params and t2.Params.BlockNonCoreUserInput and v26 == 1 then
				GuiService:SetMenuIsOpen(true, "NotificationModal")

				return
			end

			GuiService:SetMenuIsOpen(false, "NotificationModal")
		end
	end, { v26 })

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = not GetFFlagManagerAddDisplayOrderAndBackgroundDismiss() and 0 or (v20.Params and v20.Params.DisplayOrder or 0),
		Enabled = v24:map(function(p1) -- line: 152
			return p1 > 0
		end)
	}, {
		Background = React.createElement("Frame", {
			BorderSizePixel = 1,
			ZIndex = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = v24:map(function(n1: number) -- line: 160
				return 1 - n1 * 0.5
			end)
		}),
		Container = React.createElement("TextButton", {
			ZIndex = 1,
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Modal = true,
			Selectable = false,
			Position = v24:map(function(p2) -- line: 173
				return UDim2.new(0, 0, 1 - p2, 0)
			end),
			[ReactRoblox.Event.Activated] = function() -- line: 178
				-- upvalues: GetFFlagManagerAddDisplayOrderAndBackgroundDismiss (copy), v20 (copy), t2 (copy)
				local v33 = if not GetFFlagManagerAddDisplayOrderAndBackgroundDismiss() then nil else v20.Params and v20.Params.DisableBackgroundDismiss

				if t2.CloseModal and not v33 then
					t2.CloseModal()
				end
			end
		}, {
			LocalizationProvider = React.createElement(LocalizationProvider, {
				localization = if not GetFFlagEnablePushNotificationsUpsellModal() then Localization.new(LocalizationService.RobloxLocaleId) else v20.Params and v20.Params.Localization or Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {}, {
					ModalComponent = if not v20.Component then nil else React.createElement(v20.Component, v20.Params and v20.Params.Props or {})
				})
			})
		})
	})
end
