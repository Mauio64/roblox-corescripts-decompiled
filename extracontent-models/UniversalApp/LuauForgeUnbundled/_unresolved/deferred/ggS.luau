local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local t = require(CorePackages.Packages.t)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module2 = require("@luauforge/deferred/gfc")

local module3 = require("@luauforge/deferred/gfb")
local module4 = require("@luauforge/bundled/dTM")
local extended = Roact.PureComponent:extend("CatalogReport")

extended.validateProps = t.strictInterface({
	userId = t.string,
	itemId = t.string,
	itemCreatorId = t.string,
	itemName = t.string,
	itemDescription = t.string,
	screenSize = t.Vector2,
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	navigation = t.table,
	onOverlayClosed = t.optional(t.callback)
})

function extended:init()
	function self.sendReport()
		local userId = self.props.userId
		local itemId = self.props.itemId
		local itemCreatorId = self.props.itemCreatorId
		local itemName = self.props.itemName
		local itemDescription = self.props.itemDescription

		GetExperienceSourceLanguage.ReportItemV2(
			userId,
			itemId,
			itemCreatorId,
			itemName,
			itemDescription,
			"xbox-app",
			"xbox-catalog",
			"7",
			"Item reported from the Xbox App."
		)

		self.closePrompt()
	end

	function self.closePrompt()
		module4.closeOverlay(self.props.navigation)
	end
end

function extended.render(data)
	return withLocalization({
		titleText = "Feature.Catalog.Label.ReportItem",
		messageText = "Feature.Catalog.Message.ReportCatalogItemPhrase",
		submitText = "Feature.Catalog.Action.Submit",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(props)
		return Roact.createElement(interactiveAlert, {
			title = props.titleText,
			bodyText = props.messageText,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = data.closePrompt,
							text = props.cancelButtonText
						},
						isDefaultChild = true
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = data.sendReport,
							text = props.submitText
						}
					}
				}
			},
			screenSize = data.props.screenSize,
			defaultChildRef = data.props.defaultChildRef
		})
	end)
end

return (module3((module2((RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end)(extended))))))
