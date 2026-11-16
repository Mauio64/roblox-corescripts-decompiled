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
local module = require(SharedFlags)
local getFFlagGateEducationalPopupVisibilityViaGUAC = module.GetFFlagGateEducationalPopupVisibilityViaGUAC

local InExperienceCapabilities = require(CorePackages.Workspace.Packages.InExperienceCapabilities)
local inExperienceCapabilities = InExperienceCapabilities.InExperienceCapabilities
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local module2 = require(SharedFlags)
local fFlagSurvBloxEventTypeEnabled = module2.FFlagSurvBloxEventTypeEnabled
local toggleSideSheet

if isSideSheetEnabled then
	local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
	toggleSideSheet = InExperienceSideSheet.toggleSideSheet
else
	toggleSideSheet = nil
end

local notificationTypeList = GuiService:GetNotificationTypeList()
local Roact = require(CorePackages.Packages.Roact)
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local linkingProtocol = LinkingProtocol.LinkingProtocol
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local SendAnalytics = require(RobloxGui.Modules.InGameMenu.Utility.SendAnalytics)
local UserLocalStore = require(RobloxGui.Modules.InGameMenu.Utility.UserLocalStore)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local GetDefaultQualityLevel = AppCommonLib.GetDefaultQualityLevel
local SurveyEventPublisher = require(CorePackages.Workspace.Packages.OnPlatformSurveys.SurveyEventPublisher)
local WebViewEventType = require(CorePackages.Workspace.Packages.OnPlatformSurveys.WebViewEventType)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus)
local messageBus = MessageBus.MessageBus

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local UIBlox = InGameMenuDependencies.UIBlox
local Images = UIBlox.App.ImageSet.Images
local EducationalModal = UIBlox.App.Dialog.Modal.EducationalModal

local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local v = nil

local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))

