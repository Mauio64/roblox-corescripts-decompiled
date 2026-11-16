local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local UIBlox = require(parent.UIBlox)
local React = require(parent.React)
local Style = require(parent.Style)
local Colors = Style.Colors
local FunctionalCountryCodeSelectorButton = require(AuthCommon.Components.FunctionalCountryCodeSelectorButton)
require(AuthCommon.Common.Types)
local UIBlox2 = require(parent.UIBlox)
local useStyle = UIBlox2.Core.Style.useStyle
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Graphite = Colors.Graphite

local function CountryCodeDropdownView(props)
	local dropdownVisible = props.dropdownVisible
	local countryCodeList = props.countryCodeList
	local onCountryCodeSelected = props.onCountryCodeSelected
	local position = props.position
	local maxHeight = props.maxHeight
	local v = useStyle()
	local color = v.Theme.UIDefault.Color
	local transparency = v.Theme.UIDefault.Transparency

	local function getListButtons(countryCodeList2)
		local children = {
			React.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
			React.createElement("UIPadding", { PaddingLeft = UDim.new(0, 8) })
		}
		local layoutOrder = 1

		for _, item in ipairs(countryCodeList2) do
			table.insert(children, React.createElement(FunctionalCountryCodeSelectorButton, {
				CountryCode = item,
				Size = UDim2.new(1, 0, 0, 48),
				LayoutOrder = layoutOrder,
				ListButtonProps = { TextSize = 14, SelectionCallback = onCountryCodeSelected },
				BoldPrefixEnabled = true
			}))

			layoutOrder += 1

			table.insert(
				children,
				React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = Graphite,
					LayoutOrder = layoutOrder,
					BorderSizePixel = 0
				})
			)

			layoutOrder += 1
		end

		return children
	end

	local listButtons = getListButtons(countryCodeList)
	local v2 = #countryCodeList

	if dropdownVisible then
		return (React.createElement(ImageSetLabel, {
			ZIndex = 2,
			Size = props.size or UDim2.new(1, 0, 0, maxHeight),
			Position = position,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(9, 9, 9, 9),
			Image = GetImageData("LuaApp/buttons/buttonFill"),
			ImageColor3 = v.Theme.BackgroundUIDefault.Color,
			ImageTransparency = 0
		}, {
			Boundary = React.createElement(ImageSetLabel, {
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = GetImageData("LuaApp/buttons/buttonStroke"),
				ImageColor3 = color,
				ImageTransparency = transparency
			}),
			ScrollingFrame = React.createElement("ScrollingFrame", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ScrollBarImageColor3 = Graphite,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(1, 0, 0, v2 * 49)
			}, {
				ListHolder = React.createElement(
					"Frame",
					{ Size = UDim2.new(1, -8, 1, maxHeight), BackgroundTransparency = 1 },
					listButtons
				)
			})
		}))
	end

	return nil
end

return CountryCodeDropdownView
