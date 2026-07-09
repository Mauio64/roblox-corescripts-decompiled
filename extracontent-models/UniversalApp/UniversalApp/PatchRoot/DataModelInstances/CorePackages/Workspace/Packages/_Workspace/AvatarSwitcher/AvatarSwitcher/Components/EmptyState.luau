local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationCloudAssets = require(Parent.FoundationCloudAssets)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local v6 = FoundationCloudAssets.Assets["pictograms/collaborators"]

function EmptyState(t1: {[any]: any}) -- line: 16
	-- upvalues: useLocalization (copy), React (copy), Foundation (copy), v6 (copy)
	local v8 = useLocalization({
		noAvatars = "Feature.AvatarSwitcher.Message.NoAvatars",
		addAvatars = "Feature.AvatarSwitcher.Message.AddAvatars"
	})

	return React.createElement(Foundation.View, {
		tag = "size-full"
	}, {
		Header = t1.headerSlot,
		Content = React.createElement(Foundation.View, {
			tag = "auto-xy position-center-center anchor-center-center col align-x-center"
		}, {
			Image = React.createElement(Foundation.Image, {
				LayoutOrder = 1,
				Image = v6.assetId,
				Size = UDim2.fromOffset(v6.size.X / 3, v6.size.Y / 3)
			}),
			Text = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-large padding-bottom-small",
				LayoutOrder = 2,
				Text = v8.noAvatars
			}),
			SubText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-medium",
				LayoutOrder = 3,
				Text = v8.addAvatars
			})
		})
	})
end

return EmptyState
