local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(CorePackages.Packages.UIBlox)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local scrollingListTable = UIBlox.App.Table.ScrollingListTable
local cellHeadDetail = UIBlox.App.Table.CellHeadDetail
local cell = UIBlox.App.Table.Cell
local Dash = require(CorePackages.Packages.Dash)
local Style = require("@game/CorePackages/Workspace/Packages/Style")
local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum
local useStyle = UIBlox.Core.Style.useStyle

local isSelectedDataDSAIllegalContent = require("@luauforge/deferred/ghA").isSelectedDataDSAIllegalContent

local isShowEUDSAIllegalContentReportingLink = require("@luauforge/deferred/ghA").isShowEUDSAIllegalContentReportingLink

local getFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting
local getFFlagDSAVRSkipFrontendGeoCheck = SharedFlags.GetFFlagDSAVRSkipFrontendGeoCheck

local Foundation2 = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation2.Utility.Flags.FoundationFontFaceMigration

return function(props)
	local v5 = useDesignTokens()
	local selectionData = props.selectionData
	local v6 = useStyle()

	React.useEffect(function()
		props.onSummaryPageMounted()
	end, {})

	local v7 = not (props.dsaText == nil) and isSelectedDataDSAIllegalContent(props.selectionData)
	local v8

	if getFFlagDSAVRSkipFrontendGeoCheck() then
		v8 = v7 and getFFlagDSAIllegalContentReporting()
	else
		v8 = v7 and isShowEUDSAIllegalContentReportingLink()
	end

	local createElement = React.createElement
	local v10 = { Size = UDim2.new(1, 0, 0, 460), BackgroundTransparency = 1 }

	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Heading = 0,
		SelectionList = 0,
		DSANotice = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		Size = UDim2.new(1, 0, 0, v5.Size.Size_1200),
		BackgroundTransparency = 1
	}

	local v13 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Size.Size_400),
			PaddingBottom = UDim.new(0, v5.Size.Size_400)
		}),
		Prompt = 0
	}

	local createElement3 = React.createElement
	local v15 = {
		Text = props.heading,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		TextColor3 = 0,
		TextTransparency = 0,
		TextSize = 0,
		TextWrapped = true,
		TextXAlignment = 0,
		Size = 0,
		BackgroundTransparency = 1
	}

	local v16 = if not foundationFontFaceMigration then mapTypographyVariantToFontEnum(v5.Typography.TitleLarge) else nil
	v15.Font = v16

	local v17 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.TitleLarge.Font) else nil
	v15.FontFace = v17

	v15.TextColor3 = v5.Color.Content.Emphasis.Color3
	v15.TextTransparency = v5.Color.Content.Emphasis.Transparency
	v15.TextSize = v5.Typography.TitleLarge.FontSize

	v15.TextXAlignment = Enum.TextXAlignment.Left
	v15.Size = UDim2.new(1, 0, 0, v5.Typography.TitleLarge.FontSize)
	v13.Prompt = createElement3("TextLabel", v15)
	children.Heading = createElement2("Frame", v12, v13)

	local createElement4 = React.createElement

	local v20 = if v8 then UDim2.new(1, 0, 0, 120) else UDim2.new(1, 0, 1, 0)
	children.SelectionList = createElement4(
		"Frame",
		{ LayoutOrder = 2, Size = v20, BackgroundTransparency = 1 },
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ListTable = React.createElement(scrollingListTable, {
				cells = Dash.map(selectionData, function(p2)
					return React.createElement(cell, {
						size = UDim2.new(1, 0, 0, v5.Size.Size_1600),
						head = React.createElement(cellHeadDetail, {
							labelText = p2.heading,
							labelTextColor = v6.Theme.TextMuted,
							labelTextFont = v6.Font.SubHeader1,
							subLabelText = p2.humanReadableText,
							subLabelTextColor = v6.Theme.TextEmphasis,
							subLabelTextFont = v6.Font.Body
						}),
						userInteractionEnabled = false
					})
				end)
			})
		}
	)

	local v21 = if v8 then React.createElement(
		"Frame",
		{ LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 120), BackgroundTransparency = 1 },
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Content = React.createElement(styledTextLabel, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 0, 60),
				lineHeight = 1,
				text = props.dsaText,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Top,
				fontStyle = v6.Font.Body,
				colorStyle = v6.Theme.TextEmphasis,
				fluidSizing = true,
				richText = false
			})
		}
	) else nil
	children.DSANotice = v21
	return createElement("Frame", v10, children)
end
