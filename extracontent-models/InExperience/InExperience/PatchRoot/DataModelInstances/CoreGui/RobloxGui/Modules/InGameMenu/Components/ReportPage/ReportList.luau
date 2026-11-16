local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local Cryo = InGameMenuDependencies.Cryo

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Resources.Constants)
local PlayerLabel = require(parent.Components.PlayerLabel)
local Divider = require(parent.Components.Divider)
local BarOnTopScrollingFrame = require(parent.Components.BarOnTopScrollingFrame)
local GameLabel = require(script.Parent.GameLabel)
local ReportButton = require(script.Parent.ReportButton)
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)
local withLocalization = require(parent.Localization.withLocalization)

local DsaIllegalContentReporting = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting)
local isShowEUDSAIllegalContentReportingLink = DsaIllegalContentReporting.isShowEUDSAIllegalContentReportingLink

local TrustAndSafety = require(RobloxGui.Modules.TrustAndSafety)

local extended = Roact.PureComponent:extend("ReportList")
local GetFFlagIGMGamepadSelectionHistory = require(parent.Flags.GetFFlagIGMGamepadSelectionHistory)

local strictInterface = t.strictInterface
local v = {
	placeName = t.string,
	players = t.array(t.union(t.instanceIsA("Player"), t.strictInterface({
		UserId = t.integer,
		Name = t.string
	}))),
	canCaptureFocus = t.optional(t.boolean),
	currentPage = 0,
	currentZone = 0
}
local currentPage

if GetFFlagIGMGamepadSelectionHistory() then
	currentPage = t.optional(t.string) or nil
end

v.currentPage = currentPage
v.currentZone = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil
extended.validateProps = strictInterface(v)

local function sortPlayers(p, p2): boolean
	return p.Name:lower() < p2.Name:lower()
end

function extended:init()
	self.reportGameRef = Roact.createRef()
end

function extended:renderListEntries()
	local sorted = Cryo.List.sort(self.props.players, sortPlayers)

	local v2 = #sorted
	local layoutOrder = 3

	local children = {}

	children.ListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right
	})

	if GetFFlagIGMGamepadSelectionHistory() then
		children.FocusHandler = Roact.createElement(FocusHandler, {
			isFocused = self.props.canCaptureFocus,
			shouldForgetPreviousSelection = self.props.currentPage == Constants.MainPagePageKey or self.props.currentZone == 0,
			didFocus = function(p)
				GuiService.SelectedCoreObject = p or self.reportGameRef:getValue()
			end
		})
	end

	children.GameReport = Roact.createElement(GameLabel, {
		gameId = game.GameId,
		gameName = self.props.placeName,
		LayoutOrder = 1,
		[Roact.Ref] = self.reportGameRef,
		onActivated = function()
			TrustAndSafety.openReportDialogForPlace(Constants.AnalyticsInGameMenuName)
		end
	}, {
		ReportButton = Roact.createElement(ReportButton, { LayoutOrder = 1 })
	})

	if #sorted > 0 then
		children["divider_" .. layoutOrder] = Roact.createElement(Divider, {
			LayoutOrder = 2,
			Size = UDim2.new(1, -80, 0, 1)
		})
	end

	for k, v3 in pairs(sorted) do
		children["player_" .. k] = Roact.createElement(PlayerLabel, {
			username = v3.Name,
			userId = v3.UserId,
			isOnline = true,
			isSelected = false,
			LayoutOrder = layoutOrder,
			onActivated = function()
				TrustAndSafety.openReportDialogForPlayer(v3, Constants.AnalyticsInGameMenuName)
			end
		}, {
			ReportButton = Roact.createElement(ReportButton, {
				userId = v3.UserId,
				userName = v3.Name,
				LayoutOrder = 1
			})
		})

		layoutOrder += 1

		if not (k < v2) then
			continue
		end

		children["divider_" .. layoutOrder] = Roact.createElement(Divider, {
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, -80, 0, 1)
		})

		layoutOrder += 1
	end

	return children
end

function extended.didUpdate(p, p2, _)
	if not GetFFlagIGMGamepadSelectionHistory() and p.props.canCaptureFocus and not p2.canCaptureFocus then
		GuiService.SelectedCoreObject = p.reportGameRef:getValue()
	end
end

function extended:render()
	local v2 = #self.props.players * 71 + 70

	if isShowEUDSAIllegalContentReportingLink() then
		return withLocalization({ DSAFooterText = "CoreScripts.InGameMenu.Report.DSAFooter" })(function(p)
			return Roact.createElement(
				"Frame",
				{
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, -50),
					BackgroundTransparency = 1
				},
				{
					ScrollingFrame = Roact.createElement(
						BarOnTopScrollingFrame,
						{
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, -50),
							CanvasSize = UDim2.new(1, 0, 0, v2)
						},
						self:renderListEntries()
					),
					EUWarning = Roact.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 0, 50),
							Position = UDim2.new(0, 0, 1, -50),
							BackgroundTransparency = 1
						},
						{
							Padding = Roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 30),
								PaddingRight = UDim.new(0, 30),
								PaddingTop = UDim.new(0, 20)
							}),
							TextLabel = Roact.createElement(ThemedTextLabel, {
								fontKey = "Footer",
								themeKey = "TextEmphasis",
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(1, 0, 1, 0),
								TextWrapped = true,
								Text = p.DSAFooterText,
								TextXAlignment = Enum.TextXAlignment.Center
							})
						}
					)
				}
			)
		end)
	end

	return Roact.createElement(
		BarOnTopScrollingFrame,
		{
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(1, 0, 0, v2)
		},
		self:renderListEntries()
	)
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local v2 = {
		placeName = data.gameInfo.name,
		canCaptureFocus = data.menuPage == "Report" and data.displayOptions.inputType == Constants.InputType.Gamepad and not (data.report.dialogOpen or data.report.reportSentOpen or data.respawn.dialogOpen) and data.currentZone == 1,
		currentPage = 0,
		currentZone = 0
	}
	local currentPage2

	if GetFFlagIGMGamepadSelectionHistory() then
		currentPage2 = data.menuPage
	end

	v2.currentPage = currentPage2
	local currentZone

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = data.currentZone
	end

	v2.currentZone = currentZone
	return v2
end)(extended)
