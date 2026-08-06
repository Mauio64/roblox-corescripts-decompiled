local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local Images = InGameMenuDependencies.UIBlox.App.ImageSet.Images
local ParentParent = script.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local CloseNativeClosePrompt = require(ParentParent.Actions.CloseNativeClosePrompt)
local LeaveGame = require(ParentParent.Utility.LeaveGame)
local EducationalPopupDialog = require(script.Parent.EducationalPopupDialog)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local NotificationTypeList = GuiService:GetNotificationTypeList()
local _ = {
	EventContext = "educational_popup",
	ConfirmName = "educational_confirmed",
	CancelName = "educational_close_app",
	DismissName = "educational_dismiss_prompt"
}
local v17 = Roact.PureComponent:extend("EducationalPopup")

v17.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	onDismiss = t.callback,
	onConfirm = t.callback,
	isClosingApp = t.boolean
})

function v17.init(p1) -- line: 39
	-- upvalues: SendAnalytics (copy), GuiService (copy), NotificationTypeList (copy)
	function p1.onCancel() -- line: 40
		-- upvalues: SendAnalytics (copy), GuiService (copy), NotificationTypeList (copy)
		SendAnalytics("educational_popup", "educational_close_app", {})
		GuiService:BroadcastNotification("", NotificationTypeList.NATIVE_EXIT)
	end
end
function v17.render(p2) -- line: 46
	-- upvalues: withLocalization (copy), Roact (copy), EducationalPopupDialog (copy), Images (copy)
	return withLocalization({
		title = "CoreScripts.InGameMenu.ExitModal.Title",
		subtitle = "CoreScripts.InGameMenu.ExitModal.Subtitle",
		bodyTextOpenMenu = "CoreScripts.InGameMenu.ExitModal.BodyTextOpenMenu",
		bodyTextClickHome = "CoreScripts.InGameMenu.ExitModal.BodyTextClickHome",
		actionExit = "CoreScripts.InGameMenu.ExitModal.ActionExit",
		actionHome = "CoreScripts.InGameMenu.ExitModal.ActionHome"
	})(function(p3) -- line: 54
		-- upvalues: Roact (copy), EducationalPopupDialog (copy), Images (copy), p2 (copy)
		return Roact.createElement(EducationalPopupDialog, {
			blurBackground = true,
			bodyContents = {
				{
					isSystemMenuIcon = true,
					text = p3.bodyTextOpenMenu
				},
				{
					icon = Images["icons/menu/home_off"],
					text = p3.bodyTextClickHome
				}
			},
			cancelText = p3.actionExit,
			confirmText = p3.actionHome,
			titleBackgroundImageProps = {
				image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground_05202026.jpg",
				imageHeight = 200,
				text = "<font face=\"GothamBlack\" size=\"42\">" .. p3.title .. "</font><font size=\"4\"><br /></font><br />" .. p3.subtitle
			},
			screenSize = p2.props.screenSize,
			onDismiss = p2.props.onDismiss,
			onCancel = p2.onCancel,
			onConfirm = p2.props.onConfirm,
			visible = p2.props.isClosingApp
		})
	end)
end
function v17.didUpdate(p4) -- line: 86
	-- upvalues: GuiService (copy)
	local isClosingApp = p4.props.isClosingApp

	GuiService:SetMenuIsOpen(isClosingApp, "EducationalPopup")
end

return RoactRodux.UNSTABLE_connect2(function(p5, _) -- line: 91
	return {
		isClosingApp = p5.nativeClosePrompt.closingApp,
		screenSize = p5.screenSize
	}
end, function(p7) -- line: 96
	-- upvalues: CloseNativeClosePrompt (copy), RbxAnalyticsService (copy), SendAnalytics (copy), LeaveGame (copy)
	return {
		onDismiss = function() -- line: 98
			-- upvalues: p7 (copy), CloseNativeClosePrompt (copy), RbxAnalyticsService (copy), SendAnalytics (copy)
			p7(CloseNativeClosePrompt())
			RbxAnalyticsService:ReportCounter("EducationalPopup_Dismiss", 1)
			SendAnalytics("educational_popup", "educational_dismiss_prompt", {})
		end,
		onConfirm = function() -- line: 103
			-- upvalues: RbxAnalyticsService (copy), SendAnalytics (copy), LeaveGame (copy)
			RbxAnalyticsService:ReportCounter("EducationalPopup_Confirm", 1)
			SendAnalytics("educational_popup", "educational_confirmed", {})
			LeaveGame()
		end
	}
end)(v17)
