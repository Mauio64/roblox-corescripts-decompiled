local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)
local useXSmallTileTypography = require(SocialCarousel.Hooks.useXSmallTileTypography)
local FFlagSocialCarouselXSmallTileText = require(SocialCarousel.Flags.FFlagSocialCarouselXSmallTileText)
local useTokens = Foundation.Hooks.useTokens
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local Text = Foundation.Text
local View = Foundation.View

local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled

local function FriendsHintTile(p)
	local v = useSocialCarouselContext()
	local v2

	if FFlagSocialCarouselXSmallTileText then
		v2 = useTokens()
	end

	local v3

	if FFlagSocialCarouselXSmallTileText then
		v3 = useXSmallTileTypography()
	end

	local fontStyle, fontStyle2

	if FFlagSocialCarouselXSmallTileText and v3 and v2 then
		fontStyle = {
			Font = v2.Typography.BodySmall.Font,
			FontSize = v2.FontSize.FontSize_200,
			LineHeight = v2.Typography.BodySmall.LineHeight
		}

		fontStyle2 = {
			Font = v2.Typography.TitleMedium.Font,
			FontSize = v2.FontSize.FontSize_200,
			LineHeight = v2.Typography.TitleMedium.LineHeight
		}
	end

	local v4

	if FFlagSocialCarouselShareQREnabled then
		v4 = {
			friendsHintBold = Constants.LOCALIZATION.FRIENDS_HINT_BOLD,
			friendsHintPlain = Constants.LOCALIZATION.FRIENDS_HINT_PLAIN
		}
	else
		v4 = {
			friendsHintTitle = Constants.LOCALIZATION.FRIENDS_HINT_TITLE,
			friendsHintBody = Constants.LOCALIZATION.FRIENDS_HINT_BODY
		}
	end

	local v5 = useLocalization(v4)

	React.useEffect(function()
		v.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.EMPTY_HINT)
	end, {})

	local createElement = React.createElement

	local scale = p.itemSize.X.Scale
	local v6 = p.itemSize.X.Offset + Constants.TILE_TEXT_WIDTH
	local scale2 = p.itemSize.Y.Scale
	local v7

	if FFlagSocialCarouselXSmallTileText and v3 then
		v7 = p.itemSize.X.Offset
	else
		v7 = p.itemSize.Y.Offset - Constants.TILE_TEXT_HEIGHT
	end

	local v8 = {
		Size = UDim2.new(scale, v6, scale2, v7),
		LayoutOrder = p.index,
		BackgroundTransparency = 1,
		tag = "col auto-none align-y-center"
	}

	local createElement2 = React.createElement
	local v9

	if FFlagSocialCarouselShareQREnabled then
		v9 = {
			HintText = React.createElement(Text, {
				Text = `<b>{v5.friendsHintBold}</b> {v5.friendsHintPlain}`,
				RichText = true,
				fontStyle = fontStyle,
				tag = "text-body-small text-align-x-left auto-xy text-wrap"
			})
		}
	else
		v9 = {
			Title = React.createElement(Text, {
				Text = v5.friendsHintTitle,
				fontStyle = fontStyle2,
				tag = "text-title-medium text-align-x-left auto-xy text-wrap",
				LayoutOrder = 1
			}),
			Subtitle = React.createElement(Text, {
				Text = v5.friendsHintBody,
				fontStyle = fontStyle,
				tag = "text-body-small text-align-x-left auto-xy text-wrap",
				LayoutOrder = 2
			})
		}
	end

	return createElement(View, v8, {
		Content = createElement2(View, {
			BackgroundTransparency = 1,
			tag = {
				["auto-xy"] = FFlagSocialCarouselShareQREnabled,
				["col gap-xxsmall auto-xy"] = not FFlagSocialCarouselShareQREnabled
			}
		}, v9)
	})
end

return FriendsHintTile
