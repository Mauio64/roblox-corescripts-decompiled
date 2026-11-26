local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local FFlagMomentsCommentRowRedesign = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentRowRedesign")
local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")
local FFlagMomentsUseSharedReactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsUseSharedReactions")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local v5 = if FFlagMomentsUseSharedReactions then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/Reaction") else MomentsCommon.Components.Reaction
local reactionAssets = MomentsCommon.Components.ReactionAssets
local reactionSize = MomentsCommon.Enums.ReactionSize
local reactionType = MomentsCommon.Enums.ReactionType

local v6 = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }

local v7 = { frequency = 5, dampingRatio = 0.5 }
local v8 = { frequency = 6, dampingRatio = 1 }

local function CommentReactionButton(props)
	local v9 = useTokens()
	local formatted = `moments-comment-reaction-button-{props.commentId}`

	local v10, v11 = ReactOtter.useAnimatedBinding(props.isReactionSelected and 1 or 0)
	local ref = React.useRef({
		commentId = props.commentId,
		isReactionSelected = props.isReactionSelected
	})
	React.useLayoutEffect(function()
		local current = ref.current
		ref.current = {
			commentId = props.commentId,
			isReactionSelected = props.isReactionSelected
		}
		local v12 = props.isReactionSelected and 1 or 0

		if current.commentId ~= props.commentId then
			v11(ReactOtter.instant(v12))
		elseif current.isReactionSelected ~= props.isReactionSelected then
			local spring = ReactOtter.spring
			local v14 = if props.isReactionSelected then v7 else v8
			v11(spring(v12, v14))
		end
	end, { props.commentId, props.isReactionSelected })

	local v12 = if FFlagMomentsCommentRowRedesign then v9.Color.Content.Emphasis else v9.Color.Content.Default
	local mapped = v10:map(function(value)
		return getColorStyleWithTransparency(v12, (math.clamp(value, 0, 1)))
	end)

	local mapped2 = v10:map(function(value)
		return (math.lerp(1, 0.6, (math.clamp(value, 0, 1))))
	end)

	local mapped3 = v10:map(function(value)
		return getColorStyleWithTransparency(v6, 1 - math.clamp(value, 0, 1))
	end)

	local v13 = not FFlagMomentsCommentRowRedesign and 1 or v9.Size.Size_400 / reactionAssets.getSizePixels(reactionSize.XSmall)

	if FFlagMomentsUseSharedReactions and FFlagMomentsCommentRowRedesign then
		v13 = v9.Size.Size_400 / v9.Size.Size_500
	end

	local mapped4 = v10:map(function(p2)
		return math.lerp(0.6, 1, p2) * v13
	end)

	local small = v9.Padding.Small
	local rightInset = props.rightInset or small

	local v14 = if FFlagMomentsCommentRowRedesign then small - (v9.Size.Size_600 - v9.Size.Size_400) / 2 else small

	local v15 = React.useMemo(function()
		return {
			radius = UDim.new(0, v9.Radius.Medium),
			offset = 0,
			borderWidth = v9.Stroke.Thicker
		}
	end, { v9 })

	local createElement = React.createElement
	local v17 = {
		tag = {
			["size-0-600 auto-x"] = FFlagMomentsCommentRowRedesign,
			["auto-xy"] = not FFlagMomentsCommentRowRedesign
		},
		LayoutOrder = props.LayoutOrder,
		testId = `moments-comment-reaction-{props.commentId}`
	}

	local createElement2 = React.createElement

	local v20 = if FFlagMomentsCommentRowRedesign then Vector2.new(0, 0.5) else nil
	local v21 = if FFlagMomentsCommentRowRedesign then UDim2.new(0, 0, 0.5, -1) else nil
	local v22 = { right = UDim.new(0, rightInset), bottom = 0 }
	local v23 = if not FFlagMomentsCommentRowRedesign then UDim.new(0, small) else nil
	v22.bottom = v23

	local createElement3 = React.createElement
	local v26 = {
		tag = "row align-y-center gap-xsmall auto-xy",
		testId = `moments-comment-reaction-content-{props.commentId}`,
		GroupTransparency = props.isReactionDisabled and 0.5 or nil
	}

	local createElement4 = React.createElement
	local v29 = {
		tag = {
			["size-400-400"] = FFlagMomentsCommentRowRedesign,
			["size-500-500"] = not FFlagMomentsCommentRowRedesign
		},
		LayoutOrder = 1,
		testId = `moments-comment-reaction-icon-slot-{props.commentId}`
	}

	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local v34 = {
		name = BuilderIcons.Icon.ThumbUp,
		size = 0,
		style = 0,
		AnchorPoint = 0,
		Position = 0,
		testId = 0
	}
	local v35 = if FFlagMomentsCommentRowRedesign then iconSize.Small else iconSize.Medium
	v34.size = v35
	v34.style = mapped
	v34.AnchorPoint = Vector2.new(0.5, 0.5)
	v34.Position = UDim2.fromScale(0.5, 0.5)
	v34.testId = `{formatted}--icon`
	local v27 = {
		IconSlot = createElement4(view, v29, {
			Thumb = createElement5(
				view,
				{
					tag = "position-center-center anchor-center-center size-full",
					scale = mapped2
				},
				{ Icon = createElement6(icon, v34) }
			),
			Reacted = React.createElement(v5, {
				reactionType = reactionType.ThumbsUp,
				size = reactionSize.XSmall,
				imageStyle = mapped3,
				scale = mapped4,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				testId = `{formatted}--image`
			})
		}),
		Count = 0
	}

	local v36 = if not props.isReactionCountHidden then React.createElement(text, {
		tag = {
			["auto-xy"] = true,
			["text-label-small content-emphasis"] = FFlagMomentsCommentRowRedesign,
			["text-title-small content-emphasis"] = not FFlagMomentsCommentRowRedesign and props.isReactionSelected,
			["text-body-small content-default"] = not (FFlagMomentsCommentRowRedesign or props.isReactionSelected)
		},
		Text = props.reactionCountLabel,
		testId = `moments-comment-reaction-count-{props.commentId}`,
		LayoutOrder = 2
	}) else nil
	v27.Count = v36
	local children = {
		PaddedContent = createElement2(
			view,
			{ tag = "auto-xy", AnchorPoint = v20, Position = v21, padding = v22 },
			{ Content = createElement3(view, v26, v27) }
		),
		HitArea = 0
	}

	local createElement7 = React.createElement
	local v38 = {
		tag = "radius-medium",
		Position = UDim2.fromOffset(-small, -v14),
		Size = 0,
		ZIndex = 2,
		cursor = 0,
		isDisabled = 0,
		onActivated = 0,
		selection = 0,
		testId = 0
	}

	local v39 = if FFlagMomentsCommentRowRedesign then UDim2.new(1, small, 1, 2 * v14) else UDim2.new(1, small, 1, small)
	v38.Size = v39

	v38.cursor = v15
	v38.isDisabled = props.isReactionDisabled
	local v40 = if not props.isReactionDisabled then props.onReactionActivated else nil
	v38.onActivated = v40
	v38.selection = {
		Selectable = not props.isReactionDisabled
	}

	v38.testId = formatted
	children.HitArea = createElement7(view, v38)
	return createElement(view, v17, children)
end

return React.memo(CommentReactionButton)
