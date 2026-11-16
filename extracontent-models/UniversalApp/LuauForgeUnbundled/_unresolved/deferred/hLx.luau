local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local withStyle = UIBlox.Core.Style.withStyle
local module = require("@luauforge/bundled/edC")
local module2 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module3 = require("@luauforge/deferred/fyr")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module4 = require("@luauforge/bundled/fsq")
local module5 = require("@luauforge/bundled/dCp")

local extended = Roact.Component:extend("VNGBalanceTransferPrompt")

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:init()
	function self.supportFormActivated(p3)
		if self.props.useExternalBrowserForDisclaimerLinks then
			module3(self.props.linking, module4.static.about.support())
		else
			self.props.navigateDown({
				name = module5.GenericWebPage,
				detail = module4.static.about.support(),
				extraProps = { title = p3.support }
			})
		end
	end
end

function extended:render()
	return module({
		title = "CommonUI.UserAgreements.Popup.TransferCurrency.Title",
		message = "CommonUI.UserAgreements.Popup.TransferCurrency.Message",
		button = "CommonUI.UserAgreements.Popup.ContactCustomerSupport",
		support = "Feature.Moderation.Link.SupportForm"
	})(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended:renderWithProviders(props, p3)
	local props2 = self.props

	return Roact.createElement(interactiveAlert, {
		anchorPoint = props2.anchorPoint,
		position = props2.position,
		screenSize = props2.screenSize,
		title = props.title,
		bodyText = props.message,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = function()
							self.supportFormActivated(props)
							props2.doneActivated()
						end,
						text = props.button
					}
				}
			}
		}
	})
end

local v5 = roactAppPolicy.connect(function(p2)
	return {
		useExternalBrowserForDisclaimerLinks = p2.shouldUseExternalBrowserForDisclaimerLinks()
	}
end)(extended)

return (RoactRodux.connect(nil, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module2(p2))
			end
		end
	}
end)(v5))
