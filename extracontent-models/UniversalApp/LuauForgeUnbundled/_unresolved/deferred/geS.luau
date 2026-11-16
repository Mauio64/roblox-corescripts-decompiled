local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/geT")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/deferred/gfb")
local module3 = require("@luauforge/deferred/gfc")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module4 = require("@luauforge/bundled/gfg")
local module5 = require("@luauforge/bundled/dTM")

local extended = Roact.PureComponent:extend("EquipOutfitConfirmation")
local module6 = require("@luauforge/deferred/gfi")

extended.validateProps = t.strictInterface({
	outfitInfo = t.table,
	onOverlayClosed = t.optional(t.callback),
	onEquip = t.optional(t.callback),
	screenSize = t.Vector2,
	equipOutfit = t.callback,
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	analytics = t.optional(t.table),
	navigation = t.table
})

function extended:init()
	function self.equipCostume()
		local outfitInfo = self.props.outfitInfo
		local analytics = self.props.analytics
		local navigation = self.props.navigation

		if module6() then
			self.closePrompt()
			local v5 = self.props.equipOutfit(outfitInfo, analytics, navigation, nil)

			if self.props.onEquip then
				self.props.onEquip(v5)
			end
		else
			local v5 = self.props.equipOutfit(outfitInfo, analytics, navigation, nil)

			if self.props.onEquip then
				self.props.onEquip(v5)
			end

			self.closePrompt()
		end
	end

	function self.closePrompt()
		module5.closeOverlay(self.props.navigation)
	end
end

function extended:renderLocalized(props2)
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
						onActivated = self.equipCostume,
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
		titleText = "Feature.Avatar.Action.Switch",
		messageText = "Feature.Avatar.Message.EquipCostumeConfirmation",
		confirmButtonText = "Feature.Avatar.Action.Switch",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p2)
		return self:renderLocalized(p2)
	end)
end

local v5 = module2((module3((RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		equipOutfit = function(p2, p3, p4, p5)
			return callback(module4({
				outfitInfo = p2,
				analytics = p3,
				navigation = p4,
				isSelected = p5
			}))
		end
	}
end)(extended)))))

return (roactServices.connect({ analytics = module })(v5))
