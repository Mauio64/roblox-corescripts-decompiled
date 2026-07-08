local DsaIllegalContentReporting = script:FindFirstAncestor("DsaIllegalContentReporting")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Constants = require(DsaIllegalContentReporting.Utility.Constants)
local DsaIllegalContentReportingParent = DsaIllegalContentReporting.Parent
local UIBlox = require(DsaIllegalContentReportingParent.UIBlox)
local React = require(DsaIllegalContentReportingParent.React)
local StyleProviderWithDefaultTheme = require(DsaIllegalContentReportingParent.Style).StyleProviderWithDefaultTheme
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Responsive = require(DsaIllegalContentReportingParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local isInExperienceUIVREnabled = require(DsaIllegalContentReportingParent.SharedExperimentDefinition).isInExperienceUIVREnabled
local useLocalization = require(DsaIllegalContentReportingParent.Localization).Hooks.useLocalization
local LinkButton = UIBlox.App.Button.LinkButton
local useStyle = UIBlox.Core.Style.useStyle
local _ = {
	OPEN_CUSTOM_WEBVIEW = 20
}

function DSAReportLink() -- line: 26
	-- upvalues: useStyle (copy), usePreferredInput (copy), Responsive (copy), isInExperienceUIVREnabled (copy), useLocalization (copy), React (copy), StyledTextLabel (copy), LinkButton (copy), HttpService (copy), Constants (copy), GuiService (copy)
	local v17 = useStyle()
	local v18 = usePreferredInput() == Responsive.Input.Directional
	local v19 = false

	if isInExperienceUIVREnabled then
		v19 = Responsive.useIsSpatial()
	end

	local v20 = v18 or not not isInExperienceUIVREnabled and v19
	local v21 = useLocalization({
		reportLinkText = "Feature.ReportAbuse.DSAIllegal.ReportLink",
		readonlyLinkText = "Feature.DynamicUI.Translation.Reporting.IllegalContentEUBody"
	})
	local v22 = if not v20 then React.createElement(LinkButton, {
		layoutOrder = 2,
		fontStyle = not v18 and "Footer" or "CaptionBody",
		size = UDim2.new(0, 100, 0, 20),
		text = v21.reportLinkText,
		onActivated = function() -- line: 59
			-- upvalues: HttpService (copy), Constants (copy), GuiService (copy)
			local json = HttpService:JSONEncode({
				presentationStyle = nil,
				visible = true,
				title = Constants.HELP_PAGE_TITLE,
				url = Constants.DSA_REPORT_LINK
			})

			GuiService:BroadcastNotification(json, 20)
		end
	}) else React.createElement(StyledTextLabel, {
		layoutOrder = 2,
		lineHeight = 1,
		fluidSizing = true,
		richText = false,
		size = UDim2.new(0, 500, 0, 60),
		text = v21.readonlyLinkText,
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		fontStyle = v17.Font.Body,
		colorStyle = v17.Theme.TextEmphasis
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 16)
		}),
		Divider = React.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 0,
			BackgroundColor3 = v17.Theme.Divider.Color,
			BackgroundTransparency = v17.Theme.Divider.Transparency,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}),
		Link = v22
	})
end
function WrapperContainer() -- line: 95
	-- upvalues: React (copy), StyleProviderWithDefaultTheme (copy)
	return React.createElement(StyleProviderWithDefaultTheme, {
		withDarkTheme = true
	}, {
		Button = React.createElement(DSAReportLink)
	})
end

return WrapperContainer
