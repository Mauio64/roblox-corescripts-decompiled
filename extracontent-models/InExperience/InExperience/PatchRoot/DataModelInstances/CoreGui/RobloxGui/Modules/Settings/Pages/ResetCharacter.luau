local AvatarEditorService = game:GetService("AvatarEditorService")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Utility = require(RobloxGui.Modules.Settings.Utility)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local Cryo = require(CorePackages.Packages.Cryo)
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
local Localization3 = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization3.Hooks.useLocalization

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

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutRemoveLeaveOnRespawnPage = SharedFlags.FFlagChromeShortcutRemoveLeaveOnRespawnPage
local FFlagRespawnActionChromeShortcutTelemetry = require(RobloxGui.Modules.Chrome.Flags.FFlagRespawnActionChromeShortcutTelemetry)
local FFlagRefactorMenuConfirmationButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRefactorMenuConfirmationButtons)
local FFlagConfirmationButtonsUseGreyButtons = require(RobloxGui.Modules.Settings.Flags.FFlagConfirmationButtonsUseGreyButtons)
local FFlagRenameRespawnConfirmationPage = SharedFlags.FFlagRenameRespawnConfirmationPage

local Constants2 = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

local FoundationProvider = Foundation.FoundationProvider
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View

local function ResetCharacterButtonsContainer(p)
	local ref = React.useRef(nil)

	local v = useLastInput()
	local v2 = useFocusGuiObject()

	local v3 = {
		ConfirmResetCharacter = Constants2.ConfirmResetCharacterLocalizedKey,
		ResetCharacter = 0,
		DontResetCharacter = 0
	}
	local resetCharacter

	if FFlagRenameRespawnConfirmationPage then
		resetCharacter = Constants2.RespawnLocalizedKey
	else
		resetCharacter = Constants2.ResetCharacterLocalizedKey
	end

	v3.ResetCharacter = resetCharacter
	v3.DontResetCharacter = Constants2.DontResetCharacterLocalizedKey
	local v4 = useLocalization(v3)

	React.useEffect(function()
		if v == Input.Touch then
			v2(nil)
		else
			v2(ref.current)
		end
	end, { v, v2 })

	local onActivated = React.useCallback(function()
		p.dontResetCharFromButton(Utility:IsUsingGamepad())
	end, { Utility, p.dontResetCharFromButton })

	local createElement = React.createElement
	local v5 = {
		Position = UDim2.new(0, 0, 0, textheadinglarge and 100 or 0),
		tag = "size-full-0 auto-y col"
	}

	local v6 = {
		ResetCharacterText = React.createElement(Text, {
			Text = v4.ConfirmResetCharacter,
			Size = UDim2.new(1, 0, 0, Utility:IsSmallTouchScreen() and 100 or 200),
			LayoutOrder = 1,
			tag = {
				["text-wrap"] = true,
				["text-heading-medium"] = not (Utility:IsSmallTouchScreen() or textheadinglarge),
				["text-heading-small"] = Utility:IsSmallTouchScreen(),
				["text-heading-large"] = textheadinglarge
			}
		}),
		ButtonsContainer = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v7 = {
		text = v4.ResetCharacter,
		size = InputSize.Large,
		variant = 0,
		width = 0,
		LayoutOrder = 1,
		ref = 0,
		onActivated = 0
	}
	local variant

	if FFlagConfirmationButtonsUseGreyButtons then
		variant = ButtonVariant.Standard
	else
		variant = ButtonVariant.SoftEmphasis
	end

	v7.variant = variant
	v7.width = UDim.new(0, textheadinglarge and 300 or 200)

	v7.ref = ref
	v7.onActivated = p.onResetFunction
	v6.ButtonsContainer = createElement2(
		View,
		{ LayoutOrder = 2, tag = "size-full-0 auto-y row align-x-center gap-xlarge wrap" },
		{
			ResetCharacterButton = createElement3(Button, v7),
			DontResetCharacterButton = React.createElement(Button, {
				text = v4.DontResetCharacter,
				size = InputSize.Large,
				variant = ButtonVariant.Subtle,
				width = UDim.new(0, textheadinglarge and 300 or 200),
				LayoutOrder = 2,
				onActivated = onActivated
			})
		}
	)
	return createElement(View, v5, v6)
end

local function ResetCharacterContainer(p)
	local localization = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(LocalizationProvider, { localization = localization }, {
		FoundationProvider = React.createElement(FoundationProvider, {
			colorMode = Foundation.Enums.ColorMode.Dark
		}, {
			FocusNavigationProvider = React.createElement(
				ReactFocusNavigation.FocusNavigationContext.Provider,
				{ value = focusNavigationService },
				{
					ResetCharacterButtonsContainer = React.createElement(ResetCharacterButtonsContainer, p)
				}
			)
		})
	})
end

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()

	function newPage.DontResetCharFunc(p)
		RbxAnalyticsService:SetRBXEventStream(
			Constants2.AnalyticsTargetName,
			Constants2.AnalyticsInGameMenuName,
			Constants2.AnalyticsRespawnCharacterName,
			{ confirmed = Constants2.AnalyticsCancelledName, universeid = tostring(game.GameId) }
		)

		if newPage.HubRef then
			newPage.HubRef:PopMenu(p, true)
		end
	end
	function newPage.DontResetCharFromHotkey(_, p, p2)
		if p == Enum.UserInputState.Begin then
			local v = p2.UserInputType == Enum.UserInputType.Gamepad1
				or p2.UserInputType == Enum.UserInputType.Gamepad2
				or p2.UserInputType == Enum.UserInputType.Gamepad3
				or p2.UserInputType == Enum.UserInputType.Gamepad4

			newPage.DontResetCharFunc(v)
		end
	end
	function newPage.DontResetCharFromButton(p)
		newPage.DontResetCharFunc(p)
	end

	newPage.TabHeader = nil

	newPage.Page.Name = "ResetCharacter"
	newPage.ShouldShowBottomBar = false
	newPage.ShouldShowHubBar = false
	local parent

	if not FFlagRefactorMenuConfirmationButtons then
		local parent2 = Create("TextLabel")({
			Name = "ResetCharacterText",
			Text = FFlagRenameRespawnConfirmationPage and "Are you sure you want to respawn your character?" or "Are you sure you want to reset your character?",
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

		parent = Create("Frame")({
			Name = "ResetButtonContainer",
			Parent = parent2,
			Size = UDim2.new(1, 0, 0, 400),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0)
		})

		Create("UIGridLayout")({
			Name = "ResetButtonsLayout",
			CellSize = textheadinglarge and UDim2.new(0, 300, 0, 80) or UDim2.new(0, 200, 0, 50),
			CellPadding = UDim2.new(0, 20, 0, 20),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Parent = parent
		})

		if Utility:IsSmallTouchScreen() then
			parent2.FontSize = Enum.FontSize.Size24
			parent2.Size = UDim2.new(1, 0, 0, 100)
		elseif textheadinglarge then
			parent2.FontSize = Enum.FontSize.Size48
		end
	end

	local function fn(p)
		local localPlayer = Players.LocalPlayer

		if localPlayer then
			local character = localPlayer.Character

			local humanoid = character and character:FindFirstChild("Humanoid")

			if humanoid then
				humanoid.Health = 0
			end
		end

		local joined = {
			confirmed = Constants2.AnalyticsConfirmedName,
			universeid = tostring(game.GameId)
		}

		if FFlagRespawnActionChromeShortcutTelemetry and p and type(p) == "table" and p.resetTelemetryFields then
			joined = Cryo.Dictionary.join(joined, p.resetTelemetryFields)
		end

		RbxAnalyticsService:SetRBXEventStream(
			Constants2.AnalyticsTargetName,
			Constants2.AnalyticsInGameMenuName,
			Constants2.AnalyticsRespawnCharacterName,
			joined
		)
		RbxAnalyticsService:ReportCounter("InGameMenu-ResetCharacter")
	end

	newPage.ResetBindable = true

	local function onResetFunction(p)
		AvatarEditorService:BustAvatarFetchCache()

		if newPage.ResetBindable == true then
			fn(p)
		elseif newPage.ResetBindable then
			newPage.ResetBindable:Fire()
		end

		if newPage.HubRef then
			newPage.HubRef:SetVisibility(false, true)
		end
	end

	if FFlagEnableConsoleExpControls then
		newPage.ResetFunction = onResetFunction
	end

	if not FFlagRefactorMenuConfirmationButtons then
		newPage.ResetCharacterButton = Utility:MakeStyledButton(
			"ResetCharacter",
			FFlagRenameRespawnConfirmationPage and "Respawn" or "Reset",
			nil,
			onResetFunction
		)
		newPage.ResetCharacterButton.NextSelectionRight = nil
		newPage.ResetCharacterButton.Parent = parent

		local styledButton = Utility:MakeStyledButton(
			"DontResetCharacter",
			FFlagRenameRespawnConfirmationPage and "Don't Respawn" or "Don't Reset",
			nil,
			newPage.DontResetCharFromButton
		)
		styledButton.NextSelectionLeft = nil
		styledButton.Parent = parent

		newPage.Page.Size = UDim2.new(1, 0, 0, styledButton.AbsolutePosition.Y + styledButton.AbsoluteSize.Y)
	end

	if FFlagRefactorMenuConfirmationButtons then
		function newPage.RenderPage()
			newPage.PageRoot = ReactRoblox.createRoot(newPage.Page)
			newPage.PageRoot:render(React.createElement(ResetCharacterContainer, {
				onResetFunction = onResetFunction,
				dontResetCharFromButton = newPage.DontResetCharFromButton
			}))
		end

		function newPage.UnmountPage()
			if newPage.PageRoot then
				newPage.PageRoot:unmount()
			end
		end

		newPage.Page.Size = UDim2.new(1, 0, 0, 0)
	end

	return newPage
end

local initialize = Initialize()
local v = false

initialize.Displayed.Event:connect(function()
	v = true

	if FFlagRefactorMenuConfirmationButtons then
		initialize.RenderPage()
	end

	if not FFlagRefactorMenuConfirmationButtons then
		GuiService.SelectedCoreObject = initialize.ResetCharacterButton
	end

	if FFlagEnableConsoleExpControls then
		if enabled then
			if FFlagChromeShortcutRemoveLeaveOnRespawnPage then
				Service:setShortcutBar(Constants.TILTMENU_RESPAWN_DIALOG_SHORTCUTBAR_ID)
			else
				Service:setShortcutBar(Constants.TILTMENU_DIALOG_SHORTCUTBAR_ID)
			end
		end
	else
		ContextActionService:BindCoreAction(
			"ResetCharacterAction",
			initialize.DontResetCharFromHotkey,
			false,
			Enum.KeyCode.ButtonB
		)
	end
end)

initialize.Hidden.Event:connect(function()
	v = false

	if FFlagRefactorMenuConfirmationButtons then
		initialize.UnmountPage()
	end

	ContextActionService:UnbindCoreAction("ResetCharacterAction")
end)

function initialize.SetResetCallback(_, resetBindable)
	if resetBindable == false and v then
		initialize.HubRef:PopMenu(nil, true)
	end

	initialize.ResetBindable = resetBindable
end

return initialize
