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
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local Input = Responsive.Input
local useLastInput = Responsive.useLastInput
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Foundation = require(CorePackages.Packages.Foundation)
local v25 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v26 = if not v25 then nil else require(RobloxGui.Modules.Chrome.Service)
local v27 = if not v25 then nil else require(RobloxGui.Modules.Chrome.ChromeShared.Unibar.Constants)

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local v28 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutRemoveLeaveOnRespawnPage = SharedFlags.FFlagChromeShortcutRemoveLeaveOnRespawnPage
local FFlagRespawnActionChromeShortcutTelemetry = require(RobloxGui.Modules.Chrome.Flags.FFlagRespawnActionChromeShortcutTelemetry)
local FFlagRefactorMenuConfirmationButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRefactorMenuConfirmationButtons)
local FFlagConfirmationButtonsUseGreyButtons = require(RobloxGui.Modules.Settings.Flags.FFlagConfirmationButtonsUseGreyButtons)
local FFlagRenameRespawnConfirmationPage = SharedFlags.FFlagRenameRespawnConfirmationPage
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local v37 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FoundationProvider = Foundation.FoundationProvider
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View

local function ResetCharacterButtonsContainer(t1: {[any]: any}) -- line: 83
	-- upvalues: React (copy), useLastInput (copy), useFocusGuiObject (copy), useLocalization (copy), Constants (copy), FFlagRenameRespawnConfirmationPage (copy), Input (copy), Utility (copy), View (copy), v28 (copy), FoundationText (copy), Button (copy), InputSize (copy), FFlagConfirmationButtonsUseGreyButtons (copy), ButtonVariant (copy)
	local v50 = React.useRef(nil)
	local v51 = useLastInput()
	local v52 = useFocusGuiObject()
	local v53 = useLocalization({
		ConfirmResetCharacter = Constants.ConfirmResetCharacterLocalizedKey,
		ResetCharacter = if not FFlagRenameRespawnConfirmationPage then Constants.ResetCharacterLocalizedKey else Constants.RespawnLocalizedKey,
		DontResetCharacter = Constants.DontResetCharacterLocalizedKey
	})

	React.useEffect(function() -- line: 95
		-- upvalues: v51 (copy), Input (copy), v52 (copy), v50 (copy)
		if v51 ~= Input.Touch then
			v52(v50.current)

			return
		end

		v52(nil)
	end, {
		v51,
		v52
	})

	local v54 = React.useCallback(function() -- line: 103
		-- upvalues: t1 (copy), Utility (copy)
		t1.dontResetCharFromButton(Utility:IsUsingGamepad())
	end, {
		Utility,
		t1.dontResetCharFromButton
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		Position = UDim2.new(0, 0, 0, not v28 and 0 or 100)
	}, {
		ResetCharacterText = React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = v53.ConfirmResetCharacter,
			Size = UDim2.new(1, 0, 0, not Utility:IsSmallTouchScreen() and 200 or 100),
			tag = {
				["text-wrap"] = true,
				["text-heading-medium"] = not Utility:IsSmallTouchScreen() and not v28,
				["text-heading-small"] = Utility:IsSmallTouchScreen(),
				["text-heading-large"] = v28
			}
		}),
		ButtonsContainer = React.createElement(View, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y row align-x-center gap-xlarge wrap"
		}, {
			ResetCharacterButton = React.createElement(Button, {
				LayoutOrder = 1,
				text = v53.ResetCharacter,
				size = InputSize.Large,
				variant = if not FFlagConfirmationButtonsUseGreyButtons then ButtonVariant.SoftEmphasis else ButtonVariant.Standard,
				width = UDim.new(0, not v28 and 200 or 300),
				ref = v50,
				onActivated = t1.onResetFunction
			}),
			DontResetCharacterButton = React.createElement(Button, {
				LayoutOrder = 2,
				text = v53.DontResetCharacter,
				size = InputSize.Large,
				variant = ButtonVariant.Subtle,
				width = UDim.new(0, not v28 and 200 or 300),
				onActivated = v54
			})
		})
	})
end
local function ResetCharacterContainer(t2: {[any]: any}) -- line: 147
	-- upvalues: Localization (copy), LocalizationService (copy), React (copy), LocalizationProvider (copy), FoundationProvider (copy), Foundation (copy), ReactFocusNavigation (copy), v37 (copy), ResetCharacterButtonsContainer (copy)
	local v56 = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(LocalizationProvider, {
		localization = v56
	}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
				value = v37
			}, {
				ResetCharacterButtonsContainer = React.createElement(ResetCharacterButtonsContainer, t2)
			})
		})
	})
