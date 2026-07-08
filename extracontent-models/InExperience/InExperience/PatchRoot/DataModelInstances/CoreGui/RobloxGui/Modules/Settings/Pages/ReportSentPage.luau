local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local SettingsPageFactory = require(Modules.Settings.SettingsPageFactory)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local onBlockButtonActivated = require(script:FindFirstAncestor("Settings").onBlockButtonActivated)
local BlockingAnalytics = require(script:FindFirstAncestor("Settings").Analytics.BlockingAnalytics)
local Utility = require(Modules.Settings.Utility)
local Theme = require(Modules.Settings.Theme)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local v15 = BlockingAnalytics.new(LocalPlayer.UserId, {
	EventStream = RbxAnalyticsService
})
local v16 = Theme.textSize(36)
local v17 = Theme.textSize(24)
local v18 = Theme.textSize(16)

local function Initialize() -- line: 36
	-- upvalues: SettingsPageFactory (copy), Create (copy), Theme (copy), Utility (copy), RobloxTranslator (copy), v16 (copy), v17 (copy), v18 (copy)
	local v21 = SettingsPageFactory:CreateNewPage()

	v21.TabHeader = nil
	v21.PageListLayout.Parent = nil
	v21.ShouldShowBottomBar = false
	v21.ShouldShowHubBar = false
	v21.IsPageClipped = false
	v21.Page.Name = "ReportSentPage"
	v21.Page.Size = UDim2.fromScale(1, 0)
	v21.Page.AutomaticSize = Enum.AutomaticSize.Y
	v21.Root = Create("Frame")({
		BackgroundTransparency = 1,
		Name = "ReportSentContents",
		Size = UDim2.fromScale(1, 1),
		Parent = v21.Page
	})
	v21.RootLayout = Create("UIListLayout")({
		Name = "RootLayout",
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = v21.Root
	})

	local function createTextLabel(p1, p2, p3, p4) -- line: 64
		-- upvalues: Create (copy), Theme (copy), v21 (copy)
		return Create("TextLabel")({
			BackgroundTransparency = 1,
			TextWrap = true,
			Name = p1,
			LayoutOrder = p4,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = p2,
			TextSize = p3,
			Font = Theme.font(Enum.Font.SourceSansBold, "Bold"),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = v21.Root
		})
	end
	local function createButton(p5, p6, p7, p8) -- line: 81
		-- upvalues: Utility (copy), v21 (copy)
		local v48, v49 = Utility:MakeStyledButton(p5, p6, UDim2.new(1, 0, 0, 50), p8)

		v48.LayoutOrder = p7
		v48.Parent = v21.Root

		return v48, v49
	end
	local function createSpacer(p9, p10) -- line: 89
		-- upvalues: Create (copy), v21 (copy)
		return Create("Frame")({
			LayoutOrder = p10,
			Name = "Spacer" .. tostring(p10),
			Size = UDim2.fromOffset(0, p9),
			Parent = v21.Root
		})
	end

	v21.TitleLabel = createTextLabel("TitleLabel", RobloxTranslator:FormatByKey("Feature.SettingsHub.Heading.Report.ThanksForReport"), v16, 0)
	v21.BodyLabel = createTextLabel("BodyLabel", RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Report.ReceivedReportBody"), v17, 1)
	v21.TopSpacer = createSpacer(10, 2)
	v21.ActionHeader = createTextLabel("ActionHeader", RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Report.OtherActionsHeader"), v18, 3)
	v21.ActionHeader.TextXAlignment = Enum.TextXAlignment.Left

	local v25 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Block")
	local v26, v27 = Utility:MakeStyledButton("BlockButton", v25, UDim2.new(1, 0, 0, 50), function() -- line: 111
		-- upvalues: v21 (copy)
		v21:HandleBlock()
	end)

	v26.LayoutOrder = 4
	v26.Parent = v21.Root
	v21.BlockButton = v26
	v21.BlockLabel = v27
	v21.MiddleSpacer = createSpacer(20, 6)

	local v28 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Report.Done")
	local v29, _ = Utility:MakeStyledButton("DoneButton", v28, UDim2.new(1, 0, 0, 50), function() -- line: 118
		-- upvalues: v21 (copy)
		v21:HandleDone()
	end)

	v29.LayoutOrder = 7
	v29.Parent = v21.Root
	v21.DoneButton = v29

	return v21
end

local v20 = Initialize()

function v20.UpdateActions(p11) -- line: 127
	-- upvalues: BlockingUtility (copy), RobloxTranslator (copy)
	if p11.ReportedPlayer then
		p11.TopSpacer.Visible = true
		p11.ActionHeader.Visible = true

		local v32 = BlockingUtility:IsPlayerBlockedByUserId(p11.ReportedPlayer.UserId)

		p11.BlockButton.Visible = not v32

		local DisplayName = p11.ReportedPlayer.DisplayName
		local ReportedPlayerName = p11.ReportedPlayer.Name
		local v35 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Report.BlockDisplayName", {
			DISPLAY_NAME = DisplayName,
			RBX_NAME = ReportedPlayerName
		})

		p11.BlockLabel.Text = v35

		return
	end

	p11.TopSpacer.Visible = false
	p11.ActionHeader.Visible = false
	p11.BlockButton.Visible = false
end
function v20.ShowReportedPlayer(p12, p13) -- line: 149
	-- upvalues: v20 (copy)
	p12.ReportedPlayer = p13
	p12:UpdateActions()
	p12.HubRef:SwitchToPage(v20, true)
end
function v20.HandleBlock(p14) -- line: 156
	-- upvalues: onBlockButtonActivated (copy), v15 (copy)
	if p14.ReportedPlayer then
		onBlockButtonActivated(p14.ReportedPlayer, v15)
	end

	p14:HandleDone()
end
function v20.HandleDone(p15) -- line: 163
	p15.HubRef:SetVisibility(false, true)
end

return v20
