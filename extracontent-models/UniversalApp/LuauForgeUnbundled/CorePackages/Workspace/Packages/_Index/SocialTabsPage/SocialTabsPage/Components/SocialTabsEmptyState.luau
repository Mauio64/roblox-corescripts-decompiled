local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Foundation")
local view = Foundation.View
local image = Foundation.Image
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/FoundationCloudAssets")
local assets = FoundationCloudAssets.Assets
FoundationCloudAssets.preloadAsset("pictograms/collaborators")
local pictogramscollaborators = assets["pictograms/collaborators"] or {}

local function SocialTabsEmptyState(p2)
	local v5 = useTokens()
	local v6 = 180 * v5.Config.UI.Scale
	local v7 = 320 * v5.Config.UI.Scale

	return React.createElement(view, {
		tag = "col align-x-center align-y-center size-full"
	}, {
		EmptyContainer = React.createElement(view, {
			tag = "col align-x-center size-full-0 auto-y"
		}, {
			Illustration = React.createElement(image, {
				LayoutOrder = 1,
				Image = pictogramscollaborators.assetId,
				imageStyle = v5.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(0, v7, 0, v6),
				tag = "position-top-center anchor-top-center"
			}),
			EmptyText = React.createElement(text, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium",
				Text = p2.text
			})
		})
	})
end

return SocialTabsEmptyState
