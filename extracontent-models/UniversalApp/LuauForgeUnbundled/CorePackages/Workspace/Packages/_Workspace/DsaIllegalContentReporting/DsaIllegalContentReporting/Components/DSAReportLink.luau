local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/DsaIllegalContentReporting/Utility/Constants")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/UIBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/React")
local styleProviderWithDefaultTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Style").StyleProviderWithDefaultTheme
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local isInExperienceUIVREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/SharedExperimentDefinition").isInExperienceUIVREnabled
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/DsaIllegalContentReporting/Localization").Hooks.useLocalization

local linkButton = UIBlox.App.Button.LinkButton
local useStyle = UIBlox.Core.Style.useStyle

local v5 = { OPEN_CUSTOM_WEBVIEW = 20 }

function LUAUFORGE_MODULE_GLOBALS_cXL_DSAReportLink()
	local v6 = useStyle()
	local v7 = usePreferredInput() == Responsive.Input.Directional

	local v8 = if isInExperienceUIVREnabled then Responsive.useIsSpatial() else false

	if v7 then
		v8 = v7
	elseif not isInExperienceUIVREnabled then
		v8 = false
	end

	local v9 = useLocalization({
		reportLinkText = "Feature.ReportAbuse.DSAIllegal.ReportLink",
		readonlyLinkText = "Feature.DynamicUI.Translation.Reporting.IllegalContentEUBody"
	})
	local v10

	if v8 then
		v10 = React.createElement(styledTextLabel, {
			layoutOrder = 2,
			size = UDim2.new(0, 500, 0, 60),
			lineHeight = 1,
			text = v9.readonlyLinkText,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			fontStyle = v6.Font.Body,
			colorStyle = v6.Theme.TextEmphasis,
			fluidSizing = true,
			richText = false
		})
	else
		v10 = React.createElement(linkButton, {
			fontStyle = v7 and "CaptionBody" or "Footer",
			size = UDim2.new(0, 100, 0, 20),
			text = v9.reportLinkText,
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

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1
	}, {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 16) }),
		Divider = React.createElement("Frame", {
			BackgroundColor3 = v6.Theme.Divider.Color,
			BackgroundTransparency = v6.Theme.Divider.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			LayoutOrder = 0
		}),
		Link = v10
	})
end

function LUAUFORGE_MODULE_GLOBALS_cXL_WrapperContainer()
	return React.createElement(styleProviderWithDefaultTheme, { withDarkTheme = true }, {
		Button = React.createElement(LUAUFORGE_MODULE_GLOBALS_cXL_DSAReportLink)
	})
end

return LUAUFORGE_MODULE_GLOBALS_cXL_WrapperContainer
