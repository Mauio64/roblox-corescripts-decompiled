local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fCM")
local module2 = require("@luauforge/deferred/hXJ")
local module3 = require("@luauforge/deferred/hXK")
local module4 = require("@luauforge/deferred/hXL")
local module5 = require("@luauforge/deferred/hXM")
local module6 = require("@luauforge/bundled/fzJ")
local module7 = require("@luauforge/bundled/fzM")
local Roact = require(CorePackages.Packages.Roact)
local module8 = require("@luauforge/bundled/ecq")
local module9 = require("@luauforge/bundled/egx")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local UIBlox = require(CorePackages.Packages.UIBlox)
local module10 = require("@luauforge/bundled/fzP")
local module11 = require("@luauforge/bundled/egZ")

local buttonType = UIBlox.App.Button.Enum.ButtonType

local v5 = {
	action = "Feature.AccountSecurityPrompt.Action.SetUpAuthenticatorAccountRestoresPolicyUpsell",
	description = "Feature.AccountSecurityPrompt.Description.AccountRestoresPolicyUpsellMessageBody",
	header = "Feature.AccountSecurityPrompt.Header.AccountRestoresPolicyUpsell",
	settingsTitle = "CommonUI.Features.Label.Settings"
}

local extended = Roact.PureComponent:extend("AccountRestoresPolicyUpsell")

function extended:init()
	self:setState({ requestInFlight = false })

	function self.continueToAuthenticatorAppScreen(p2)
		return function()
			self:setState({ requestInFlight = true })

			self.props.navigateToSecuritySettings()
			self.props.closeOverlay()

			self.props.updatePromptAssignment(
				self.props.networking,
				self.props.promptType,
				module7.DismissPrompt
			)
		end
	end

	function self.closeCallback()
		self.props.updatePromptAssignment(
			self.props.networking,
			self.props.promptType,
			module7.DismissPrompt
		)
	end
end

function extended.render(data)
	local requestInFlight = data.state.requestInFlight

	return module11(v5)(function(props)
		return Roact.createElement(module3, {
			title = props.header,
			closeCallback = data.closeCallback,
			makeBodyFragment = function(p2)
				return Roact.createFragment({
					Lock = Roact.createElement(module2, { layoutOrder = 1 }),
					ModalBodyText = Roact.createElement(module4, {
						layoutOrder = 2,
						contentWidth = p2,
						text = props.description:gsub("{linkStartSettings}", ""):gsub(
							"{linkEndSettings}",
							""
						)
					})
				})
			end,
			buttonConfig = module5({
				{
					isDisabled = requestInFlight,
					isLoading = requestInFlight,
					onActivated = data.continueToAuthenticatorAppScreen(props),
					text = props.action,
					type = buttonType.PrimarySystem
				}
			})
		})
	end)
end

local v6 = RoactRodux.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		closeOverlay = function()
			return callback(module())
		end,
		navigateToSecuritySettings = function()
			callback(module6())
		end,
		updatePromptAssignment = function(p2, p3, p4)
			return callback(module10(p2, p3, p4))
		end
	}
end)(extended)

return (roactServices.connect({ analytics = module8, networking = module9 })(v6))
