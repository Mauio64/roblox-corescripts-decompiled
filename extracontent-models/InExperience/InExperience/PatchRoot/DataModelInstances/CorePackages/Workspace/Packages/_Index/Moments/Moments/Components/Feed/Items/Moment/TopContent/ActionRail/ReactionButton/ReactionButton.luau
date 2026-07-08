local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local BuilderIcons = require(MomentsParent.BuilderIcons)
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local ReactOtter = require(MomentsParent.ReactOtter)
local Icon = Foundation.Icon
local View = Foundation.View
local Popover = Foundation.Popover
local IconSize = Foundation.Enums.IconSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local Reaction = MomentsCommon.Components.Reaction
local ReactionType = MomentsCommon.Enums.ReactionType
local RailItem = require(script.Parent.Parent.RailItem)
local ReactionPicker = require(script.Parent.ReactionPicker)
local MomentContext = require(script.Parent.Parent.Parent.Parent.MomentContext)
local useReactionCommit = require(script.Parent.Parent.Parent.Parent.Reactions.useReactionCommit)
local useMomentGestures = require(script.Parent.Parent.Parent.Parent.Reactions.useMomentGestures)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local usePreferredInput = require(Moments.Hooks.usePreferredInput)
local ThumbUp = BuilderIcons.Icon.ThumbUp
local t1 = {
	Transparency = 0,
	Color3 = Color3.new(1, 1, 1)
}

local function v29() -- line: 37
end
local function ReactionButton(t2: {[any]: any}) -- line: 45
	-- upvalues: useTokens (copy), usePreferredInput (copy), MomentContext (copy), useReactionCommit (copy), useSignalState (copy), React (copy), ReactOtter (copy), ReactionType (copy), useMomentGestures (copy), getColorStyleWithTransparency (copy), t1 (copy), Popover (copy), RailItem (copy), v29 (copy), View (copy), Icon (copy), ThumbUp (copy), IconSize (copy), Reaction (copy), PopoverSide (copy), PopoverAlign (copy), EnumsRadius (copy), ReactionPicker (copy)
	local v32 = useTokens()
	local v33 = usePreferredInput() == Enum.PreferredInput.Gamepad
	local store = MomentContext.useMoment().store
	local v35 = useReactionCommit()
	local v36 = useSignalState(store.getIsReactionPickerOpen)
	local v37 = useSignalState(store.getSelectedReaction)
	local v38 = v37 ~= nil
	local v39 = React.useCallback(function() -- line: 58
		-- upvalues: store (copy)
		store.setReactionPickerOpen(false)
	end, { store })
	local v40, v41 = ReactOtter.useAnimatedBinding(not v38 and 0 or 1)

	React.useEffect(function() -- line: 63
		-- upvalues: v41 (copy), ReactOtter (copy), v38 (copy)
		v41(ReactOtter.spring(not v38 and 0 or 1, {
			frequency = 6,
			dampingRatio = 1
		}))
	end, { v38 })

	local v42 = React.useRef(ReactionType.ThumbsUp)

	if v37 ~= nil then
		v42.current = v37
	end

	local v43 = v37 or v42.current
	local v44 = React.useCallback(function() -- line: 80
		-- upvalues: store (copy), v35 (copy)
		if store.getIsReacted(false) then
			v35("tapButton", nil, nil)
		end

		store.setReactionPickerOpen(true)
	end, {
		store,
		v35
	})
	local v45 = useMomentGestures(not v33 and not t2.isDisabled, {
		onTap = v44
	})
	local v46 = React.joinBindings({
		transition = v40,
		scrub = t2.animationRatio
	}):map(function(t3: {[any]: any}) -- line: 97
		-- upvalues: getColorStyleWithTransparency (copy), v32 (copy)
		local v49 = (1 - t3.transition) * (1 - t3.scrub)

		return getColorStyleWithTransparency(v32.Color.Content.Emphasis, 1 - v49)
	end)
	local v47 = React.joinBindings({
		transition = v40,
		scrub = t2.animationRatio
	}):map(function(t4: {[any]: any}) -- line: 104
		-- upvalues: getColorStyleWithTransparency (copy), t1 (copy)
		local v51 = t4.transition * (1 - t4.scrub)

		return getColorStyleWithTransparency(t1, 1 - v51)
	end)

	return React.createElement(Popover.Root, {
		isOpen = v36
	}, {
		Anchor = React.createElement(Popover.Anchor, nil, {
			ReactButton = React.createElement(RailItem, {
				animationRatio = t2.animationRatio,
				isDisabled = t2.isDisabled,
				onActivated = if not v33 then v29 else v44,
				LayoutOrder = t2.LayoutOrder,
				nativeRef = v45.ref,
				slot = React.createElement(View, {
					tag = "size-800-800"
				}, {
					Thumb = React.createElement(Icon, {
						name = ThumbUp,
						size = IconSize.Large,
						style = v46,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					}),
					Reacted = React.createElement(Reaction, {
						reactionType = v43,
						size = IconSize.Medium,
						imageStyle = v47,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					})
				})
			})
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = false,
			side = {
				offset = 8,
				position = PopoverSide.Top
			},
			align = PopoverAlign.End,
			radius = EnumsRadius.Circle,
			backgroundStyle = v32.Color.OverMedia.OverMedia_100,
			onPressedOutside = v39
		}, {
			ReactionPicker = React.createElement(ReactionPicker)
		})
	})
end

return React.memo(ReactionButton)
