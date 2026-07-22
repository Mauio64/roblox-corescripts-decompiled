local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Gradient = require(Foundation.Components.Gradient)
local Image = require(Foundation.Components.Image)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withDefaults = require(Foundation.Utility.withDefaults)
local Flags = require(Foundation.Utility.Flags)
local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local t1 = {
	sticky = false,
	height = UDim.new(1, 0)
}

local function SheetFullBleed(t2: {[any]: any}, p1) -- line: 38
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), SheetContext (copy), Flags (copy), Image (copy), Gradient (copy), View (copy), Constants (copy)
	local v16 = withDefaults(t2, t1)
	local v17 = React.useContext(SheetContext)
	local setFullBleedHeight = v17.setFullBleedHeight
	local fullBleedHeight = v17.fullBleedHeight
	local innerScrollY = v17.innerScrollY
	local hasHeader = v17.hasHeader
	local hasRadius = v17.hasRadius
	local testId = v17.testId

	assert(setFullBleedHeight and (hasHeader and testId), "SheetFullBleed must be used within a Sheet")
	React.useEffect(function() -- line: 50
		-- upvalues: v16 (copy), hasHeader (copy)
		assert(not (v16.sticky and hasHeader:getValue()), "Sheet.FullBleed with sticky=true is unsupported when used with Sheet.Header")
	end, {
		v16.sticky,
		hasHeader
	})

	local v24 = React.useCallback(function(p2) -- line: 57
		-- upvalues: setFullBleedHeight (copy)
		setFullBleedHeight(p2.AbsoluteSize.Y)
	end, {})

	React.useEffect(function() -- line: 61
		-- upvalues: setFullBleedHeight (copy)
		return function() -- line: 62
			-- upvalues: setFullBleedHeight (copy)
			setFullBleedHeight(0)
		end
	end, {})

	local uDim2 = UDim2.new(1, 0, v16.height.Scale, v16.height.Offset)
	local v26 = nil

	if v16.sticky then
		v26 = uDim2
	elseif innerScrollY and fullBleedHeight then
		v26 = React.joinBindings({
			scrollY = innerScrollY,
			height = fullBleedHeight
		}):map(function(t3: {[any]: any}) -- line: 78
			if t3.height == 0 then
				return UDim2.fromScale(1, 1)
			end

			local v31 = math.max(0, t3.height - t3.scrollY)

			return UDim2.new(1, 0, 0, v31)
		end)
	end

	local t4 = {
		RoundedCorners = if Flags.FoundationMediaRoundedCornerTags then nil else if not hasRadius then nil else React.createElement(Image, {
			tag = "radius-large",
			ZIndex = 1,
			Image = v16.media,
			imageStyle = v16.mediaStyle,
			backgroundStyle = v16.backgroundStyle,
			aspectRatio = v16.aspectRatio,
			Size = uDim2,
			testId = `{ testId }--full-bleed--rounded-corners`
		}),
		Image = React.createElement(Image, {
			ZIndex = 0,
			Image = v16.media,
			imageStyle = v16.mediaStyle,
			backgroundStyle = v16.backgroundStyle,
			aspectRatio = v16.aspectRatio,
			tag = if not Flags.FoundationMediaRoundedCornerTags then nil else if not hasRadius then nil else "radius-top-large",
			onAbsoluteSizeChanged = if v16.sticky then nil else v24,
			Size = uDim2
		}, if Flags.FoundationMediaRoundedCornerTags then nil else if not hasRadius then nil else {
			TransparencyGradient = React.createElement(Gradient, {
				top = false,
				fillDirection = Enum.FillDirection.Vertical
			})
		}),
		Content = if not v16.children then nil else React.createElement(View, {
			ZIndex = 2,
			aspectRatio = v16.aspectRatio,
			Size = uDim2
		}, v16.children)
	}
	local v28 = React.createElement(View, {
		ClipsDescendants = true,
		ZIndex = 2,
		Size = v26,
		aspectRatio = if not v16.sticky then nil else v16.aspectRatio,
		LayoutOrder = if not v16.sticky then nil else Constants.MIN_LAYOUT_ORDER,
		testId = `{ testId }--full-bleed`,
		ref = p1
	}, if v16.sticky or not v16.aspectRatio then t4 else React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 9999),
		aspectRatio = v16.aspectRatio
	}, t4))

	if not v16.sticky then
		return React.createElement("Folder", nil, v28)
	end

	return v28
end

return React.memo(React.forwardRef(SheetFullBleed))
