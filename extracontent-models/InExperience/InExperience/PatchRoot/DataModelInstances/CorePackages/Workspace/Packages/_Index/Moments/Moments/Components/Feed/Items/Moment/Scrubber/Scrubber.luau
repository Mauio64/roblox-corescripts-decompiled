local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local ScrubberBar = require(script.Parent.ScrubberBar)
local MomentContext = require(script.Parent.Parent.MomentContext)
local useMomentProgress = require(script.Parent.Parent.Hooks.useMomentProgress)
local PreviewPopover = require(script.Parent.PreviewPopover)

local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useSignalBinding = SignalsReact.useSignalBinding

local function Scrubber(p)
	local v = MomentContext.useMoment()

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local ref = React.useRef(nil)
	local v2 = React.useCallback(function(vector2: Vector2)
		local current = ref.current

		if current == nil then
			return 0
		end

		local v2 = math.clamp((vector2.X - current.AbsolutePosition.X) / current.AbsoluteSize.X, 0, 1)
		v.store.setScrubPosition(v2)

		return v2
	end, { v.store.setScrubPosition })

	local v3 = useSignalBinding((useMomentProgress()))
	local v4 = { useSignalBinding(v.store.getScrubPosition), v3 }
	local mapped = React.joinBindings(v4):map(function(list)
		local ratio = list[1]
		local item = list[2]

		if ratio == nil then
			ratio = item.ratio
		end

		return {
			time = ratio * item.duration,
			duration = item.duration,
			ratio = ratio
		}
	end)

	local mapped2 = mapped:map(function(p2)
		return p2.ratio
	end)

	return React.createElement(View, {
		tag = "size-full-300",
		LayoutOrder = p.LayoutOrder,
		stateLayer = { affordance = StateLayerAffordance.None },
		onStateChanged = function(p2)
			local v5 = p2 == ControlState.Hover or p2 == ControlState.Selected
			local v6 = p2 == ControlState.Pressed or p2 == ControlState.SelectedPressed

			setState(v5)
			setState2(v6)
		end
	}, {
		DragContainer = React.createElement(View, { tag = "size-full", ZIndex = 2, ref = ref }, {
			DragDetector = React.createElement("UIDragDetector", {
				CursorIcon = "",
				DragAxis = Vector2.new(1, 0),
				DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
				[React.Event.DragStart] = function(_, vector2: Vector2)
					setState3(true)

					if v.controller then
						v.controller.pause(0)
					end

					v2(vector2)
				end,
				[React.Event.DragContinue] = function(_, vector2: Vector2)
					v2(vector2)
				end,
				[React.Event.DragEnd] = function(_, vector2: Vector2)
					local v5 = v2(vector2)
					v.store.setScrubPosition(nil)
					setState3(false)

					if v.controller then
						v.controller.play()
						local duration = v.controller.getState(false).duration
						v.controller.seek(v5 * duration)
					end
				end
			})
		}),
		ScrubberBar = React.createElement(ScrubberBar, {
			isHovering = state,
			isPressed = state2 or state3,
			progressRatio = mapped2
		}),
		PreviewPopover = React.createElement(PreviewPopover, {
			progress = mapped,
			progressRatio = mapped2
		})
	})
end

return React.memo(Scrubber)
