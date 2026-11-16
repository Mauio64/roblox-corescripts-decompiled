local parent = script:FindFirstAncestor("AdPlayer").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local Image = Foundation.Image
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

return function(props)
	local visible = props.Visible
	local image = props.Image

	return React.createElement(
		View,
		{
			tag = "position-center-left anchor-center-left size-900-500 row align-x-center align-y-center gap-xsmall"
		},
		{
			adText = React.createElement(Text, {
				tag = "size-400 content-emphasis text-body-small",
				Text = "Ad",
				TextScaled = true,
				Visible = visible
			}),
			icon = React.createElement(Image, {
				tag = "size-300",
				Image = image,
				LayoutOrder = 2,
				onActivated = props.handleToggleAdsModal,
				Visible = visible,
				stateLayer = { affordance = StateLayerAffordance.None }
			})
		}
	)
end
