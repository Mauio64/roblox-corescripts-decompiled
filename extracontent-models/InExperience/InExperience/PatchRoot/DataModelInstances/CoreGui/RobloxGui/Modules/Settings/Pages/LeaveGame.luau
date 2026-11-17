local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalizationService = game:GetService("LocalizationService")

local Utility = require(RobloxGui.Modules.Settings.Utility)
local leaveGame = require(RobloxGui.Modules.Settings.leaveGame)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local Input = Responsive.Input
local useLastInput = Responsive.useLastInput

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

local Foundation = require(CorePackages.Packages.Foundation)

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local Service

if enabled then
	Service = require(RobloxGui.Modules.Chrome.Service)
else
	Service = nil
end

local Constants

if enabled then
	Constants = require(RobloxGui.Modules.Chrome.ChromeShared.Unibar.Constants)
else
	Constants = nil
end

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local textheadinglarge = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutRemoveRespawnOnLeavePage = SharedFlags.FFlagChromeShortcutRemoveRespawnOnLeavePage
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local PioneerUtils2 = require(CorePackages.Workspace.Packages.PioneerUtils)
local PioneerLeaveReason = PioneerUtils2.PioneerLeaveReason
local FFlagPioneerLeaveLogsOut = SharedFlags.FFlagPioneerLeaveLogsOut

local FFlagRefactorMenuConfirmationButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRefactorMenuConfirmationButtons)

local FFlagConfirmationButtonsUseGreyButtons = require(RobloxGui.Modules.Settings.Flags.FFlagConfirmationButtonsUseGreyButtons)

local Constants2 = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))

local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local LocalizationKeys = InExperienceSideSheet.Constants.LocalizationKeys
local FFlagPioneerLogoutButtonLabel = InExperienceSideSheet.Flags.FFlagPioneerLogoutButtonLabel

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

local Theme = require(RobloxGui.Modules.Settings.Theme)

