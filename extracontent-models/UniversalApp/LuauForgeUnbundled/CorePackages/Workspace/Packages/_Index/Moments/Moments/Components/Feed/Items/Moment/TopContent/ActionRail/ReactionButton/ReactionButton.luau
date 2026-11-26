local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")
local FFlagMomentsUseSharedReactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsUseSharedReactions")

local icon = Foundation.Icon
local view = Foundation.View
local popover = Foundation.Popover
local iconSize = Foundation.Enums.IconSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local v5 = if FFlagMomentsUseSharedReactions then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/Reaction") else MomentsCommon.Components.Reaction

local v6 = if FFlagMomentsUseSharedReactions then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Reactions/ReactionPickerPopover") else nil

local reactionSize = MomentsCommon.Enums.ReactionSize
local reactionType = MomentsCommon.Enums.ReactionType

local RailItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/RailItem")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/ReactionButton/ReactionPicker")
local usePickerReactions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/TopContent/ActionRail/ReactionButton/usePickerReactions")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local useReactionCommit = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/useReactionCommit")
local useMomentGestures = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Reactions/useMomentGestures")
local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")
local usePreferredInput = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/usePreferredInput")

local fFlagLuaSupportMicroGamepadPreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagLuaSupportMicroGamepadPreferredInput

local thumbUp = BuilderIcons.Icon.ThumbUp
local v7 = { Color3 = Color3.new(1, 1, 1), Transparency = 0 }

local function fn() end

local function ReactionButton(props)
	local v8 = useTokens()
	local v9 = usePreferredInput()
	local v10 = v9 == Enum.PreferredInput.Gamepad
		or fFlagLuaSupportMicroGamepadPreferredInput and v9 == Enum.PreferredInput.MicroGamepad

	local store = MomentContext.useMoment().store
	local v11 = useReactionCommit()

	local v12 = useSignalState(store.getIsReactionPickerOpen)
	local v13 = useSignalState(store.getSelectedReaction)
	local v14 = v13 ~= nil
	local v15 = React.useCallback(function()
		store.setReactionPickerOpen(false)
	end, { store })

	local v16, v17 = ReactOtter.useAnimatedBinding(v14 and 1 or 0)
	React.useEffect(function()
		v17(ReactOtter.spring(v14 and 1 or 0, { frequency = 6, dampingRatio = 1 }))
	end, { v14 })

	local ref = React.useRef(reactionType.ThumbsUp)

	if v13 ~= nil then
		ref.current = v13
	end

	local v18 = v13 or ref.current

	local v19 = React.useCallback(function()
		if store.getIsReacted(false) then
			v11("tapButton", nil, nil)
		end

		store.setReactionPickerOpen(true)
	end, { store, v11 })

	local v20 = not (v10 or props.isDisabled)

	local v21 = useMomentGestures(not FFlagMomentsUseSharedReactions and v20, { onTap = v19 })
	local ref2, v22, v23, v24, v25

	if FFlagMomentsUseSharedReactions then
		ref2 = React.useRef(nil)

		v22 = usePickerReactions()

		v23 = React.useCallback(function()
			store.setReactionPickerOpen(true)
		end, { store })

		v24 = React.useCallback(function(p2, p3)
			v11("pickerSelect", p3, p2)
			store.setReactionPickerOpen(false)
		end, { store, v11 })

		v25 = React.useMemo(function()
			if v13 == nil then
				return nil
			end

			local set = {}
			set[v13] = true
			return set
		end, { v13 })
	end

	local mapped = React.joinBindings({
		transition = v16,
		scrub = props.animationRatio
	}):map(function(p2)
		local v26 = (1 - p2.transition) * (1 - p2.scrub)
		return getColorStyleWithTransparency(v8.Color.Content.Emphasis, 1 - v26)
	end)

	local mapped2 = React.joinBindings({
		transition = v16,
		scrub = props.animationRatio
	}):map(function(p2)
		return getColorStyleWithTransparency(v7, 1 - p2.transition * (1 - p2.scrub))
	end)

	local createElement = React.createElement
	local v27 = {
		animationRatio = props.animationRatio,
		isDisabled = props.isDisabled,
		onActivated = if v10 then v19 else fn,
		LayoutOrder = props.LayoutOrder,
		nativeRef = 0,
		slot = 0
	}
	local v29 = if FFlagMomentsUseSharedReactions then ref2 else v21.ref
	v27.nativeRef = v29
	v27.slot = React.createElement(view, { tag = "size-800-800" }, {
		Thumb = React.createElement(icon, {
			name = thumbUp,
			size = iconSize.Large,
			style = mapped,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}),
		Reacted = React.createElement(v5, {
			reactionType = v18,
			size = iconSize.Medium,
			imageStyle = mapped2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	})
	local element = createElement(RailItem, v27)

	if not FFlagMomentsUseSharedReactions then
		return React.createElement(popover.Root, { isOpen = v12 }, {
			Anchor = React.createElement(popover.Anchor, nil, {
				ReactButton = element
			}),
			Content = React.createElement(popover.Content, {
				side = { position = popoverSide.Top, offset = 8 },
				align = popoverAlign.End,
				hasArrow = false,
				radius = radius.Circle,
				backgroundStyle = v8.Color.OverMedia.OverMedia_100,
				onPressedOutside = v15
			}, { ReactionPicker = React.createElement(module9) })
		})
	end

	assert(v6 ~= nil, "expected ReactionPickerPopover when FFlagMomentsUseSharedReactions is on")
	local v30 = ref2 ~= nil and v24 ~= nil
	assert(v30, "expected the shared picker hooks when FFlagMomentsUseSharedReactions is on")

	local createElement2 = React.createElement
	local fragment = React.Fragment

	local createElement3 = React.createElement

	if not v20 then
		v23 = nil
	end

	if not v20 then
		v19 = nil
	end

	return createElement2(fragment, nil, {
		ReactButton = element,
		Picker = createElement3(v6, {
			isOpen = v12,
			anchorRef = ref2,
			onReactionSelected = v24,
			onDismiss = v15,
			onOpen = v23,
			onTap = v19,
			reactions = v22,
			reactionSize = reactionSize.Medium,
			selectedReactions = v25,
			side = { position = popoverSide.Top, offset = 8 },
			align = popoverAlign.End,
			backgroundStyle = v8.Color.OverMedia.OverMedia_100
		})
	})
end

return React.memo(ReactionButton)
