local Parent = script:FindFirstAncestor("SocialTabsPage").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local FoundationCloudAssets = require(Parent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets

FoundationCloudAssets.preloadAsset("pictograms/collaborators")

local v10 = Assets["pictograms/collaborators"] or {}

local function SocialTabsEmptyState(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationImage (copy), v10 (copy), FoundationText (copy)
	local v13 = useTokens()
	local v14 = 180 * v13.Config.UI.Scale
	local v15 = 320 * v13.Config.UI.Scale

	return React.createElement(View, {
		tag = "col align-x-center align-y-center size-full"
	}, {
		EmptyContainer = React.createElement(View, {
			tag = "col align-x-center size-full-0 auto-y"
		}, {
			Illustration = React.createElement(FoundationImage, {
				LayoutOrder = 1,
				tag = "position-top-center anchor-top-center",
				Image = v10.assetId,
				imageStyle = v13.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(0, v15, 0, v14)
			}),
			EmptyText = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium",
				Text = t1.text
			})
		})
	})
end

return SocialTabsEmptyState
