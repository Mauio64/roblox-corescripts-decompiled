local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Signals = require(PeopleReactViewParent.Signals)
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local useSignalState = SignalsReact.useSignalState
local VoiceVolumePopover = require(PeopleReactView.Components.Buttons.VoiceVolumePopover)
local v16 = Signals.createSignal("")
local v17 = Signals.createSignal(false)
local v18 = React.memo(function(t1: {[any]: any}) -- line: 42
	-- upvalues: useTokens (copy), useSignalState (copy), v16 (copy), v17 (copy), React (copy), Foundation (copy), IconSize (copy)
	local v21 = useTokens()
	local v22 = useSignalState(t1.animatedIcon or v16)
	local v23 = useSignalState(t1.isGrayedOut or v17)

	if v22 ~= "" then
		return (React.createElement(Foundation.Icon, {
			name = v22,
			size = IconSize.Medium,
			style = {
				Transparency = if not v23 then nil else v21.Color.Common.Shadow.Transparency
			}
		}))
	end

	return nil
end)

local function MuteVolumeButton(t2: {[any]: any}) -- line: 61
	-- upvalues: useTokens (copy), React (copy), ControlState (copy), useCursor (copy), View (copy), StateLayerAffordance (copy), v18 (copy), Foundation (copy), IconName (copy), IconSize (copy), VoiceVolumePopover (copy)
	local v25 = useTokens()
	local XXSmall = v25.Gap.XXSmall
	local config = t2.config
	local v28, v29 = React.useState(false)
	local v30, v31 = React.useState(ControlState.Initialize)
	local v32, v33 = React.useState(ControlState.Initialize)
	local v34 = useCursor({
		radius = UDim.new(0, v25.Radius.Medium),
		offset = v25.Size.Size_150,
		borderWidth = v25.Stroke.Thicker
	})
	local v35 = React.useCallback(function() -- line: 76
		-- upvalues: config (copy), t2 (copy)
		config.onActivated(t2.entryPoint)
	end, {
		config.onActivated,
		t2.entryPoint
	})
	local v36 = React.useCallback(function() -- line: 80
		-- upvalues: v29 (copy)
		v29(function(p1) -- line: 81
			return not p1
		end)
	end, {})
	local v37 = React.useCallback(function() -- line: 86
		-- upvalues: v29 (copy)
		v29(false)
	end, {})
	local v38 = React.useCallback(function(p2) -- line: 90
		-- upvalues: t2 (copy)
		if t2.onButtonMount then
			t2.onButtonMount(p2, t2.muteButtonName)
		end
	end, {
		t2.onButtonMount,
		t2.muteButtonName
	})
	local v39 = React.useCallback(function(p3) -- line: 96
		-- upvalues: t2 (copy)
		if t2.onButtonMount then
			t2.onButtonMount(p3, t2.volumeButtonName)
		end
	end, {
		t2.onButtonMount,
		t2.volumeButtonName
	})
	local v40 = React.useCallback(function(p4) -- line: 102
		-- upvalues: v31 (copy)
		v31(p4)
	end, {})
	local v41 = React.useCallback(function(p5) -- line: 106
		-- upvalues: v33 (copy)
		v33(p5)
	end, {})
	local v42 = v28 and t2.userId ~= nil
	local Size_1000 = v25.Size.Size_1000
	local Size_1000_2 = v25.Size.Size_1000
	local Medium = v25.Radius.Medium
	local uDim = UDim.new(0, Medium)
	local Background = v25.Color.ActionStandard.Background
	local v48 = t2.LayoutOrder or config.layoutOrder

	local function getInteractionOverlayStyle(p6) -- line: 119
		-- upvalues: ControlState (copy), v25 (copy)
		if p6 == ControlState.Pressed then
			return v25.Color.State.Press
		end

		if p6 == ControlState.Hover then
			return v25.Color.State.Hover
		end

		return nil
	end

	local v50 = if v30 ~= ControlState.Pressed then if v30 ~= ControlState.Hover then nil else v25.Color.State.Hover else v25.Color.State.Press
	local v51 = if v32 ~= ControlState.Pressed then if v32 ~= ControlState.Hover then nil else v25.Color.State.Hover else v25.Color.State.Press
	local v52 = React.createElement(View, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromOffset(Size_1000, Size_1000_2),
		Position = UDim2.fromOffset(0, 0),
		onActivated = v35,
		onStateChanged = v40,
		selection = {
			SelectionImageObject = v34
		},
		LayoutOrder = v48,
		ref = v38,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		Background = React.createElement(View, {
			backgroundStyle = Background,
			cornerRadius = uDim,
			Size = UDim2.fromOffset(Size_1000 + Medium, Size_1000_2),
			Position = UDim2.fromOffset(0, 0)
		}, {
			StateOverlay = if not v50 then nil else React.createElement(View, {
				tag = "size-full",
				backgroundStyle = v50,
				cornerRadius = uDim
			})
		}),
		IconOverlay = React.createElement(View, {
			tag = "row align-x-center align-y-center size-full",
			ZIndex = 2,
			Active = false
		}, {
			Icon = React.createElement(v18, {
				animatedIcon = config.animatedIcon,
				isGrayedOut = config.isGrayedOut
			})
		})
	})
	local v53 = React.createElement(View, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromOffset(Size_1000, Size_1000_2),
		Position = UDim2.fromOffset(Size_1000 + XXSmall, 0),
		onActivated = v36,
		onStateChanged = v41,
		selection = {
			SelectionImageObject = v34
		},
		LayoutOrder = v48 + 0.5,
		ref = v39,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		Background = React.createElement(View, {
			backgroundStyle = Background,
			cornerRadius = uDim,
			Size = UDim2.fromOffset(Size_1000 + Medium, Size_1000_2),
			Position = UDim2.fromOffset(-Medium, 0)
		}, {
			StateOverlay = if not v51 then nil else React.createElement(View, {
				tag = "size-full",
				backgroundStyle = v51,
				cornerRadius = uDim
			})
		}),
		IconOverlay = React.createElement(View, {
			tag = "row align-x-center align-y-center size-full padding-right-xxsmall",
			ZIndex = 2,
			Active = false
		}, {
			ChevronIcon = React.createElement(Foundation.Icon, {
				name = if not v42 then IconName.ChevronSmallDown else IconName.ChevronSmallUp,
				size = IconSize.Large
			})
		})
	})

	return React.createElement(VoiceVolumePopover, {
		userId = t2.userId,
		isOpen = v42,
		onClose = v37,
		layoutOrder = v48,
		muteHalf = v52,
		chevronHalf = v53,
		muteHalfKey = t2.muteButtonName,
		volumeHalfKey = t2.volumeButtonName,
		pillWidth = Size_1000 * 2 + XXSmall,
		pillHeight = Size_1000_2,
		alignOffset = Size_1000 + XXSmall,
		isMutedByLocalUser = config.isGrayedOut
	})
end

return MuteVolumeButton
