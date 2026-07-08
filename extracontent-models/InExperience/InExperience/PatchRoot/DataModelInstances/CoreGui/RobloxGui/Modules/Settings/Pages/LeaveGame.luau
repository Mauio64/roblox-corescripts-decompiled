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
local FFlagRefactorMenuConfirmationButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRefactorMenuConfirmationButtons)
local FFlagConfirmationButtonsUseGreyButtons = require(RobloxGui.Modules.Settings.Flags.FFlagConfirmationButtonsUseGreyButtons)
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local v33 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local FoundationProvider = Foundation.FoundationProvider
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function LeaveButtonsContainer(t1: {[any]: any}) -- line: 80
	-- upvalues: React (copy), useLastInput (copy), useFocusGuiObject (copy), useLocalization (copy), Constants (copy), Input (copy), leaveGame (copy), Utility (copy), View (copy), v25 (copy), FoundationText (copy), Button (copy), InputSize (copy), FFlagConfirmationButtonsUseGreyButtons (copy), ButtonVariant (copy)
	local v47 = React.useRef(nil)
	local v48 = useLastInput()
	local v49 = useFocusGuiObject()
	local v50 = useLocalization({
		ConfirmLeaveGame = Constants.ConfirmLeaveGameLocalizedKey,
		LeaveGame = Constants.LeaveGameLocalizedKey,
		DontLeaveGame = Constants.DontLeaveGameLocalizedKey
	})

	React.useEffect(function() -- line: 92
		-- upvalues: v48 (copy), Input (copy), v49 (copy), v47 (copy)
		if v48 ~= Input.Touch then
			v49(v47.current)

			return
		end

		v49(nil)
	end, {
		v48,
		v49
	})

	local v51 = React.useCallback(function() -- line: 100
		-- upvalues: leaveGame (copy)
		leaveGame(true)
	end, { leaveGame })
	local v52 = React.useCallback(function() -- line: 104
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
			Text = v50.ConfirmLeaveGame,
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
				text = v50.LeaveGame,
				size = InputSize.Large,
				variant = if not FFlagConfirmationButtonsUseGreyButtons then ButtonVariant.SoftEmphasis else ButtonVariant.Standard,
				width = UDim.new(0, not v25 and 200 or 300),
				ref = v47,
				onActivated = v51
			}),
			DontLeaveGameButton = React.createElement(Button, {
				LayoutOrder = 2,
				text = v50.DontLeaveGame,
				size = InputSize.Large,
				variant = ButtonVariant.Subtle,
				width = UDim.new(0, not v25 and 200 or 300),
				onActivated = v52
			})
		})
	})
end
local function LeaveGameContainer(t2: {[any]: any}) -- line: 148
	-- upvalues: Localization (copy), LocalizationService (copy), React (copy), LocalizationProvider (copy), FoundationProvider (copy), Foundation (copy), ReactFocusNavigation (copy), v33 (copy), LeaveButtonsContainer (copy)
	local v54 = Localization.new(LocalizationService.RobloxLocaleId)

	return React.createElement(LocalizationProvider, {
		localization = v54
	}, {
		FoundationProvider = React.createElement(FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
				value = v33
			}, {
				LeaveButtonsContainer = React.createElement(LeaveButtonsContainer, t2)
			})
		})
	})