local GetFIntEducationalPopupDisplayMaxCount = require(RobloxGui.Modules.Flags.GetFIntEducationalPopupDisplayMaxCount)

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()

	function newPage.LeaveAppFunc(p)
		GuiService.SelectedCoreObject = nil

		SendAnalytics("educational_popup", "educational_close_app", {
			source = p and "Native" or "Button"
		})

		RunService.RenderStepped:wait()
		RunService.RenderStepped:wait()

		local settings = settings()
		settings.Rendering.QualityLevel = GetDefaultQualityLevel()

		GuiService:BroadcastNotification("", notificationTypeList.NATIVE_EXIT)
	end
	function newPage.LeaveGameFunc(p)
		GuiService.SelectedCoreObject = nil

		SendAnalytics("educational_popup", "educational_confirmed", {
			source = p and "Gamepad" or "Button"
		})

		if linkingProtocol.default:isInternalDlicEnabled() then
			local internalDlic = linkingProtocol.default:createInternalDlic(
				"roblox://navigation/home",
				DeepLinkSource.LuaInternal
			)

			linkingProtocol.default:detectDeeplinkIntent(internalDlic)
		else
			linkingProtocol.default:detectURL("roblox://navigation/home")
		end

		RunService.RenderStepped:wait()
		RunService.RenderStepped:wait()

		game:Shutdown()

		local settings = settings()
		settings.Rendering.QualityLevel = GetDefaultQualityLevel()
	end
	function newPage.LeaveGameFromHotkey(_, p, p2)
		if p == Enum.UserInputState.Begin then
			local v2 = p2.UserInputType == Enum.UserInputType.Gamepad1
				or p2.UserInputType == Enum.UserInputType.Gamepad2
				or p2.UserInputType == Enum.UserInputType.Gamepad3
				or p2.UserInputType == Enum.UserInputType.Gamepad4

			newPage.LeaveGameFunc(v2)
		end
	end
	function newPage.DontLeaveFunc(p)
		v.dismissedFrom = p and "Gamepad" or "Button"

		if newPage.HubRef then
			newPage.HubRef:PopMenu(p, true)
		end
	end
	function newPage.DontLeaveFromHotkey(_, p, p2)
		if p == Enum.UserInputState.Begin then
			local v2 = p2.UserInputType == Enum.UserInputType.Gamepad1
				or p2.UserInputType == Enum.UserInputType.Gamepad2
				or p2.UserInputType == Enum.UserInputType.Gamepad3
				or p2.UserInputType == Enum.UserInputType.Gamepad4

			newPage.DontLeaveFunc(v2)
		end
	end

	function newPage.DontShowAgain()
		local v2 = UserLocalStore.new()
		v2:SetItem("NativeCloseLuaPromptDisplayCount", (tostring(1e999)))
		v2:Flush()
	end

	function newPage.ShouldShow(): boolean
		local v2 = UserLocalStore.new()
		local item = tonumber(v2:GetItem("NativeCloseLuaPromptDisplayCount"))

		if GetFIntEducationalPopupDisplayMaxCount() < item then
			return false
		end

		v2:SetItem("NativeCloseLuaPromptDisplayCount", (tostring(item + 1)))
		v2:Flush()
		return true
	end

	newPage.TabHeader = nil

	newPage.Page.Name = "ExitModalPage"
	newPage.ShouldShowBottomBar = false
	newPage.ShouldShowHubBar = false
	newPage.IsPageClipped = false

	newPage.Page.Size = UDim2.new(1, 0, 0, 1)

	local v2 = Localization.new(LocalizationService.RobloxLocaleId)

	local function ExitModal()
		v2:SetLocale(LocalizationService.RobloxLocaleId)
		local v3 = {
			title = v2:Format("CoreScripts.InGameMenu.ExitModal.Title"),
			subtitle = v2:Format("CoreScripts.InGameMenu.ExitModal.Subtitle"),
			bodyTextOpenMenu = v2:Format("CoreScripts.InGameMenu.ExitModal.BodyTextOpenMenu"),
			bodyTextClickHome = v2:Format("CoreScripts.InGameMenu.ExitModal.BodyTextClickHome"),
			optionDontShow = v2:Format("CoreScripts.InGameMenu.ExitModal.OptionDontShow"),
			actionExit = v2:Format("CoreScripts.InGameMenu.ExitModal.ActionExit"),
			actionHome = v2:Format("CoreScripts.InGameMenu.ExitModal.ActionHome")
		}

		return renderWithCoreScriptsStyleProvider({ Roact.createElement(EducationalModal, {
				bodyContents = {
					{ text = v3.bodyTextOpenMenu, isSystemMenuIcon = true },
					{ icon = Images["icons/menu/home_off"], text = v3.bodyTextClickHome }
				},
				hasDoNotShow = true,
				cancelText = v3.actionExit,
				confirmText = v3.actionHome,
				doNotShowText = v3.optionDontShow,
				titleBackgroundImageProps = {
					image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground_05202026.jpg",
					imageHeight = 200,
					text = "<font face=\"GothamBlack\" size=\"42\">" .. v3.title .. "</font><font size=\"4\"><br /></font><br />" .. v3.subtitle
				},
				screenSize = CoreGui.RobloxGui.AbsoluteSize,
				onDismiss = function()
					newPage.DontLeaveFunc(false)
				end,
				onCancel = function(p)
					if p then
						newPage.DontShowAgain()
					end

					newPage.LeaveAppFunc(false)
				end,
				onConfirm = function(p)
					if p then
						newPage.DontShowAgain()
					end

					newPage.LeaveGameFunc(false)

					if fFlagSurvBloxEventTypeEnabled then
						SurveyEventPublisher.publishSurveyEvent(WebViewEventType.LeaveButtonClick)
						return
					end

					local customProps = { chromeSeenCount = tostring(0) }

					local userId = tostring(Players.LocalPlayer.UserId)
					messageBus.publish(Constants.OnSurveyEventDescriptor, {
						eventType = Constants.SurveyEventType,
						userId = userId,
						customProps = customProps
					})
				end
			}) })
	end

	local v3 = Roact.mount(ExitModal(), newPage.Page, "ExitModal")

	local v4 = false
	local function fn()
		if not v4 then
			v4 = true
			task.delay(1, function()
				v4 = false
				v3 = Roact.update(v3, ExitModal())
			end)
		end
	end
	LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(fn)
	CoreGui.RobloxGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn)

	return newPage
end

v = Initialize()

v.Displayed.Event:connect(function()
	if
		not v.ShouldShow()
		or getFFlagGateEducationalPopupVisibilityViaGUAC() and not inExperienceCapabilities.canViewEducationalPopup
	then
		v.LeaveAppFunc(true)
	end

	v.dismissedFrom = "Menu"
	ContextActionService:BindCoreAction("LeaveGameAction", v.LeaveGameFromHotkey, false, Enum.KeyCode.ButtonA)

	ContextActionService:BindCoreAction("DontLeaveAction", v.DontLeaveFromHotkey, false, Enum.KeyCode.ButtonB)

	if isSideSheetEnabled then
		toggleSideSheet(false)
	end
end)

v.Hidden.Event:connect(function()
	if v.dismissedFrom then
		SendAnalytics("educational_popup", "educational_dismiss_prompt", {
			source = v.dismissedFrom
		})

		v.dismissedFrom = nil
	end

	ContextActionService:UnbindCoreAction("LeaveGameAction")
	ContextActionService:UnbindCoreAction("DontLeaveAction")
end)

return v
