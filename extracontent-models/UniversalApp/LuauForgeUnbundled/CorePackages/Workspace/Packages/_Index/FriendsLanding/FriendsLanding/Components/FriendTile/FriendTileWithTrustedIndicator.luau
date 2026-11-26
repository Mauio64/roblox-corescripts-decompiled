local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local react = dependencies.React
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Localization").Hooks.useLocalization
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/LuaSocialLibrariesDeps").llama
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/VerifiedBadges")

local uiBlox = dependencies.UIBlox
local useStyle = uiBlox.Core.Style.useStyle
local playerTile = uiBlox.App.Tile.PlayerTile
local openTypeSupport = uiBlox.Utility.OpenTypeSupport
local playerContext = uiBlox.App.Indicator.PlayerContext

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Foundation")
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local text = Foundation.Text
local skeleton = Foundation.Skeleton
local enums = Foundation.Enums
local stateLayerAffordance = enums.StateLayerAffordance

local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagEnableBlackbirdCheck

local v5 = {
	userPresence = nil,
	index = 1,
	openPlayerProfile = nil,
	buttons = nil,
	trustedConnection = false,
	isVerified = false
}

local function FriendTileWithTrustedIndicator(options)
	local joined = llama.Dictionary.join(v5, options or {})
	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useLocalization({
		trustedText = "Feature.Friends.TrustedConnection.Label.Trusted"
	})

	local textDefault = v6.Theme.TextDefault
	local iconColor, icon, iconTransparency

	if joined.relevancyInfo then
		iconColor = joined.relevancyInfo.iconColor
		icon = joined.relevancyInfo.icon
		iconTransparency = joined.relevancyInfo.iconTransparency
	end

	local createElement = react.createElement
	local v10 = {
		tag = "col auto-xy size-0-0 gap-small",
		onActivated = joined.openPlayerProfile,
		stateLayer = { affordance = stateLayerAffordance.None }
	}

	local createElement2 = react.createElement

	local createElement3 = react.createElement
	local v15 = {
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

	local v16 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
	v15.openTypeFeatures = v16
	local children = {
		PlayerTile = createElement2(
			view,
			{ tag = "size-full-full aspect-1-1 bg-surface-100 clip", LayoutOrder = 1 },
			{ createElement3(playerTile, v15) }
		),
		TextColumn = 0
	}

	local createElement4 = react.createElement

	local createElement5 = react.createElement

	local v22 = if not joined.title then react.createElement(skeleton, {
		Size = UDim2.new(1, 0, 0, v7.Typography.TitleLarge.FontSize)
	}) else nil

	local v23 = joined.title

	if v23 then
		local createElement6 = react.createElement

		local v26 = {
			TitleText = react.createElement(text, {
				tag = "text-truncate-end text-align-x-left auto-xy shrink content-default",
				fontStyle = v7.Typography.TitleLarge,
				Text = joined.title,
				LayoutOrder = 1,
				RichText = true
			}),
			VerifiedBadge = joined.isVerified and react.createElement(text, {
				tag = "auto-xy content-default",
				fontStyle = v7.Typography.TitleLarge,
				Text = VerifiedBadges.emoji.verified,
				LayoutOrder = 2,
				RichText = true
			}),
			SubscriptionBadge = 0
		}

		local v27 = if fFlagEnableBlackbirdCheck and joined.isRobloxSubscriber == true then react.createElement(Foundation.Icon, {
			name = enums.IconName.RobloxPlus,
			size = enums.IconSize.Small,
			style = v7.Color.Content.Emphasis,
			LayoutOrder = 3
		}) else nil
		v26.SubscriptionBadge = v27
		v23 = createElement6(view, {
			tag = "row auto-y size-full-0 align-y-center ",
			LayoutOrder = 1
		}, v26)
	end

	local children2 = {
		Title = createElement5(view, { tag = "auto-y size-full-0" }, {
			LoadingSkeleton = v22,
			Title = v23
		}),
		Subtitle = 0,
		RelevancyContainer = 0
	}

	local createElement6 = react.createElement

	local v27 = if not joined.subtitle or joined.subtitle == "@" then react.createElement(skeleton, {
		Size = UDim2.new(0.4, 0, 0, v7.Typography.BodySmall.FontSize)
	}) else nil

	local v28 = joined.subtitle

	if v28 then
		if joined.subtitle == "@" then
			v28 = false
		else
			v28 = react.createElement(text, {
				tag = "text-truncate-end auto-xy text-align-x-left shrink content-default",
				fontStyle = v7.Typography.BodySmall,
				Text = joined.subtitle,
				LayoutOrder = 1,
				RichText = true
			})
		end
	end

	local v29 = joined.isTrustedConnection and joined.subtitle

	if v29 then
		if joined.subtitle == "@" then
			v29 = false
		else
			v29 = react.createElement(text, {
				tag = "content-default auto-xy text-align-x-left",
				LayoutOrder = 2,
				fontStyle = v7.Typography.BodySmall,
				Text = " • " .. v8.trustedText
			})
		end
	end

	children2.Subtitle = createElement6(view, {
		tag = "row auto-y size-full-0",
		LayoutOrder = 2
	}, {
		LoadingSkeleton = v27,
		SubtitleText = v28,
		TCTextLabel = v29
	})

	local createElement7 = react.createElement

	local v33 = joined.relevancyInfo and joined.relevancyInfo.text

	if v33 then
		local createElement8 = react.createElement
		local v35 = {
			fontStyle = v6.Font.CaptionBody,
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

		local v36 = if joined.relevancyInfo then joined.relevancyInfo.text else nil
		v35.text = v36
		v35.textColorStyle = textDefault
		v35.onActivated = joined.openPlayerProfile
		v33 = createElement8(playerContext, v35)
	end

	children2.RelevancyContainer = createElement7(
		view,
		{
			tag = "size-full-0 row auto-y gap-xsmall align-x-left align-y-center",
			LayoutOrder = 3
		},
		{ ContextualPresence = v33 }
	)
	children.TextColumn = createElement4(
		view,
		{ tag = "col size-full-0 auto-y gap-xxsmall", LayoutOrder = 2 },
		children2
	)
	return createElement(view, v10, children)
end

return FriendTileWithTrustedIndicator
