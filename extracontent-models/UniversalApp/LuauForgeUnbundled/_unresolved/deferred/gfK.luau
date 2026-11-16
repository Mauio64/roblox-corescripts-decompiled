local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module3 = require("@luauforge/deferred/gfc")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module4 = require("@luauforge/bundled/dTM")

local extended = Roact.PureComponent:extend("PremiumSellOnlyPrompt")

function extended:init()
	function self.openPremiumPage()
		self.closePrompt()
		self.props.openPremiumPage()
	end

	function self.closePrompt()
		module4.closeOverlay(self.props.navigation)
	end
end

function extended:renderAlertLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.titleText,
		bodyText = props2.messageText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = self.closePrompt,
						text = props2.cancelButtonText
					},
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = self.openPremiumPage,
						text = props2.confirmButtonText
					}
				}
			}
		},
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		titleText = "Feature.Catalog.Heading.PremiumOnly",
		messageText = "Feature.Catalog.Label.SellPageUpsell",
		confirmButtonText = "Feature.Catalog.Action.Upgrade",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

return (module3((RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		openPremiumPage = function()
			local v5 = { name = module.BuildersClub }

			if not fFlagSignalsNavP3Dispatch then
				return callback(module2(v5))
			end

			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		end
	}
end)(extended))))