end
local function Initialize() -- line: 165
	-- upvalues: RobloxGui (copy), RbxAnalyticsService (copy), Constants (copy), FFlagRefactorMenuConfirmationButtons (copy), Create (copy), FFlagRenameRespawnConfirmationPage (copy), Theme (copy), v28 (copy), Utility (copy), Players (copy), FFlagRespawnActionChromeShortcutTelemetry (copy), Cryo (copy), AvatarEditorService (copy), FFlagEnableConsoleExpControls (copy), ReactRoblox (copy), React (copy), ResetCharacterContainer (copy)
	local v57 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	function v57.DontResetCharFunc(p1) -- line: 169
		-- upvalues: RbxAnalyticsService (copy), Constants (copy), v57 (copy)
		RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsRespawnCharacterName, {
			confirmed = Constants.AnalyticsCancelledName,
			universeid = tostring(game.GameId)
		})

		if v57.HubRef then
			v57.HubRef:PopMenu(p1, true)
		end
	end
	function v57.DontResetCharFromHotkey(_, p3, p4) -- line: 177
		-- upvalues: v57 (copy)
		if p3 == Enum.UserInputState.Begin then
			local v69 = p4.UserInputType == Enum.UserInputType.Gamepad1 or (p4.UserInputType == Enum.UserInputType.Gamepad2 or (p4.UserInputType == Enum.UserInputType.Gamepad3 or p4.UserInputType == Enum.UserInputType.Gamepad4))

			v57.DontResetCharFunc(v69)
		end
	end
	function v57.DontResetCharFromButton(p5) -- line: 185
		-- upvalues: v57 (copy)
		v57.DontResetCharFunc(p5)
	end

	v57.TabHeader = nil
	v57.Page.Name = "ResetCharacter"
	v57.ShouldShowBottomBar = false
	v57.ShouldShowHubBar = false

	local v58 = nil

	if not FFlagRefactorMenuConfirmationButtons then
		local v59 = Create("TextLabel")({
			Name = "ResetCharacterText",
			BackgroundTransparency = 1,
			TextWrapped = true,
			ZIndex = 2,
			Text = not FFlagRenameRespawnConfirmationPage and "Are you sure you want to reset your character?" or "Are you sure you want to respawn your character?",
			Font = Theme.font(Enum.Font.SourceSansBold, "Confirmation"),
			FontSize = Theme.fontSize(Enum.FontSize.Size36, "Confirmation"),
			TextColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(1, 0, 0, 200),
			Parent = v57.Page,
			Position = v28 and UDim2.new(0, 0, 0, 100) or UDim2.new(0, 0, 0, 0)
		})

		v58 = Create("Frame")({
			Name = "ResetButtonContainer",
			BackgroundTransparency = 1,
			Parent = v59,
			Size = UDim2.new(1, 0, 0, 400),
			Position = UDim2.new(0, 0, 1, 0)
		})
		Create("UIGridLayout")({
			Name = "ResetButtonsLayout",
			CellSize = v28 and UDim2.new(0, 300, 0, 80) or UDim2.new(0, 200, 0, 50),
			CellPadding = UDim2.new(0, 20, 0, 20),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Parent = v58
		})

		if Utility:IsSmallTouchScreen() then
			v59.FontSize = Enum.FontSize.Size24
			v59.Size = UDim2.new(1, 0, 0, 100)
		elseif v28 then
			v59.FontSize = Enum.FontSize.Size48
		end
	end

	local function v60(t3: {[any]: any}?) -- line: 244
		-- upvalues: Players (copy), Constants (copy), FFlagRespawnActionChromeShortcutTelemetry (copy), Cryo (copy), RbxAnalyticsService (copy)
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer then
			local Character = LocalPlayer.Character

			if Character then
				local Humanoid = Character:FindFirstChild("Humanoid")

				if Humanoid then
					Humanoid.Health = 0
				end
			end
		end

		local t4 = {
			confirmed = Constants.AnalyticsConfirmedName,
			universeid = tostring(game.GameId)
		}

		if FFlagRespawnActionChromeShortcutTelemetry and t3 and type(t3) == "table" and t3.resetTelemetryFields then
			t4 = Cryo.Dictionary.join(t4, t3.resetTelemetryFields)
		end

		RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsRespawnCharacterName, t4)
		RbxAnalyticsService:ReportCounter("InGameMenu-ResetCharacter")
	end

	v57.ResetBindable = true

	local function v61(t5: {[any]: any}?) -- line: 267
		-- upvalues: AvatarEditorService (copy), v57 (copy), v60 (copy)
		AvatarEditorService:BustAvatarFetchCache()

		if v57.ResetBindable == true then
			v60(t5)
		elseif v57.ResetBindable then
			v57.ResetBindable:Fire()
		end

		if v57.HubRef then
			v57.HubRef:SetVisibility(false, true)
		end
	end

	if FFlagEnableConsoleExpControls then
		v57.ResetFunction = v61
	end

	if not FFlagRefactorMenuConfirmationButtons then
		v57.ResetCharacterButton = Utility:MakeStyledButton("ResetCharacter", not FFlagRenameRespawnConfirmationPage and "Reset" or "Respawn", nil, v61)
		v57.ResetCharacterButton.NextSelectionRight = nil
		v57.ResetCharacterButton.Parent = v58

		local v62 = Utility:MakeStyledButton("DontResetCharacter", not FFlagRenameRespawnConfirmationPage and "Don't Reset" or "Don't Respawn", nil, v57.DontResetCharFromButton)

		v62.NextSelectionLeft = nil
		v62.Parent = v58
		v57.Page.Size = UDim2.new(1, 0, 0, v62.AbsolutePosition.Y + v62.AbsoluteSize.Y)
	end

	if FFlagRefactorMenuConfirmationButtons then
		function v57.RenderPage() -- line: 297
			-- upvalues: v57 (copy), ReactRoblox (copy), React (copy), ResetCharacterContainer (copy), v61 (copy)
			v57.PageRoot = ReactRoblox.createRoot(v57.Page)
			v57.PageRoot:render(React.createElement(ResetCharacterContainer, {
				onResetFunction = v61,
				dontResetCharFromButton = v57.DontResetCharFromButton
			}))
		end
		function v57.UnmountPage() -- line: 305
			-- upvalues: v57 (copy)
			if v57.PageRoot then
				v57.PageRoot:unmount()
			end
		end

		v57.Page.Size = UDim2.new(1, 0, 0, 0)
	end

	return v57
