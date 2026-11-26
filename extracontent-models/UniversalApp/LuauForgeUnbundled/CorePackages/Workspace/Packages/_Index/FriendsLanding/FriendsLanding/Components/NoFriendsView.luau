local fFlagFontFaceSocialFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFontFaceSocialFriends

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local react = dependencies.React
local dash = dependencies.Dash

local uiBlox = dependencies.UIBlox
local images = uiBlox.App.ImageSet.Images
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local standardButtonSize = uiBlox.App.Button.Enum.StandardButtonSize
local colors = uiBlox.App.Style.Colors
local useStyle = uiBlox.Core.Style.useStyle
local styledTextLabel = uiBlox.App.Text.StyledTextLabel

local useLocalization = dependencies.Hooks.useLocalization

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Common/TextKeys")
local appFonts = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Style").AppFonts
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Foundation")
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FoundationCloudAssets")
local assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

local defineFastFlag = game:DefineFastFlag("MigrateNoFriendsViewToFoundation", false)

local v5 = {
	layoutOrder = 0,
	pageLoadingTimeReport = nil,
	pageRenderReport = nil,
	openAddFriendsPage = dash.noop,
	addFriendsBtnLabelKey = TextKeys.ADD_FRIENDS_BTN,
	noFriendsTextLabelKey = TextKeys.NO_FRIENDS_TEXT,
	addFriendsBtnEnabled = true
}

local function loadFoundationCloudAsset(p2)
	preloadAsset(p2)
	local asset = assets[p2]
	return asset.assetId, asset.size
end

local function NoFriendsView(options)
	local joined = dash.join(v5, options or {})
	local v6 = defineFastFlag and "pictograms/collaborators" or nil
	local assetId, size

	if defineFastFlag then
		preloadAsset(v6)
		local asset = assets[v6]
		assetId = asset.assetId
		size = asset.size
	end

	local v7 = if defineFastFlag then size / 3 else nil

	react.useEffect(function()
		if joined.pageLoadingTimeReport then
			joined.pageLoadingTimeReport()
		end

		if joined.pageRenderReport then
			joined.pageRenderReport()
		end
	end, {})

	local v8 = useLocalization({
		addFriendsBtn = joined.addFriendsBtnLabelKey,
		noFriendsText = joined.noFriendsTextLabelKey,
		noFriendsHeader = joined.noFriendsHeaderKey
	})

	local v9 = useStyle()
	local v10 = useTokens()
	local createElement = react.createElement
	local v12 = {
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = joined.layoutOrder,
		BackgroundTransparency = 1
	}

	local createElement2 = react.createElement
	local v15 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local children = {
		SidePadding = react.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 30),
			PaddingLeft = UDim.new(0, 30)
		}),
		UIList = react.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 15)
		}),
		Imagelabel = 0,
		Headerlabel = 0,
		Textlabel = 0,
		Padding = 0,
		AddFriendsButton = 0
	}

	local v16 = if defineFastFlag then react.createElement(image, {
		Image = assetId,
		imageStyle = v10.Color.Content.Emphasis,
		Size = UDim2.fromOffset(v7.X, v7.Y),
		LayoutOrder = 1
	}) else react.createElement(imageSetLabel, {
		BackgroundTransparency = 1,
		Image = images["icons/graphic/findfriends_xlarge"],
		ImageColor3 = colors.White,
		LayoutOrder = 1,
		Size = UDim2.fromOffset(96, 96)
	})
	children.Imagelabel = v16

	local v17 = if joined.noFriendsHeaderKey and v8.noFriendsHeader then react.createElement(styledTextLabel, {
		text = v8.noFriendsHeader,
		fontStyle = v9.Font.Header1,
		colorStyle = v9.Theme.TextEmphasis,
		automaticSize = Enum.AutomaticSize.Y,
		size = UDim2.new(1, 0, 0, 0),
		textXAlignment = Enum.TextXAlignment.Center,
		textYAlignment = Enum.TextYAlignment.Center,
		layoutOrder = 2
	}) else nil
	children.Headerlabel = v17

	local createElement3 = react.createElement
	local v19 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 3,
		Size = 0,
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextTransparency = 0
	}

	local v20 = if not fFlagFontFaceSocialFriends then appFonts.default:getDefault() else nil
	v19.Font = v20

	local v21 = if fFlagFontFaceSocialFriends then normalizeFontFace(v9.Tokens.Typography.BodySmall.Font) else nil
	v19.FontFace = v21

	v19.Size = UDim2.new(1, 0, 0, 0)
	v19.Text = v8.noFriendsText
	v19.TextColor3 = v9.Theme.TextMuted.Color
	v19.TextSize = v9.Font.Header2.RelativeSize * v9.Font.BaseSize
	v19.TextTransparency = v9.Theme.TextMuted.Transparency
	children.Textlabel = createElement3("TextLabel", v19)

	children.Padding = react.createElement("Frame", {
		LayoutOrder = 4,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 10)
	})

	children.AddFriendsButton = joined.addFriendsBtnEnabled and react.createElement(button, {
		buttonType = buttonType.PrimarySystem,
		layoutOrder = 5,
		text = v8.addFriendsBtn,
		standardSize = standardButtonSize.Regular,
		onActivated = joined.openAddFriendsPage
	})
	return createElement("Frame", v12, {
		IndicatorInner = createElement2("Frame", v15, children)
	})
end

return NoFriendsView
