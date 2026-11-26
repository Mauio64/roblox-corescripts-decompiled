local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module = require("@luauforge/deferred/gJI")

local module2 = require("@luauforge/deferred/gJH")
local module3 = require("@luauforge/bundled/fAe")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module4 = require("@luauforge/bundled/dXh")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module5 = require("@luauforge/bundled/ecq")
local module6 = require("@luauforge/bundled/egx")
local module7 = require("@luauforge/bundled/fDf")
local module8 = require("@luauforge/bundled/dPN")
local module9 = require("@luauforge/bundled/fDz")
local clearTryOns = require("@luauforge/bundled/dKU").Actions.ClearTryOns
local module10 = require("@luauforge/deferred/gKN")
local module11 = require("@luauforge/deferred/gKO")

local extended = Roact.PureComponent:extend("ResetToNewCharacterPrompt")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	numCartItems = t.number,
	clearTryOns = t.callback,
	toggleTryOn = t.callback,
	networking = t.callback,
	appAnalytics = t.table,
	catalogAnalytics = t.table,
	itemId = t.string,
	navigation = t.table,
	avatarRoute = t.table,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback)
})

function extended:init()
	function self.equipNewCharacter()
		self.props.toggleTryOn(
			self.props.networking,
			self.props.catalogAnalytics,
			module8.ItemType.Bundle,
			module8.BundleTypeIdStrings.BodyParts,
			self.props.itemId,
			true,
			self.props.avatarRoute,
			self.props.navigation
		)
	end

	function self.resetTryOnsAndAdd()
		self.props.clearTryOns()
		self.equipNewCharacter()
		self.closePrompt()
	end

	function self.keepTryOnsAndAdd()
		self.equipNewCharacter()
		self.closePrompt()
	end

	function self.closePrompt()
		module4.closeOverlay(self.props.navigation)
	end
end

function extended:renderAlertLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.resetToNewCharacterTitle,
		bodyText = props2.resetToNewCharacterBody,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = self.resetTryOnsAndAdd,
						text = props2.reset
					},
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = self.keepTryOnsAndAdd, text = props2.keep }
				}
			}
		},
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		resetToNewCharacterTitle = "Feature.Avatar.Title.ResetToNewCharacter",
		resetToNewCharacterBody = "Feature.Avatar.Label.ResetToNewCharacter",
		reset = "CommonUI.Messages.Action.Reset",
		keep = "Feature.Avatar.Action.Keep"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

local v5 = roactServices.connect({
	appAnalytics = module5,
	catalogAnalytics = module7,
	networking = module6
})(extended)

return (module2((module((module3((RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize, numCartItems = module11(p2) }
end, module10({ clearTryOns = clearTryOns, toggleTryOn = module9 }))(v5))))))))
