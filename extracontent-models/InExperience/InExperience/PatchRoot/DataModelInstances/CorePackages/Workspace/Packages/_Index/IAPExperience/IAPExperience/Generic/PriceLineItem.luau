local parent = script:FindFirstAncestor("IAPExperience").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text

local RoactUtils = require(parent.RoactUtils)
local combineReactTags = RoactUtils.combineReactTags

local function PriceLineItem(props)
	local textStyle = props.textStyle or "text-body-small content-emphasis"
	local tag = React.useMemo(function()
		return combineReactTags("auto-y", textStyle, "content-emphasis", "text-align-x-left", "text-wrap")
	end, { textStyle })
	local tag2 = React.useMemo(function()
		return combineReactTags("auto-y", textStyle, "content-emphasis", "text-align-x-right")
	end, { textStyle })

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		tag = props.tag or "row size-full-0 auto-y align-y-top padding-x-xsmall"
	}, {
		Label = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.label,
			Size = UDim2.new(0.8, 0, 0, 0),
			tag = tag,
			RichText = true
		}),
		Amount = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.amount,
			Size = UDim2.new(0.2, 0, 0, 0),
			tag = tag2,
			RichText = true
		})
	})
end

return PriceLineItem
