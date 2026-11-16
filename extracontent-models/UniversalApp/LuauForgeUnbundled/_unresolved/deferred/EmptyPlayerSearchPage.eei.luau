local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)

local emptyState = UIBlox.App.Indicator.EmptyState
local images = UIBlox.App.ImageSet.Images
local colors = UIBlox.App.Style.Colors
local useStyle = UIBlox.Core.Style.useStyle

local Foundation = require(CorePackages.Packages.Foundation)
local FoundationCloudAssets = require(CorePackages.Packages.FoundationCloudAssets)
local useTokens = Foundation.Hooks.useTokens

local module = require("@luauforge/deferred/eej")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local fFlagUserSearchEmptyPageNewIcons = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUserSearchEmptyPageNewIcons

local iconsstatusoof_xlarge = images["icons/status/oof_xlarge"]
local iconsgraphicfindfriends_xlarge = images["icons/graphic/findfriends_xlarge"]
local pictogramsfind_people, pictogramscollaborators

if fFlagUserSearchEmptyPageNewIcons then
	local assets = FoundationCloudAssets.Assets
	local preloadAsset = FoundationCloudAssets.preloadAsset
	preloadAsset("pictograms/find_people")
	preloadAsset("pictograms/collaborators")
	pictogramsfind_people = assets["pictograms/find_people"] or {}
	pictogramscollaborators = assets["pictograms/collaborators"] or {}
else
	pictogramsfind_people = nil
	pictogramscollaborators = nil
end

local function EmptyPlayerSearchPage(props)
	local v5 = useLocalization({
		keywordTooShortText = "Feature.PlayerSearchResults.Label.KeywordTooShort",
		noResultsText = "Feature.PlayerSearchResults.Label.NoResultsFound",
		findFriendsButton = "Feature.Friends.Action.FindFriends",
		tryAnotherWayText = "Feature.PlayerSearchResults.Label.NoResultsTryAnotherWay"
	})

	local v6 = module().searchForFriendsPrompt

	local v7 = useStyle()

	local white = nil
	local v8

	if props.shouldShowUserSearchLandingPage then
		if fFlagUserSearchEmptyPageNewIcons then
			v8 = pictogramsfind_people
		else
			v8 = iconsgraphicfindfriends_xlarge
		end

		white = colors.White
	else
		v6 = if props.searchWordLengthNotSupported then v5.keywordTooShortText else v5.noResultsText

		if fFlagUserSearchEmptyPageNewIcons then
			v8 = pictogramscollaborators
		else
			v8 = iconsstatusoof_xlarge
		end
	end

	if fFlagUserSearchEmptyPageNewIcons then
		local v9 = useTokens()
		local v10 = 180 * v9.Config.UI.Scale
		local v11 = 320 * v9.Config.UI.Scale

		return React.createElement(
			Foundation.View,
			{ tag = "size-full auto-y col align-x-center align-y-center" },
			{
				Icon = React.createElement(Foundation.Image, {
					LayoutOrder = 1,
					Image = v8.assetId,
					imageStyle = v9.Color.Content.Emphasis,
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.new(0, v11, 0, v10),
					tag = "position-top-center anchor-top-center"
				}),
				TextBody = React.createElement(Foundation.Text, {
					LayoutOrder = 3,
					tag = "auto-y size-full-0 text-body-medium text-wrap padding-x-xlarge",
					Text = v6
				})
			}
		)
	else
		local createElement = React.createElement

		local v10 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 0,
			BackgroundColor3 = 0,
			BorderSizePixel = 0
		}
		local v11 = if props.backgroundTransparency then props.backgroundTransparency else v7.Theme.BackgroundDefault.Transparency
		v10.BackgroundTransparency = v11

		v10.BackgroundColor3 = v7.Theme.BackgroundDefault.Color
		return createElement("Frame", v10, {
			LandingText = React.createElement(emptyState, {
				text = v6,
				icon = v8,
				iconColor = white,
				maxSizeTextLabel = Vector2.new(props.screenSize.X - 64, props.screenSize.Y)
			})
		})
	end
end

return EmptyPlayerSearchPage
