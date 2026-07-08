local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local Flags = require(script.Parent.Flags)
local v4 = Flags.GetFStringAdGuiLivePreviewWatermark()
local v5 = Flags.GetFStringAdGuiLivePreviewWatermarkV2()
local v6 = Flags.GetFStringLivePreviewPlaceId()
local v7 = Flags.GetFFlagUseV2LivePreviewWatermark()
local v8 = Roact.PureComponent:extend("LivePreviewWatermark")

function v8.init(p1) -- line: 13
	p1.placeId = tostring(game.PlaceId)
end
function v8.render(p2) -- line: 17
	-- upvalues: v6 (copy), Roact (copy), v7 (copy), v5 (copy), v4 (copy)
	return v6 == p2.placeId and p2.props.IsVisible and Roact.createElement("ImageLabel", {
		ZIndex = -999,
		Transparency = 1,
		Image = v7 and v5 or v4,
		Size = v7 and UDim2.new(1, 0, 1, 0) or UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ScaleType = Enum.ScaleType.Fit,
		ImageTransparency = not v7 and 0.7 or 0,
		Rotation = not v7 and 15 or 0
	}) or nil
end

return v8
