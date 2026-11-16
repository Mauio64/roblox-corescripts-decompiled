local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

local PerfUtils = require(RobloxGui.Modules.Common.PerfUtils)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local linkingProtocol = LinkingProtocol.LinkingProtocol
local Theme = require(RobloxGui.Modules.Settings.Theme)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local v = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local GetFFlagEnableInGameMenuDurationLogger = require(RobloxGui.Modules.Common.Flags.GetFFlagEnableInGameMenuDurationLogger)
local fFlag = settings():GetFFlag("CollectAnalyticsForSystemMenu")

local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local GetDefaultQualityLevel = AppCommonLib2.GetDefaultQualityLevel
local Constants

if fFlag then
	Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
else
	Constants = nil
end

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.playsessionid = ""

	if engineFeature then
		newPage.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function newPage.LeaveFunc()
		if GetFFlagEnableInGameMenuDurationLogger() then
			PerfUtils.leavingGame()
		end

		GuiService.SelectedCoreObject = nil

		if fFlag then
			RbxAnalyticsService:SetRBXEventStream(
				Constants.AnalyticsTargetName,
				Constants.AnalyticsInGameMenuName,
				Constants.AnalyticsLeaveGameName,
				{
					confirmed = Constants.AnalyticsConfirmedName,
					universeid = tostring(game.GameId),
					source = Constants.AnalyticsLeaveToHomeSource,
					playsessionid = newPage.playsessionid
				}
			)
		end

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
	function newPage.DontLeaveFunc(p)
		if newPage.HubRef then
			newPage.HubRef:PopMenu(p, true)
		end

		if fFlag then
			RbxAnalyticsService:SetRBXEventStream(
				Constants.AnalyticsTargetName,
				Constants.AnalyticsInGameMenuName,
				Constants.AnalyticsLeaveGameName,
				{
					confirmed = Constants.AnalyticsCancelledName,
					universeid = tostring(game.GameId),
					source = Constants.AnalyticsLeaveToHomeSource,
					playsessionid = newPage.playsessionid
				}
			)
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
	function newPage.DontLeaveFromButton(p)
		newPage.DontLeaveFunc(p)
	end

	newPage.TabHeader = nil

	newPage.Page.Name = "LeaveGameToHomePage"
	newPage.ShouldShowBottomBar = false
	newPage.ShouldShowHubBar = false

	local formatByKey = RobloxTranslator:FormatByKey(not fFlag and "CoreScripts.InGameMenu.Prompt.ConfirmLeaveGame" or Constants.ConfirmLeaveGameLocalizedKey)

	local parent = Create("TextLabel")({
		Name = "LeaveGameText",
		Text = formatByKey,
		Font = Theme.font(Enum.Font.SourceSansBold, "Confirmation"),
		FontSize = Theme.fontSize(Enum.FontSize.Size36, "Confirmation"),
		TextColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 200),
		TextWrapped = true,
		ZIndex = 2,
		Parent = newPage.Page,
		Position = v and UDim2.new(0, 0, 0, 100) or UDim2.new(0, 0, 0, 0)
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
		CellSize = v and UDim2.new(0, 300, 0, 80) or UDim2.new(0, 200, 0, 50),
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
	elseif v then
		parent.FontSize = Enum.FontSize.Size48
	end

	newPage.LeaveGameButton = Utility:MakeStyledButton("LeaveGame", "Leave", nil, newPage.LeaveFunc)
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

local initialize = Initialize()

initialize.Displayed.Event:connect(function()
	GuiService.SelectedCoreObject = initialize.LeaveGameButton
	ContextActionService:BindCoreAction(
		"LeaveGameCancelAction",
		initialize.DontLeaveFromHotkey,
		false,
		Enum.KeyCode.ButtonB
	)
end)

initialize.Hidden.Event:connect(function()
	ContextActionService:UnbindCoreAction("LeaveGameCancelAction")
end)

return initialize
