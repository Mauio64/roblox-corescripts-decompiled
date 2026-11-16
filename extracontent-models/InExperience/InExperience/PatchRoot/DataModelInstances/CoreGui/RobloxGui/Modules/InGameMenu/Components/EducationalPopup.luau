local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local Images = InGameMenuDependencies.UIBlox.App.ImageSet.Images

local parent = script.Parent.Parent
local withLocalization = require(parent.Localization.withLocalization)
local CloseNativeClosePrompt = require(parent.Actions.CloseNativeClosePrompt)
local LeaveGame = require(parent.Utility.LeaveGame)

local EducationalPopupDialog = require(script.Parent.EducationalPopupDialog)

local SendAnalytics = require(parent.Utility.SendAnalytics)

local notificationTypeList = GuiService:GetNotificationTypeList()

local _ = {
	EventContext = "educational_popup",
	ConfirmName = "educational_confirmed",
	CancelName = "educational_close_app",
	DismissName = "educational_dismiss_prompt"
}

local extended = Roact.PureComponent:extend("EducationalPopup")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	onDismiss = t.callback,
	onConfirm = t.callback,
	isClosingApp = t.boolean
})

function extended:init()
	function self.onCancel()
		SendAnalytics("educational_popup", "educational_close_app", {})
		GuiService:BroadcastNotification("", notificationTypeList.NATIVE_EXIT)
	end
end

function extended.render(p)
	return withLocalization({
		title = "CoreScripts.InGameMenu.ExitModal.Title",
		subtitle = "CoreScripts.InGameMenu.ExitModal.Subtitle",
		bodyTextOpenMenu = "CoreScripts.InGameMenu.ExitModal.BodyTextOpenMenu",
		bodyTextClickHome = "CoreScripts.InGameMenu.ExitModal.BodyTextClickHome",
		actionExit = "CoreScripts.InGameMenu.ExitModal.ActionExit",
		actionHome = "CoreScripts.InGameMenu.ExitModal.ActionHome"
	})(function(props)
		return Roact.createElement(EducationalPopupDialog, {
			bodyContents = {
				{ text = props.bodyTextOpenMenu, isSystemMenuIcon = true },
				{ icon = Images["icons/menu/home_off"], text = props.bodyTextClickHome }
			},
			cancelText = props.actionExit,
			confirmText = props.actionHome,
			titleBackgroundImageProps = {
				image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground_05202026.jpg",
				imageHeight = 200,
				text = "<font face=\"GothamBlack\" size=\"42\">" .. props.title .. "</font><font size=\"4\"><br /></font><br />" .. props.subtitle
			},
			screenSize = p.props.screenSize,
			onDismiss = p.props.onDismiss,
			onCancel = p.onCancel,
			onConfirm = p.props.onConfirm,
			blurBackground = true,
			visible = p.props.isClosingApp
		})
	end)
end

function extended.didUpdate(p)
	GuiService:SetMenuIsOpen(p.props.isClosingApp, "EducationalPopup")
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { isClosingApp = p.nativeClosePrompt.closingApp, screenSize = p.screenSize }
end, function(callback)
	return {
		onDismiss = function()
			callback(CloseNativeClosePrompt())
			RbxAnalyticsService:ReportCounter("EducationalPopup_Dismiss", 1)
			SendAnalytics("educational_popup", "educational_dismiss_prompt", {})
		end,
		onConfirm = function()
			RbxAnalyticsService:ReportCounter("EducationalPopup_Confirm", 1)
			SendAnalytics("educational_popup", "educational_confirmed", {})

			LeaveGame()
		end
	}
end)(extended)
