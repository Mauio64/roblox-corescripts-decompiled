local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BaseTile = require(Foundation.Components.Tile.BaseTile)
local ControlState = require(Foundation.Enums.ControlState)
local Metadata = require(Foundation.Components.Metadata)
local MetadataSize = require(Foundation.Enums.MetadataSize)
local Text = require(Foundation.Components.Text)
local TileAspectRatio = require(Foundation.Enums.TileAspectRatio)
local TilePlayerAvatar = require(script.Parent.TilePlayerAvatar)
require(Foundation.Components.Types)
require(Foundation.Enums.UserPresence)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { Size = UDim2.fromScale(1, 0), testId = "--foundation-tile-player" }

local function TilePlayer(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local controlState, onStateChanged = React.useBinding(ControlState.Default)

	local createElement = React.createElement
	local children = {
		mediaAspectRatio = TileAspectRatio.Ratio1x1,
		mediaBackgroundStyle = v3.Color.None,
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
	local v4 = {
		userId = v2.userId,
		userPresence = v2.userPresence,
		includeProfileFrame = v2.includeProfileFrame,
		backgroundStyle = v2.backgroundStyle,
		controlState = 0,
		testId = 0
	}

	if not v2.onActivated then
		controlState = nil
	end

	v4.controlState = controlState
	v4.testId = v2.testId
	children.mediaContent = createElement2(TilePlayerAvatar, v4)

	children.title = React.createElement(Text, {
		Text = v2.title,
		tag = "size-full-0 auto-y text-title-small text-align-x-center text-truncate-split content-emphasis",
		testId = `{v2.testId}--title`
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

return React.memo(React.forwardRef(TilePlayer))
