local DsaIllegalContentReporting = script:FindFirstAncestor("DsaIllegalContentReporting")

local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Constants = require(DsaIllegalContentReporting.Utility.Constants)

local parent = DsaIllegalContentReporting.Parent
local UIBlox = require(parent.UIBlox)
local React = require(parent.React)
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local LinkButton = UIBlox.App.Button.LinkButton
local useStyle = UIBlox.Core.Style.useStyle

local _ = { OPEN_CUSTOM_WEBVIEW = 20 }

function DSAReportLink()
	local v = useStyle()
	local v2 = usePreferredInput() == Responsive.Input.Directional
	local v3

	if isInExperienceUIVREnabled then
		v3 = Responsive.useIsSpatial()
	else
		v3 = false
	end

	if v2 then
		v3 = v2
	elseif not isInExperienceUIVREnabled then
		v3 = false
	end

	local v4 = useLocalization({
		reportLinkText = "Feature.ReportAbuse.DSAIllegal.ReportLink",
		readonlyLinkText = "Feature.DynamicUI.Translation.Reporting.IllegalContentEUBody"
	})
	local link

	if v3 then
		link = React.createElement(StyledTextLabel, {
			layoutOrder = 2,
			size = UDim2.new(0, 500, 0, 60),
			lineHeight = 1,
			text = v4.readonlyLinkText,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			fontStyle = v.Font.Body,
			colorStyle = v.Theme.TextEmphasis,
			fluidSizing = true,
			richText = false
		})
	else
		link = React.createElement(LinkButton, {
			fontStyle = v2 and "CaptionBody" or "Footer",
			size = UDim2.new(0, 100, 0, 20),
			text = v4.reportLinkText,
			layoutOrder = 2,
			onActivated = function()
				GuiService:BroadcastNotification(
					HttpService:JSONEncode({
						title = Constants.HELP_PAGE_TITLE,
						presentationStyle = nil,
						visible = true,
						url = Constants.DSA_REPORT_LINK
					}),
					20
				)
			end
		})
	end

	return React.createElement("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 16) }),
		Divider = React.createElement("Frame", {
			BackgroundColor3 = v.Theme.Divider.Color,
			BackgroundTransparency = v.Theme.Divider.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			LayoutOrder = 0
		}),
		Link = link
	})
end

function WrapperContainer()
	return React.createElement(StyleProviderWithDefaultTheme, { withDarkTheme = true }, {
		Button = React.createElement(DSAReportLink)
	})
end

return WrapperContainer
