local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/deferred/hNb")
local module2 = require("@luauforge/deferred/hNc")
local module3 = require("@luauforge/deferred/hNd")
local module4 = require("@luauforge/deferred/hNe")
local module5 = require("@luauforge/deferred/hNf")
local module6 = require("@luauforge/bundled/fso")
local module7 = require("@luauforge/deferred/hNg")
local module8 = require("@luauforge/bundled/dYT")
local module9 = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module10 = require("@luauforge/bundled/hKe")
local module11 = require("@luauforge/deferred/hNh")
local module12 = require("@luauforge/deferred/hNj")
local module13 = require("@luauforge/bundled/edC")

local fFlagUseSignalsForAccountSecurityPrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAccountSecurityPrompt
local getAccountSecurityPromptStore

if fFlagUseSignalsForAccountSecurityPrompt then
	getAccountSecurityPromptStore = require("@luauforge/bundled/frE").Stores.GetAccountSecurityPromptStore
else
	getAccountSecurityPromptStore = nil
end

local buttonType = UIBlox.App.Button.Enum.ButtonType

local joined = Cryo.Dictionary.join({
	action = "Feature.AccountSecurityPrompt.Action.UnlockAccountPin",
	description = "Feature.AccountSecurityPrompt.Description.EnterYourAccountPin",
	header = "Feature.AccountSecurityPrompt.Header.AccountPinRequired",
	headerExpired = "Feature.AccountSecurityPrompt.Header.AccountPinExpired",
	label = "Feature.AccountSecurityPrompt.Label.AccountPin"
}, module.localizationKeys)

local extended = Roact.PureComponent:extend("AccountPinForm")

function extended:init()
	self:setState({
		accountPin = "",
		accountPinError = nil,
		requestError = nil,
		requestInFlight = false
	})

	function self.setAccountPin(p2)
		self:setState({ accountPin = p2 })
	end

	function self.setAccountPinError(p2)
		self:setState({
			accountPinError = p2 or Roact.None
		})
	end

	function self.clearRequestError()
		self:setState({ requestError = Roact.None })
	end

	function self.unlockAccountPin(p2)
		return function()
			self:setState({ requestInFlight = true })

			self.props.unlockAccountPin(self.props.networking, self.state.accountPin):andThen(function(p3)
				local v5 = math.floor(p3.unlockedUntil * 1000)
				local v6 = DateTime.now().UnixTimestampMillis + v5

				self.props.updateAccountPinUnlockTimeout(DateTime.fromUnixTimestampMillis(v6))

				if not self.isMounted then
					return
				end

				self.props.navigateToModalState(module6.ChangePasswordForm)
			end):catch(function(p3)
				if not self.isMounted then
					return
				end

				self:setState({
					requestError = module.toString(p2, p3),
					requestInFlight = false
				})
			end)
		end
	end
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(data)
	local accountPin = data.state.accountPin
	local requestError = data.state.requestError
	local requestInFlight = data.state.requestInFlight
	local v5 = accountPin ~= ""
	return module13(joined)(function(props)
		local v6 = if data.props.modalState == module6.AccountPinForm then props.header else props.headerExpired

		return Roact.createElement(module3, {
			title = v6,
			makeBodyFragment = function(p2)
				return Roact.createFragment({
					Lock = Roact.createElement(module2, { layoutOrder = 1 }),
					ModalBodyText = Roact.createElement(module4, {
						layoutOrder = 2,
						contentWidth = p2,
						text = props.description
					}),
					ModalTextInput = Roact.createElement(module7, {
						layoutOrder = 3,
						errorText = requestError,
						labelText = props.label,
						onChanged = data.clearRequestError,
						placeholderText = "",
						setError = data.setAccountPinError,
						setValue = data.setAccountPin,
						textInputType = Enum.TextInputType.Password,
						validate = module12,
						value = accountPin
					})
				})
			end,
			buttonConfig = module5({
				{
					isDisabled = requestInFlight or not v5,
					isLoading = requestInFlight,
					onActivated = data.unlockAccountPin(props),
					text = props.action,
					type = buttonType.PrimarySystem
				}
			})
		})
	end)
end

local v5 = RoactRodux.connect(nil, function(callback)
	return {
		updateAccountPinUnlockTimeout = function(p2)
			if fFlagUseSignalsForAccountSecurityPrompt then
				getAccountSecurityPromptStore(false).updateAccountPinUnlockTimeout(p2)
			else
				callback(module10(p2))
			end
		end,
		unlockAccountPin = function(p2, p3)
			return callback(module11(p2, p3))
		end
	}
end)(extended)

return (roactServices.connect({ analytics = module8, networking = module9 })(v5))
