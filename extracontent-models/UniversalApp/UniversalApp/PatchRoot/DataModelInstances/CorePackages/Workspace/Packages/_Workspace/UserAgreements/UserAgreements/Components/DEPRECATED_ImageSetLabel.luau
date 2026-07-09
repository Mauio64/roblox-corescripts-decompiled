local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local GuiService = game:GetService("GuiService")
local Roact = dependencies.Roact
local AppCommonLib = dependencies.AppCommonLib
local RobloxAppAssets = dependencies.RobloxAppAssets
local Cryo = dependencies.Cryo
local Immutable = AppCommonLib.Immutable
local GetImageSetData = RobloxAppAssets.GetImageSetData
local GetImageSetPathPattern = RobloxAppAssets.GetImageSetPathPattern
local v11 = Roact.PureComponent:extend("ImageSetLabel")

function v11.render(p1) -- line: 17
	-- upvalues: GetImageSetData (copy), GuiService (copy), Immutable (copy), Roact (copy), GetImageSetPathPattern (copy)
	local v13, v14 = GetImageSetData(GuiService:GetResolutionScale())
	local v15 = v13[p1.props.Image]

	if not v15 then
		local forwardRef = p1.props.forwardRef
		local v17 = Immutable.RemoveFromDictionary(p1.props, "forwardRef")

		v17[Roact.Ref] = forwardRef

		return Roact.createElement("ImageLabel", v17)
	end

	local forwardRef = p1.props.forwardRef
	local v19 = Immutable.RemoveFromDictionary(p1.props, "Image", "ImageRectOffset", "ImageRectSize", "SliceCenter", "forwardRef")

	v19[Roact.Ref] = forwardRef

	if p1.props.Image then
		v19.Image = GetImageSetPathPattern(v15.ImageSet)
	end

	if p1.props.ImageRectOffset then
		v19.ImageRectOffset = Vector2.new(v15.ImageRectOffset.X + p1.props.ImageRectOffset.X * v14, v15.ImageRectOffset.Y + p1.props.ImageRectOffset.Y * v14)
	else
		v19.ImageRectOffset = v15.ImageRectOffset
	end

	if p1.props.ImageRectSize then
		v19.ImageRectSize = Vector2.new(p1.props.ImageRectSize.X * v14, p1.props.ImageRectSize.Y * v14)
	else
		v19.ImageRectSize = v15.ImageRectSize
	end

	if p1.props.SliceCenter then
		v19.SliceCenter = Rect.new(p1.props.SliceCenter.Min.X * v14, p1.props.SliceCenter.Min.Y * v14, p1.props.SliceCenter.Max.X * v14, p1.props.SliceCenter.Max.Y * v14)

		if p1.props.SliceScale then
			v19.SliceScale = p1.props.SliceScale / v14
		else
			v19.SliceScale = 1 / v14
		end
	end

	return Roact.createElement("ImageLabel", v19)
end

return Roact.forwardRef(function(p2, p3) -- line: 77
	-- upvalues: Roact (copy), v11 (copy), Cryo (copy)
	return Roact.createElement(v11, Cryo.Dictionary.join(p2, {
		forwardRef = p3
	}))
end)
