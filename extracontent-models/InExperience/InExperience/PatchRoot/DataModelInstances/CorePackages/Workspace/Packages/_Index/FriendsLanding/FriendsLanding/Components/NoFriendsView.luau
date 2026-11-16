local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local SharedFlags = require(parent.SharedFlags)
local v = SharedFlags.FFlagFontFaceSocialFriends

if v then
	local Foundation = require(parent.Foundation)
	v = Foundation.Utility.Flags.FoundationFontFaceMigration
end

local dependencies = require(FriendsLanding.dependencies)

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

local TextKeys = require(FriendsLanding.Common.TextKeys)
local Style = require(parent.Style)
local AppFonts = Style.AppFonts
local Foundation = require(parent.Foundation)
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

local defineFastFlag = game:DefineFastFlag("MigrateNoFriendsViewToFoundation", false)

local v2 = {
	layoutOrder = 0,
	pageLoadingTimeReport = nil,
	pageRenderReport = nil,
	openAddFriendsPage = dash.noop,
	addFriendsBtnLabelKey = TextKeys.ADD_FRIENDS_BTN,
	noFriendsTextLabelKey = TextKeys.NO_FRIENDS_TEXT,
	addFriendsBtnEnabled = true
}

local function loadFoundationCloudAsset(p: string) -- 1 equivalent call inferred from this helper
	preloadAsset(p)
	local asset = Assets[p]
	return asset.assetId, asset.size
end

local function NoFriendsView(options)
	local joined = dash.join(v2, options or {})
	local v3 = defineFastFlag and "pictograms/collaborators" or nil
	local image, v4

	if defineFastFlag then
		image, v4 = loadFoundationCloudAsset(v3) -- inferred equivalent call
	end

	local v5

	if defineFastFlag then
		v5 = v4 / 3
	end

	react.useEffect(function()
		if joined.pageLoadingTimeReport then
			joined.pageLoadingTimeReport()
		end

		if joined.pageRenderReport then
			joined.pageRenderReport()
		end
	end, {})

	local v6 = useLocalization({
		addFriendsBtn = joined.addFriendsBtnLabelKey,
		noFriendsText = joined.noFriendsTextLabelKey,
		noFriendsHeader = joined.noFriendsHeaderKey
	})

	local v7 = useStyle()
	local v8 = useTokens()
	local createElement = react.createElement
	local v9 = {
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = joined.layoutOrder,
		BackgroundTransparency = 1
	}

	local createElement2 = react.createElement
	local v10 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

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
	local imagelabel

	if defineFastFlag then
		imagelabel = react.createElement(Image, {
			Image = image,
			imageStyle = v8.Color.Content.Emphasis,
			Size = UDim2.fromOffset(v5.X, v5.Y),
			LayoutOrder = 1
		})
	else
		imagelabel = react.createElement(imageSetLabel, {
			BackgroundTransparency = 1,
			Image = images["icons/graphic/findfriends_xlarge"],
			ImageColor3 = colors.White,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(96, 96)
		})
	end

	children.Imagelabel = imagelabel
	local headerlabel

	if joined.noFriendsHeaderKey and v6.noFriendsHeader then
		headerlabel = react.createElement(styledTextLabel, {
			text = v6.noFriendsHeader,
			fontStyle = v7.Font.Header1,
			colorStyle = v7.Theme.TextEmphasis,
			automaticSize = Enum.AutomaticSize.Y,
			size = UDim2.new(1, 0, 0, 0),
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center,
			layoutOrder = 2
		})
	end

	children.Headerlabel = headerlabel

	local createElement3 = react.createElement
	local v11 = {
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
	local font

	if not v then
		font = AppFonts.default:getDefault()
	end

	v11.Font = font
	local fontFace

	if v then
		fontFace = normalizeFontFace(v7.Tokens.Typography.BodySmall.Font)
	end

	v11.FontFace = fontFace

	v11.Size = UDim2.new(1, 0, 0, 0)
	v11.Text = v6.noFriendsText
	v11.TextColor3 = v7.Theme.TextMuted.Color
	v11.TextSize = v7.Font.Header2.RelativeSize * v7.Font.BaseSize
	v11.TextTransparency = v7.Theme.TextMuted.Transparency
	children.Textlabel = createElement3("TextLabel", v11)

	children.Padding = react.createElement("Frame", {
		LayoutOrder = 4,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 10)
	})

	children.AddFriendsButton = joined.addFriendsBtnEnabled and react.createElement(button, {
		buttonType = buttonType.PrimarySystem,
		layoutOrder = 5,
		text = v6.addFriendsBtn,
		standardSize = standardButtonSize.Regular,
		onActivated = joined.openAddFriendsPage
	})
	return createElement("Frame", v9, {
		IndicatorInner = createElement2("Frame", v10, children)
	})
end

return NoFriendsView
