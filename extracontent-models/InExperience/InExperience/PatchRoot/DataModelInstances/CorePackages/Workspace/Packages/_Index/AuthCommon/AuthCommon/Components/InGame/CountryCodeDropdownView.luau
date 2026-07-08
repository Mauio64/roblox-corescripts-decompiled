local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local UIBlox = require(AuthCommonParent.UIBlox)
local React = require(AuthCommonParent.React)
local Colors = require(AuthCommonParent.Style).Colors
local FunctionalCountryCodeSelectorButton = require(AuthCommon.Components.FunctionalCountryCodeSelectorButton)

require(AuthCommon.Common.Types)

local useStyle = require(AuthCommonParent.UIBlox).Core.Style.useStyle
local GetImageData = require(AuthCommonParent.RobloxAppAssets).GetImageData
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Graphite = Colors.Graphite

local function CountryCodeDropdownView(t1: {[any]: any}) -- line: 28
	-- upvalues: useStyle (copy), React (copy), FunctionalCountryCodeSelectorButton (copy), Graphite (copy), ImageSetLabel (copy), GetImageData (copy)
	local dropdownVisible = t1.dropdownVisible
	local countryCodeList = t1.countryCodeList
	local onCountryCodeSelected = t1.onCountryCodeSelected
	local position = t1.position
	local maxHeight = t1.maxHeight
	local v18 = useStyle()
	local UIDefaultColor = v18.Theme.UIDefault.Color
	local UIDefaultTransparency = v18.Theme.UIDefault.Transparency

	local function getListButtons(p1) -- line: 38
		-- upvalues: React (copy), FunctionalCountryCodeSelectorButton (copy), onCountryCodeSelected (copy), Graphite (copy)
		local t2 = {
			React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8)
			})
		}
		local n1 = 1

		for _, v in ipairs(p1) do
			table.insert(t2, React.createElement(FunctionalCountryCodeSelectorButton, {
				BoldPrefixEnabled = true,
				CountryCode = v,
				Size = UDim2.new(1, 0, 0, 48),
				LayoutOrder = n1,
				ListButtonProps = {
					TextSize = 14,
					SelectionCallback = onCountryCodeSelected
				}
			}))

			local v29 = n1 + 1

			table.insert(t2, React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Graphite,
				LayoutOrder = v29
			}))
			n1 = v29 + 1
		end

		return t2
	end

	local v22 = getListButtons(countryCodeList)
	local v23 = #countryCodeList

	if dropdownVisible then
		return (React.createElement(ImageSetLabel, {
			ZIndex = 2,
			BackgroundTransparency = 1,
			ImageTransparency = 0,
			Size = t1.size or UDim2.new(1, 0, 0, maxHeight),
			Position = position,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(9, 9, 9, 9),
			Image = GetImageData("LuaApp/buttons/buttonFill"),
			ImageColor3 = v18.Theme.BackgroundUIDefault.Color
		}, {
			Boundary = React.createElement(ImageSetLabel, {
				ZIndex = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = GetImageData("LuaApp/buttons/buttonStroke"),
				ImageColor3 = UIDefaultColor,
				ImageTransparency = UIDefaultTransparency
			}),
			ScrollingFrame = React.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ScrollBarImageColor3 = Graphite,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				CanvasSize = UDim2.new(1, 0, 0, v23 * 49)
			}, {
				ListHolder = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -8, 1, maxHeight)
				}, v22)
			})
		}))
	end

	return nil
end

return CountryCodeDropdownView
