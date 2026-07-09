local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local React = require(AbuseReportingParent.React)

require(AbuseReporting.Common.Types)

local useAbuseReportingDesignTokens = require(AbuseReporting.Hooks.useAbuseReportingDesignTokens)
local uDim2 = UDim2.new(1, 0, 1, 0)

local function ReportHeader(t1: {[any]: any}) -- line: 26
	-- upvalues: useAbuseReportingDesignTokens (copy), uDim2 (copy), React (copy)
	local ReportHeader2 = useAbuseReportingDesignTokens().ReportHeader
	local v9 = ReportHeader2.size or uDim2
	local v10 = ReportHeader2.dividerVerticalPadding or 36
	local v11 = ReportHeader2.dividerHeight or 2

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v9,
		LayoutOrder = t1.layoutOrder
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UIPadding = if not ReportHeader2.verticalPadding then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, ReportHeader2.verticalPadding),
			PaddingBottom = UDim.new(0, ReportHeader2.verticalPadding)
		}),
		Title = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = t1.title,
			Font = ReportHeader2.titleFontStyle and ReportHeader2.titleFontStyle.Font,
			TextColor3 = ReportHeader2.titleTextColor and ReportHeader2.titleTextColor.Color3,
			TextSize = ReportHeader2.titleFontStyle and ReportHeader2.titleFontStyle.FontSize,
			LineHeight = ReportHeader2.titleFontStyle and ReportHeader2.titleFontStyle.LineHeight
		}),
		Subtitle = if not t1.subtitle then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = t1.subtitle,
			Font = ReportHeader2.subtitleFontStyle and ReportHeader2.subtitleFontStyle.Font,
			TextColor3 = ReportHeader2.subtitleTextColor and ReportHeader2.subtitleTextColor.Color3,
			TextSize = ReportHeader2.subtitleFontStyle and ReportHeader2.subtitleFontStyle.FontSize,
			LineHeight = ReportHeader2.subtitleFontStyle and ReportHeader2.subtitleFontStyle.LineHeight
		}),
		Decoration = if not t1.hasDivider then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v10)
		}, {
			Divider = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v11),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = ReportHeader2.dividerColor and ReportHeader2.dividerColor.Color3,
				BackgroundTransparency = ReportHeader2.dividerColor and ReportHeader2.dividerColor.Transparency or 0.8
			})
		})
	})
end

return ReportHeader
