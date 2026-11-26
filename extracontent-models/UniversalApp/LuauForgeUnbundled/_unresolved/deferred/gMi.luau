local CorePackages = game:GetService("CorePackages")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(CorePackages.Packages.UIBlox)

local scrollingListTable = UIBlox.App.Table.ScrollingListTable
local cellTailDescription = UIBlox.App.Table.CellTailDescription
local cellHeadDetail = UIBlox.App.Table.CellHeadDetail
require("@luauforge/deferred/gMj")
local cell = UIBlox.App.Table.Cell
local Dash = require(CorePackages.Packages.Dash)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local getFFlagLuafiedReportThumbnail = SharedFlags.GetFFlagLuafiedReportThumbnail

return function(p2)
	local v5 = useDesignTokens()

	local currentList = p2.currentList

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Heading = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, v5.Size.Size_1400),
				BackgroundTransparency = 1
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v5.Size.Size_600),
					PaddingBottom = UDim.new(0, v5.Size.Size_600)
				}),
				HeadingText = React.createElement("TextLabel", {
					Text = currentList.heading,
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
		SelectionList = React.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			},
			{
				ListTable = React.createElement(scrollingListTable, {
					cells = Dash.map(currentList.listItems, function(props)
						local createElement = React.createElement
						local newUDim2 = UDim2.new

						local v10 = if getFFlagLuafiedReportThumbnail() then v5.Size.Size_1000 else v5.Size.Size_1400
						return createElement(cell, {
							size = newUDim2(1, 0, 0, v10),
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
	})
end
