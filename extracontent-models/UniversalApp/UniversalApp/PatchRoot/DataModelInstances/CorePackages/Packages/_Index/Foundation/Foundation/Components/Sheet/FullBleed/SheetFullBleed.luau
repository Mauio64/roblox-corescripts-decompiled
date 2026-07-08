local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Gradient = require(Foundation.Components.Gradient)
local Image = require(Foundation.Components.Image)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withDefaults = require(Foundation.Utility.withDefaults)
local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local t1 = {
	sticky = false,
	height = UDim.new(1, 0)
}

local function SheetFullBleed(t2: {[any]: any}, p1) -- line: 36
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), SheetContext (copy), Image (copy), Gradient (copy), View (copy), Constants (copy)
	local v15 = withDefaults(t2, t1)
	local v16 = React.useContext(SheetContext)
	local setFullBleedHeight = v16.setFullBleedHeight
	local fullBleedHeight = v16.fullBleedHeight
	local innerScrollY = v16.innerScrollY
	local hasHeader = v16.hasHeader
	local hasRadius = v16.hasRadius
	local testId = v16.testId

	assert(setFullBleedHeight and (hasHeader and testId), "SheetFullBleed must be used within a Sheet")
	React.useEffect(function() -- line: 48
		-- upvalues: v15 (copy), hasHeader (copy)
		assert(not (v15.sticky and hasHeader:getValue()), "Sheet.FullBleed with sticky=true is unsupported when used with Sheet.Header")
	end, {
		v15.sticky,
		hasHeader
	})

	local v23 = React.useCallback(function(p2) -- line: 55
		-- upvalues: setFullBleedHeight (copy)
		setFullBleedHeight(p2.AbsoluteSize.Y)
	end, {})

	React.useEffect(function() -- line: 59
		-- upvalues: setFullBleedHeight (copy)
		return function() -- line: 60
			-- upvalues: setFullBleedHeight (copy)
			setFullBleedHeight(0)
		end
	end, {})

	local uDim2 = UDim2.new(1, 0, v15.height.Scale, v15.height.Offset)
	local v25 = nil

	if v15.sticky then
		v25 = uDim2
	elseif innerScrollY and fullBleedHeight then
		v25 = React.joinBindings({
			scrollY = innerScrollY,
			height = fullBleedHeight
		}):map(function(t3: {[any]: any}) -- line: 76
			if t3.height == 0 then
				return UDim2.fromScale(1, 1)
			end

			local v30 = math.max(0, t3.height - t3.scrollY)

			return UDim2.new(1, 0, 0, v30)
		end)
	end

	local t4 = {
		RoundedCorners = if not hasRadius then nil else React.createElement(Image, {
			tag = "radius-large",
			ZIndex = 1,
			Image = v15.media,
			imageStyle = v15.mediaStyle,
			backgroundStyle = v15.backgroundStyle,
			aspectRatio = v15.aspectRatio,
			Size = uDim2,
			testId = `{ testId }--full-bleed--rounded-corners`
		}),
		Image = React.createElement(Image, {
			ZIndex = 0,
			Image = v15.media,
			imageStyle = v15.mediaStyle,
			backgroundStyle = v15.backgroundStyle,
			aspectRatio = v15.aspectRatio,
			onAbsoluteSizeChanged = if v15.sticky then nil else v23,
			Size = uDim2
		}, if not hasRadius then nil else {
			TransparencyGradient = React.createElement(Gradient, {
				top = false,
				fillDirection = Enum.FillDirection.Vertical
			})
		}),
		Content = if not v15.children then nil else React.createElement(View, {
			ZIndex = 2,
			aspectRatio = v15.aspectRatio,
			Size = uDim2
		}, v15.children)
	}
	local v27 = React.createElement(View, {
		ClipsDescendants = true,
		ZIndex = 2,
		Size = v25,
		aspectRatio = if not v15.sticky then nil else v15.aspectRatio,
		LayoutOrder = if not v15.sticky then nil else Constants.MIN_LAYOUT_ORDER,
		testId = `{ testId }--full-bleed`,
		ref = p1
	}, if v15.sticky or not v15.aspectRatio then t4 else React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 9999),
		aspectRatio = v15.aspectRatio
	}, t4))

	if not v15.sticky then
		return React.createElement("Folder", nil, v27)
	end

	return v27
end

return React.memo(React.forwardRef(SheetFullBleed))
