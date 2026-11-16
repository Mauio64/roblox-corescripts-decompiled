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
local module5 = require("@luauforge/bundled/fvg")

local module6 = require("@luauforge/bundled/dMx")

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local defineFastFlag = game:DefineFastFlag("AXFixR15PromptDismiss", false)

local extended = Roact.PureComponent:extend("R15UpgradePrompt")

extended.validateProps = t.strictInterface({
	bodyTextKey = t.string,
	onSwitchSelected = t.optional(t.callback),
	onOverlayClosed = t.optional(t.callback),
	onOverlayClosedPostClose = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	navigation = t.table,
	screenSize = t.Vector2,
	setAvatarType = t.callback,
	toggleEquipAsset = t.callback
})

function extended:init()
	function self.switchToR15()
		self.props.setAvatarType(module6.AvatarType.R15)

		if self.props.onSwitchSelected then
			self.props.onSwitchSelected()
		end

		self.closePrompt()
	end

	function self.closePrompt()
		module.closeOverlay(self.props.navigation)

		if self.props.onOverlayClosedPostClose then
			self.props.onOverlayClosedPostClose()
		end
	end
end

function extended:renderLocalized(props2)
	if not defineFastFlag then
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
							onActivated = self.switchToR15,
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

	return Roact.createElement(
		"TextButton",
		{
			Size = UDim2.fromScale(1, 1),
			Transparency = 1,
			Selectable = false,
			[Roact.Event.Activated] = self.closePrompt
		},
		{
			InteractiveAlert = Roact.createElement(interactiveAlert, {
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
								onActivated = self.switchToR15,
								text = props2.confirmButtonText
							}
						}
					}
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = self.props.screenSize,
				defaultChildRef = self.props.defaultChildRef
			})
		}
	)
end

function extended:render()
	return withLocalization({
		titleText = "Feature.Avatar.Label.SwitchToR15",
		bodyText = self.props.bodyTextKey,
		confirmButtonText = "Feature.Avatar.Action.Switch",
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
		toggleEquipAsset = function(p2, p3, p4)
			callback(module5(p2, p3, p4))
		end
	}
end

return (module3((module2((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended))))))
