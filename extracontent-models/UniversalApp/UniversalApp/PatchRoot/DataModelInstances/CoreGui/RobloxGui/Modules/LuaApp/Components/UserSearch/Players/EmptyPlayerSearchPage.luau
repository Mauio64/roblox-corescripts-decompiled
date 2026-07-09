local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local EmptyState = UIBlox.App.Indicator.EmptyState
local Images = UIBlox.App.ImageSet.Images
local Colors = UIBlox.App.Style.Colors
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationCloudAssets = require(CorePackages.Packages.FoundationCloudAssets)
local useTokens = Foundation.Hooks.useTokens
local useDisplayNameText = require(CorePackages.Workspace.Packages.EditProfile.useDisplayNameText)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FFlagUserSearchEmptyPageNewIcons = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUserSearchEmptyPageNewIcons
local v14 = Images["icons/status/oof_xlarge"]
local v15 = Images["icons/graphic/findfriends_xlarge"]
local u16 = nil
local u17 = nil

if FFlagUserSearchEmptyPageNewIcons then
	local Assets = FoundationCloudAssets.Assets
	local preloadAsset = FoundationCloudAssets.preloadAsset

	preloadAsset("pictograms/find_people")
	preloadAsset("pictograms/collaborators")
	u16 = Assets["pictograms/find_people"] or {}
	u17 = Assets["pictograms/collaborators"] or {}
end

local function EmptyPlayerSearchPage(t1: {[any]: any}) -- line: 49
	-- upvalues: useLocalization (copy), useDisplayNameText (copy), useStyle (copy), FFlagUserSearchEmptyPageNewIcons (copy), u16 (ref), v15 (copy), Colors (copy), v14 (copy), u17 (ref), useTokens (copy), React (copy), Foundation (copy), EmptyState (copy)
	local v22 = useLocalization({
		keywordTooShortText = "Feature.PlayerSearchResults.Label.KeywordTooShort",
		noResultsText = "Feature.PlayerSearchResults.Label.NoResultsFound",
		findFriendsButton = "Feature.Friends.Action.FindFriends",
		tryAnotherWayText = "Feature.PlayerSearchResults.Label.NoResultsTryAnotherWay"
	})
	local searchForFriendsPrompt = useDisplayNameText().searchForFriendsPrompt
	local v24 = useStyle()
	local White = nil
	local v26

	if t1.shouldShowUserSearchLandingPage then
		v26 = if not FFlagUserSearchEmptyPageNewIcons then v15 else u16
		White = Colors.White
	elseif t1.searchWordLengthNotSupported then
		searchForFriendsPrompt = v22.keywordTooShortText

		local _ = v14

		v26 = if not FFlagUserSearchEmptyPageNewIcons then v14 else u17
	else
		searchForFriendsPrompt = v22.noResultsText
		v26 = if not FFlagUserSearchEmptyPageNewIcons then v14 else u17
	end

	if FFlagUserSearchEmptyPageNewIcons then
		local v28 = useTokens()
		local v29 = 180 * v28.Config.UI.Scale
		local v30 = 320 * v28.Config.UI.Scale

		return React.createElement(Foundation.View, {
			tag = "size-full auto-y col align-x-center align-y-center"
		}, {
			Icon = React.createElement(Foundation.Image, {
				LayoutOrder = 1,
				tag = "position-top-center anchor-top-center",
				Image = v26.assetId,
				imageStyle = v28.Color.Content.Emphasis,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.new(0, v30, 0, v29)
			}),
			TextBody = React.createElement(Foundation.Text, {
				LayoutOrder = 3,
				tag = "auto-y size-full-0 text-body-medium text-wrap padding-x-xlarge",
				Text = searchForFriendsPrompt
			})
		})
	end

	return (React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = if not t1.backgroundTransparency then v24.Theme.BackgroundDefault.Transparency else t1.backgroundTransparency,
		BackgroundColor3 = v24.Theme.BackgroundDefault.Color
	}, {
		LandingText = React.createElement(EmptyState, {
			text = searchForFriendsPrompt,
			icon = v26,
			iconColor = White,
			maxSizeTextLabel = Vector2.new(t1.screenSize.X - 64, t1.screenSize.Y)
		})
	}))
end

return EmptyPlayerSearchPage
