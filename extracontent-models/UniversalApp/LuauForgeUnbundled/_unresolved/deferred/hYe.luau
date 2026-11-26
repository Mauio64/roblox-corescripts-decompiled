local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/deferred/hXI")
local module2 = require("@luauforge/deferred/hYf")

local module3 = require("@luauforge/bundled/fzD")
local module4 = require("@luauforge/deferred/hXJ")
local module5 = require("@luauforge/deferred/hXK")
local module6 = require("@luauforge/deferred/hXL")
local module7 = require("@luauforge/deferred/hXM")
local AlertViewLabel = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/AlertView/AlertViewLabel")
local module9 = require("@luauforge/bundled/fzI")
local module10 = require("@luauforge/bundled/fzF")
local module11 = require("@luauforge/bundled/ecq")
local module12 = require("@luauforge/bundled/egx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module13 = require("@luauforge/bundled/hUM")
local module14 = require("@luauforge/bundled/egZ")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagUseSignalsForAccountSecurityPrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAccountSecurityPrompt
local getAccountSecurityPromptStore

if fFlagUseSignalsForAccountSecurityPrompt then
	getAccountSecurityPromptStore = require("@luauforge/bundled/fyY").Stores.GetAccountSecurityPromptStore
else
	getAccountSecurityPromptStore = nil
end

local buttonType = UIBlox.App.Button.Enum.ButtonType

local values = {
	[module10.ChangePasswordSuspectedCompromise] = Cryo.Dictionary.join(
		{
			action = "Feature.AccountSecurityPrompt.Action.ContinueChangePassword",
			descriptionEnd = "Feature.AccountSecurityPrompt.Description.ChangeYourPassword",
			descriptionStart = "Feature.AccountSecurityPrompt.Description.UnusualActivity",
			header = "Feature.AccountSecurityPrompt.Header.ChangeYourPassword"
		},
		module.localizationKeys
	),
	[module10.ChangePasswordBreachedCredential] = Cryo.Dictionary.join({
		action = "Feature.AccountSecurityPrompt.Action.ContinueChangePassword",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.NoChangeForceReset",
		descriptionEndSingular = "Feature.AccountSecurityPrompt.Description.NoChangeForceResetSingular",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.ChangeYourPassword",
		header = "Feature.AccountSecurityPrompt.Header.ChangeYourPassword"
	}, module.localizationKeys)
}

local extended = Roact.PureComponent:extend("ChangePasswordIntroV2")

function extended:init()
	self:setState({ requestError = nil, requestInFlight = false })

	function self.continueToChangePassword(p2)
		return function()
			self:setState({ requestInFlight = true })

			self.props.getAccountPinState(self.props.networking):andThen(function(p3)
				local v5 = not (p3.unlockedUntil == nil) and p3.unlockedUntil > 0

				if v5 or not p3.isEnabled then
					if p3.unlockedUntil == nil then
						self.props.updateAccountPinUnlockTimeout(nil)
					else
						local v6 = math.floor(p3.unlockedUntil * 1000)
						local v7 = DateTime.now().UnixTimestampMillis + v6
						self.props.updateAccountPinUnlockTimeout(DateTime.fromUnixTimestampMillis(v7))
					end

					if not self.isMounted then
						return
					end

					self.props.navigateToModalState(module9.ChangePasswordForm)
				else
					if not self.isMounted then
						return
					end

					self.props.navigateToModalState(module9.AccountPinForm)
				end
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
	local promptType = data.props.promptType
	local metadata = data.props.metadata
	local requestError = data.state.requestError
	local requestInFlight = data.state.requestInFlight

	return module14(values[promptType] or values[module10.ChangePasswordSuspectedCompromise])(function(props)
		local v6 = props.descriptionEnd

		if promptType == module10.ChangePasswordBreachedCredential then
			v6 = module3(props.descriptionEndSingular, props.descriptionEnd, metadata.forceResetTimestamp)
		end

		local v7 = props.descriptionStart .. " " .. v6

		return Roact.createElement(module5, {
			title = props.header,
			makeBodyFragment = function(p2)
				return Roact.createFragment({
					Lock = Roact.createElement(module4, { layoutOrder = 1 }),
					ModalBodyText = Roact.createElement(module6, {
						layoutOrder = 2,
						contentWidth = p2,
						richText = true,
						text = v7
					}),
					ModalErrorText = requestError and Roact.createElement(AlertViewLabel, {
						layoutOrder = 3,
						contentWidth = p2,
						errorText = requestError
					})
				})
			end,
			buttonConfig = module7({
				{
					isDisabled = requestInFlight,
					isLoading = requestInFlight,
					onActivated = data.continueToChangePassword(props),
					text = props.action,
					type = buttonType.PrimarySystem
				}
			})
		})
	end)
end

local v5 = RoactRodux.connect(not fFlagUseSignalsForAccountSecurityPrompt and function(p2, p3)
	return {
		promptType = p2.AccountSecurityPrompt.promptType,
		metadata = p2.AccountSecurityPrompt.metadata
	}
end or nil, function(callback)
	return {
		getAccountPinState = function(p2)
			return callback(module2(p2))
		end,
		updateAccountPinUnlockTimeout = function(p2)
			if fFlagUseSignalsForAccountSecurityPrompt then
				getAccountSecurityPromptStore(false).updateAccountPinUnlockTimeout(p2)
			else
				callback(module13(p2))
			end
		end
	}
end)(extended)
local v6

if fFlagUseSignalsForAccountSecurityPrompt then
	v6 = React.memo(function(p2)
		local v7 = useSignalState(getAccountSecurityPromptStore(false).getPromptType)
		local v8 = useSignalState(getAccountSecurityPromptStore(false).getMetadata)
		return Roact.createElement(v5, Cryo.Dictionary.union(p2, {
			promptType = v7,
			metadata = v8
		}))
	end)
else
	v6 = v5
end

return (roactServices.connect({ analytics = module11, networking = module12 })(v6))
