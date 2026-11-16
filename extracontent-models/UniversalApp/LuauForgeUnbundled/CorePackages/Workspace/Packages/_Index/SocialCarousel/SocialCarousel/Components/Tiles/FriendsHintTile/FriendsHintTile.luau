local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization").Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local text = Foundation.Text
local view = Foundation.View

local fFlagSocialCarouselShareQREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselShareQREnabled

local function FriendsHintTile(p2)
	local v5 = useSocialCarouselContext()
	local v6

	if fFlagSocialCarouselShareQREnabled then
		v6 = {
			friendsHintBold = Constants.LOCALIZATION.FRIENDS_HINT_BOLD,
			friendsHintPlain = Constants.LOCALIZATION.FRIENDS_HINT_PLAIN
		}
	else
		v6 = {
			friendsHintTitle = Constants.LOCALIZATION.FRIENDS_HINT_TITLE,
			friendsHintBody = Constants.LOCALIZATION.FRIENDS_HINT_BODY
		}
	end

	local v7 = useLocalization(v6)

	React.useEffect(function()
		v5.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.EMPTY_HINT)
	end, {})

	local createElement = React.createElement
	local v9 = {
		Size = UDim2.new(
			p2.itemSize.X.Scale,
			p2.itemSize.X.Offset + Constants.TILE_TEXT_WIDTH,
			p2.itemSize.Y.Scale,
			p2.itemSize.Y.Offset - Constants.TILE_TEXT_HEIGHT
		),
		LayoutOrder = p2.index,
		BackgroundTransparency = 1,
		tag = "col auto-none align-y-center"
	}

	local createElement2 = React.createElement
	local v13

	if fFlagSocialCarouselShareQREnabled then
		v13 = {
			HintText = React.createElement(text, {
				Text = `<b>{v7.friendsHintBold}</b> {v7.friendsHintPlain}`,
				RichText = true,
				tag = "text-body-small text-align-x-left auto-xy text-wrap"
			})
		}
	else
		v13 = {
			Title = React.createElement(text, {
				Text = v7.friendsHintTitle,
				tag = "text-title-medium text-align-x-left auto-xy text-wrap",
				LayoutOrder = 1
			}),
			Subtitle = React.createElement(text, {
				Text = v7.friendsHintBody,
				tag = "text-body-small text-align-x-left auto-xy text-wrap",
				LayoutOrder = 2
			})
		}
	end

	return createElement(view, v9, {
		Content = createElement2(view, {
			BackgroundTransparency = 1,
			tag = {
				["auto-xy"] = fFlagSocialCarouselShareQREnabled,
				["col gap-xxsmall auto-xy"] = not fFlagSocialCarouselShareQREnabled
			}
		}, v13)
	})
end

return FriendsHintTile
