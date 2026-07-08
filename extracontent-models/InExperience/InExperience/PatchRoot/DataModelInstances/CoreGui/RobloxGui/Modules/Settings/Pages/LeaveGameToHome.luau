local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local PerfUtils = require(RobloxGui.Modules.Common.PerfUtils)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local Theme = require(RobloxGui.Modules.Settings.Theme)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local v13 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFFlagEnableInGameMenuDurationLogger = require(RobloxGui.Modules.Common.Flags.GetFFlagEnableInGameMenuDurationLogger)
local FFlag = settings():GetFFlag("CollectAnalyticsForSystemMenu")
local GetDefaultQualityLevel = require(CorePackages.Workspace.Packages.AppCommonLib).GetDefaultQualityLevel
local Constants = nil

if FFlag then
	Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
end

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function Initialize() -- line: 51
	-- upvalues: RobloxGui (copy), EngineFeature (copy), RbxAnalyticsService (copy), GetFFlagEnableInGameMenuDurationLogger (copy), PerfUtils (copy), GuiService (copy), FFlag (copy), Constants (ref), LinkingProtocol (copy), RunService (copy), GetDefaultQualityLevel (copy), RobloxTranslator (copy), Create (copy), Theme (copy), v13 (copy), Utility (copy)
	local v22 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	v22.playsessionid = ""

	if EngineFeature then
		v22.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function v22.LeaveFunc() -- line: 60
		-- upvalues: GetFFlagEnableInGameMenuDurationLogger (copy), PerfUtils (copy), GuiService (copy), FFlag (copy), RbxAnalyticsService (copy), Constants (ref), v22 (copy), LinkingProtocol (copy), RunService (copy), GetDefaultQualityLevel (copy)
		if GetFFlagEnableInGameMenuDurationLogger() then
			PerfUtils.leavingGame()
		end

		GuiService.SelectedCoreObject = nil

		if FFlag then
			RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
				confirmed = Constants.AnalyticsConfirmedName,
				universeid = tostring(game.GameId),
				source = Constants.AnalyticsLeaveToHomeSource,
				playsessionid = v22.playsessionid
			})
		end

		LinkingProtocol.default:detectURL("roblox://navigation/home")
		RunService.RenderStepped:wait()
		RunService.RenderStepped:wait()
		game:Shutdown()
		settings().Rendering.QualityLevel = GetDefaultQualityLevel()
	end
	function v22.DontLeaveFunc(p1) -- line: 92
		-- upvalues: v22 (copy), FFlag (copy), RbxAnalyticsService (copy), Constants (ref)
		if v22.HubRef then
			v22.HubRef:PopMenu(p1, true)
		end

		if FFlag then
			RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
				confirmed = Constants.AnalyticsCancelledName,
				universeid = tostring(game.GameId),
				source = Constants.AnalyticsLeaveToHomeSource,
				playsessionid = v22.playsessionid
			})
		end
	end
	function v22.DontLeaveFromHotkey(_, p3, p4) -- line: 111
		-- upvalues: v22 (copy)
		if p3 == Enum.UserInputState.Begin then
			local v31 = p4.UserInputType == Enum.UserInputType.Gamepad1 or (p4.UserInputType == Enum.UserInputType.Gamepad2 or (p4.UserInputType == Enum.UserInputType.Gamepad3 or p4.UserInputType == Enum.UserInputType.Gamepad4))

			v22.DontLeaveFunc(v31)
		end
	end
	function v22.DontLeaveFromButton(p5) -- line: 119
		-- upvalues: v22 (copy)
		v22.DontLeaveFunc(p5)
	end

	v22.TabHeader = nil
	v22.Page.Name = "LeaveGameToHomePage"
	v22.ShouldShowBottomBar = false
	v22.ShouldShowHubBar = false

	local v23 = RobloxTranslator:FormatByKey(not FFlag and "CoreScripts.InGameMenu.Prompt.ConfirmLeaveGame" or Constants.ConfirmLeaveGameLocalizedKey)
	local v24 = Create("TextLabel")({
		Name = "LeaveGameText",
		BackgroundTransparency = 1,
		TextWrapped = true,
		ZIndex = 2,
		Text = v23,
		Font = Theme.font(Enum.Font.SourceSansBold, "Confirmation"),
		FontSize = Theme.fontSize(Enum.FontSize.Size36, "Confirmation"),
		TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 0, 200),
		Parent = v22.Page,
		Position = v13 and UDim2.new(0, 0, 0, 100) or UDim2.new(0, 0, 0, 0)
	})
	local v25 = Create("Frame")({
		Name = "LeaveButtonContainer",
		BackgroundTransparency = 1,
		Parent = v24,
		Size = UDim2.new(1, 0, 0, 400),
		Position = UDim2.new(0, 0, 1, 0)
	})

	Create("UIGridLayout")({
		Name = "LeavetButtonsLayout",
		CellSize = v13 and UDim2.new(0, 300, 0, 80) or UDim2.new(0, 200, 0, 50),
		CellPadding = UDim2.new(0, 20, 0, 20),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = v25
	})

	if Utility:IsSmallTouchScreen() then
		v24.FontSize = Enum.FontSize.Size24
		v24.Size = UDim2.new(1, 0, 0, 100)
	elseif v13 then
		v24.FontSize = Enum.FontSize.Size48
	end

	v22.LeaveGameButton = Utility:MakeStyledButton("LeaveGame", "Leave", nil, v22.LeaveFunc)
	v22.LeaveGameButton.NextSelectionRight = nil
	v22.LeaveGameButton.Parent = v25

	local v26 = Utility:MakeStyledButton("DontLeaveGame", RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.DontLeaveButton"), nil, v22.DontLeaveFromButton)

	v26.NextSelectionLeft = nil
	v26.Parent = v25
	v22.Page.Size = UDim2.new(1, 0, 0, v26.AbsolutePosition.Y + v26.AbsoluteSize.Y)

	return v22
end

local u21 = Initialize()

u21.Displayed.Event:connect(function() -- line: 204
	-- upvalues: GuiService (copy), u21 (ref), ContextActionService (copy)
	GuiService.SelectedCoreObject = u21.LeaveGameButton
	ContextActionService:BindCoreAction("LeaveGameCancelAction", u21.DontLeaveFromHotkey, false, Enum.KeyCode.ButtonB)
end)
u21.Hidden.Event:connect(function() -- line: 209
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("LeaveGameCancelAction")
end)

return u21
