local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local FoundationCloudAssets = require(Parent.FoundationCloudAssets)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local v7 = game:DefineFastFlag("AddFriendsFixText", false)
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename
local Assets = FoundationCloudAssets.Assets

FoundationCloudAssets.preloadAsset("pictograms/collaborators")

local v10 = Assets["pictograms/collaborators"] or {}

local function AddFriendsEmptyState(t1: {[any]: any}) -- line: 26
	-- upvalues: useLocalization (copy), FFlagConnectionsToFriendsRename (copy), v7 (copy), useTokens (copy), React (copy), Foundation (copy), v10 (copy)
	local v13 = useLocalization({
		titleText = not FFlagConnectionsToFriendsRename and "Feature.AddFriends.Title.AddConnectionsToolTip" or "Feature.AddFriends.Title.AddFriendsToolTip",
		emptyStatePromptText = if not v7 then not FFlagConnectionsToFriendsRename and "Feature.AddFriends.Label.EmptyState" or "Feature.AddFriends.Label.EmptyState.FriendsRename" else nil,
		emptyStateBodyText = if not v7 then nil else {
			not FFlagConnectionsToFriendsRename and "Feature.AddFriends.Text.EmptyState" or "Feature.AddFriends.Text.EmptyState.FriendsRename",
			lineBreak = "\n"
		}
	})
	local v14 = useTokens()
	local v15 = 180 * v14.Config.UI.Scale
	local v16 = 320 * v14.Config.UI.Scale

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y col align-x-center",
		LayoutOrder = t1.layoutOrder
	}, {
		Icon = React.createElement(Foundation.Image, {
			LayoutOrder = 1,
			tag = "position-top-center anchor-top-center",
			Image = v10.assetId,
			imageStyle = v14.Color.Content.Emphasis,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.new(0, v16, 0, v15)
		}),
		TextTitle = React.createElement(Foundation.Text, {
			LayoutOrder = 2,
			tag = "auto-y size-full-0 padding-bottom-small text-heading-small content-emphasis",
			Text = v13.titleText
		}),
		TextBody = React.createElement(Foundation.Text, {
			LayoutOrder = 3,
			tag = "auto-y size-full-0 text-body-medium",
			Text = if not v7 then v13.emptyStatePromptText else v13.emptyStateBodyText
		})
	})
end

return AddFriendsEmptyState
