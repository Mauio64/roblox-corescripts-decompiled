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
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useStyle = UIBlox.Core.Style.useStyle

local isSelectedDataDSAIllegalContent = require("@luauforge/deferred/gMg").isSelectedDataDSAIllegalContent

local isShowEUDSAIllegalContentReportingLink = require("@luauforge/deferred/gMg").isShowEUDSAIllegalContentReportingLink

local getFFlagDSAIllegalContentReporting = SharedFlags.GetFFlagDSAIllegalContentReporting
local getFFlagDSAVRSkipFrontendGeoCheck = SharedFlags.GetFFlagDSAVRSkipFrontendGeoCheck

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

	local v11 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Heading = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, v5.Size.Size_1200),
				BackgroundTransparency = 1
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v5.Size.Size_400),
					PaddingBottom = UDim.new(0, v5.Size.Size_400)
				}),
				Prompt = React.createElement("TextLabel", {
					Text = props.heading,
					FontFace = normalizeFontFace(v5.Typography.TitleLarge.Font),
					LayoutOrder = 1,
					TextColor3 = v5.Color.Content.Emphasis.Color3,
					TextTransparency = v5.Color.Content.Emphasis.Transparency,
					TextSize = v5.Typography.TitleLarge.FontSize,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, v5.Typography.TitleLarge.FontSize),
					BackgroundTransparency = 1
				})
			}
		),
		SelectionList = 0,
		DSANotice = 0
	}

	local createElement2 = React.createElement

	local v14 = if v8 then UDim2.new(1, 0, 0, 120) else UDim2.new(1, 0, 1, 0)
	v11.SelectionList = createElement2(
		"Frame",
		{ LayoutOrder = 2, Size = v14, BackgroundTransparency = 1 },
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

	local v15 = if v8 then React.createElement(
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
	v11.DSANotice = v15
	return createElement("Frame", v10, v11)
end
