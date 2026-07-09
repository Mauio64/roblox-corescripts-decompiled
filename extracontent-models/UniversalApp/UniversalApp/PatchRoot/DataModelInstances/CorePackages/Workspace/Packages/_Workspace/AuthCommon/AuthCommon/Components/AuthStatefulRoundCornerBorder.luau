local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(Parent.RobloxAppAssets).GetImageData
local t1 = {
	Hover = "Hover",
	Focused = "Focused",
	Error = "Error",
	Default = "Default"
}
local v8 = Roact.PureComponent:extend("AuthStatefulRoundCornerBorder")

v8.defaultProps = {
	borderState = t1.Default
}

function v8.render(p1) -- line: 27
	-- upvalues: withStyle (copy), Roact (copy), t1 (copy), ImageSetLabel (copy), GetImageData (copy)
	return withStyle(function(p2) -- line: 28
		-- upvalues: p1 (copy), Roact (copy), t1 (copy), ImageSetLabel (copy), GetImageData (copy)
		local size = p1.props.size
		local borderState = p1.props.borderState
		local layoutOrder = p1.props.layoutOrder
		local v14 = p1.props[Roact.Children] or {}
		local UIDefaultColor = p2.Theme.UIDefault.Color
		local UIDefaultTransparency = p2.Theme.UIDefault.Transparency

		if borderState == t1.Focused then
			UIDefaultColor = p2.Theme.IconEmphasis.Color
			UIDefaultTransparency = p2.Theme.IconEmphasis.Transparency
		elseif borderState == t1.Hover then
			UIDefaultColor = p2.Theme.IconDefault.Color
			UIDefaultTransparency = p2.Theme.IconDefault.Transparency
		elseif borderState == t1.Error then
			UIDefaultColor = p2.Theme.Alert.Color
			UIDefaultTransparency = p2.Theme.Alert.Transparency
		end

		if p1.props.borderColorOverride ~= nil then
			UIDefaultColor = p1.props.borderColorOverride
		end

		if p1.props.borderTransparencyOverride ~= nil then
			UIDefaultTransparency = p1.props.borderTransparencyOverride
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = size,
			LayoutOrder = layoutOrder
		}, {
			Boundary = Roact.createElement(ImageSetLabel, {
				ZIndex = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(9, 9, 9, 9),
				Image = GetImageData("LuaApp/buttons/buttonStroke") or "LuaApp/buttons/buttonStroke",
				ImageColor3 = UIDefaultColor,
				ImageTransparency = UIDefaultTransparency
			}),
			ContentWrapper = Roact.createElement("Frame", {
				ZIndex = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, v14)
		})
	end)
end

v8.BorderState = t1

return v8
