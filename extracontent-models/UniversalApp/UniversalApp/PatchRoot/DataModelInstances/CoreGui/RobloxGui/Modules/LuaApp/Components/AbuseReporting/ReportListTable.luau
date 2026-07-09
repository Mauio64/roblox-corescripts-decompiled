local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ScrollingListTable = UIBlox.App.Table.ScrollingListTable
local CellTailDescription = UIBlox.App.Table.CellTailDescription
local CellHeadDetail = UIBlox.App.Table.CellHeadDetail

require(Modules.LuaApp.Components.AbuseReporting.ReportTypes)

local Cell = UIBlox.App.Table.Cell
local Dash = require(CorePackages.Packages.Dash)
local Style = require(CorePackages.Workspace.Packages.Style)
local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum
local GetFFlagLuafiedReportThumbnail = SharedFlags.GetFFlagLuafiedReportThumbnail

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useDesignTokens (copy), React (copy), mapTypographyVariantToFontEnum (copy), ScrollingListTable (copy), Dash (copy), Cell (copy), GetFFlagLuafiedReportThumbnail (copy), CellHeadDetail (copy), CellTailDescription (copy)
	local v16 = useDesignTokens()
	local currentList = t1.currentList

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Heading = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v16.Size.Size_1400)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v16.Size.Size_600),
				PaddingBottom = UDim.new(0, v16.Size.Size_600)
			}),
			HeadingText = React.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = currentList.heading,
				Font = mapTypographyVariantToFontEnum(v16.Typography.TitleLarge),
				TextColor3 = v16.Color.Content.Emphasis.Color3,
				TextTransparency = v16.Color.Content.Emphasis.Transparency,
				TextSize = v16.Typography.TitleLarge.FontSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, v16.Typography.TitleLarge.FontSize)
			})
		}),
		SelectionList = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			ListTable = React.createElement(ScrollingListTable, {
				cells = Dash.map(currentList.listItems, function(p1) -- line: 71
					-- upvalues: React (copy), Cell (copy), GetFFlagLuafiedReportThumbnail (copy), v16 (copy), CellHeadDetail (copy), CellTailDescription (copy), t1 (copy), currentList (copy)
					return React.createElement(Cell, {
						size = UDim2.new(1, 0, 0, if not GetFFlagLuafiedReportThumbnail() then v16.Size.Size_1400 else v16.Size.Size_1000),
						head = React.createElement(CellHeadDetail, {
							labelText = p1.humanReadableText
						}),
						tail = React.createElement(CellTailDescription, {
							text = "",
							showArrow = true
						}),
						onActivated = function() -- line: 86
							-- upvalues: t1 (copy), p1 (copy), currentList (copy)
							t1.onSelect(p1.tagValues, currentList.heading, p1.humanReadableText, p1.nextList)
						end
					})
				end)
			})
		})
	})
end
