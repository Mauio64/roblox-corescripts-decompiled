local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BaseTileContent = require(script.Parent.BaseTileContent)
local BaseTileMedia = require(script.Parent.BaseTileMedia)
local TileAspectRatio = require(Foundation.Enums.TileAspectRatio)
require(Foundation.Components.Types)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local joinBindables = require(Foundation.Utility.joinBindables)
local mapBindable = require(Foundation.Utility.mapBindable)
local useCursor = require(Foundation.Providers.Cursor.useCursor)
local useGuiControlState = require(Foundation.Utility.Control.useGuiControlState)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local function isHeightBounded(udim: UDim2): boolean -- 2 equivalent calls inferred from this helper
	return udim.Y.Scale ~= 0 or udim.Y.Offset ~= 0
end

local v = {
	mediaAspectRatio = TileAspectRatio.Ratio16x9,
	isContained = false,
	testId = "--foundation-base-tile"
}

local function BaseTile(p, p2)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local selectionImageObject = useCursor((React.useMemo(function()
		return {
			radius = UDim.new(0, v3.Radius.Medium),
			offset = v3.Size.Size_200,
			borderWidth = v3.Stroke.Thicker
		}
	end, { v3 })))
	local size = v2.Size or UDim2.fromOffset(250 * v3.Config.UI.Scale, 0)
	local automaticSize = mapBindable(size, function(udim: UDim2)
		if isHeightBounded(udim) then -- inferred equivalent call
			return Enum.AutomaticSize.None
		end

		return Enum.AutomaticSize.Y
	end)
	local v4 = typeof(size) ~= "UDim2" or size.Y.Scale ~= 0 or size.Y.Offset ~= 0

	local ref = React.useRef(nil)

	if v4 and ref.current == nil then
		local binding, setTileHeight = React.createBinding(0)
		local binding2, setContentHeight = React.createBinding(0)
		ref.current = {
			tileHeight = binding,
			setTileHeight = setTileHeight,
			contentHeight = binding2,
			setContentHeight = setContentHeight
		}
	end

	local onAbsoluteSizeChanged = v2.onAbsoluteSizeChanged
	local v5 = React.useMemo(function()
		local current = ref.current

		if v4 and current ~= nil then
			return {
				mediaMaxHeight = joinBindables(
					{
						size = size,
						tileHeight = current.tileHeight,
						contentHeight = current.contentHeight
					},
					function(data)
						if isHeightBounded(data.size) then -- inferred equivalent call
							return (math.max(data.tileHeight - data.contentHeight, 0))
						end

						return nil
					end
				),
				onTileAbsoluteSizeChanged = function(p3)
					current.setTileHeight(p3.AbsoluteSize.Y)

					if onAbsoluteSizeChanged ~= nil then
						onAbsoluteSizeChanged(p3)
					end
				end,
				onContentAbsoluteSizeChanged = function(p3)
					current.setContentHeight(p3.AbsoluteSize.Y)
				end
			}
		end

		return nil
	end, { size, v4, onAbsoluteSizeChanged })

	local onActivated = v2.onActivated
	local onSecondaryActivated = v2.onSecondaryActivated
	local onStateChanged = v2.onStateChanged
	local v6 = onActivated ~= nil or onSecondaryActivated ~= nil
	local v7 = onStateChanged ~= nil
	local containedBackgroundStyle

	if v2.isContained then
		containedBackgroundStyle = v2.containedBackgroundStyle or v3.Color.Shift.Shift_200
	end

	local v8

	if v7 then
		v8 = p2
	end

	local ref2 = useGuiControlState(v8, onStateChanged)

	local v9 = v6 or v7
	local v10 = {}
	v10.AnchorPoint = v2.AnchorPoint
	v10.AutomaticSize = automaticSize
	local backgroundColor

	if containedBackgroundStyle ~= nil then
		backgroundColor = mapBindable(containedBackgroundStyle, function(p3)
			return p3.Color3
		end)
	end

	v10.BackgroundColor3 = backgroundColor

	v10.BackgroundTransparency = containedBackgroundStyle == nil and 1
		or mapBindable(containedBackgroundStyle, function(p3)
			return p3.Transparency
		end)

	v10.BorderSizePixel = 0
	v10.LayoutOrder = v2.LayoutOrder
	v10.Position = v2.Position
	v10.Size = size
	v10.Visible = v2.Visible
	v10.ZIndex = v2.ZIndex

	if not v7 then
		ref2 = p2
	end

	v10.ref = ref2
	local absoluteSize = React.Change.AbsoluteSize
	local v11

	if v5 == nil then
		v11 = onAbsoluteSizeChanged
	else
		v11 = v5.onTileAbsoluteSizeChanged
	end

	v10[absoluteSize] = v11

	v10[React.Change.AbsolutePosition] = v2.onAbsolutePositionChanged
	v10[React.Tag] = getTestIdTag(v2.testId)

	if v9 then
		v10.Active = v6
		v10.AutoButtonColor = false
		v10.Selectable = v6
		v10.SelectionImageObject = selectionImageObject
		v10.Text = ""
		v10[React.Event.Activated] = onActivated
		v10[React.Event.SecondaryActivated] = onSecondaryActivated
	end

	local createElement = React.createElement
	local children = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v3.Radius.Medium) }),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Media = 0,
		Content = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		content = v2.mediaContent,
		aspectRatio = v2.mediaAspectRatio,
		backgroundStyle = v2.mediaBackgroundStyle or v3.Color.Shift.Shift_200,
		isContained = v2.isContained,
		tileSize = size,
		maxHeight = 0,
		LayoutOrder = 1,
		testId = 0
	}
	local maxHeight

	if v5 ~= nil then
		maxHeight = v5.mediaMaxHeight
	end

	v12.maxHeight = maxHeight

	v12.testId = `{v2.testId}--media`
	children.Media = createElement2(BaseTileMedia, v12)

	local createElement3 = React.createElement
	local v13 = {
		title = v2.title,
		metadata = v2.metadata,
		contentAction = v2.contentAction,
		footer = v2.footer,
		isContained = v2.isContained,
		onAbsoluteSizeChanged = 0,
		LayoutOrder = 2,
		testId = 0
	}
	local onAbsoluteSizeChanged2

	if v5 ~= nil then
		onAbsoluteSizeChanged2 = v5.onContentAbsoluteSizeChanged
	end

	v13.onAbsoluteSizeChanged = onAbsoluteSizeChanged2

	v13.testId = v2.testId
	children.Content = createElement3(BaseTileContent, v13)
	return createElement(v9 and "TextButton" or "Frame", v10, children)
end

return React.memo(React.forwardRef(BaseTile))
