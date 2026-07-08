local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local ParentParent2Parent = ParentParent2.Parent
local Roact = require(ParentParent2Parent.Roact)
local Cryo = require(ParentParent2Parent.Cryo)
local t = require(ParentParent2Parent.t)
local Images = require(ParentParent2.App.ImageSet.Images)
local Tile = require(ParentParent.BaseTile.Tile)
local v9 = Roact.PureComponent:extend("SaveTile")

v9.validateProps = t.strictInterface({
	hasRoundedCorners = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
	isDisabled = t.optional(t.boolean),
	thumbnail = t.optional(t.union(t.string, t.table)),
	thumbnailSize = t.optional(t.UDim2),
	thumbnailTransparency = t.optional(t.number),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	thumbnailRef = t.optional(t.table),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v9.defaultProps = {
	hasRoundedCorners = true,
	thumbnailTransparency = 0,
	isRoactGamepadEnabled = true,
	thumbnail = Images["icons/actions/edit/add"],
	thumbnailSize = UDim2.new(0, 36, 0, 36)
}

function v9.render(p1) -- line: 54
	-- upvalues: Roact (copy), Tile (copy)
	local hasRoundedCorners = p1.props.hasRoundedCorners
	local onActivated = p1.props.onActivated
	local isDisabled = p1.props.isDisabled
	local thumbnail = p1.props.thumbnail
	local thumbnailSize = p1.props.thumbnailSize
	local thumbnailTransparency = p1.props.thumbnailTransparency

	return Roact.createElement(Tile, {
		hasRoundedCorners = hasRoundedCorners,
		name = "",
		onActivated = onActivated,
		isDisabled = isDisabled,
		thumbnail = thumbnail,
		thumbnailSize = thumbnailSize,
		thumbnailTransparency = thumbnailTransparency,
		isRoactGamepadEnabled = p1.props.isRoactGamepadEnabled,
		NextSelectionLeft = p1.props.NextSelectionLeft,
		NextSelectionRight = p1.props.NextSelectionRight,
		NextSelectionUp = p1.props.NextSelectionUp,
		NextSelectionDown = p1.props.NextSelectionDown,
		[Roact.Ref] = p1.props.thumbnailRef
	})
end

return Roact.forwardRef(function(p2, p3) -- line: 79
	-- upvalues: Roact (copy), v9 (copy), Cryo (copy)
	return Roact.createElement(v9, Cryo.Dictionary.join(p2, {
		thumbnailRef = p3
	}))
end)
