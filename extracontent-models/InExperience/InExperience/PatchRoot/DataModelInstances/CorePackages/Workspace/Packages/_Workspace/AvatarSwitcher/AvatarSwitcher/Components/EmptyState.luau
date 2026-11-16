local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local pictogramscollaborators = FoundationCloudAssets.Assets["pictograms/collaborators"]

function EmptyState(p)
	local v = useLocalization({
		noAvatars = "Feature.AvatarSwitcher.Message.NoAvatars",
		addAvatars = "Feature.AvatarSwitcher.Message.AddAvatars"
	})

	return React.createElement(Foundation.View, { tag = "size-full" }, {
		Header = p.headerSlot,
		Content = React.createElement(
			Foundation.View,
			{ tag = "auto-xy position-center-center anchor-center-center col align-x-center" },
			{
				Image = React.createElement(Foundation.Image, {
					Image = pictogramscollaborators.assetId,
					Size = UDim2.fromOffset(pictogramscollaborators.size.X / 3, pictogramscollaborators.size.Y / 3),
					LayoutOrder = 1
				}),
				Text = React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-large padding-bottom-small",
					Text = v.noAvatars,
					LayoutOrder = 2
				}),
				SubText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-body-medium",
					Text = v.addAvatars,
					LayoutOrder = 3
				})
			}
		)
	})
end

return EmptyState
