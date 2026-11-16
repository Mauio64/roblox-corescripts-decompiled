local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")

local modules = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local SettingsPageFactory = require(modules.Settings.SettingsPageFactory)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local onBlockButtonActivated = require(script:FindFirstAncestor("Settings").onBlockButtonActivated)
local BlockingAnalytics = require(script:FindFirstAncestor("Settings").Analytics.BlockingAnalytics)
local Utility = require(modules.Settings.Utility)
local Theme = require(modules.Settings.Theme)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local v = BlockingAnalytics.new(LocalPlayer.UserId, { EventStream = RbxAnalyticsService })

local textSize = Theme.textSize(36)
local textSize2 = Theme.textSize(24)
local textSize3 = Theme.textSize(16)

local function Initialize()
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.TabHeader = nil
	newPage.PageListLayout.Parent = nil
	newPage.ShouldShowBottomBar = false
	newPage.ShouldShowHubBar = false
	newPage.IsPageClipped = false
	newPage.Page.Name = "ReportSentPage"
	newPage.Page.Size = UDim2.fromScale(1, 0)
	newPage.Page.AutomaticSize = Enum.AutomaticSize.Y

	newPage.Root = Create("Frame")({
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Name = "ReportSentContents",
		Parent = newPage.Page
	})

	newPage.RootLayout = Create("UIListLayout")({
		Name = "RootLayout",
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = newPage.Root
	})

	local function createTextLabel(name, text, textSize4, layoutOrder)
		return Create("TextLabel")({
			Name = name,
			LayoutOrder = layoutOrder,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = text,
			TextSize = textSize4,
			Font = Theme.font(Enum.Font.SourceSansBold, "Bold"),
			TextWrap = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = newPage.Root
		})
	end

	local function createButton(p, p2, layoutOrder, p3)
		local styledButton, v2 = Utility:MakeStyledButton(p, p2, UDim2.new(1, 0, 0, 50), p3)

		styledButton.LayoutOrder = layoutOrder
		styledButton.Parent = newPage.Root
		return styledButton, v2
	end

	local function createSpacer(p, layoutOrder)
		return Create("Frame")({
			LayoutOrder = layoutOrder,
			Name = "Spacer" .. tostring(layoutOrder),
			Size = UDim2.fromOffset(0, p),
			Parent = newPage.Root
		})
	end

	newPage.TitleLabel = createTextLabel(
		"TitleLabel",
		RobloxTranslator:FormatByKey("Feature.SettingsHub.Heading.Report.ThanksForReport"),
		textSize,
		0
	)

	newPage.BodyLabel = createTextLabel(
		"BodyLabel",
		RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Report.ReceivedReportBody"),
		textSize2,
		1
	)

	newPage.TopSpacer = createSpacer(10, 2)

	newPage.ActionHeader = createTextLabel(
		"ActionHeader",
		RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Report.OtherActionsHeader"),
		textSize3,
		3
	)
	newPage.ActionHeader.TextXAlignment = Enum.TextXAlignment.Left
	local styledButton, blockLabel = Utility:MakeStyledButton(
		"BlockButton",
		RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Block"),
		UDim2.new(1, 0, 0, 50),
		function()
			newPage:HandleBlock()
		end
	)
	styledButton.LayoutOrder = 4
	styledButton.Parent = newPage.Root

	newPage.BlockButton = styledButton
	newPage.BlockLabel = blockLabel

	newPage.MiddleSpacer = createSpacer(20, 6)
	local styledButton2, _ = Utility:MakeStyledButton(
		"DoneButton",
		RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Report.Done"),
		UDim2.new(1, 0, 0, 50),
		function()
			newPage:HandleDone()
		end
	)
	styledButton2.LayoutOrder = 7
	styledButton2.Parent = newPage.Root

	newPage.DoneButton = styledButton2

	return newPage
end

local initialize = Initialize()

function initialize:UpdateActions()
	if self.ReportedPlayer then
		self.TopSpacer.Visible = true
		self.ActionHeader.Visible = true

		local isPlayerBlockedByUserId = BlockingUtility:IsPlayerBlockedByUserId(self.ReportedPlayer.UserId)
		self.BlockButton.Visible = not isPlayerBlockedByUserId

		local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Report.BlockDisplayName", {
			DISPLAY_NAME = self.ReportedPlayer.DisplayName,
			RBX_NAME = self.ReportedPlayer.Name
		})

		self.BlockLabel.Text = formatByKey
	else
		self.TopSpacer.Visible = false
		self.ActionHeader.Visible = false
		self.BlockButton.Visible = false
	end
end

function initialize:ShowReportedPlayer(reportedPlayer)
	self.ReportedPlayer = reportedPlayer
	self:UpdateActions()

	self.HubRef:SwitchToPage(initialize, true)
end

function initialize:HandleBlock()
	if self.ReportedPlayer then
		onBlockButtonActivated(self.ReportedPlayer, v)
	end

	self:HandleDone()
end

function initialize:HandleDone()
	self.HubRef:SetVisibility(false, true)
end

return initialize
