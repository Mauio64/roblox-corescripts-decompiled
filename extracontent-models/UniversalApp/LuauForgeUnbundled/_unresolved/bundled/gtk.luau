local module = require("@luauforge/bundled/gsU")

local GuiService = game:GetService("GuiService")
local roact = module.Roact
local appCommonLib = module.AppCommonLib
local robloxAppAssets = module.RobloxAppAssets
local cryo = module.Cryo

local immutable = appCommonLib.Immutable
local getImageSetData = robloxAppAssets.GetImageSetData
local getImageSetPathPattern = robloxAppAssets.GetImageSetPathPattern

local extended = roact.PureComponent:extend("ImageSetLabel")

function extended.render(p2)
	local imageSetData, v5 = getImageSetData(GuiService:GetResolutionScale())
	local v6 = imageSetData[p2.props.Image]

	if v6 then
		local forwardRef = p2.props.forwardRef
		local forwardRefsByRef = immutable.RemoveFromDictionary(
			p2.props,
			"Image",
			"ImageRectOffset",
			"ImageRectSize",
			"SliceCenter",
			"forwardRef"
		)

		forwardRefsByRef[roact.Ref] = forwardRef

		if p2.props.Image then
			forwardRefsByRef.Image = getImageSetPathPattern(v6.ImageSet)
		end

		if p2.props.ImageRectOffset then
			forwardRefsByRef.ImageRectOffset = Vector2.new(
				v6.ImageRectOffset.X + p2.props.ImageRectOffset.X * v5,
				v6.ImageRectOffset.Y + p2.props.ImageRectOffset.Y * v5
			)
		else
			forwardRefsByRef.ImageRectOffset = v6.ImageRectOffset
		end

		if p2.props.ImageRectSize then
			forwardRefsByRef.ImageRectSize = Vector2.new(
				p2.props.ImageRectSize.X * v5,
				p2.props.ImageRectSize.Y * v5
			)
		else
			forwardRefsByRef.ImageRectSize = v6.ImageRectSize
		end

		if p2.props.SliceCenter then
			forwardRefsByRef.SliceCenter = Rect.new(
				p2.props.SliceCenter.Min.X * v5,
				p2.props.SliceCenter.Min.Y * v5,
				p2.props.SliceCenter.Max.X * v5,
				p2.props.SliceCenter.Max.Y * v5
			)

			if p2.props.SliceScale then
				forwardRefsByRef.SliceScale = p2.props.SliceScale / v5
			else
				forwardRefsByRef.SliceScale = 1 / v5
			end
		end

		return roact.createElement("ImageLabel", forwardRefsByRef)
	else
		local forwardRef = p2.props.forwardRef
		local forwardRefsByRef = immutable.RemoveFromDictionary(p2.props, "forwardRef")
		forwardRefsByRef[roact.Ref] = forwardRef
		return roact.createElement("ImageLabel", forwardRefsByRef)
	end
end

return roact.forwardRef(function(p2, p3)
	return roact.createElement(extended, cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
