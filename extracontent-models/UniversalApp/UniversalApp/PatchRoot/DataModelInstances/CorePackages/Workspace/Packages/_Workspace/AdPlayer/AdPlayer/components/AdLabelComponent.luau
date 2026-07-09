local AdPlayer = script:FindFirstAncestor("AdPlayer")
local AdPlayerParent = AdPlayer.Parent
local React = require(AdPlayerParent.React)
local Foundation = require(AdPlayerParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local FoundationImage = Foundation.Image
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local Flags = require(AdPlayer.Flags)

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), View (copy), Flags (copy), FoundationText (copy), FoundationImage (copy), StateLayerAffordance (copy)
	local t1Visible = t1.Visible
	local t1Image = t1.Image

	return React.createElement(View, {
		tag = not Flags.GetEnableLuaRewardTimerUI() and "position-center-left anchor-center-left size-900-500 row align-x-center align-y-center gap-xsmall" or "size-900-500 row align-x-center align-y-center gap-xsmall"
	}, {
		adText = React.createElement(FoundationText, {
			tag = "size-400 content-emphasis text-body-small",
			Text = "Ad",
			TextScaled = true,
			Visible = t1Visible
		}),
		icon = React.createElement(FoundationImage, {
			tag = "size-300",
			LayoutOrder = 2,
			Image = t1Image,
			onActivated = t1.handleToggleAdsModal,
			Visible = t1Visible,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		})
	})
end
