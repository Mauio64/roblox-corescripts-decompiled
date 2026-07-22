local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalizationService = game:GetService("LocalizationService")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local leaveGame = require(RobloxGui.Modules.Settings.leaveGame)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
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
local v22 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local v23 = if not v22 then nil else require(RobloxGui.Modules.Chrome.Service)
local v24 = if not v22 then nil else require(RobloxGui.Modules.Chrome.ChromeShared.Unibar.Constants)

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local v25 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutRemoveRespawnOnLeavePage = SharedFlags.FFlagChromeShortcutRemoveRespawnOnLeavePage
local FFlagDebugEnablePioneerUX = SharedFlags.FFlagDebugEnablePioneerUX
local FFlagRefactorMenuConfirmationButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRefactorMenuConfirmationButtons)
local FFlagConfirmationButtonsUseGreyButtons = require(RobloxGui.Modules.Settings.Flags.FFlagConfirmationButtonsUseGreyButtons)
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local LocalizationKeys = require(CorePackages.Workspace.Packages.InExperienceSideSheet).Constants.LocalizationKeys
local v35 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local FoundationProvider = Foundation.FoundationProvider
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function LeaveButtonsContainer(t1: {[any]: any}) -- line: 84
	-- upvalues: React (copy), useLastInput (copy), useFocusGuiObject (copy), useLocalization (copy), FFlagDebugEnablePioneerUX (copy), LocalizationKeys (copy), Constants (copy), Input (copy), leaveGame (copy), Utility (copy), View (copy), v25 (copy), FoundationText (copy), Button (copy), InputSize (copy), FFlagConfirmationButtonsUseGreyButtons (copy), ButtonVariant (copy)
	local v49 = React.useRef(nil)
	local v50 = useLastInput()
	local v51 = useFocusGuiObject()
	local v52 = useLocalization({
		ConfirmLeaveGame = if not FFlagDebugEnablePioneerUX then Constants.ConfirmLeaveGameLocalizedKey else LocalizationKeys.LogoutConfirmation,
		LeaveGame = if not FFlagDebugEnablePioneerUX then Constants.LeaveGameLocalizedKey else LocalizationKeys.LogoutButton,
		DontLeaveGame = if not FFlagDebugEnablePioneerUX then Constants.DontLeaveGameLocalizedKey else LocalizationKeys.Cancel
	})

	React.useEffect(function() -- line: 102
		-- upvalues: v50 (copy), Input (copy), v51 (copy), v49 (copy)
		if v50 ~= Input.Touch then
			v51(v49.current)

			return
		end

		v51(nil)
	end, {
		v50,
		v51
	})

	local v53 = React.useCallback(function() -- line: 110
		-- upvalues: FFlagDebugEnablePioneerUX (copy), leaveGame (copy)
		if FFlagDebugEnablePioneerUX then
			leaveGame(false, {
				shouldNativeExit = true
			})

			return
		end

		leaveGame(true)
	end, { leaveGame })
	local v54 = React.useCallback(function() -- line: 121
		-- upvalues: t1 (copy), Utility (copy)
		t1.dontLeaveFromButton(Utility:IsUsingGamepad())
	end, {
		Utility,
		t1.dontLeaveFromButton
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		Position = UDim2.new(0, 0, 0, not v25 and 0 or 100)
	}, {
		LeaveGameText = React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = v52.ConfirmLeaveGame,
			Size = UDim2.new(1, 0, 0, not Utility:IsSmallTouchScreen() and 200 or 100),
			tag = {
				["text-wrap"] = true,
				["text-heading-medium"] = not Utility:IsSmallTouchScreen() and not v25,
				["text-heading-small"] = Utility:IsSmallTouchScreen(),
				["text-heading-large"] = v25
			}
		}),
		LeaveButtonsContainer = React.createElement(View, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y row align-x-center gap-xlarge wrap"
		}, {
			LeaveGameButton = React.createElement(Button, {
				LayoutOrder = 1,
				text = v52.LeaveGame,
				size = InputSize.Large,
				variant = if not FFlagConfirmationButtonsUseGreyButtons then ButtonVariant.SoftEmphasis else ButtonVariant.Standard,
				width = UDim.new(0, not v25 and 200 or 300),
				ref = v49,
				onActivated = v53
			}),
			DontLeaveGameButton = React.createElement(Button, {
				LayoutOrder = 2,
				text = v52.DontLeaveGame,
				size = InputSize.Large,
				variant = ButtonVariant.Subtle,
				width = UDim.new(0, not v25 and 200 or 300),
				onActivated = v54
			})
		})
	})
