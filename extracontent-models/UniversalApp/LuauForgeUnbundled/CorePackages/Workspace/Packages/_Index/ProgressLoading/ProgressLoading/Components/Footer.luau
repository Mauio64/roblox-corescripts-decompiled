local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization").Hooks.useLocalization

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local function Footer(props)
	local v5 = useTokens()
	local size_300 = v5.Size.Size_300
	local v6 = useLocalization({ poweredBy = "Feature.Landing.Label.PoweredBy" })

	return React.createElement(view, {
		tag = props.tag or "auto-xy",
		LayoutOrder = props.LayoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Size.Size_150),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		testId = props.testId
	}, {
		Label = React.createElement(text, {
			Text = v6.poweredBy,
			tag = "auto-xy text-body-medium content-default",
			LayoutOrder = 1,
			testId = props.textTestId
		}),
		Wordmark = React.createElement(image, {
			Image = "icons/logo/letterform",
			imageStyle = v5.Color.Content.Default,
			Size = UDim2.fromOffset(size_300 * (47 / 9), size_300),
			LayoutOrder = 2,
			testId = props.wordmarkTestId
		})
	})
end

return Footer
