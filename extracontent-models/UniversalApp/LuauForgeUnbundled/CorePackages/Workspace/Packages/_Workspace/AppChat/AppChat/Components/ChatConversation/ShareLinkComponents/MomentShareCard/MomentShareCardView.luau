local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local view = Foundation.View
local image = Foundation.Image
local text = Foundation.Text
local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius

local FFlagAppChatMomentShareCardUseFoundationImage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardUseFoundationImage")
local FFlagAppChatNativeFoundationCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatNativeFoundationCornerRadii")
local FFlagAppChatMomentShareCardLoadingSkeletons = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardLoadingSkeletons")
local FFlagAppChatMomentShareCardHideMomentsGlyph = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardHideMomentsGlyph")

local v5 = FFlagAppChatNativeFoundationCornerRadii and FFlagAppChatMomentShareCardUseFoundationImage

local GameCardError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardError")
local MomentDetailsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentDetailsStatus")

local MomentShareCardUnavailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentShareCardUnavailable")

local function toUDim(value)
	if type(value) == "number" then
		return (UDim.new(0, value))
	end

	return value
end

local function roundedCorner(props)
	if props == nil then
		return nil
	end

	local createElement = React.createElement
	local topLeft = props.topLeft

	if type(topLeft) == "number" then
		topLeft = UDim.new(0, topLeft)
	end

	local topRight = props.topRight

	if type(topRight) == "number" then
		topRight = UDim.new(0, topRight)
	end

	local bottomLeft = props.bottomLeft

	if type(bottomLeft) == "number" then
		bottomLeft = UDim.new(0, bottomLeft)
	end

	local bottomRight = props.bottomRight

	if type(bottomRight) == "number" then
		bottomRight = UDim.new(0, bottomRight)
	end

	return createElement("UICorner", {
		TopLeftRadius = topLeft,
		TopRightRadius = topRight,
		BottomLeftRadius = bottomLeft,
		BottomRightRadius = bottomRight
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
	local v7 = {
		tag = "col auto-y",
		testId = "MomentShareCardView",
		Size = UDim2.fromOffset(props.mediaSize, 0),
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local v9 = {
		tag = "clip",
		testId = "MomentSharePlaceholder",
		Size = UDim2.fromOffset(props.mediaSize, props.mediaSize),
		LayoutOrder = 1
	}
	local v11

	if props.hasMedia then
		local createElement3 = React.createElement
		local v15

		if not props.isPosterLoaded then
			v15 = React.createElement("CanvasGroup", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 1,
				[React.Tag] = "data-testid=MomentShareCardPosterShimmer"
			}, {
				Corner = roundedCorner(props.cornerRadii),
				Shimmer = React.createElement(skeleton, {
					radius = radius.None,
					Size = UDim2.fromScale(1, 1)
				})
			})
		end

		local v16

		if props.posterContent ~= nil then
			if v5 then
				v16 = React.createElement(image, {
					tag = "size-full",
					ImageContent = props.posterContent,
					ScaleType = Enum.ScaleType.Crop,
					ZIndex = 2,
					testId = "MomentShareCardPosterImage",
					cornerRadius = props.cornerRadii
				})
			else
				v16 = React.createElement("ImageLabel", {
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

		v11 = createElement3(view, {
			tag = "size-full",
			testId = "MomentShareCardPoster"
		}, {
			ShimmerClip = v15,
			Poster = v16
		})
	end

	local v12 = if props.isVideo then React.createElement(
		view,
		{
			tag = "row align-x-center align-y-center position-center-center anchor-center-center size-1200-1200 radius-circle clip bg-over-media-0",
			testId = "MomentSharePlayButton",
			ZIndex = 2
		},
		{
			Glyph = React.createElement(icon, {
				name = iconName.PlayLarge,
				size = iconSize.Medium,
				style = props.playIconStyle
			})
		}
	) else nil

	local createElement3 = React.createElement
	local v14 = {
		tag = "size-full",
		testId = "MomentShareInteractionOverlay",
		onActivated = props.onActivated,
		cornerRadius = 0,
		selection = 0,
		ZIndex = 3
	}
	local v15 = if FFlagAppChatNativeFoundationCornerRadii then props.cornerRadii else nil
	v14.cornerRadius = v15
	v14.selection = { Selectable = props.selectable }

	local v17 = if not FFlagAppChatNativeFoundationCornerRadii then roundedCorner(props.cornerRadii) else nil
	local children = {
		MomentSharePlaceholder = createElement2(view, v9, {
			MomentShareCardPoster = v11,
			MomentSharePlayButton = v12,
			InteractionOverlay = createElement3(view, v14, { Corner = v17 })
		}),
		Footer = 0
	}

	local createElement4 = React.createElement
	local v21

	if FFlagAppChatMomentShareCardLoadingSkeletons and props.isUsernameLoading then
		v21 = React.createElement(view, {
			tag = "row align-y-center size-full-500",
			LayoutOrder = 1
		}, {
			Skeleton = React.createElement(skeleton, {
				Size = UDim2.fromScale(0.6, 1),
				radius = radius.Small,
				testId = "MomentShareUsernameSkeleton"
			})
		})
	elseif props.username then
		v21 = React.createElement(text, {
			tag = "size-full-500 text-title-medium text-align-x-left text-truncate-end content-emphasis",
			Text = props.username,
			LayoutOrder = 1
		})
	end

	local v22

	if props.metadataText or FFlagAppChatMomentShareCardLoadingSkeletons and props.isMetadataLoading then
		local createElement5 = React.createElement

		local v26 = if not FFlagAppChatMomentShareCardHideMomentsGlyph then React.createElement(icon, {
			name = iconName.Moments,
			size = iconSize.Small,
			testId = "MomentShareMomentsGlyph",
			LayoutOrder = 1
		}) else nil

		local v27 = if FFlagAppChatMomentShareCardLoadingSkeletons and props.isMetadataLoading then React.createElement(skeleton, {
			Size = UDim2.fromScale(0.7, 1),
			radius = radius.Small,
			testId = "MomentShareMetadataSkeleton",
			LayoutOrder = 2
		}) else React.createElement(text, {
			tag = "fill auto-y text-body-medium text-align-x-left text-truncate-end content-default",
			Text = props.metadataText,
			LayoutOrder = 2
		})
		v22 = createElement5(
			view,
			{
				tag = "row align-y-center gap-xsmall size-full-500",
				testId = "MomentShareMetadata",
				LayoutOrder = 2
			},
			{ MomentsGlyph = v26, MetadataText = v27 }
		)
	end

	children.Footer = createElement4(
		view,
		{
			tag = "col size-full-0 auto-y padding-medium",
			testId = "MomentShareFooter",
			LayoutOrder = 2
		},
		{ Username = v21, Metadata = v22 }
	)
	return createElement(view, v7, children)
end

return React.memo(MomentShareCardView)
