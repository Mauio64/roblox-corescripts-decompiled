local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/dzD")
local module3 = require("@luauforge/bundled/egZ")

local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appUserInputService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUserInputService
local module4 = require("@luauforge/bundled/gIF")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local module5 = require("@luauforge/bundled/ggi")
local module6 = require("@luauforge/bundled/ehB")
local module7 = require("@luauforge/bundled/dFu")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module9 = require("@luauforge/bundled/ggp")

local module10 = require("@luauforge/bundled/hUi")
local fFlagUseSignalsForScreenGuiBlur = SharedFlags.FFlagUseSignalsForScreenGuiBlur
local getScreenGuiBlurStore

if fFlagUseSignalsForScreenGuiBlur then
	getScreenGuiBlurStore = require("@luauforge/bundled/gIG").GetScreenGuiBlurStore
else
	getScreenGuiBlurStore = nil
end

local extended = Roact.PureComponent:extend("AntiAddictionPrompt")

function extended:init()
	local guiService = self.props.guiService
	local networking = self.props.networking

	self.state = { screenSize = Vector2.new(0, 0) }

	function self.changeScreenSize(p2)
		if self.state.screenSize ~= p2.AbsoluteSize then
			self:setState({ screenSize = p2.AbsoluteSize })
		end
	end

	function self.OkCallback(...)
		if self.props.okCallback then
			self.props.okCallback(...)
		end
	end

	function self.LogoutCallback()
		self.props.logout(networking, guiService)

		if self.props.logoutCallback then
			self.props.logoutCallback()
		end
	end
end

function extended.render(data)
	local message = data.props.message
	local lockOut = data.props.lockOut
	local logoutCallback = lockOut and data.LogoutCallback or data.OkCallback

	local focusedTextBox = data.props.userInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end

	local function fn(p2)
		local element = Roact.createElement(interactiveAlert, {
			title = p2.alertTitle,
			bodyText = message,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
						props = { onActivated = logoutCallback, text = p2.buttonText }
					}
				}
			},
			screenSize = data.state.screenSize
		})

		local element2 = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(),
			BackgroundTransparency = 1,
			Active = true,
			Selectable = false
		}, { AlertWindow = element })

		return Roact.createElement(
			module4,
			{
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = module2.DisplayOrder.AntiAddictionPrompt,
				OnTopOfCoreBlur = lockOut
			},
			{ Overlay = element2 }
		)
	end

	return module3({
		buttonText = lockOut and "Application.Logout.Action.Logout" or "CommonUI.Messages.Action.OK",
		alertTitle = "CommonUI.Messages.Label.Alert"
	})(function(p2)
		return fn(p2)
	end)
end

function extended.didMount(p2)
	if p2.props.lockOut then
		p2.props.setScreenGuiBlur(true)
	end
end

function extended.willUnmount(p2)
	if p2.props.lockOut then
		p2.props.setScreenGuiBlur(false)
	end
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		openLogoutPage = function()
			local v6 = { name = module7.LogoutConfirmation }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v6))
			else
				callback(module6(v6))
			end
		end,
		setScreenGuiBlur = function(p2)
			if fFlagUseSignalsForScreenGuiBlur then
				getScreenGuiBlurStore(false).setScreenGuiBlur(
					"AntiAddictionPrompt",
					p2,
					module2.DisplayOrder.AntiAddictionPrompt
				)
			else
				callback(module10("AntiAddictionPrompt", p2, module2.DisplayOrder.AntiAddictionPrompt))
			end
		end,
		logout = function(p2, p3)
			callback(module5(p2, p3, module9.AntiAddiction))
		end
	}
end)(extended)

return (roactServices.connect({
	guiService = appGuiService,
	userInputService = appUserInputService,
	networking = module
})(v5))
