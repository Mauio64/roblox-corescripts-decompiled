local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local React = require(AbuseReportingParent.React)
local UIBlox = require(AbuseReportingParent.UIBlox)

require(AbuseReporting.Common.Types)

local useAbuseReportingDesignTokens = require(AbuseReporting.Hooks.useAbuseReportingDesignTokens)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local uDim2 = UDim2.new(1, 0, 0, 200)

local function ReportActionBar(t1: {[any]: any}) -- line: 26
	-- upvalues: useAbuseReportingDesignTokens (copy), uDim2 (copy), ButtonType (copy), React (copy), ButtonStack (copy)
	local ReportActionBar2 = useAbuseReportingDesignTokens().ReportActionBar
	local v12 = ReportActionBar2.size or uDim2
	local v13 = ReportActionBar2.buttonHeight or 48
	local v14 = ReportActionBar2.buttonWidth or 500
	local uDim2_2 = UDim2.fromOffset(v14, v13)
	local t2 = {}

	for _, v18 in t1.buttons do
		table.insert(t2, {
			buttonType = v18.buttonType or ButtonType.Secondary,
			props = {
				onActivated = v18.onActivated,
				size = uDim2_2,
				text = v18.text
			}
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = v12
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		ActionButtons = React.createElement(ButtonStack, {
			marginBetween = ReportActionBar2.buttonListHorizontalPadding,
			buttonHeight = v13,
			buttons = t2
		})
	})
end

return ReportActionBar
