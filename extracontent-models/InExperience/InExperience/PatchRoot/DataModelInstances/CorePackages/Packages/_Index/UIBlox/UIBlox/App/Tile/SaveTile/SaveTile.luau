local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local t = require(parent3.t)

local Images = require(parent2.App.ImageSet.Images)
local Tile = require(parent.BaseTile.Tile)

local extended = Roact.PureComponent:extend("SaveTile")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	hasRoundedCorners = true,
	thumbnail = Images["icons/actions/edit/add"],
	thumbnailSize = UDim2.new(0, 36, 0, 36),
	thumbnailTransparency = 0,
	isRoactGamepadEnabled = true
}

function extended.render(p)
	local hasRoundedCorners = p.props.hasRoundedCorners
	local onActivated = p.props.onActivated
	local isDisabled = p.props.isDisabled
	local thumbnail = p.props.thumbnail
	local thumbnailSize = p.props.thumbnailSize
	local thumbnailTransparency = p.props.thumbnailTransparency

	return Roact.createElement(Tile, {
		hasRoundedCorners = hasRoundedCorners,
		name = "",
		onActivated = onActivated,
		isDisabled = isDisabled,
		thumbnail = thumbnail,
		thumbnailSize = thumbnailSize,
		thumbnailTransparency = thumbnailTransparency,
		isRoactGamepadEnabled = p.props.isRoactGamepadEnabled,
		NextSelectionLeft = p.props.NextSelectionLeft,
		NextSelectionRight = p.props.NextSelectionRight,
		NextSelectionUp = p.props.NextSelectionUp,
		NextSelectionDown = p.props.NextSelectionDown,
		[Roact.Ref] = p.props.thumbnailRef
	})
end

return Roact.forwardRef(function(p, thumbnailRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { thumbnailRef = thumbnailRef }))
end)
