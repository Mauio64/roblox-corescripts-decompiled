local module = require("@luauforge/deferred/eeO")
local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization

local module2 = require("@luauforge/deferred/ege")
local module3 = require("@luauforge/deferred/egm")
local useTokens = require("@luauforge/deferred/ege").Hooks.useTokens

local defineFastFlag = game:DefineFastFlag("AddFriendsFixText", false)
local assets = module3.Assets
module3.preloadAsset("pictograms/collaborators")
local pictogramscollaborators = assets["pictograms/collaborators"] or {}

local function AddFriendsEmptyState(p2)
	local v5 = useLocalization({
		titleText = "Feature.AddFriends.Title.AddFriendsToolTip",
		emptyStatePromptText = not defineFastFlag and "Feature.AddFriends.Label.EmptyState.FriendsRename" or nil,
		emptyStateBodyText = defineFastFlag and {
			"Feature.AddFriends.Text.EmptyState.FriendsRename",
			lineBreak = "\n"
		} or nil
	})

	local v6 = useTokens()
	local v7 = 180 * v6.Config.UI.Scale
	local v8 = 320 * v6.Config.UI.Scale

	local createElement = module.createElement
	local view = module2.View
	local v9 = {
		tag = "size-full-0 auto-y col align-x-center",
		LayoutOrder = p2.layoutOrder
	}
	local v10 = {
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
		TextBody = 0
	}

	local createElement2 = module.createElement
	local text = module2.Text

	local v12 = if defineFastFlag then v5.emptyStateBodyText else v5.emptyStatePromptText
	v10.TextBody = createElement2(text, {
		LayoutOrder = 3,
		tag = "auto-y size-full-0 text-body-medium",
		Text = v12
	})
	return createElement(view, v9, v10)
end

return AddFriendsEmptyState
