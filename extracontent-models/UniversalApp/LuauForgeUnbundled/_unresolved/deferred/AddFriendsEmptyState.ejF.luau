local module = require("@luauforge/deferred/eil")
local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization

local module2 = require("@luauforge/deferred/eiU")
local module3 = require("@luauforge/deferred/ejH")
local useTokens = require("@luauforge/deferred/eiU").Hooks.useTokens

local assets = module3.Assets
module3.preloadAsset("pictograms/collaborators")
local pictogramscollaborators = assets["pictograms/collaborators"] or {}

local function AddFriendsEmptyState(p2)
	local v5 = useLocalization({
		titleText = "Feature.AddFriends.Title.AddFriendsToolTip",
		emptyStateBodyText = {
			"Feature.AddFriends.Text.EmptyState.FriendsRename",
			lineBreak = "\n"
		}
	})

	local v6 = useTokens()
	local v7 = 180 * v6.Config.UI.Scale
	local v8 = 320 * v6.Config.UI.Scale

	return module.createElement(
		module2.View,
		{ tag = "size-full-0 auto-y col align-x-center", LayoutOrder = p2.layoutOrder },
		{
			Icon = module.createElement(module2.Image, {
				LayoutOrder = 1,
				Image = pictogramscollaborators.assetId,
				imageStyle = v6.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(0, v8, 0, v7),
				tag = "position-top-center anchor-top-center"
			}),
			TextTitle = module.createElement(module2.Text, {
				LayoutOrder = 2,
				tag = "auto-y size-full-0 padding-bottom-small text-heading-small content-emphasis",
				Text = v5.titleText
			}),
			TextBody = module.createElement(module2.Text, {
				LayoutOrder = 3,
				tag = "auto-y size-full-0 text-body-medium",
				Text = v5.emptyStateBodyText
			})
		}
	)
end

return AddFriendsEmptyState
