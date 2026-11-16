local CorePackages = game:GetService("CorePackages")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(CorePackages.Packages.UIBlox)

local scrollingListTable = UIBlox.App.Table.ScrollingListTable
local cellTailDescription = UIBlox.App.Table.CellTailDescription
local cellHeadDetail = UIBlox.App.Table.CellHeadDetail
require("@luauforge/deferred/ghD")
local cell = UIBlox.App.Table.Cell
local Dash = require(CorePackages.Packages.Dash)
local Style = require("@game/CorePackages/Workspace/Packages/Style")
local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum

local getFFlagLuafiedReportThumbnail = SharedFlags.GetFFlagLuafiedReportThumbnail

local Foundation2 = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation2.Utility.Flags.FoundationFontFaceMigration

return function(p2)
	local v5 = useDesignTokens()

	local currentList = p2.currentList

	local createElement = React.createElement
	local v7 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Heading = 0,
		SelectionList = 0
	}

	local createElement2 = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, v5.Size.Size_1400),
		BackgroundTransparency = 1
	}

	local v10 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Size.Size_600),
			PaddingBottom = UDim.new(0, v5.Size.Size_600)
		}),
		HeadingText = 0
	}

	local createElement3 = React.createElement
	local v12 = {
		Text = currentList.heading,
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

	local v13 = if not foundationFontFaceMigration then mapTypographyVariantToFontEnum(v5.Typography.TitleLarge) else nil
	v12.Font = v13

	local v14 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.TitleLarge.Font) else nil
	v12.FontFace = v14

	v12.TextColor3 = v5.Color.Content.Emphasis.Color3
	v12.TextTransparency = v5.Color.Content.Emphasis.Transparency
	v12.TextSize = v5.Typography.TitleLarge.FontSize

	v12.TextXAlignment = Enum.TextXAlignment.Left
	v12.Size = UDim2.new(1, 0, 0, v5.Typography.TitleLarge.FontSize)
	v10.HeadingText = createElement3("TextLabel", v12)
	children.Heading = createElement2("Frame", v9, v10)

	children.SelectionList = React.createElement(
		"Frame",
		{ LayoutOrder = 2, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
		{
			ListTable = React.createElement(scrollingListTable, {
				cells = Dash.map(currentList.listItems, function(props)
					local createElement4 = React.createElement
					local newUDim2 = UDim2.new

					local v19 = if getFFlagLuafiedReportThumbnail() then v5.Size.Size_1000 else v5.Size.Size_1400
					return createElement4(cell, {
						size = newUDim2(1, 0, 0, v19),
						head = React.createElement(cellHeadDetail, {
							labelText = props.humanReadableText
						}),
						tail = React.createElement(cellTailDescription, {
							text = "",
							showArrow = true
						}),
						onActivated = function()
							p2.onSelect(
								props.tagValues,
								currentList.heading,
								props.humanReadableText,
								props.nextList
							)
						end
					})
				end)
			})
		}
	)
	return createElement("Frame", v7, children)
end
