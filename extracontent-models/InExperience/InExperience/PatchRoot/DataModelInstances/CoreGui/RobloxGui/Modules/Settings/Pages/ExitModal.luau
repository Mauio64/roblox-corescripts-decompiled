local _ = {
	EventContext = "educational_popup",
	ConfirmName = "educational_confirmed",
	CancelName = "educational_close_app",
	DismissName = "educational_dismiss_prompt"
}
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local SharedFlags = CorePackages.Workspace.Packages.SharedFlags
local GetFFlagGateEducationalPopupVisibilityViaGUAC = require(SharedFlags).GetFFlagGateEducationalPopupVisibilityViaGUAC
local InExperienceCapabilities = require(CorePackages.Workspace.Packages.InExperienceCapabilities).InExperienceCapabilities
local FFlagEnableSideSheet = require(SharedFlags).FFlagEnableSideSheet
local FFlagSurvBloxEventTypeEnabled = require(SharedFlags).FFlagSurvBloxEventTypeEnabled
local toggleSideSheet = nil

if FFlagEnableSideSheet then
	toggleSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet).toggleSideSheet
end

local NotificationTypeList = GuiService:GetNotificationTypeList()
local Roact = require(CorePackages.Packages.Roact)
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local SendAnalytics = require(RobloxGui.Modules.InGameMenu.Utility.SendAnalytics)
local UserLocalStore = require(RobloxGui.Modules.InGameMenu.Utility.UserLocalStore)
local GetDefaultQualityLevel = require(CorePackages.Workspace.Packages.AppCommonLib).GetDefaultQualityLevel
local SurveyEventPublisher = require(CorePackages.Workspace.Packages.OnPlatformSurveys.SurveyEventPublisher)
local WebViewEventType = require(CorePackages.Workspace.Packages.OnPlatformSurveys.WebViewEventType)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local UIBlox = require(CorePackages.Packages.InGameMenuDependencies).UIBlox
local Images = UIBlox.App.ImageSet.Images
local EducationalModal = UIBlox.App.Dialog.Modal.EducationalModal
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local u30 = nil
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local GetFIntEducationalPopupDisplayMaxCount = require(RobloxGui.Modules.Flags.GetFIntEducationalPopupDisplayMaxCount)

