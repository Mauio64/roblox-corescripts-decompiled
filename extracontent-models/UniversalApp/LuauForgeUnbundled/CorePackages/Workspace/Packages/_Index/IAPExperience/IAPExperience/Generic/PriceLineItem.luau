local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local text = Foundation.Text

local combineReactTags = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/RoactUtils").combineReactTags

local function PriceLineItem(props)
	local textStyle = props.textStyle or "text-body-small content-emphasis"
	local v5 = React.useMemo(function()
		return combineReactTags("auto-y", textStyle, "content-emphasis", "text-align-x-left", "text-wrap")
	end, { textStyle })
	local v6 = React.useMemo(function()
		return combineReactTags("auto-y", textStyle, "content-emphasis", "text-align-x-right")
	end, { textStyle })

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = props.tag or "row size-full-0 auto-y align-y-top padding-x-xsmall"
	}, {
		Label = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.label,
			Size = UDim2.new(0.8, 0, 0, 0),
			tag = v5,
			RichText = true
		}),
		Amount = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.amount,
			Size = UDim2.new(0.2, 0, 0, 0),
			tag = v6,
			RichText = true
		})
	})
end

return PriceLineItem
