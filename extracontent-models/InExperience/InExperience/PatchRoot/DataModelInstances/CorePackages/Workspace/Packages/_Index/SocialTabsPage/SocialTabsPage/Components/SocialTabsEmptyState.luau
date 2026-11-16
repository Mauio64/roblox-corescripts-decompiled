local parent = script:FindFirstAncestor("SocialTabsPage").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Image = Foundation.Image
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets
FoundationCloudAssets.preloadAsset("pictograms/collaborators")
local pictogramscollaborators = Assets["pictograms/collaborators"] or {}

local function SocialTabsEmptyState(p)
	local v = useTokens()
	local v2 = 180 * v.Config.UI.Scale
	local v3 = 320 * v.Config.UI.Scale

	return React.createElement(View, { tag = "col align-x-center align-y-center size-full" }, {
		EmptyContainer = React.createElement(View, { tag = "col align-x-center size-full-0 auto-y" }, {
			Illustration = React.createElement(Image, {
				LayoutOrder = 1,
				Image = pictogramscollaborators.assetId,
				imageStyle = v.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(0, v3, 0, v2),
				tag = "position-top-center anchor-top-center"
			}),
			EmptyText = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium",
				Text = p.text
			})
		})
	})
end

return SocialTabsEmptyState