local function Initialize() -- line: 79
	-- upvalues: RobloxGui (copy), GuiService (copy), SendAnalytics (copy), RunService (copy), GetDefaultQualityLevel (copy), NotificationTypeList (copy), LinkingProtocol (copy), u30 (ref), UserLocalStore (copy), GetFIntEducationalPopupDisplayMaxCount (copy), Localization (copy), LocalizationService (copy), Roact (copy), EducationalModal (copy), Images (copy), CoreGui (copy), FFlagSurvBloxEventTypeEnabled (copy), SurveyEventPublisher (copy), WebViewEventType (copy), Players (copy), MessageBus (copy), Constants (copy), renderWithCoreScriptsStyleProvider (copy)
	local v34 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	function v34.LeaveAppFunc(p1) -- line: 83
		-- upvalues: GuiService (copy), SendAnalytics (copy), RunService (copy), GetDefaultQualityLevel (copy), NotificationTypeList (copy)
		GuiService.SelectedCoreObject = nil
		SendAnalytics("educational_popup", "educational_close_app", {
			source = not p1 and "Button" or "Native"
		})
		RunService.RenderStepped:wait()
		RunService.RenderStepped:wait()
		settings().Rendering.QualityLevel = GetDefaultQualityLevel()
		GuiService:BroadcastNotification("", NotificationTypeList.NATIVE_EXIT)
	end
	function v34.LeaveGameFunc(p2) -- line: 100
		-- upvalues: GuiService (copy), SendAnalytics (copy), LinkingProtocol (copy), RunService (copy), GetDefaultQualityLevel (copy)
		GuiService.SelectedCoreObject = nil
		SendAnalytics("educational_popup", "educational_confirmed", {
			source = not p2 and "Button" or "Gamepad"
		})
		LinkingProtocol.default:detectURL("roblox://navigation/home")
		RunService.RenderStepped:wait()
		RunService.RenderStepped:wait()
		game:Shutdown()
		settings().Rendering.QualityLevel = GetDefaultQualityLevel()
	end
	function v34.LeaveGameFromHotkey(_, p4, p5) -- line: 119
		-- upvalues: v34 (copy)
		if p4 == Enum.UserInputState.Begin then
			local v45 = p5.UserInputType == Enum.UserInputType.Gamepad1 or (p5.UserInputType == Enum.UserInputType.Gamepad2 or (p5.UserInputType == Enum.UserInputType.Gamepad3 or p5.UserInputType == Enum.UserInputType.Gamepad4))

			v34.LeaveGameFunc(v45)
		end
	end
	function v34.DontLeaveFunc(p6) -- line: 129
		-- upvalues: u30 (ref), v34 (copy)
		u30.dismissedFrom = not p6 and "Button" or "Gamepad"

		if v34.HubRef then
			v34.HubRef:PopMenu(p6, true)
		end
	end
	function v34.DontLeaveFromHotkey(_, p8, p9) -- line: 136
		-- upvalues: v34 (copy)
		if p8 == Enum.UserInputState.Begin then
			local v50 = p9.UserInputType == Enum.UserInputType.Gamepad1 or (p9.UserInputType == Enum.UserInputType.Gamepad2 or (p9.UserInputType == Enum.UserInputType.Gamepad3 or p9.UserInputType == Enum.UserInputType.Gamepad4))

			v34.DontLeaveFunc(v50)
		end
	end
	function v34.DontShowAgain() -- line: 147
		-- upvalues: UserLocalStore (copy)
		local v51 = UserLocalStore.new()

		v51:SetItem("NativeCloseLuaPromptDisplayCount", (tostring(1e999)))
		v51:Flush()
	end
	function v34.ShouldShow() -- line: 154
		-- upvalues: UserLocalStore (copy), GetFIntEducationalPopupDisplayMaxCount (copy)
		local v52 = UserLocalStore.new()
		local num = tonumber(v52:GetItem("NativeCloseLuaPromptDisplayCount"))

		if num > GetFIntEducationalPopupDisplayMaxCount() then
			return false
		end

		v52:SetItem("NativeCloseLuaPromptDisplayCount", (tostring(num + 1)))
		v52:Flush()

		return true
	end

	v34.TabHeader = nil
	v34.Page.Name = "ExitModalPage"
	v34.ShouldShowBottomBar = false
	v34.ShouldShowHubBar = false
	v34.IsPageClipped = false
	v34.Page.Size = UDim2.new(1, 0, 0, 1)

	local v35 = Localization.new(LocalizationService.RobloxLocaleId)

	local function ExitModal() -- line: 182
		-- upvalues: v35 (copy), LocalizationService (copy), Roact (copy), EducationalModal (copy), Images (copy), CoreGui (copy), v34 (copy), FFlagSurvBloxEventTypeEnabled (copy), SurveyEventPublisher (copy), WebViewEventType (copy), Players (copy), MessageBus (copy), Constants (copy), renderWithCoreScriptsStyleProvider (copy)
		v35:SetLocale(LocalizationService.RobloxLocaleId)

		local t1 = {
			title = v35:Format("CoreScripts.InGameMenu.ExitModal.Title"),
			subtitle = v35:Format("CoreScripts.InGameMenu.ExitModal.Subtitle"),
			bodyTextOpenMenu = v35:Format("CoreScripts.InGameMenu.ExitModal.BodyTextOpenMenu"),
			bodyTextClickHome = v35:Format("CoreScripts.InGameMenu.ExitModal.BodyTextClickHome"),
			optionDontShow = v35:Format("CoreScripts.InGameMenu.ExitModal.OptionDontShow"),
			actionExit = v35:Format("CoreScripts.InGameMenu.ExitModal.ActionExit"),
			actionHome = v35:Format("CoreScripts.InGameMenu.ExitModal.ActionHome")
		}
		local t3 = { Roact.createElement(EducationalModal, {
			hasDoNotShow = true,
			bodyContents = {
				{
					isSystemMenuIcon = true,
					text = t1.bodyTextOpenMenu
				},
				{
					icon = Images["icons/menu/home_off"],
					text = t1.bodyTextClickHome
				}
			},
			cancelText = t1.actionExit,
			confirmText = t1.actionHome,
			doNotShowText = t1.optionDontShow,
			titleBackgroundImageProps = {
				image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg",
				imageHeight = 200,
				text = "<font face=\"GothamBlack\" size=\"42\">" .. t1.title .. "</font><font size=\"4\"><br /></font><br />" .. t1.subtitle
			},
			screenSize = CoreGui.RobloxGui.AbsoluteSize,
			onDismiss = function() -- line: 218
				-- upvalues: v34 (copy)
				v34.DontLeaveFunc(false)
			end,
			onCancel = function(p10) -- line: 221
				-- upvalues: v34 (copy)
				if p10 then
					v34.DontShowAgain()
				end

				v34.LeaveAppFunc(false)
			end,
			onConfirm = function(p11) -- line: 227
				-- upvalues: v34 (copy), FFlagSurvBloxEventTypeEnabled (copy), SurveyEventPublisher (copy), WebViewEventType (copy), Players (copy), MessageBus (copy), Constants (copy)
				if p11 then
					v34.DontShowAgain()
				end

				v34.LeaveGameFunc(false)

				if FFlagSurvBloxEventTypeEnabled then
					SurveyEventPublisher.publishSurveyEvent(WebViewEventType.LeaveButtonClick)

					return
				end

				local t2 = {
					chromeSeenCount = tostring(0)
				}
				local str = tostring(Players.LocalPlayer.UserId)

				MessageBus.publish(Constants.OnSurveyEventDescriptor, {
					eventType = Constants.SurveyEventType,
					userId = str,
					customProps = t2
				})
			end
		}) }

		return renderWithCoreScriptsStyleProvider(t3)
	end

	local u37 = Roact.mount(ExitModal(), v34.Page, "ExitModal")
	local u38 = false

	local function v39() -- line: 255
		-- upvalues: u38 (ref), u37 (ref), Roact (copy), ExitModal (copy)
		if not u38 then
			u38 = true
			task.delay(1, function() -- line: 258
				-- upvalues: u38 (ref), u37 (ref), Roact (copy), ExitModal (copy)
				u38 = false
				u37 = Roact.update(u37, ExitModal())
			end)
		end
	end

	LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(v39)
	CoreGui.RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(v39)

	return v34
