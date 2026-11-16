local parent = script:FindFirstAncestor("AuthCommon").Parent

local Roact = require(parent.Roact)

local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData

local borderState2 = { Hover = "Hover", Focused = "Focused", Error = "Error", Default = "Default" }

local extended = Roact.PureComponent:extend("AuthStatefulRoundCornerBorder")

extended.defaultProps = { borderState = borderState2.Default }

function extended.render(p)
	return withStyle(function(p2)
		local size = p.props.size
		local borderState = p.props.borderState
		local layoutOrder = p.props.layoutOrder

		local v = p.props[Roact.Children] or {}

		local imageColor = p2.Theme.UIDefault.Color
		local imageTransparency = p2.Theme.UIDefault.Transparency

		if borderState == borderState2.Focused then
			imageColor = p2.Theme.IconEmphasis.Color
			imageTransparency = p2.Theme.IconEmphasis.Transparency
		elseif borderState == borderState2.Hover then
			imageColor = p2.Theme.IconDefault.Color
			imageTransparency = p2.Theme.IconDefault.Transparency
		elseif borderState == borderState2.Error then
			imageColor = p2.Theme.Alert.Color
			imageTransparency = p2.Theme.Alert.Transparency
		end

		if p.props.borderColorOverride ~= nil then
			imageColor = p.props.borderColorOverride
		end

		if p.props.borderTransparencyOverride ~= nil then
			imageTransparency = p.props.borderTransparencyOverride
		end

		return Roact.createElement(
			"Frame",
			{
				Size = size,
				LayoutOrder = layoutOrder,
				BackgroundTransparency = 1,
				ClipsDescendants = true
			},
			{
				Boundary = Roact.createElement(ImageSetLabel, {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = GetImageData("LuaApp/buttons/buttonStroke") or "LuaApp/buttons/buttonStroke",
					ImageColor3 = imageColor,
					ImageTransparency = imageTransparency
				}),
				ContentWrapper = Roact.createElement(
					"Frame",
					{ ZIndex = 1, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
					v
				)
			}
		)
	end)
end

extended.BorderState = borderState2

return extended
