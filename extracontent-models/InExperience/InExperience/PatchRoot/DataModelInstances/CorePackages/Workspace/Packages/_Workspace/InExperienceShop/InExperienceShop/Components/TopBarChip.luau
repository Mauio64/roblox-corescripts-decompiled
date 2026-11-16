local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function TopBarChip(props)
	local v = useTokens()
	local thicker = math.floor(v.Stroke.Thicker)
	local isEmphasis = props.isEmphasis == true

	local createElement = React.createElement
	local v2 = {
		tag = {
			["row align-x-center align-y-center shrink size-0-1000 auto-x radius-circle clip bg-system-emphasis"] = isEmphasis,
			["row align-x-center align-y-center shrink size-0-1000 auto-x radius-circle clip bg-over-media-300"] = not isEmphasis
		},
		onActivated = props.onActivated,
		onStateChanged = props.onStateChanged,
		isDisabled = props.isDisabled,
		GroupTransparency = props.isDisabled and 0.5 or 0,
		selection = {
			Selectable = props.isDisabled ~= true
		},
		LayoutOrder = props.LayoutOrder,
		ref = props.chipRef,
		testId = props.testId,
		cursor = {
			radius = UDim.new(0, v.Radius.Circle),
			offset = thicker * 2,
			borderWidth = thicker
		}
	}

	local createElement2 = React.createElement
	local v3 = {
		tag = "auto-xy",
		LayoutOrder = 1,
		padding = { left = UDim.new(0, v.Size.Size_250) }
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v4 = { Image = props.image, tag = "size-full", testId = 0 }
	local testId

	if props.testId ~= nil then
		testId = `{props.testId}--image`
	end

	v4.testId = testId
	return createElement(View, v2, {
		Leading = createElement2(View, v3, {
			ImagePlate = createElement3(View, { tag = "size-600 radius-circle clip bg-shift-200" }, {
				Image = createElement4(Image, v4)
			})
		}),
		Label = React.createElement(Text, {
			Text = props.text,
			LayoutOrder = 2,
			tag = {
				["shrink size-0-full auto-x text-label-large text-no-wrap text-align-x-center text-align-y-center text-truncate-end content-action-emphasis"] = isEmphasis,
				["shrink size-0-full auto-x text-label-large text-no-wrap text-align-x-center text-align-y-center text-truncate-end content-action-standard"] = not isEmphasis
			},
			padding = { left = UDim.new(0, v.Padding.Small), right = UDim.new(0, v.Padding.Large) }
		})
	})
end

return TopBarChip