end
local function Initialize() -- line: 166
	-- upvalues: RobloxGui (copy), EngineFeature (copy), RbxAnalyticsService (copy), Constants (copy), FFlagRefactorMenuConfirmationButtons (copy), ReactRoblox (copy), React (copy), LeaveGameContainer (copy), RobloxTranslator (copy), Create (copy), Theme (copy), v25 (copy), Utility (copy), leaveGame (copy)
	local v55 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	v55.playsessionid = ""

	if EngineFeature then
		v55.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function v55.DontLeaveFunc(p1) -- line: 175
		-- upvalues: v55 (copy), RbxAnalyticsService (copy), Constants (copy)
		if v55.HubRef then
			v55.HubRef:PopMenu(p1, true)
		end

		RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
			confirmed = Constants.AnalyticsCancelledName,
			universeid = tostring(game.GameId),
			source = Constants.AnalyticsLeaveGameSource,
			playsessionid = v55.playsessionid
		})
	end
	function v55.DontLeaveFromHotkey(_, p3, p4) -- line: 192
		-- upvalues: v55 (copy)
		if p3 == Enum.UserInputState.Begin then
			local v64 = p4.UserInputType == Enum.UserInputType.Gamepad1 or (p4.UserInputType == Enum.UserInputType.Gamepad2 or (p4.UserInputType == Enum.UserInputType.Gamepad3 or p4.UserInputType == Enum.UserInputType.Gamepad4))

			v55.DontLeaveFunc(v64)
		end
	end
	function v55.DontLeaveFromButton(p5) -- line: 200
		-- upvalues: v55 (copy)
		v55.DontLeaveFunc(p5)
	end

	v55.TabHeader = nil
	v55.Page.Name = "LeaveGamePage"
	v55.ShouldShowBottomBar = false
	v55.ShouldShowHubBar = false

	if FFlagRefactorMenuConfirmationButtons then
		function v55.RenderPage() -- line: 213
			-- upvalues: v55 (copy), ReactRoblox (copy), React (copy), LeaveGameContainer (copy)
			v55.PageRoot = ReactRoblox.createRoot(v55.Page)
			v55.PageRoot:render(React.createElement(LeaveGameContainer, {
				dontLeaveFromButton = v55.DontLeaveFromButton
			}))
		end
		function v55.UnmountPage() -- line: 220
			-- upvalues: v55 (copy)
			if v55.PageRoot then
				v55.PageRoot:unmount()
			end
		end

		v55.Page.Size = UDim2.new(1, 0, 0, 0)

		return v55
	end

	local v56 = RobloxTranslator:FormatByKey(Constants.ConfirmLeaveGameLocalizedKey)
	local v57 = Create("TextLabel")({
		Name = "LeaveGameText",
		BackgroundTransparency = 1,
		TextWrapped = true,
		ZIndex = 2,
		Text = v56,
		Font = Theme.font(Enum.Font.SourceSansBold, "Confirmation"),
		FontSize = Theme.fontSize(Enum.FontSize.Size36, "Confirmation"),
		TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 0, 200),
		Parent = v55.Page,
		Position = v25 and UDim2.new(0, 0, 0, 100) or UDim2.new(0, 0, 0, 0)
	})
	local v58 = Create("Frame")({
		Name = "LeaveButtonContainer",
		BackgroundTransparency = 1,
		Parent = v57,
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
		Parent = v58
	})

	if Utility:IsSmallTouchScreen() then
		v57.FontSize = Enum.FontSize.Size24
		v57.Size = UDim2.new(1, 0, 0, 100)
	elseif v25 then
		v57.FontSize = Enum.FontSize.Size48
	end

	v55.LeaveGameButton = Utility:MakeStyledButton("LeaveGame", "Leave", nil, function() -- line: 273
		-- upvalues: leaveGame (copy)
		leaveGame(true)
	end)
	v55.LeaveGameButton.NextSelectionRight = nil
	v55.LeaveGameButton.Parent = v58

	local v59 = Utility:MakeStyledButton("DontLeaveGame", RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.DontLeaveButton"), nil, v55.DontLeaveFromButton)

	v59.NextSelectionLeft = nil
	v59.Parent = v58
	v55.Page.Size = UDim2.new(1, 0, 0, v59.AbsolutePosition.Y + v59.AbsoluteSize.Y)

	return v55
end

local u45 = Initialize()

u45.Displayed.Event:connect(function() -- line: 298
	-- upvalues: FFlagRefactorMenuConfirmationButtons (copy), u45 (ref), GuiService (copy), FFlagEnableConsoleExpControls (copy), v22 (copy), FFlagChromeShortcutRemoveRespawnOnLeavePage (copy), v23 (copy), v24 (copy), ContextActionService (copy)
	if FFlagRefactorMenuConfirmationButtons then
		u45.RenderPage()
	end

	if not FFlagRefactorMenuConfirmationButtons then
		GuiService.SelectedCoreObject = u45.LeaveGameButton
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
		ContextActionService:BindCoreAction("LeaveGameCancelAction", u45.DontLeaveFromHotkey, false, Enum.KeyCode.ButtonB)
	end
end)
u45.Hidden.Event:connect(function() -- line: 318
	-- upvalues: FFlagRefactorMenuConfirmationButtons (copy), u45 (ref), ContextActionService (copy)
	if FFlagRefactorMenuConfirmationButtons then
		u45.UnmountPage()
	end

	ContextActionService:UnbindCoreAction("LeaveGameCancelAction")
end)

return u45
