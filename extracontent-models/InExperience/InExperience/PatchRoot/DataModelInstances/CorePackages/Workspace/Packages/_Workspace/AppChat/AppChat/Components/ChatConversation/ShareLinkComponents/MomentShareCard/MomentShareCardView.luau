local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Image = Foundation.Image
local Text = Foundation.Text
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius

local FFlagAppChatMomentShareCardUseFoundationImage = require(AppChat.Flags.FFlagAppChatMomentShareCardUseFoundationImage)
local FFlagAppChatNativeFoundationCornerRadii = require(AppChat.Flags.FFlagAppChatNativeFoundationCornerRadii)
local FFlagAppChatMomentShareCardLoadingSkeletons = require(AppChat.Flags.FFlagAppChatMomentShareCardLoadingSkeletons)
local FFlagAppChatMomentShareCardHideMomentsGlyph = require(AppChat.Flags.FFlagAppChatMomentShareCardHideMomentsGlyph)

local v = FFlagAppChatNativeFoundationCornerRadii and FFlagAppChatMomentShareCardUseFoundationImage

local GameCardError = require(script.Parent.Parent.GameCardComponents.GameCardError)
local MomentDetailsStatus = require(script.Parent.MomentDetailsStatus)

local MomentShareCardUnavailable = require(script.Parent.MomentShareCardUnavailable)

local function toUDim(value) -- 4 equivalent calls inferred from this helper
	if type(value) == "number" then
		return (UDim.new(0, value))
	end

	return value
end

local function roundedCorner(props)
	if props == nil then
		return nil
	end

	return React.createElement("UICorner", {
		TopLeftRadius = toUDim(props.topLeft), -- inferred equivalent call
		TopRightRadius = toUDim(props.topRight), -- inferred equivalent call
		BottomLeftRadius = toUDim(props.bottomLeft), -- inferred equivalent call
		BottomRightRadius = toUDim(props.bottomRight) -- inferred equivalent call
	})
end

local function MomentShareCardView(props)
	if props.status == MomentDetailsStatus.Error then
		return React.createElement(GameCardError)
	end

	if props.status == MomentDetailsStatus.Unavailable or props.status == MomentDetailsStatus.Locked then
		return React.createElement(MomentShareCardUnavailable)
	end

	local createElement = React.createElement
	local v2 = {
		tag = "col auto-y",
		testId = "MomentShareCardView",
		Size = UDim2.fromOffset(props.mediaSize, 0),
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local v3 = {
		tag = "clip",
		testId = "MomentSharePlaceholder",
		Size = UDim2.fromOffset(props.mediaSize, props.mediaSize),
		LayoutOrder = 1
	}
	local momentShareCardPoster

	if props.hasMedia then
		local createElement3 = React.createElement
		local shimmerClip

		if not props.isPosterLoaded then
			shimmerClip = React.createElement("CanvasGroup", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 1,
				[React.Tag] = "data-testid=MomentShareCardPosterShimmer"
			}, {
				Corner = roundedCorner(props.cornerRadii),
				Shimmer = React.createElement(Skeleton, {
					radius = Radius.None,
					Size = UDim2.fromScale(1, 1)
				})
			})
		end

		local poster

		if props.posterContent ~= nil then
			if v then
				poster = React.createElement(Image, {
					tag = "size-full",
					ImageContent = props.posterContent,
					ScaleType = Enum.ScaleType.Crop,
					ZIndex = 2,
					testId = "MomentShareCardPosterImage",
					cornerRadius = props.cornerRadii
				})
			else
				poster = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ImageContent = props.posterContent,
					ScaleType = Enum.ScaleType.Crop,
					ZIndex = 2,
					[React.Tag] = "data-testid=MomentShareCardPosterImage"
				}, {
					Corner = roundedCorner(props.cornerRadii)
				})
			end
		end

		momentShareCardPoster = createElement3(View, {
			tag = "size-full",
			testId = "MomentShareCardPoster"
		}, {
			ShimmerClip = shimmerClip,
			Poster = poster
		})
	end

	local momentSharePlayButton

	if props.isVideo then
		momentSharePlayButton = React.createElement(
			View,
			{
				tag = "row align-x-center align-y-center position-center-center anchor-center-center size-1200-1200 radius-circle clip bg-over-media-0",
				testId = "MomentSharePlayButton",
				ZIndex = 2
			},
			{
				Glyph = React.createElement(Icon, {
					name = IconName.PlayLarge,
					size = IconSize.Medium,
					style = props.playIconStyle
				})
			}
		)
	end

	local createElement3 = React.createElement
	local v4 = {
		tag = "size-full",
		testId = "MomentShareInteractionOverlay",
		onActivated = props.onActivated,
		cornerRadius = 0,
		selection = 0,
		ZIndex = 3
	}
	local cornerRadius

	if FFlagAppChatNativeFoundationCornerRadii then
		cornerRadius = props.cornerRadii
	end

	v4.cornerRadius = cornerRadius
	v4.selection = { Selectable = props.selectable }
	local corner

	if not FFlagAppChatNativeFoundationCornerRadii then
		corner = roundedCorner(props.cornerRadii)
	end

	local children = {
		MomentSharePlaceholder = createElement2(View, v3, {
			MomentShareCardPoster = momentShareCardPoster,
			MomentSharePlayButton = momentSharePlayButton,
			InteractionOverlay = createElement3(View, v4, { Corner = corner })
		}),
		Footer = 0
	}

	local createElement4 = React.createElement
	local username

	if FFlagAppChatMomentShareCardLoadingSkeletons and props.isUsernameLoading then
		username = React.createElement(View, {
			tag = "row align-y-center size-full-500",
			LayoutOrder = 1
		}, {
			Skeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(0.6, 1),
				radius = Radius.Small,
				testId = "MomentShareUsernameSkeleton"
			})
		})
	elseif props.username then
		username = React.createElement(Text, {
			tag = "size-full-500 text-title-medium text-align-x-left text-truncate-end content-emphasis",
			Text = props.username,
			LayoutOrder = 1
		})
	end

	local metadata

	if props.metadataText or FFlagAppChatMomentShareCardLoadingSkeletons and props.isMetadataLoading then
		local createElement5 = React.createElement
		local momentsGlyph

		if not FFlagAppChatMomentShareCardHideMomentsGlyph then
			momentsGlyph = React.createElement(Icon, {
				name = IconName.Moments,
				size = IconSize.Small,
				testId = "MomentShareMomentsGlyph",
				LayoutOrder = 1
			})
		end

		local metadataText

		if FFlagAppChatMomentShareCardLoadingSkeletons and props.isMetadataLoading then
			metadataText = React.createElement(Skeleton, {
				Size = UDim2.fromScale(0.7, 1),
				radius = Radius.Small,
				testId = "MomentShareMetadataSkeleton",
				LayoutOrder = 2
			})
		else
			metadataText = React.createElement(Text, {
				tag = "fill auto-y text-body-medium text-align-x-left text-truncate-end content-default",
				Text = props.metadataText,
				LayoutOrder = 2
			})
		end

		metadata = createElement5(
			View,
			{
				tag = "row align-y-center gap-xsmall size-full-500",
				testId = "MomentShareMetadata",
				LayoutOrder = 2
			},
			{ MomentsGlyph = momentsGlyph, MetadataText = metadataText }
		)
	end

	children.Footer = createElement4(
		View,
		{
			tag = "col size-full-0 auto-y padding-medium",
			testId = "MomentShareFooter",
			LayoutOrder = 2
		},
		{ Username = username, Metadata = metadata }
	)
	return createElement(View, v2, children)
end

return React.memo(MomentShareCardView)
