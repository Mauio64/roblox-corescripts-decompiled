local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/fCM")
local module2 = require("@luauforge/bundled/fzH")
local module3 = require("@luauforge/deferred/hXJ")
local module4 = require("@luauforge/deferred/hXK")
local module5 = require("@luauforge/deferred/hXL")
local module6 = require("@luauforge/deferred/hXM")
local AlertViewLabel = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/AlertView/AlertViewLabel")
local module8 = require("@luauforge/bundled/fzI")
local module9 = require("@luauforge/bundled/fzM")
local module10 = require("@luauforge/bundled/fzF")
local module11 = require("@luauforge/bundled/ecq")
local module12 = require("@luauforge/bundled/egx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module13 = require("@luauforge/bundled/fzP")
local module14 = require("@luauforge/bundled/fzQ")
local module15 = require("@luauforge/bundled/egZ")

local buttonType = UIBlox.App.Button.Enum.ButtonType

local extended = Roact.PureComponent:extend("DismissConfirmation")

function extended:init()
	self:setState({
		requestError = nil,
		requestInFlightDismissForever = false,
		requestInFlightDismissTemporary = false,
		requestInFlightSecureAccount = false
	})

	function self.updatePromptAssignment(p2, p3)
		return function()
			self:setState({
				requestInFlightDismissForever = true,
				requestInFlightDismissTemporary = false,
				requestInFlightSecureAccount = false
			})

			self.props.updatePromptAssignment(
				self.props.networking,
				module10.ChangePasswordSuspectedCompromise,
				p3
			):andThen(function()
				self.props.updatePromptType(self.props.analytics, nil, nil, nil)
				self.props.closeOverlay()
			end):catch(function(p4)
				if not self.isMounted then
					return
				end

				self:setState({
					requestError = p2.messageError,
					requestInFlightDismissForever = false
				})
			end)
		end
	end

	function self.secureAccount()
		self:setState({
			requestInFlightDismissForever = false,
			requestInFlightDismissTemporary = false,
			requestInFlightSecureAccount = true
		})

		self.props.navigateToModalState(module8.ChangePasswordIntro)
	end
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(data)
	local requestError = data.state.requestError
	local requestInFlightDismissForever = data.state.requestInFlightDismissForever
	local requestInFlightDismissTemporary = data.state.requestInFlightDismissTemporary
	local requestInFlightSecureAccount = data.state.requestInFlightSecureAccount
	local v5 = requestInFlightDismissForever
		or requestInFlightDismissTemporary
		or requestInFlightSecureAccount
	local modalState = data.props.modalState
	return module15({
		actionDismissForever = "Feature.AccountSecurityPrompt.Action.DismissForever",
		actionDismissTemporary = "Feature.AccountSecurityPrompt.Action.DismissTemporary",
		actionSecureAccount = "Feature.AccountSecurityPrompt.Action.SecureAccount",
		description = "Feature.AccountSecurityPrompt.Description.AreYouSureDismissForeverChangePassword",
		header = "Feature.AccountSecurityPrompt.Header.AreYouSure",
		messageError = "Feature.AccountSecurityPrompt.Message.Error.PromptAssignments.Default"
	})(function(props)
		return Roact.createElement(module4, {
			title = props.header,
			makeBodyFragment = function(p2)
				return Roact.createFragment({
					Lock = Roact.createElement(module3, { layoutOrder = 1 }),
					ModalBodyText = Roact.createElement(module5, {
						layoutOrder = 2,
						contentWidth = p2,
						text = props.description
					}),
					ModalErrorText = requestError and Roact.createElement(AlertViewLabel, {
						layoutOrder = 3,
						contentWidth = p2,
						errorText = requestError
					})
				})
			end,
			buttonConfig = module6({
				{
					isDisabled = v5,
					isLoading = requestInFlightSecureAccount,
					onActivated = data.secureAccount,
					text = props.actionSecureAccount,
					type = buttonType.PrimarySystem
				},
				{
					isDisabled = v5,
					isLoading = requestInFlightDismissForever,
					onActivated = data.updatePromptAssignment(props, module9.DisablePrompt),
					text = props.actionDismissForever,
					type = buttonType.Secondary
				},
				{
					isDisabled = v5,
					isLoading = requestInFlightDismissTemporary,
					onActivated = data.updatePromptAssignment(props, module9.DismissPrompt),
					text = props.actionDismissTemporary,
					type = buttonType.Secondary
				}
			})
		})
	end)
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		closeOverlay = function()
			return callback(module())
		end,
		getPromptAssignments = function(p2)
			return callback(module2(p2))
		end,
		updatePromptType = function(p2, p3, p4, p5)
			return callback(module14(p2, p3, p4, p5))
		end,
		updatePromptAssignment = function(p2, p3, p4)
			return callback(module13(p2, p3, p4))
		end
	}
end)(extended)

return (roactServices.connect({ analytics = module11, networking = module12 })(v5))
