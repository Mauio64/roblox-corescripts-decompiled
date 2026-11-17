local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BaseTile = require(Foundation.Components.Tile.BaseTile)
local BaseTileMediaClipping = require(Foundation.Enums.BaseTileMediaClipping)
local ControlState = require(Foundation.Enums.ControlState)
local Metadata = require(Foundation.Components.Metadata)
local MetadataSize = require(Foundation.Enums.MetadataSize)
local Text = require(Foundation.Components.Text)
local TileAspectRatio = require(Foundation.Enums.TileAspectRatio)
require(script.Parent.TileIconIndicator)
local TileIconMedia = require(script.Parent.TileIconMedia)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { Size = UDim2.fromScale(1, 0), testId = "--foundation-tile-icon" }

local function TileIcon(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local controlState, onStateChanged = React.useBinding(ControlState.Default)

	local createElement = React.createElement
	local children = {
		mediaAspectRatio = TileAspectRatio.Ratio1x1,
		mediaBackgroundStyle = v3.Color.None,
		mediaClippingStyle = BaseTileMediaClipping.None,
		mediaContent = 0,
		title = 0,
		metadata = 0,
		onActivated = 0,
		onStateChanged = 0,
		Size = 0,
		maxSize = 0,
		AnchorPoint = 0,
		LayoutOrder = 0,
		Position = 0,
		Visible = 0,
		ZIndex = 0,
		onAbsoluteSizeChanged = 0,
		onAbsolutePositionChanged = 0,
		testId = 0,
		ref = 0
	}
	local createElement2 = React.createElement
	local icon

	if typeof(v2.icon) == "table" then
		icon = v2.icon.name
	else
		icon = v2.icon
	end

	local iconVariant

	if typeof(v2.icon) == "table" then
		iconVariant = v2.icon.variant
	end

	local v4 = {
		icon = icon,
		iconVariant = iconVariant,
		indicator = v2.indicator,
		controlState = 0,
		testId = 0
	}

	if not v2.onActivated then
		controlState = nil
	end

	v4.controlState = controlState
	v4.testId = v2.testId
	children.mediaContent = createElement2(TileIconMedia, v4)

	children.title = React.createElement(Text, {
		Text = v2.label,
		tag = "size-full-0 auto-y text-title-small text-align-x-center text-truncate-split content-emphasis",
		testId = `{v2.testId}--label`
	})
	local metadata

	if v2.metadata then
		metadata = React.createElement(View, { tag = "col align-x-center size-full-0 auto-y" }, {
			Metadata = React.createElement(Metadata, {
				text = v2.metadata,
				size = MetadataSize.Small,
				testId = `{v2.testId}--metadata`
			})
		})
	end

	children.metadata = metadata

	children.onActivated = v2.onActivated

	if not v2.onActivated then
		onStateChanged = nil
	end

	children.onStateChanged = onStateChanged
	children.Size = v2.Size
	children.maxSize = Vector2.new(v3.Size.Size_2400, 1e999)
	children.AnchorPoint = v2.AnchorPoint
	children.LayoutOrder = v2.LayoutOrder
	children.Position = v2.Position
	children.Visible = v2.Visible
	children.ZIndex = v2.ZIndex
	children.onAbsoluteSizeChanged = v2.onAbsoluteSizeChanged
	children.onAbsolutePositionChanged = v2.onAbsolutePositionChanged
	children.testId = v2.testId
	children.ref = ref
	return createElement(BaseTile, children)
end

return React.memo(React.forwardRef(TileIcon))
