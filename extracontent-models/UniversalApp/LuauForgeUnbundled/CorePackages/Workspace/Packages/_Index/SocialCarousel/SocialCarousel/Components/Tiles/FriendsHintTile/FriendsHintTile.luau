local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Localization").Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local useXSmallTileTypography = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useXSmallTileTypography")
local FFlagSocialCarouselXSmallTileText = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselXSmallTileText")
local useTokens = Foundation.Hooks.useTokens
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local text = Foundation.Text
local view = Foundation.View

local fFlagSocialCarouselShareQREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselShareQREnabled

local function FriendsHintTile(p2)
	local v5 = useSocialCarouselContext()
	local v6 = if FFlagSocialCarouselXSmallTileText then useTokens() else nil
	local v7 = if FFlagSocialCarouselXSmallTileText then useXSmallTileTypography() else nil
	local v8, v9

	if FFlagSocialCarouselXSmallTileText and v7 and v6 then
		v8 = {
			Font = v6.Typography.BodySmall.Font,
			FontSize = v6.FontSize.FontSize_200,
			LineHeight = v6.Typography.BodySmall.LineHeight
		}

		v9 = {
			Font = v6.Typography.TitleMedium.Font,
			FontSize = v6.FontSize.FontSize_200,
			LineHeight = v6.Typography.TitleMedium.LineHeight
		}
	end

	local v10

	if fFlagSocialCarouselShareQREnabled then
		v10 = {
			friendsHintBold = Constants.LOCALIZATION.FRIENDS_HINT_BOLD,
			friendsHintPlain = Constants.LOCALIZATION.FRIENDS_HINT_PLAIN
		}
	else
		v10 = {
			friendsHintTitle = Constants.LOCALIZATION.FRIENDS_HINT_TITLE,
			friendsHintBody = Constants.LOCALIZATION.FRIENDS_HINT_BODY
		}
	end

	local v11 = useLocalization(v10)

	React.useEffect(function()
		v5.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.EMPTY_HINT)
	end, {})

	local createElement = React.createElement
	local newUDim2 = UDim2.new
	local scale = p2.itemSize.X.Scale
	local v14 = p2.itemSize.X.Offset + Constants.TILE_TEXT_WIDTH
	local scale2 = p2.itemSize.Y.Scale
	local v15

	if FFlagSocialCarouselXSmallTileText and v7 then
		v15 = p2.itemSize.X.Offset
	else
		v15 = p2.itemSize.Y.Offset - Constants.TILE_TEXT_HEIGHT
	end

	local v13 = {
		Size = newUDim2(scale, v14, scale2, v15),
		LayoutOrder = p2.index,
		BackgroundTransparency = 1,
		tag = "col auto-none align-y-center"
	}

	local createElement2 = React.createElement
	local v19

	if fFlagSocialCarouselShareQREnabled then
		v19 = {
			HintText = React.createElement(text, {
				Text = `<b>{v11.friendsHintBold}</b> {v11.friendsHintPlain}`,
				RichText = true,
				fontStyle = v8,
				tag = "text-body-small text-align-x-left auto-xy text-wrap"
			})
		}
	else
		v19 = {
			Title = React.createElement(text, {
				Text = v11.friendsHintTitle,
				fontStyle = v9,
				tag = "text-title-medium text-align-x-left auto-xy text-wrap",
				LayoutOrder = 1
			}),
			Subtitle = React.createElement(text, {
				Text = v11.friendsHintBody,
				fontStyle = v8,
				tag = "text-body-small text-align-x-left auto-xy text-wrap",
				LayoutOrder = 2
			})
		}
	end

	return createElement(view, v13, {
		Content = createElement2(view, {
			BackgroundTransparency = 1,
			tag = {
				["auto-xy"] = fFlagSocialCarouselShareQREnabled,
				["col gap-xxsmall auto-xy"] = not fFlagSocialCarouselShareQREnabled
			}
		}, v19)
	})
end

return FriendsHintTile
