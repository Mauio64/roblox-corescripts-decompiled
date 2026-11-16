local parent = script:FindFirstAncestor("ProgressLoading").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local function Footer(props)
	local v = useTokens()
	local size_300 = v.Size.Size_300
	local v2 = useLocalization({ poweredBy = "Feature.Landing.Label.PoweredBy" })

	return React.createElement(View, {
		tag = props.tag or "auto-xy",
		LayoutOrder = props.LayoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v.Size.Size_150),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		testId = props.testId
	}, {
		Label = React.createElement(Text, {
			Text = v2.poweredBy,
			tag = "auto-xy text-body-medium content-default",
			LayoutOrder = 1,
			testId = props.textTestId
		}),
		Wordmark = React.createElement(Image, {
			Image = "icons/logo/letterform",
			imageStyle = v.Color.Content.Default,
			Size = UDim2.fromOffset(size_300 * (47 / 9), size_300),
			LayoutOrder = 2,
			testId = props.wordmarkTestId
		})
	})
end

return Footer