end
local function LeaveGameContainer(t2: {[any]: any}) -- line: 165
	-- upvalues: Localization (copy), LocalizationService (copy), React (copy), LocalizationProvider (copy), FoundationProvider (copy), Foundation (copy), ReactFocusNavigation (copy), v35 (copy), LeaveButtonsContainer (copy)
	local v56 = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(LocalizationProvider, {
		localization = v56
	}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
				value = v35
			}, {
				LeaveButtonsContainer = React.createElement(LeaveButtonsContainer, t2)
			})
		})
	})
end
local function Initialize() -- line: 183
	-- upvalues: RobloxGui (copy), EngineFeature (copy), RbxAnalyticsService (copy), Constants (copy), FFlagRefactorMenuConfirmationButtons (copy), ReactRoblox (copy), React (copy), LeaveGameContainer (copy), FFlagDebugEnablePioneerUX (copy), RobloxTranslator (copy), LocalizationKeys (copy), Create (copy), Theme (copy), v25 (copy), Utility (copy), leaveGame (copy)
	local v57 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	v57.playsessionid = ""

	if EngineFeature then
		v57.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function v57.DontLeaveFunc(p1) -- line: 192
		-- upvalues: v57 (copy), RbxAnalyticsService (copy), Constants (copy)
		if v57.HubRef then
			v57.HubRef:PopMenu(p1, true)
		end

		RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
			confirmed = Constants.AnalyticsCancelledName,
			universeid = tostring(game.GameId),
			source = Constants.AnalyticsLeaveGameSource,
			playsessionid = v57.playsessionid
		})
	end
	function v57.DontLeaveFromHotkey(_, p3, p4) -- line: 209
		-- upvalues: v57 (copy)
		if p3 == Enum.UserInputState.Begin then
			local v67 = p4.UserInputType == Enum.UserInputType.Gamepad1 or (p4.UserInputType == Enum.UserInputType.Gamepad2 or (p4.UserInputType == Enum.UserInputType.Gamepad3 or p4.UserInputType == Enum.UserInputType.Gamepad4))

			v57.DontLeaveFunc(v67)
		end
	end
	function v57.DontLeaveFromButton(p5) -- line: 217
		-- upvalues: v57 (copy)
		v57.DontLeaveFunc(p5)
	end

	v57.TabHeader = nil
	v57.Page.Name = "LeaveGamePage"
	v57.ShouldShowBottomBar = false
	v57.ShouldShowHubBar = false

	if FFlagRefactorMenuConfirmationButtons then
		function v57.RenderPage() -- line: 230
			-- upvalues: v57 (copy), ReactRoblox (copy), React (copy), LeaveGameContainer (copy)
			v57.PageRoot = ReactRoblox.createRoot(v57.Page)
			v57.PageRoot:render(React.createElement(LeaveGameContainer, {
				dontLeaveFromButton = v57.DontLeaveFromButton
			}))
		end
		function v57.UnmountPage() -- line: 237
			-- upvalues: v57 (copy)
			if v57.PageRoot then
				v57.PageRoot:unmount()
			end
		end

		v57.Page.Size = UDim2.new(1, 0, 0, 0)

		return v57
	end

	local v58 = if not FFlagDebugEnablePioneerUX then RobloxTranslator:FormatByKey(Constants.ConfirmLeaveGameLocalizedKey) else RobloxTranslator:FormatByKey(LocalizationKeys.LogoutConfirmation)
	local v59 = Create("TextLabel")({
		Name = "LeaveGameText",
		BackgroundTransparency = 1,
		TextWrapped = true,
		ZIndex = 2,
		Text = v58,
		Font = Theme.font(Enum.Font.SourceSansBold, "Confirmation"),
		FontSize = Theme.fontSize(Enum.FontSize.Size36, "Confirmation"),
		TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 0, 200),
		Parent = v57.Page,
		Position = v25 and UDim2.new(0, 0, 0, 100) or UDim2.new(0, 0, 0, 0)
	})
	local v60 = Create("Frame")({
		Name = "LeaveButtonContainer",
		BackgroundTransparency = 1,
		Parent = v59,
		Size = UDim2.new(1, 0, 0, 400),
		Position = UDim2.new(0, 0, 1, 0)
	})

	Create("UIGridLayout")({
		Name = "LeavetButtonsLayout",
		CellSize = v25 and UDim2.new(0, 300, 0, 80) or UDim2.new(0, 200, 0, 50),
		CellPadding = UDim2.new(0, 20, 0, 20),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = v60
	})

	if Utility:IsSmallTouchScreen() then
		v59.FontSize = Enum.FontSize.Size24
		v59.Size = UDim2.new(1, 0, 0, 100)
	elseif v25 then
		v59.FontSize = Enum.FontSize.Size48
	end

	local v61 = not FFlagDebugEnablePioneerUX and "Leave" or RobloxTranslator:FormatByKey(LocalizationKeys.LogoutButton)

	v57.LeaveGameButton = Utility:MakeStyledButton("LeaveGame", v61, nil, function() -- line: 295
		-- upvalues: FFlagDebugEnablePioneerUX (copy), leaveGame (copy)
		if FFlagDebugEnablePioneerUX then
			leaveGame(false, {
				shouldNativeExit = true
			})

			return
		end

		leaveGame(true)
	end)
	v57.LeaveGameButton.NextSelectionRight = nil
	v57.LeaveGameButton.Parent = v60

	local v62 = Utility:MakeStyledButton("DontLeaveGame", RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.DontLeaveButton"), nil, v57.DontLeaveFromButton)

	v62.NextSelectionLeft = nil
	v62.Parent = v60
	v57.Page.Size = UDim2.new(1, 0, 0, v62.AbsolutePosition.Y + v62.AbsoluteSize.Y)

	return v57
end

local u47 = Initialize()

u47.Displayed.Event:connect(function() -- line: 329
	-- upvalues: FFlagRefactorMenuConfirmationButtons (copy), u47 (ref), GuiService (copy), FFlagEnableConsoleExpControls (copy), v22 (copy), FFlagChromeShortcutRemoveRespawnOnLeavePage (copy), v23 (copy), v24 (copy), ContextActionService (copy)
	if FFlagRefactorMenuConfirmationButtons then
		u47.RenderPage()
	end

	if not FFlagRefactorMenuConfirmationButtons then
		GuiService.SelectedCoreObject = u47.LeaveGameButton
	end

	if FFlagEnableConsoleExpControls then
		if v22 then
			if FFlagChromeShortcutRemoveRespawnOnLeavePage then
				v23:setShortcutBar(v24.TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID)

				return
			end

			v23:setShortcutBar(v24.TILTMENU_DIALOG_SHORTCUTBAR_ID)

			return
		end
	else
		ContextActionService:BindCoreAction("LeaveGameCancelAction", u47.DontLeaveFromHotkey, false, Enum.KeyCode.ButtonB)
	end
end)
u47.Hidden.Event:connect(function() -- line: 349
	-- upvalues: FFlagRefactorMenuConfirmationButtons (copy), u47 (ref), ContextActionService (copy)
	if FFlagRefactorMenuConfirmationButtons then
		u47.UnmountPage()
	end

	ContextActionService:UnbindCoreAction("LeaveGameCancelAction")
end)

return u47
