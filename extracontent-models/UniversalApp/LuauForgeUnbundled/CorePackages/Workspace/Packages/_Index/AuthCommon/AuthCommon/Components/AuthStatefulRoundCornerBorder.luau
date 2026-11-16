local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local withStyle = UIBlox.Style.withStyle

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppAssets").GetImageData

local v5 = {
	Hover = "Hover",
	Focused = "Focused",
	Error = "Error",
	Default = "Default"
}

local extended = Roact.PureComponent:extend("AuthStatefulRoundCornerBorder")

extended.defaultProps = { borderState = v5.Default }

function extended.render(p2)
	return withStyle(function(p3)
		local size = p2.props.size
		local borderState = p2.props.borderState
		local layoutOrder = p2.props.layoutOrder

		local v6 = p2.props[Roact.Children] or {}

		local v7 = p3.Theme.UIDefault.Color
		local v8 = p3.Theme.UIDefault.Transparency

		if borderState == v5.Focused then
			v7 = p3.Theme.IconEmphasis.Color
			v8 = p3.Theme.IconEmphasis.Transparency
		elseif borderState == v5.Hover then
			v7 = p3.Theme.IconDefault.Color
			v8 = p3.Theme.IconDefault.Transparency
		elseif borderState == v5.Error then
			v7 = p3.Theme.Alert.Color
			v8 = p3.Theme.Alert.Transparency
		end

		if p2.props.borderColorOverride ~= nil then
			v7 = p2.props.borderColorOverride
		end

		if p2.props.borderTransparencyOverride ~= nil then
			v8 = p2.props.borderTransparencyOverride
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
				Boundary = Roact.createElement(imageSetLabel, {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(9, 9, 9, 9),
					Image = getImageData("LuaApp/buttons/buttonStroke") or "LuaApp/buttons/buttonStroke",
					ImageColor3 = v7,
					ImageTransparency = v8
				}),
				ContentWrapper = Roact.createElement(
					"Frame",
					{
						ZIndex = 1,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1
					},
					v6
				)
			}
		)
	end)
end

extended.BorderState = v5

return extended
