local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").Colors
local FunctionalCountryCodeSelectorButton = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/FunctionalCountryCodeSelectorButton")
require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/Types")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox").Core.Style.useStyle
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppAssets").GetImageData
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local graphite = colors.Graphite

local function CountryCodeDropdownView(props)
	local dropdownVisible = props.dropdownVisible
	local countryCodeList = props.countryCodeList
	local onCountryCodeSelected = props.onCountryCodeSelected
	local position = props.position
	local maxHeight = props.maxHeight
	local v5 = useStyle()
	local color = v5.Theme.UIDefault.Color
	local transparency = v5.Theme.UIDefault.Transparency

	local function getListButtons(countryCodeList2)
		local children = {
			React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			React.createElement("UIPadding", { PaddingLeft = UDim.new(0, 8) })
		}
		local v6 = 1

		for i, item in ipairs(countryCodeList2) do
			table.insert(children, React.createElement(FunctionalCountryCodeSelectorButton, {
				CountryCode = item,
				Size = UDim2.new(1, 0, 0, 48),
				LayoutOrder = v6,
				ListButtonProps = {
					TextSize = 14,
					SelectionCallback = onCountryCodeSelected
				},
				BoldPrefixEnabled = true
			}))

			local v7 = v6 + 1

			table.insert(
				children,
				React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = graphite,
					LayoutOrder = v7,
					BorderSizePixel = 0
				})
			)

			v6 = v7 + 1
		end

		return children
	end

	local listButtons = getListButtons(countryCodeList)
	local v6 = #countryCodeList

	if dropdownVisible then
		return (React.createElement(imageSetLabel, {
			ZIndex = 2,
			Size = props.size or UDim2.new(1, 0, 0, maxHeight),
			Position = position,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(9, 9, 9, 9),
			Image = getImageData("LuaApp/buttons/buttonFill"),
			ImageColor3 = v5.Theme.BackgroundUIDefault.Color,
			ImageTransparency = 0
		}, {
			Boundary = React.createElement(imageSetLabel, {
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = getImageData("LuaApp/buttons/buttonStroke"),
				ImageColor3 = color,
				ImageTransparency = transparency
			}),
			ScrollingFrame = React.createElement("ScrollingFrame", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ScrollBarImageColor3 = graphite,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(1, 0, 0, v6 * 49)
			}, {
				ListHolder = React.createElement(
					"Frame",
					{
						Size = UDim2.new(1, -8, 1, maxHeight),
						BackgroundTransparency = 1
					},
					listButtons
				)
			})
		}))
	end

	return nil
end

return CountryCodeDropdownView
