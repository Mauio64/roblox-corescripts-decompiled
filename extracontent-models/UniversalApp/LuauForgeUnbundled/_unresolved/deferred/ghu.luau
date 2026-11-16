local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module = require("@luauforge/bundled/dTM")
require("@luauforge/bundled/dHK")

local module2 = require("@luauforge/deferred/gfc")

local module3 = require("@luauforge/deferred/gfb")

local module4 = require("@luauforge/bundled/dNP")
local mockStore = require("@game/CorePackages/Packages/_Index/RoduxNetworking/RoduxNetworking/mockStore")
local module6 = require("@luauforge/bundled/dOI")

local module7 = require("@luauforge/bundled/dMx")

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local fFlagAXBlockMakeupEquipR6 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBlockMakeupEquipR6

local extended = Roact.PureComponent:extend("LayeredClothingR6SwitchPrompt")

local strictInterface = t.strictInterface
local v5 = {
	onOverlayClosed = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	navigation = t.table,
	screenSize = t.Vector2,
	setAvatarType = t.callback,
	removeLayeredClothing = t.callback,
	removeMakeup = 0
}
local v6 = if fFlagAXBlockMakeupEquipR6 then t.callback else nil
v5.removeMakeup = v6
extended.validateProps = strictInterface(v5)

function extended:init()
	function self.switchToR6()
		self.props.removeLayeredClothing()

		if fFlagAXBlockMakeupEquipR6 then
			self.props.removeMakeup()
		end

		self.props.setAvatarType(module7.AvatarType.R6)
		self.closePrompt()
	end

	function self.closePrompt()
		module.closeOverlay(self.props.navigation)
	end
end

function extended:renderLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.titleText,
		bodyText = props2.bodyText,
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
						onActivated = self.switchToR6,
						text = props2.confirmButtonText
					}
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		titleText = "Common.AlertsAndOptions.Title.Warning",
		bodyText = "Feature.Avatar.Label.LayeredClothingSwitchR6Warning",
		confirmButtonText = "CommonUI.Controls.Action.Confirm",
		cancelButtonText = "Feature.Avatar.Action.Cancel"
	})(function(p2)
		return self:renderLocalized(p2)
	end)
end

local function mapStateToProps(p2, p3)
	return { screenSize = p2.ScreenSize }
end

local function mapDispatchToProps(callback)
	return {
		setAvatarType = function(p2)
			callback(module4(p2))
		end,
		removeLayeredClothing = function()
			callback(mockStore())
		end,
		removeMakeup = fFlagAXBlockMakeupEquipR6 and function()
			callback(module6())
		end or nil
	}
end

return (module3((module2((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))))))
