local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)

local react = dependencies.React
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local VerifiedBadges = require(parent.VerifiedBadges)

local uiBlox = dependencies.UIBlox
local useStyle = uiBlox.Core.Style.useStyle
local playerTile = uiBlox.App.Tile.PlayerTile
local openTypeSupport = uiBlox.Utility.OpenTypeSupport
local playerContext = uiBlox.App.Indicator.PlayerContext

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Text = Foundation.Text
local Skeleton = Foundation.Skeleton
local Enums = Foundation.Enums
local StateLayerAffordance = Enums.StateLayerAffordance

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags2.FFlagEnableBlackbirdCheck

local v = {
	userPresence = nil,
	index = 1,
	openPlayerProfile = nil,
	buttons = nil,
	trustedConnection = false,
	isVerified = false
}

local function FriendTileWithTrustedIndicator(options)
	local joined = llama.Dictionary.join(v, options or {})
	local v2 = useStyle()
	local v3 = useTokens()
	local v4 = useLocalization({ trustedText = "Feature.Friends.TrustedConnection.Label.Trusted" })

	local textDefault = v2.Theme.TextDefault
	local iconColor, icon, iconTransparency

	if joined.relevancyInfo then
		iconColor = joined.relevancyInfo.iconColor
		icon = joined.relevancyInfo.icon
		iconTransparency = joined.relevancyInfo.iconTransparency
	end

	local createElement = react.createElement
	local v5 = {
		tag = "col auto-xy size-0-0 gap-small",
		onActivated = joined.openPlayerProfile,
		stateLayer = { affordance = StateLayerAffordance.None }
	}

	local createElement2 = react.createElement

	local createElement3 = react.createElement
	local v6 = {
		tileSize = UDim2.fromScale(1, 1),
		thumbnail = joined.user.thumbnail,
		title = "",
		subtitle = "",
		onActivated = joined.openPlayerProfile,
		forwardedRef = joined.playerTileRef,
		buttons = joined.buttons,
		Selectable = false,
		openTypeFeatures = 0
	}
	local openTypeFeatures

	if GetFFlagLuaAppEnableOpenTypeSupport() then
		openTypeFeatures = openTypeSupport:getUserNameStylisticAlternative()
	end

	v6.openTypeFeatures = openTypeFeatures
	local children = {
		PlayerTile = createElement2(View, {
			tag = "size-full-full aspect-1-1 bg-surface-100 clip",
			LayoutOrder = 1
		}, {
			createElement3(playerTile, v6)
		}),
		TextColumn = 0
	}

	local createElement4 = react.createElement

	local createElement5 = react.createElement
	local loadingSkeleton

	if not joined.title then
		loadingSkeleton = react.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, v3.Typography.TitleLarge.FontSize)
		})
	end

	local title = joined.title

	if title then
		local createElement6 = react.createElement

		local v7 = {
			TitleText = react.createElement(Text, {
				tag = "text-truncate-end text-align-x-left auto-xy shrink content-default",
				fontStyle = v3.Typography.TitleLarge,
				Text = joined.title,
				LayoutOrder = 1,
				RichText = true
			}),
			VerifiedBadge = joined.isVerified and react.createElement(Text, {
				tag = "auto-xy content-default",
				fontStyle = v3.Typography.TitleLarge,
				Text = VerifiedBadges.emoji.verified,
				LayoutOrder = 2,
				RichText = true
			}),
			SubscriptionBadge = 0
		}
		local subscriptionBadge

		if FFlagEnableBlackbirdCheck and joined.isRobloxSubscriber == true then
			subscriptionBadge = react.createElement(Foundation.Icon, {
				name = Enums.IconName.RobloxPlus,
				size = Enums.IconSize.Small,
				style = v3.Color.Content.Emphasis,
				LayoutOrder = 3
			})
		end

		v7.SubscriptionBadge = subscriptionBadge
		title = createElement6(View, {
			tag = "row auto-y size-full-0 align-y-center ",
			LayoutOrder = 1
		}, v7)
	end

	local children2 = {
		Title = createElement5(View, { tag = "auto-y size-full-0" }, {
			LoadingSkeleton = loadingSkeleton,
			Title = title
		}),
		Subtitle = 0,
		RelevancyContainer = 0
	}

	local createElement6 = react.createElement
	local loadingSkeleton2

	if not (joined.subtitle and joined.subtitle ~= "@") then
		loadingSkeleton2 = react.createElement(Skeleton, {
			Size = UDim2.new(0.4, 0, 0, v3.Typography.BodySmall.FontSize)
		})
	end

	local subtitleText = joined.subtitle

	if subtitleText then
		if joined.subtitle == "@" then
			subtitleText = false
		else
			subtitleText = react.createElement(Text, {
				tag = "text-truncate-end auto-xy text-align-x-left shrink content-default",
				fontStyle = v3.Typography.BodySmall,
				Text = joined.subtitle,
				LayoutOrder = 1,
				RichText = true
			})
		end
	end

	local tcTextLabel = joined.isTrustedConnection and joined.subtitle

	if tcTextLabel then
		if joined.subtitle == "@" then
			tcTextLabel = false
		else
			tcTextLabel = react.createElement(Text, {
				tag = "content-default auto-xy text-align-x-left",
				LayoutOrder = 2,
				fontStyle = v3.Typography.BodySmall,
				Text = " • " .. v4.trustedText
			})
		end
	end

	children2.Subtitle = createElement6(View, { tag = "row auto-y size-full-0", LayoutOrder = 2 }, {
		LoadingSkeleton = loadingSkeleton2,
		SubtitleText = subtitleText,
		TCTextLabel = tcTextLabel
	})

	local createElement7 = react.createElement

	local contextualPresence = joined.relevancyInfo and joined.relevancyInfo.text

	if contextualPresence then
		local createElement8 = react.createElement
		local v7 = {
			fontStyle = v2.Font.CaptionBody,
			icon = icon,
			iconColor = iconColor,
			iconSize = UDim2.fromOffset(12, 12),
			iconTransparency = iconTransparency,
			layoutOrder = 2,
			text = 0,
			textColorStyle = 0,
			onActivated = 0,
			Selectable = false
		}
		local text

		if joined.relevancyInfo then
			text = joined.relevancyInfo.text
		end

		v7.text = text
		v7.textColorStyle = textDefault
		v7.onActivated = joined.openPlayerProfile
		contextualPresence = createElement8(playerContext, v7)
	end

	children2.RelevancyContainer = createElement7(
		View,
		{ tag = "size-full-0 row auto-y gap-xsmall align-x-left align-y-center", LayoutOrder = 3 },
		{ ContextualPresence = contextualPresence }
	)
	children.TextColumn = createElement4(
		View,
		{ tag = "col size-full-0 auto-y gap-xxsmall", LayoutOrder = 2 },
		children2
	)
	return createElement(View, v5, children)
end

return FriendTileWithTrustedIndicator
