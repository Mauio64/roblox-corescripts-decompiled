local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local React = require(AbuseReportingParent.React)
local Cryo = require(AbuseReportingParent.Cryo)
local useAbuseReportingDesignTokens = require(AbuseReporting.Hooks.useAbuseReportingDesignTokens)
local ReportHeader = require(AbuseReporting.Components.ReportHeader)

return React.forwardRef(function(t1: {[any]: any}, p1) -- line: 15
	-- upvalues: useAbuseReportingDesignTokens (copy), React (copy), ReportHeader (copy), Cryo (copy)
	local v9 = useAbuseReportingDesignTokens()
	local uDim = UDim.new(not v9.ReportHeader.size and 0 or v9.ReportHeader.size.Y.Scale, not v9.ReportHeader.size and 0 or v9.ReportHeader.size.Y.Offset)

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v9.ReportBackground.backgroundColor and v9.ReportBackground.backgroundColor.Color3,
		ref = p1
	}, {
		Gradient = React.createElement("UIGradient", {
			Rotation = v9.ReportBackground.gradientRotation,
			Transparency = v9.ReportBackground.gradientTransparency
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = React.createElement(ReportHeader, {
			layoutOrder = 1,
			hasDivider = true,
			title = t1.title,
			subtitle = t1.subtitle
		}),
		Body = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1 - uDim.Scale, -uDim.Offset)
		}, Cryo.Dictionary.join({
			Layout = t1.children and React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			} or nil)
		}, t1.children or {}))
	})
end)
