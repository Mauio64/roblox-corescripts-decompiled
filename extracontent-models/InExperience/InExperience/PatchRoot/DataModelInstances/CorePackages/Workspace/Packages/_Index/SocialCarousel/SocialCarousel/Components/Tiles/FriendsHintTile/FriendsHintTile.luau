local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local Text = Foundation.Text
local View = Foundation.View

local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled

local function FriendsHintTile(p)
	local v = useSocialCarouselContext()
	local v2

	if FFlagSocialCarouselShareQREnabled then
		v2 = {
			friendsHintBold = Constants.LOCALIZATION.FRIENDS_HINT_BOLD,
			friendsHintPlain = Constants.LOCALIZATION.FRIENDS_HINT_PLAIN
		}
	else
		v2 = {
			friendsHintTitle = Constants.LOCALIZATION.FRIENDS_HINT_TITLE,
			friendsHintBody = Constants.LOCALIZATION.FRIENDS_HINT_BODY
		}
	end

	local v3 = useLocalization(v2)

	React.useEffect(function()
		v.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.EMPTY_HINT)
	end, {})

	local createElement = React.createElement
	local v4 = {
		Size = UDim2.new(
			p.itemSize.X.Scale,
			p.itemSize.X.Offset + Constants.TILE_TEXT_WIDTH,
			p.itemSize.Y.Scale,
			p.itemSize.Y.Offset - Constants.TILE_TEXT_HEIGHT
		),
		LayoutOrder = p.index,
		BackgroundTransparency = 1,
		tag = "col auto-none align-y-center"
	}

	local createElement2 = React.createElement
	local v5

	if FFlagSocialCarouselShareQREnabled then
		v5 = {
			HintText = React.createElement(Text, {
				Text = `<b>{v3.friendsHintBold}</b> {v3.friendsHintPlain}`,
				RichText = true,
				tag = "text-body-small text-align-x-left auto-xy text-wrap"
			})
		}
	else
		v5 = {
			Title = React.createElement(Text, {
				Text = v3.friendsHintTitle,
				tag = "text-title-medium text-align-x-left auto-xy text-wrap",
				LayoutOrder = 1
			}),
			Subtitle = React.createElement(Text, {
				Text = v3.friendsHintBody,
				tag = "text-body-small text-align-x-left auto-xy text-wrap",
				LayoutOrder = 2
			})
		}
	end

	return createElement(View, v4, {
		Content = createElement2(View, {
			BackgroundTransparency = 1,
			tag = {
				["auto-xy"] = FFlagSocialCarouselShareQREnabled,
				["col gap-xxsmall auto-xy"] = not FFlagSocialCarouselShareQREnabled
			}
		}, v5)
	})
end

return FriendsHintTile