end

local u47 = Initialize()
local u48 = false

u47.Displayed.Event:connect(function() -- line: 322
	-- upvalues: u48 (ref), FFlagRefactorMenuConfirmationButtons (copy), u47 (ref), GuiService (copy), FFlagEnableConsoleExpControls (copy), v25 (copy), FFlagChromeShortcutRemoveLeaveOnRespawnPage (copy), v26 (copy), v27 (copy), ContextActionService (copy)
	u48 = true

	if FFlagRefactorMenuConfirmationButtons then
		u47.RenderPage()
	end

	if not FFlagRefactorMenuConfirmationButtons then
		GuiService.SelectedCoreObject = u47.ResetCharacterButton
	end

	if FFlagEnableConsoleExpControls then
		if v25 then
			if FFlagChromeShortcutRemoveLeaveOnRespawnPage then
				v26:setShortcutBar(v27.TILTMENU_RESPAWN_DIALOG_SHORTCUTBAR_ID)

				return
			end

			v26:setShortcutBar(v27.TILTMENU_DIALOG_SHORTCUTBAR_ID)

			return
		end
	else
		ContextActionService:BindCoreAction("ResetCharacterAction", u47.DontResetCharFromHotkey, false, Enum.KeyCode.ButtonB)
	end
end)
u47.Hidden.Event:connect(function() -- line: 343
	-- upvalues: u48 (ref), FFlagRefactorMenuConfirmationButtons (copy), u47 (ref), ContextActionService (copy)
	u48 = false

	if FFlagRefactorMenuConfirmationButtons then
		u47.UnmountPage()
	end

	ContextActionService:UnbindCoreAction("ResetCharacterAction")
end)

function u47.SetResetCallback(_, p7) -- line: 351
	-- upvalues: u48 (ref), u47 (ref)
	if p7 == false and u48 then
		u47.HubRef:PopMenu(nil, true)
	end

	u47.ResetBindable = p7
end

return u47
