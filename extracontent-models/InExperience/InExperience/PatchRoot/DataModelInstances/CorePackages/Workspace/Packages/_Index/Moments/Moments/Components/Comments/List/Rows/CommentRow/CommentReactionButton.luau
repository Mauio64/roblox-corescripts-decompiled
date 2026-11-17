local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local FFlagMomentsCommentRowRedesign = require(Moments.Flags.FFlagMomentsCommentRowRedesign)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local FFlagMomentsUseSharedReactions = require(Moments.Flags.FFlagMomentsUseSharedReactions)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local v

if FFlagMomentsUseSharedReactions then
	v = require(parent.Reactions.Reaction)
else
	v = MomentsCommon.Components.Reaction
end

local ReactionAssets = MomentsCommon.Components.ReactionAssets
local ReactionSize = MomentsCommon.Enums.ReactionSize
local ReactionType = MomentsCommon.Enums.ReactionType

local v2 = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }

local v3 = { frequency = 5, dampingRatio = 0.5 }
local v4 = { frequency = 6, dampingRatio = 1 }

local function CommentReactionButton(props)
	local v5 = useTokens()
	local formatted = `moments-comment-reaction-button-{props.commentId}`

	local v6, v7 = ReactOtter.useAnimatedBinding(props.isReactionSelected and 1 or 0)
	local ref = React.useRef({
		commentId = props.commentId,
		isReactionSelected = props.isReactionSelected
	})
	React.useLayoutEffect(function()
		local current = ref.current
		ref.current = { commentId = props.commentId, isReactionSelected = props.isReactionSelected }
		local v8 = props.isReactionSelected and 1 or 0

		if current.commentId ~= props.commentId then
			v7((ReactOtter.instant(v8)))
		elseif current.isReactionSelected ~= props.isReactionSelected then
			local spring = ReactOtter.spring
			local v9

			if props.isReactionSelected then
				v9 = v3
			else
				v9 = v4
			end

			v7(spring(v8, v9))
		end
	end, { props.commentId, props.isReactionSelected })
	local v8

	if FFlagMomentsCommentRowRedesign then
		v8 = v5.Color.Content.Emphasis
	else
		v8 = v5.Color.Content.Default
	end

	local mapped = v6:map(function(value: number)
		return getColorStyleWithTransparency(v8, (math.clamp(value, 0, 1)))
	end)

	local mapped2 = v6:map(function(value: number)
		return (math.lerp(1, 0.6, (math.clamp(value, 0, 1))))
	end)

	local mapped3 = v6:map(function(value: number)
		return getColorStyleWithTransparency(v2, 1 - math.clamp(value, 0, 1))
	end)

	local v9 = not FFlagMomentsCommentRowRedesign and 1
		or v5.Size.Size_400 / ReactionAssets.getSizePixels(ReactionSize.XSmall)

	if FFlagMomentsUseSharedReactions and FFlagMomentsCommentRowRedesign then
		v9 = v5.Size.Size_400 / v5.Size.Size_500
	end

	local mapped4 = v6:map(function(p: number)
		return math.lerp(0.6, 1, p) * v9
	end)

	local small = v5.Padding.Small
	local rightInset = props.rightInset or small
	local v10

	if FFlagMomentsCommentRowRedesign then
		v10 = small - (v5.Size.Size_600 - v5.Size.Size_400) / 2
	else
		v10 = small
	end

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, v5.Radius.Medium),
			offset = 0,
			borderWidth = v5.Stroke.Thicker
		}
	end, { v5 })

	local createElement = React.createElement
	local v11 = {
		tag = {
			["size-0-600 auto-x"] = FFlagMomentsCommentRowRedesign,
			["auto-xy"] = not FFlagMomentsCommentRowRedesign
		},
		LayoutOrder = props.LayoutOrder,
		testId = `moments-comment-reaction-{props.commentId}`
	}

	local createElement2 = React.createElement
	local anchorPoint

	if FFlagMomentsCommentRowRedesign then
		anchorPoint = Vector2.new(0, 0.5)
	end

	local position

	if FFlagMomentsCommentRowRedesign then
		position = UDim2.new(0, 0, 0.5, -1)
	end

	local padding = { right = UDim.new(0, rightInset), bottom = 0 }
	local bottom

	if not FFlagMomentsCommentRowRedesign then
		bottom = UDim.new(0, small)
	end

	padding.bottom = bottom

	local createElement3 = React.createElement
	local v12 = {
		tag = "row align-y-center gap-xsmall auto-xy",
		testId = `moments-comment-reaction-content-{props.commentId}`,
		GroupTransparency = props.isReactionDisabled and 0.5 or nil
	}

	local createElement4 = React.createElement
	local v13 = {
		tag = {
			["size-400-400"] = FFlagMomentsCommentRowRedesign,
			["size-500-500"] = not FFlagMomentsCommentRowRedesign
		},
		LayoutOrder = 1,
		testId = `moments-comment-reaction-icon-slot-{props.commentId}`
	}

	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local v14 = {
		name = BuilderIcons.Icon.ThumbUp,
		size = 0,
		style = 0,
		AnchorPoint = 0,
		Position = 0,
		testId = 0
	}
	local size

	if FFlagMomentsCommentRowRedesign then
		size = IconSize.Small
	else
		size = IconSize.Medium
	end

	v14.size = size
	v14.style = mapped
	v14.AnchorPoint = Vector2.new(0.5, 0.5)
	v14.Position = UDim2.fromScale(0.5, 0.5)
	v14.testId = `{formatted}--icon`
	local v15 = {
		IconSlot = createElement4(View, v13, {
			Thumb = createElement5(
				View,
				{ tag = "position-center-center anchor-center-center size-full", scale = mapped2 },
				{ Icon = createElement6(Icon, v14) }
			),
			Reacted = React.createElement(v, {
				reactionType = ReactionType.ThumbsUp,
				size = ReactionSize.XSmall,
				imageStyle = mapped3,
				scale = mapped4,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				testId = `{formatted}--image`
			})
		}),
		Count = 0
	}
	local count

	if not props.isReactionCountHidden then
		count = React.createElement(Text, {
			tag = {
				["auto-xy"] = true,
				["text-label-small content-emphasis"] = FFlagMomentsCommentRowRedesign,
				["text-title-small content-emphasis"] = not FFlagMomentsCommentRowRedesign and props.isReactionSelected,
				["text-body-small content-default"] = not (FFlagMomentsCommentRowRedesign or props.isReactionSelected)
			},
			Text = props.reactionCountLabel,
			testId = `moments-comment-reaction-count-{props.commentId}`,
			LayoutOrder = 2
		})
	end

	v15.Count = count
	local children = {
		PaddedContent = createElement2(
			View,
			{ tag = "auto-xy", AnchorPoint = anchorPoint, Position = position, padding = padding },
			{ Content = createElement3(View, v12, v15) }
		),
		HitArea = 0
	}

	local createElement7 = React.createElement
	local v16 = {
		tag = "radius-medium",
		Position = UDim2.fromOffset(-small, -v10),
		Size = 0,
		ZIndex = 2,
		cursor = 0,
		isDisabled = 0,
		onActivated = 0,
		selection = 0,
		testId = 0
	}
	local size2

	if FFlagMomentsCommentRowRedesign then
		size2 = UDim2.new(1, small, 1, 2 * v10)
	else
		size2 = UDim2.new(1, small, 1, small)
	end

	v16.Size = size2

	v16.cursor = cursor
	v16.isDisabled = props.isReactionDisabled
	local onActivated

	if not props.isReactionDisabled then
		onActivated = props.onReactionActivated
	end

	v16.onActivated = onActivated
	v16.selection = {
		Selectable = not props.isReactionDisabled
	}

	v16.testId = formatted
	children.HitArea = createElement7(View, v16)
	return createElement(View, v11, children)
end

return React.memo(CommentReactionButton)