local FoundationProvider = Foundation.FoundationProvider
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function LeaveButtonsContainer(p)
	local ref = React.useRef(nil)

	local v = useLastInput()
	local v2 = useFocusGuiObject()
	local confirmLeaveGame2

	if isPioneerLaunch() and not FFlagPioneerLeaveLogsOut then
		confirmLeaveGame2 = LocalizationKeys.QuitConfirmation
	elseif FFlagPioneerLogoutButtonLabel and isPioneerLaunch() and FFlagPioneerLeaveLogsOut then
		confirmLeaveGame2 = LocalizationKeys.LogoutConfirmation
	else
		confirmLeaveGame2 = Constants2.ConfirmLeaveGameLocalizedKey
	end

	local leaveGame3

	if isPioneerLaunch() and not FFlagPioneerLeaveLogsOut then
		leaveGame3 = LocalizationKeys.QuitButton
	elseif FFlagPioneerLogoutButtonLabel and isPioneerLaunch() and FFlagPioneerLeaveLogsOut then
		leaveGame3 = LocalizationKeys.LogoutButton
	else
		leaveGame3 = Constants2.LeaveGameLocalizedKey
	end

	local dontLeaveGame

	if isPioneerLaunch() and not FFlagPioneerLeaveLogsOut then
		dontLeaveGame = LocalizationKeys.Resume
	else
		dontLeaveGame = Constants2.DontLeaveGameLocalizedKey
	end

	local v3 = useLocalization({
		ConfirmLeaveGame = confirmLeaveGame2,
		LeaveGame = leaveGame3,
		DontLeaveGame = dontLeaveGame
	})

	local confirmLeaveGame = v3.ConfirmLeaveGame
	local leaveGame2 = v3.LeaveGame

	React.useEffect(function()
		if v == Input.Touch then
			v2(nil)
		else
			v2(ref.current)
		end
	end, { v, v2 })

	local onActivated = React.useCallback(function()
		if FFlagPioneerLeaveLogsOut and isPioneerLaunch() then
			leaveGame(false, { leaveReason = PioneerLeaveReason.Logout, inhibitAppRating = true })
		elseif isPioneerLaunch() then
			leaveGame(false, { shouldNativeExit = true })
		else
			leaveGame(true)
		end
	end, { leaveGame })

	local onActivated2 = React.useCallback(function()
		p.dontLeaveFromButton(Utility:IsUsingGamepad())
	end, { Utility, p.dontLeaveFromButton })

	local createElement = React.createElement
	local v4 = {
		Position = UDim2.new(0, 0, 0, textheadinglarge and 100 or 0),
		tag = "size-full-0 auto-y col"
	}

	local v5 = {
		LeaveGameText = React.createElement(Text, {
			Text = confirmLeaveGame,
			Size = UDim2.new(1, 0, 0, Utility:IsSmallTouchScreen() and 100 or 200),
			LayoutOrder = 1,
			tag = {
				["text-wrap"] = true,
				["text-heading-medium"] = not (Utility:IsSmallTouchScreen() or textheadinglarge),
				["text-heading-small"] = Utility:IsSmallTouchScreen(),
				["text-heading-large"] = textheadinglarge
			}
		}),
		LeaveButtonsContainer = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v6 = {
		text = leaveGame2,
		size = InputSize.Large,
		variant = 0,
		width = 0,
		LayoutOrder = 1,
		ref = 0,
		onActivated = 0,
		testId = 0
	}
	local variant

	if FFlagConfirmationButtonsUseGreyButtons then
		variant = ButtonVariant.Standard
	else
		variant = ButtonVariant.SoftEmphasis
	end

	v6.variant = variant

	v6.width = UDim.new(0, textheadinglarge and 300 or 200)

	v6.ref = ref
	v6.onActivated = onActivated
	v6.testId = FFlagPioneerLogoutButtonLabel and "--leave-game-page-button-leave" or nil
	v5.LeaveButtonsContainer = createElement2(
		View,
		{ LayoutOrder = 2, tag = "size-full-0 auto-y row align-x-center gap-xlarge wrap" },
		{
			LeaveGameButton = createElement3(Button, v6),
			DontLeaveGameButton = React.createElement(Button, {
				text = v3.DontLeaveGame,
				size = InputSize.Large,
				variant = ButtonVariant.Subtle,
				width = UDim.new(0, textheadinglarge and 300 or 200),
				LayoutOrder = 2,
				onActivated = onActivated2,
				testId = FFlagPioneerLogoutButtonLabel and "--leave-game-page-button-dont-leave" or nil
			})
		}
	)
	return createElement(View, v4, v5)
end

local function LeaveGameContainer(p)
	local localization = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(LocalizationProvider, { localization = localization }, {
		FoundationProvider = React.createElement(FoundationProvider, {
			colorMode = Foundation.Enums.ColorMode.Dark
		}, {
			FocusNavigationProvider = React.createElement(
				ReactFocusNavigation.FocusNavigationContext.Provider,
				{ value = focusNavigationService },
				{
					LeaveButtonsContainer = React.createElement(LeaveButtonsContainer, p)
				}
			)
		})
	})
end

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.playsessionid = ""

	if engineFeature then
		newPage.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function newPage.DontLeaveFunc(p)
		if newPage.HubRef then
			newPage.HubRef:PopMenu(p, true)
		end

		RbxAnalyticsService:SetRBXEventStream(
			Constants2.AnalyticsTargetName,
			Constants2.AnalyticsInGameMenuName,
			Constants2.AnalyticsLeaveGameName,
			{
				confirmed = Constants2.AnalyticsCancelledName,
				universeid = tostring(game.GameId),
				source = Constants2.AnalyticsLeaveGameSource,
				playsessionid = newPage.playsessionid
			}
		)
	end
	function newPage.DontLeaveFromHotkey(_, p, p2)
		if p == Enum.UserInputState.Begin then
			local v = p2.UserInputType == Enum.UserInputType.Gamepad1
				or p2.UserInputType == Enum.UserInputType.Gamepad2
				or p2.UserInputType == Enum.UserInputType.Gamepad3
				or p2.UserInputType == Enum.UserInputType.Gamepad4

			newPage.DontLeaveFunc(v)
		end
	end
	function newPage.DontLeaveFromButton(p)
		newPage.DontLeaveFunc(p)
	end

	newPage.TabHeader = nil

	newPage.Page.Name = "LeaveGamePage"
	newPage.ShouldShowBottomBar = false
	newPage.ShouldShowHubBar = false

	if FFlagRefactorMenuConfirmationButtons then
		function newPage.RenderPage()
			newPage.PageRoot = ReactRoblox.createRoot(newPage.Page)
			newPage.PageRoot:render(React.createElement(LeaveGameContainer, {
				dontLeaveFromButton = newPage.DontLeaveFromButton
			}))
		end

		function newPage.UnmountPage()
			if newPage.PageRoot then
				newPage.PageRoot:unmount()
			end
		end

		newPage.Page.Size = UDim2.new(1, 0, 0, 0)
		return newPage
	else
		local text

		if isPioneerLaunch() and not FFlagPioneerLeaveLogsOut then
			text = RobloxTranslator:FormatByKey(LocalizationKeys.QuitConfirmation)
		elseif FFlagPioneerLogoutButtonLabel and isPioneerLaunch() and FFlagPioneerLeaveLogsOut then
			text = RobloxTranslator:FormatByKey(LocalizationKeys.LogoutConfirmation)
		else
			text = RobloxTranslator:FormatByKey(Constants2.ConfirmLeaveGameLocalizedKey)
		end

		local parent = Create("TextLabel")({
			Name = "LeaveGameText",
			Text = text,
			Font = Theme.font(Enum.Font.SourceSansBold, "Confirmation"),
			FontSize = Theme.fontSize(Enum.FontSize.Size36, "Confirmation"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 200),
			TextWrapped = true,
			ZIndex = 2,
			Parent = newPage.Page,
			Position = textheadinglarge and UDim2.new(0, 0, 0, 100) or UDim2.new(0, 0, 0, 0)
		})

		local parent2 = Create("Frame")({
			Name = "LeaveButtonContainer",
			Parent = parent,
			Size = UDim2.new(1, 0, 0, 400),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0)
		})

		Create("UIGridLayout")({
			Name = "LeavetButtonsLayout",
			CellSize = textheadinglarge and UDim2.new(0, 300, 0, 80) or UDim2.new(0, 200, 0, 50),
			CellPadding = UDim2.new(0, 20, 0, 20),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Parent = parent2
		})

		if Utility:IsSmallTouchScreen() then
			parent.FontSize = Enum.FontSize.Size24
			parent.Size = UDim2.new(1, 0, 0, 100)
		elseif textheadinglarge then
			parent.FontSize = Enum.FontSize.Size48
		end

		local v

		if isPioneerLaunch() and not FFlagPioneerLeaveLogsOut then
			v = RobloxTranslator:FormatByKey(LocalizationKeys.QuitButton)
		else
			v = not (FFlagPioneerLogoutButtonLabel and isPioneerLaunch() and FFlagPioneerLeaveLogsOut) and "Leave"
				or RobloxTranslator:FormatByKey(LocalizationKeys.LogoutButton)
		end

		newPage.LeaveGameButton = Utility:MakeStyledButton("LeaveGame", v, nil, function()
			if FFlagPioneerLeaveLogsOut and isPioneerLaunch() then
				leaveGame(false, {
					leaveReason = PioneerLeaveReason.Logout,
					inhibitAppRating = true
				})
			elseif isPioneerLaunch() then
				leaveGame(false, { shouldNativeExit = true })
			else
				leaveGame(true)
			end
		end)
		newPage.LeaveGameButton.NextSelectionRight = nil
		newPage.LeaveGameButton.Parent = parent2

		local styledButton = Utility:MakeStyledButton(
			"DontLeaveGame",
			RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.DontLeaveButton"),
			nil,
			newPage.DontLeaveFromButton
		)

		styledButton.NextSelectionLeft = nil
		styledButton.Parent = parent2

		newPage.Page.Size = UDim2.new(1, 0, 0, styledButton.AbsolutePosition.Y + styledButton.AbsoluteSize.Y)

		return newPage
	end
end

local initialize = Initialize()

initialize.Displayed.Event:connect(function()
	if FFlagRefactorMenuConfirmationButtons then
		initialize.RenderPage()
	end

	if not FFlagRefactorMenuConfirmationButtons then
		GuiService.SelectedCoreObject = initialize.LeaveGameButton
	end

	if FFlagEnableConsoleExpControls then
		if enabled then
			if FFlagChromeShortcutRemoveRespawnOnLeavePage then
				Service:setShortcutBar(Constants.TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID)
			else
				Service:setShortcutBar(Constants.TILTMENU_DIALOG_SHORTCUTBAR_ID)
			end
		end
	else
		ContextActionService:BindCoreAction(
			"LeaveGameCancelAction",
			initialize.DontLeaveFromHotkey,
			false,
			Enum.KeyCode.ButtonB
		)
	end
end)

initialize.Hidden.Event:connect(function()
	if FFlagRefactorMenuConfirmationButtons then
		initialize.UnmountPage()
	end

	ContextActionService:UnbindCoreAction("LeaveGameCancelAction")
end)

return initialize
