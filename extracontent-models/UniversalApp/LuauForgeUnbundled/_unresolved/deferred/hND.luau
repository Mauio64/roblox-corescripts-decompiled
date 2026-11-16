local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fvl")
local module2 = require("@luauforge/deferred/hNc")
local module3 = require("@luauforge/deferred/hNd")
local module4 = require("@luauforge/deferred/hNe")
local module5 = require("@luauforge/deferred/hNf")
local module6 = require("@luauforge/bundled/fsr")
local module7 = require("@luauforge/bundled/fss")
local module8 = require("@luauforge/bundled/fst")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local module9 = require("@luauforge/bundled/dYT")
local module10 = require("@luauforge/bundled/eda")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local UIBlox = require(CorePackages.Packages.UIBlox)
local module11 = require("@luauforge/bundled/fsv")
local module12 = require("@luauforge/bundled/edC")

local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagUseSignalsForAccountSecurityPrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAccountSecurityPrompt
local getAccountSecurityPromptStore

if fFlagUseSignalsForAccountSecurityPrompt then
	getAccountSecurityPromptStore = require("@luauforge/bundled/frE").Stores.GetAccountSecurityPromptStore
else
	getAccountSecurityPromptStore = nil
end

local buttonType = UIBlox.App.Button.Enum.ButtonType

local v5 = {
	action = "Feature.AccountSecurityPrompt.Action.SetUpEmail2SV",
	description = "Feature.AccountSecurityPrompt.Description.Email2SVUpsellMessageBody",
	header = "Feature.AccountSecurityPrompt.Header.Email2SVUpsell",
	settingsTitle = "CommonUI.Features.Label.Settings"
}

local extended = Roact.PureComponent:extend("Email2SVUpsell")

function extended:init()
	self:setState({ requestError = nil, requestInFlight = false })

	function self.continueToSecuritySettingsPage(p2)
		return function()
			self:setState({ requestInFlight = true })

			self.props.openWebView(module8.getWebViewUrlEmailHighlight(), p2.settingsTitle)
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

	return module12(v5)(function(props)
		return Roact.createElement(module3, {
			title = props.header,
			closeCallback = data.closeCallback,
			makeBodyFragment = function(p2)
				return Roact.createFragment({
					Lock = Roact.createElement(module2, { layoutOrder = 1 }),
					ModalBodyText = Roact.createElement(module4, {
						layoutOrder = 2,
						contentWidth = p2,
						text = props.description
					})
				})
			end,
			buttonConfig = module5({
				{
					isDisabled = requestInFlight,
					isLoading = requestInFlight,
					onActivated = data.continueToSecuritySettingsPage(props),
					text = props.action,
					type = buttonType.PrimarySystem
				}
			})
		})
	end)
end

local v6 = RoactRodux.connect(not fFlagUseSignalsForAccountSecurityPrompt and function(p2, p3)
	return { metadata = p2.AccountSecurityPrompt.metadata }
end or nil, function(callback)
	return {
		closeOverlay = function()
			return callback(module())
		end,
		openWebView = function(p2, p3)
			callback(module6(p2, p3))
		end,
		updatePromptAssignment = function(p2, p3, p4)
			return callback(module11(p2, p3, p4))
		end
	}
end)(extended)
local v7

if fFlagUseSignalsForAccountSecurityPrompt then
	v7 = React.memo(function(p2)
		local v8 = useSignalState(getAccountSecurityPromptStore(false).getMetadata)
		return Roact.createElement(v6, Cryo.Dictionary.union(p2, { metadata = v8 }))
	end)
else
	v7 = v6
end

return (roactServices.connect({ analytics = module9, networking = module10 })(v7))
