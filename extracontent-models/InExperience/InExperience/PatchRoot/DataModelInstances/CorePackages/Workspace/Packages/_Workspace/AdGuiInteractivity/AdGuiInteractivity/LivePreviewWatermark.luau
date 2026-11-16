local parent = script.Parent.Parent
local Roact = require(parent.Roact)

local Flags = require(script.Parent.Flags)
local fStringAdGuiLivePreviewWatermark = Flags.GetFStringAdGuiLivePreviewWatermark()
local fStringAdGuiLivePreviewWatermarkV2 = Flags.GetFStringAdGuiLivePreviewWatermarkV2()
local fStringLivePreviewPlaceId = Flags.GetFStringLivePreviewPlaceId()
local fFlagUseV2LivePreviewWatermark = Flags.GetFFlagUseV2LivePreviewWatermark()

local extended = Roact.PureComponent:extend("LivePreviewWatermark")

function extended:init()
	self.placeId = tostring(game.PlaceId)
end

function extended.render(p)
	local v

	if fStringLivePreviewPlaceId == p.placeId and p.props.IsVisible then
		return Roact.createElement("ImageLabel", {
			Image = fFlagUseV2LivePreviewWatermark and fStringAdGuiLivePreviewWatermarkV2 or fStringAdGuiLivePreviewWatermark,
			Size = fFlagUseV2LivePreviewWatermark and UDim2.new(1, 0, 1, 0) or UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = -999,
			Transparency = 1,
			ImageTransparency = fFlagUseV2LivePreviewWatermark and 0 or 0.7,
			Rotation = fFlagUseV2LivePreviewWatermark and 0 or 15
		}) or nil
	end

	return v
end

return extended
