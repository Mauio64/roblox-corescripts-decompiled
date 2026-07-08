local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local Cryo = InGameMenuDependencies.Cryo
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local PlayerLabel = require(ParentParent.Components.PlayerLabel)
local Divider = require(ParentParent.Components.Divider)
local BarOnTopScrollingFrame = require(ParentParent.Components.BarOnTopScrollingFrame)
local GameLabel = require(script.Parent.GameLabel)
local ReportButton = require(script.Parent.ReportButton)
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local withLocalization = require(ParentParent.Localization.withLocalization)
local isShowEUDSAIllegalContentReportingLink = require(CorePackages.Workspace.Packages.DsaIllegalContentReporting).isShowEUDSAIllegalContentReportingLink
local TrustAndSafety = require(RobloxGui.Modules.TrustAndSafety)
local v21 = Roact.PureComponent:extend("ReportList")
local GetFFlagIGMGamepadSelectionHistory = require(ParentParent.Flags.GetFFlagIGMGamepadSelectionHistory)

v21.validateProps = t.strictInterface({
	placeName = t.string,
	players = t.array(t.union(t.instanceIsA("Player"), t.strictInterface({
		UserId = t.integer,
		Name = t.string
	}))),
	canCaptureFocus = t.optional(t.boolean),
	currentPage = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.string) or nil,
	currentZone = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil
})

local function sortPlayers(p1, p2) -- line: 57
	return p1.Name:lower() < p2.Name:lower()
end

function v21.init(p3) -- line: 61
	-- upvalues: Roact (copy)
	p3.reportGameRef = Roact.createRef()
end
function v21.renderListEntries(p4) -- line: 65
	-- upvalues: Cryo (copy), sortPlayers (copy), Roact (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), Constants (copy), GuiService (copy), GameLabel (copy), TrustAndSafety (copy), ReportButton (copy), Divider (copy), PlayerLabel (copy)
	local v28 = Cryo.List.sort(p4.props.players, sortPlayers)
	local v29 = #v28
	local n1 = 3
	local t1 = {
		ListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}

	if GetFFlagIGMGamepadSelectionHistory() then
		t1.FocusHandler = Roact.createElement(FocusHandler, {
			isFocused = p4.props.canCaptureFocus,
			shouldForgetPreviousSelection = p4.props.currentPage == Constants.MainPagePageKey or p4.props.currentZone == 0,
			didFocus = function(p5) -- line: 83
				-- upvalues: GuiService (copy), p4 (copy)
				GuiService.SelectedCoreObject = p5 or p4.reportGameRef:getValue()
			end
		})
	end

	t1.GameReport = Roact.createElement(GameLabel, {
		gameId = game.GameId,
		gameName = p4.props.placeName,
		LayoutOrder = 1,
		[Roact.Ref] = p4.reportGameRef,
		onActivated = function() -- line: 94
			-- upvalues: TrustAndSafety (copy), Constants (copy)
			TrustAndSafety.openReportDialogForPlace(Constants.AnalyticsInGameMenuName)
		end
	}, {
		ReportButton = Roact.createElement(ReportButton, {
			LayoutOrder = 1
		})
	})

	if #v28 > 0 then
		t1["divider_" .. n1] = Roact.createElement(Divider, {
			LayoutOrder = 2,
			Size = UDim2.new(1, -80, 0, 1)
		})
	end

	for k, v in pairs(v28) do
		t1["player_" .. k] = Roact.createElement(PlayerLabel, {
			isOnline = true,
			isSelected = false,
			username = v.Name,
			userId = v.UserId,
			LayoutOrder = n1,
			onActivated = function() -- line: 118
				-- upvalues: TrustAndSafety (copy), v (copy), Constants (copy)
				TrustAndSafety.openReportDialogForPlayer(v, Constants.AnalyticsInGameMenuName)
			end
		}, {
			ReportButton = Roact.createElement(ReportButton, {
				LayoutOrder = 1,
				userId = v.UserId,
				userName = v.Name
			})
		})
		n1 += 1

		if k < v29 then
			t1["divider_" .. n1] = Roact.createElement(Divider, {
				LayoutOrder = n1,
				Size = UDim2.new(1, -80, 0, 1)
			})
			n1 += 1
		end
	end

	return t1
end
function v21.didUpdate(p6, p7, _) -- line: 144
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), GuiService (copy)
	if not GetFFlagIGMGamepadSelectionHistory() and (p6.props.canCaptureFocus and not p7.canCaptureFocus) then
		GuiService.SelectedCoreObject = p6.reportGameRef:getValue()
	end
end
function v21.render(p9) -- line: 153
	-- upvalues: isShowEUDSAIllegalContentReportingLink (copy), withLocalization (copy), Roact (copy), BarOnTopScrollingFrame (copy), ThemedTextLabel (copy)
	local v38 = #p9.props.players * 71 + 70

	if isShowEUDSAIllegalContentReportingLink() then
		return withLocalization({
			DSAFooterText = "CoreScripts.InGameMenu.Report.DSAFooter"
		})(function(p10) -- line: 159
			-- upvalues: Roact (copy), BarOnTopScrollingFrame (copy), v38 (copy), p9 (copy), ThemedTextLabel (copy)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, -50)
			}, {
				ScrollingFrame = Roact.createElement(BarOnTopScrollingFrame, {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, -50),
					CanvasSize = UDim2.new(1, 0, 0, v38)
				}, p9:renderListEntries()),
				EUWarning = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 50),
					Position = UDim2.new(0, 0, 1, -50)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 30),
						PaddingRight = UDim.new(0, 30),
						PaddingTop = UDim.new(0, 20)
					}),
					TextLabel = Roact.createElement(ThemedTextLabel, {
						fontKey = "Footer",
						themeKey = "TextEmphasis",
						TextWrapped = true,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Text = p10.DSAFooterText,
						TextXAlignment = Enum.TextXAlignment.Center
					})
				})
			})
		end)
	end

	return Roact.createElement(BarOnTopScrollingFrame, {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(1, 0, 0, v38)
	}, p9:renderListEntries())
end

return RoactRodux.UNSTABLE_connect2(function(p11, _) -- line: 204
	-- upvalues: Constants (copy), GetFFlagIGMGamepadSelectionHistory (copy)
	local name = p11.gameInfo.name
	local v42 = p11.menuPage == "Report" and (p11.displayOptions.inputType == Constants.InputType.Gamepad and (not (p11.report.dialogOpen or (p11.report.reportSentOpen or p11.respawn.dialogOpen)) and p11.currentZone == 1))

	return {
		placeName = name,
		canCaptureFocus = v42,
		currentPage = if GetFFlagIGMGamepadSelectionHistory() then p11.menuPage else nil,
		currentZone = if GetFFlagIGMGamepadSelectionHistory() then p11.currentZone else nil
	}
end)(v21)
