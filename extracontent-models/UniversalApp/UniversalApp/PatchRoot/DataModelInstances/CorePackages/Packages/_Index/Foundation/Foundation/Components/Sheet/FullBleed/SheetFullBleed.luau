local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)
local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local Flags = require(Foundation.Utility.Flags)
local devAssert = require(Foundation.Utility.devAssert)
local withDefaults = require(Foundation.Utility.withDefaults)

local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)

local v = { height = UDim.new(1, 0), sticky = false }

local function SheetFullBleed(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = React.useContext(SheetContext)

	local setFullBleedHeight = v3.setFullBleedHeight
	local fullBleedHeight = v3.fullBleedHeight
	local innerScrollY = v3.innerScrollY
	local hasHeader = v3.hasHeader
	local hasRadius = v3.hasRadius
	local testId = v3.testId
	assert(setFullBleedHeight and hasHeader and testId, "SheetFullBleed must be used within a Sheet")

	React.useEffect(function()
		if Flags.FoundationDevOnlyPropAsserts then
			devAssert(
				not (v2.sticky and hasHeader:getValue()),
				"Sheet.FullBleed with sticky=true is unsupported when used with Sheet.Header"
			)
		else
			assert(
				not (v2.sticky and hasHeader:getValue()),
				"Sheet.FullBleed with sticky=true is unsupported when used with Sheet.Header"
			)
		end
	end, { v2.sticky, hasHeader })

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		setFullBleedHeight(p2.AbsoluteSize.Y)
	end, {})

	React.useEffect(function()
		return function()
			setFullBleedHeight(0)
		end
	end, {})

	local udim = UDim2.new(1, 0, v2.height.Scale, v2.height.Offset)

	local size = nil

	if v2.sticky then
		size = udim
	elseif innerScrollY and fullBleedHeight then
		size = React.joinBindings({ scrollY = innerScrollY, height = fullBleedHeight }):map(function(p2)
			if p2.height == 0 then
				return UDim2.fromScale(1, 1)
			end

			local v4 = math.max(0, p2.height - p2.scrollY)
			return UDim2.new(1, 0, 0, v4)
		end)
	end

	local createElement = React.createElement
	local v4 = {
		Image = v2.media,
		imageStyle = v2.mediaStyle,
		backgroundStyle = v2.backgroundStyle,
		aspectRatio = v2.aspectRatio,
		tag = hasRadius and "radius-top-large" or nil,
		onAbsoluteSizeChanged = 0,
		Size = 0,
		ZIndex = 0
	}

	if v2.sticky then
		onAbsoluteSizeChanged = nil
	end

	v4.onAbsoluteSizeChanged = onAbsoluteSizeChanged
	v4.Size = udim
	local v5 = { Image = createElement(Image, v4), Content = 0 }
	local content

	if v2.children then
		content = React.createElement(View, {
			aspectRatio = v2.aspectRatio,
			Size = udim,
			ZIndex = 2
		}, v2.children)
	end

	v5.Content = content

	local createElement2 = React.createElement
	local aspectRatio

	if v2.sticky then
		aspectRatio = v2.aspectRatio
	end

	local layoutOrder

	if v2.sticky then
		layoutOrder = Constants.MIN_LAYOUT_ORDER
	end

	local v6 = {
		Size = size,
		aspectRatio = aspectRatio,
		LayoutOrder = layoutOrder,
		ClipsDescendants = true,
		ZIndex = 2,
		testId = `{testId}--full-bleed`,
		ref = ref
	}

	if not v2.sticky and v2.aspectRatio then
		v5 = React.createElement(View, {
			Size = UDim2.new(1, 0, 0, 9999),
			aspectRatio = v2.aspectRatio
		}, v5)
	end

	local element = createElement2(View, v6, v5)

	if v2.sticky then
		return element
	end

	return React.createElement("Folder", nil, element)
end

return React.memo(React.forwardRef(SheetFullBleed))
