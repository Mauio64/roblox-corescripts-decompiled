local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local Foundation = require(SocialCarouselParent.Foundation)
local useLocalization = require(SocialCarouselParent.Localization).Hooks.useLocalization
local Constants = require(SocialCarousel.Common.Constants)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local FoundationText = Foundation.Text
local View = Foundation.View
local FFlagConnectionsToFriendsRename = require(SocialCarouselParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagSocialCarouselShareQREnabled = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselShareQREnabled

local function FriendsHintTile(t1: {[any]: any}) -- line: 22
	-- upvalues: useSocialCarouselContext (copy), FFlagSocialCarouselShareQREnabled (copy), Constants (copy), FFlagConnectionsToFriendsRename (copy), useLocalization (copy), React (copy), View (copy), FoundationText (copy)
	local v14 = useSocialCarouselContext()
	local v15 = if not FFlagSocialCarouselShareQREnabled then {
		friendsHintTitle = if not FFlagConnectionsToFriendsRename then Constants.LOCALIZATION.CONNECTIONS_HINT_TITLE else Constants.LOCALIZATION.FRIENDS_HINT_TITLE,
		friendsHintBody = if not FFlagConnectionsToFriendsRename then Constants.LOCALIZATION.CONNECTIONS_HINT_BODY else Constants.LOCALIZATION.FRIENDS_HINT_BODY
	} else {
		friendsHintBold = Constants.LOCALIZATION.FRIENDS_HINT_BOLD,
		friendsHintPlain = Constants.LOCALIZATION.FRIENDS_HINT_PLAIN
	}
	local v16 = useLocalization(v15)

	React.useEffect(function() -- line: 41
		-- upvalues: v14 (copy), Constants (copy)
		v14.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.EMPTY_HINT)
	end, {})

	return React.createElement(View, {
		BackgroundTransparency = 1,
		tag = "col auto-none align-y-center",
		Size = UDim2.new(t1.itemSize.X.Scale, t1.itemSize.X.Offset + Constants.TILE_TEXT_WIDTH, t1.itemSize.Y.Scale, t1.itemSize.Y.Offset - Constants.TILE_TEXT_HEIGHT),
		LayoutOrder = t1.index
	}, {
		Content = React.createElement(View, {
			BackgroundTransparency = 1,
			tag = {
				["auto-xy"] = FFlagSocialCarouselShareQREnabled,
				["col gap-xxsmall auto-xy"] = not FFlagSocialCarouselShareQREnabled
			}
		}, if not FFlagSocialCarouselShareQREnabled then {
			Title = React.createElement(FoundationText, {
				tag = "text-title-medium text-align-x-left auto-xy text-wrap",
				LayoutOrder = 1,
				Text = v16.friendsHintTitle
			}),
			Subtitle = React.createElement(FoundationText, {
				tag = "text-body-small text-align-x-left auto-xy text-wrap",
				LayoutOrder = 2,
				Text = v16.friendsHintBody
			})
		} else {
			HintText = React.createElement(FoundationText, {
				RichText = true,
				tag = "text-body-small text-align-x-left auto-xy text-wrap",
				Text = `<b>{ v16.friendsHintBold }</b> { v16.friendsHintPlain }`
			})
		})
	})
end

return FriendsHintTile
