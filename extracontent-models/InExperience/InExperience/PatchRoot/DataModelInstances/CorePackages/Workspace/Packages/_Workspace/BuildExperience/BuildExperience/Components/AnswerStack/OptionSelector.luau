local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function OptionSelector(t2: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), React (copy), View (copy), t1 (copy), FoundationText (copy)
	local v10 = useTokens()
	local v11 = t2.isSelected == true
	local v12 = t2.selectionStyle or "committed"
	local v13 = not (v11 and v12 == "intermediate") and "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0" or "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-contrast radius-large bg-surface-0"
	local v14 = React.createElement(View, {
		ZIndex = 3,
		LayoutOrder = t2.LayoutOrder,
		onActivated = t2.onActivated,
		stateLayer = if not v11 or v12 ~= "committed" then nil else t1,
		testId = t2.testId,
		tag = v13
	}, {
		Content = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-small text-wrap text-align-x-left content-emphasis",
				Text = t2.title
			}),
			Description = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
				Text = t2.description
			})
		})
	})

	if not v11 or v12 ~= "committed" then
		return v14
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = t2.LayoutOrder
	}, {
		Card = React.cloneElement(v14, {
			LayoutOrder = 1
		}),
		StackLayers = React.createElement(View, {
			LayoutOrder = 2,
			tag = "size-full-400",
			ZIndex = 1
		}, {
			FirstLayer = React.createElement(View, {
				tag = "stroke-standard stroke-default radius-medium bg-surface-0",
				ZIndex = 2,
				Position = UDim2.new(0, v10.Size.Size_400, 0, -v10.Size.Size_200),
				Size = UDim2.new(1, -2 * v10.Size.Size_400, 0, v10.Size.Size_400)
			}),
			SecondLayer = React.createElement(View, {
				tag = "stroke-standard stroke-default radius-medium bg-surface-0",
				ZIndex = 1,
				Position = UDim2.new(0, v10.Size.Size_800, 0, 0),
				Size = UDim2.new(1, -2 * v10.Size.Size_800, 0, v10.Size.Size_400)
			})
		})
	})
end

return OptionSelector