end

u30 = Initialize()
u30.Displayed.Event:connect(function() -- line: 273
	-- upvalues: u30 (ref), GetFFlagGateEducationalPopupVisibilityViaGUAC (copy), InExperienceCapabilities (copy), ContextActionService (copy), FFlagEnableSideSheet (copy), toggleSideSheet (ref)
	if not u30.ShouldShow() or GetFFlagGateEducationalPopupVisibilityViaGUAC() and not InExperienceCapabilities.canViewEducationalPopup then
		u30.LeaveAppFunc(true)
	end

	u30.dismissedFrom = "Menu"
	ContextActionService:BindCoreAction("LeaveGameAction", u30.LeaveGameFromHotkey, false, Enum.KeyCode.ButtonA)
	ContextActionService:BindCoreAction("DontLeaveAction", u30.DontLeaveFromHotkey, false, Enum.KeyCode.ButtonB)

	if FFlagEnableSideSheet then
		toggleSideSheet(false)
	end
end)
u30.Hidden.Event:connect(function() -- line: 300
	-- upvalues: u30 (ref), SendAnalytics (copy), ContextActionService (copy)
	if u30.dismissedFrom then
		SendAnalytics("educational_popup", "educational_dismiss_prompt", {
			source = u30.dismissedFrom
		})
		u30.dismissedFrom = nil
	end

	ContextActionService:UnbindCoreAction("LeaveGameAction")
	ContextActionService:UnbindCoreAction("DontLeaveAction")
end)

return u30
