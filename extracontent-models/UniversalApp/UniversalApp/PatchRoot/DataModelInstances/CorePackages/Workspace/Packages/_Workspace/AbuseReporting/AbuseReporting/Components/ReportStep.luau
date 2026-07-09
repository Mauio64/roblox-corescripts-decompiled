local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local React = require(AbuseReportingParent.React)

require(AbuseReporting.Common.Types)

local useAbuseReportingDesignTokens = require(AbuseReporting.Hooks.useAbuseReportingDesignTokens)
local ReportActionBar = require(AbuseReporting.Components.ReportActionBar)
local uDim2 = UDim2.fromScale(1, 1)
local uDim = UDim.new(0, 10)

local function ReportStep(t1: {[any]: any}) -- line: 18
	-- upvalues: useAbuseReportingDesignTokens (copy), uDim2 (copy), uDim (copy), React (copy), ReportActionBar (copy)
	local v10 = useAbuseReportingDesignTokens()
	local ReportStep2 = v10.ReportStep
	local v12 = ReportStep2.size and ReportStep2.size or uDim2
	local v13 = ReportStep2.verticalPadding or uDim
	local uDim3 = UDim.new((v10.ReportActionBar.size and v10.ReportActionBar.size.Y.Scale or 0) + 2 * v13.Scale, (v10.ReportActionBar.size and v10.ReportActionBar.size.Y.Offset or 0) + 2 * v13.Offset)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v12
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = v13,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = t1.title and React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = t1.title,
			Font = ReportStep2.headerFontStyle and ReportStep2.headerFontStyle.Font,
			TextColor3 = ReportStep2.headerTextColor and ReportStep2.headerTextColor.Color3,
			TextSize = ReportStep2.headerFontStyle and ReportStep2.headerFontStyle.FontSize,
			LineHeight = ReportStep2.headerFontStyle and ReportStep2.headerFontStyle.LineHeight
		}) or nil,
		Body = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1 - uDim3.Scale, -uDim3.Offset)
		}, t1.children),
		Actions = React.createElement(ReportActionBar, {
			layoutOrder = 3,
			buttons = t1.buttons,
			tokens = v10.ReportActionBar
		})
	})
end

return ReportStep
