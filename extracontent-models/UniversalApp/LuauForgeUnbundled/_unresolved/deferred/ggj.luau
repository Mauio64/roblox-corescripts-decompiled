local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module = require("@luauforge/deferred/gfc")

local module2 = require("@luauforge/deferred/gfb")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module3 = require("@luauforge/bundled/dTM")

local extended = Roact.PureComponent:extend("OutfitIncompletePrompt")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	navigationCallback = t.callback,
	navigation = t.table,
	focusController = t.optional(t.table),
	defaultChildRef = t.optional(t.table),
	onOverlayClosed = t.optional(t.callback)
})

function LUAUFORGE_MODULE_GLOBALS_ggj_closePrompt(p2)
	module3.closeOverlay(p2)
end

function extended:init()
	function self.onStay()
		LUAUFORGE_MODULE_GLOBALS_ggj_closePrompt(self.props.navigation)
	end

	function self.onLeave()
		LUAUFORGE_MODULE_GLOBALS_ggj_closePrompt(self.props.navigation)
		self.props.navigationCallback()
	end
end

function extended:renderAlertLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.outfitIncompleteTitle,
		bodyText = props2.outfitIncompleteBody,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = self.onLeave, text = props2.leave },
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = self.onStay, text = props2.stay }
				}
			}
		},
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		outfitIncompleteTitle = "Feature.Avatar.Title.OutfitIncomplete",
		outfitIncompleteBody = "Feature.Avatar.Label.OutfitIncomplete",
		leave = "Feature.Chat.Action.Leave",
		stay = "Feature.Chat.Action.Stay"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

return (module2((module((RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, nil)(extended))))))
