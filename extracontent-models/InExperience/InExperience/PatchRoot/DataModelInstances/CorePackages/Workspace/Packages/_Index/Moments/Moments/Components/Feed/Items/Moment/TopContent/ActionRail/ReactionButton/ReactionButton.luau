local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local ReactOtter = require(parent.ReactOtter)
local FFlagMomentsUseSharedReactions = require(Moments.Flags.FFlagMomentsUseSharedReactions)

local Icon = Foundation.Icon
local View = Foundation.View
local Popover = Foundation.Popover
local IconSize = Foundation.Enums.IconSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local v

if FFlagMomentsUseSharedReactions then
	v = require(parent.Reactions.Reaction)
else
	v = MomentsCommon.Components.Reaction
end

local ReactionPickerPopover

if FFlagMomentsUseSharedReactions then
	ReactionPickerPopover = require(parent.Reactions.ReactionPickerPopover)
else
	ReactionPickerPopover = nil
end

local ReactionSize = MomentsCommon.Enums.ReactionSize
local ReactionType = MomentsCommon.Enums.ReactionType

local RailItem = require(script.Parent.Parent.RailItem)
local ReactionPicker = require(script.Parent.ReactionPicker)
local usePickerReactions = require(script.Parent.usePickerReactions)
local MomentContext = require(script.Parent.Parent.Parent.Parent.MomentContext)
local useReactionCommit = require(script.Parent.Parent.Parent.Parent.Reactions.useReactionCommit)
local useMomentGestures = require(script.Parent.Parent.Parent.Parent.Reactions.useMomentGestures)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
local usePreferredInput = require(Moments.Hooks.usePreferredInput)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local ThumbUp = BuilderIcons.Icon.ThumbUp
local v2 = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }

local function fn() end

local function ReactionButton(props)
	local v3 = useTokens()
	local v4 = usePreferredInput()
	local v5 = v4 == Enum.PreferredInput.Gamepad
		or FFlagLuaSupportMicroGamepadPreferredInput and v4 == Enum.PreferredInput.MicroGamepad

	local store = MomentContext.useMoment().store
	local v6 = useReactionCommit()

	local isOpen = useSignalState(store.getIsReactionPickerOpen)
	local current = useSignalState(store.getSelectedReaction)
	local v7 = current ~= nil
	local v8 = React.useCallback(function()
		store.setReactionPickerOpen(false)
	end, { store })

	local transition, v9 = ReactOtter.useAnimatedBinding(v7 and 1 or 0)
	React.useEffect(function()
		v9(ReactOtter.spring(v7 and 1 or 0, { frequency = 6, dampingRatio = 1 }))
	end, { v7 })

	local ref = React.useRef(ReactionType.ThumbsUp)

	if current ~= nil then
		ref.current = current
	end

	local reactionType = current or ref.current

	local onTap = React.useCallback(function()
		if store.getIsReacted(false) then
			v6("tapButton", nil, nil)
		end

		store.setReactionPickerOpen(true)
	end, { store, v6 })

	local v10 = not (v5 or props.isDisabled)

	local v11 = useMomentGestures(not FFlagMomentsUseSharedReactions and v10, { onTap = onTap })
	local ref2, reactions, onOpen, onReactionSelected, selectedReactions

	if FFlagMomentsUseSharedReactions then
		ref2 = React.useRef(nil)

		reactions = usePickerReactions()

		onOpen = React.useCallback(function()
			store.setReactionPickerOpen(true)
		end, { store })

		onReactionSelected = React.useCallback(function(p, vector2: Vector2)
			v6("pickerSelect", vector2, p)
			store.setReactionPickerOpen(false)
		end, { store, v6 })

		selectedReactions = React.useMemo(function()
			if current == nil then
				return nil
			end

			local set = {}
			set[current] = true
			return set
		end, { current })
	end

	local mapped = React.joinBindings({ transition = transition, scrub = props.animationRatio }):map(function(p)
		local v12 = (1 - p.transition) * (1 - p.scrub)
		return getColorStyleWithTransparency(v3.Color.Content.Emphasis, 1 - v12)
	end)

	local mapped2 = React.joinBindings({ transition = transition, scrub = props.animationRatio }):map(function(p)
		return getColorStyleWithTransparency(v2, 1 - p.transition * (1 - p.scrub))
	end)

	local createElement = React.createElement
	local v12 = {
		animationRatio = props.animationRatio,
		isDisabled = props.isDisabled,
		onActivated = 0,
		LayoutOrder = 0,
		nativeRef = 0,
		slot = 0
	}
	local onActivated = if v5 then onTap else fn
	v12.onActivated = onActivated
	v12.LayoutOrder = props.LayoutOrder
	local nativeRef

	if FFlagMomentsUseSharedReactions then
		nativeRef = ref2
	else
		nativeRef = v11.ref
	end

	v12.nativeRef = nativeRef
	v12.slot = React.createElement(View, { tag = "size-800-800" }, {
		Thumb = React.createElement(Icon, {
			name = ThumbUp,
			size = IconSize.Large,
			style = mapped,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}),
		Reacted = React.createElement(v, {
			reactionType = reactionType,
			size = IconSize.Medium,
			imageStyle = mapped2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	})
	local element = createElement(RailItem, v12)

	if not FFlagMomentsUseSharedReactions then
		return React.createElement(Popover.Root, { isOpen = isOpen }, {
			Anchor = React.createElement(Popover.Anchor, nil, { ReactButton = element }),
			Content = React.createElement(Popover.Content, {
				side = { position = PopoverSide.Top, offset = 8 },
				align = PopoverAlign.End,
				hasArrow = false,
				radius = Radius.Circle,
				backgroundStyle = v3.Color.OverMedia.OverMedia_100,
				onPressedOutside = v8
			}, {
				ReactionPicker = React.createElement(ReactionPicker)
			})
		})
	end

	assert(ReactionPickerPopover ~= nil, "expected ReactionPickerPopover when FFlagMomentsUseSharedReactions is on")
	local v13 = ref2 ~= nil and onReactionSelected ~= nil
	assert(v13, "expected the shared picker hooks when FFlagMomentsUseSharedReactions is on")

	local createElement2 = React.createElement
	local fragment = React.Fragment

	local createElement3 = React.createElement

	if not v10 then
		onOpen = nil
	end

	if not v10 then
		onTap = nil
	end

	return createElement2(fragment, nil, {
		ReactButton = element,
		Picker = createElement3(ReactionPickerPopover, {
			isOpen = isOpen,
			anchorRef = ref2,
			onReactionSelected = onReactionSelected,
			onDismiss = v8,
			onOpen = onOpen,
			onTap = onTap,
			reactions = reactions,
			reactionSize = ReactionSize.Medium,
			selectedReactions = selectedReactions,
			side = { position = PopoverSide.Top, offset = 8 },
			align = PopoverAlign.End,
			backgroundStyle = v3.Color.OverMedia.OverMedia_100
		})
	})
end

return React.memo(ReactionButton)
