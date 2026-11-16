local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local module4 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber/ScrubberBar")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local useMomentProgress = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Hooks/useMomentProgress")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber/PreviewPopover")

local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local useSignalBinding = SignalsReact.useSignalBinding

local function Scrubber(p2)
	local v5 = MomentContext.useMoment()

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local ref = React.useRef(nil)
	local v6 = React.useCallback(function(p3)
		local current = ref.current

		if current == nil then
			return 0
		end

		local v7 = math.clamp((p3.X - current.AbsolutePosition.X) / current.AbsoluteSize.X, 0, 1)
		v5.store.setScrubPosition(v7)

		return v7
	end, { v5.store.setScrubPosition })

	local v8 = useSignalBinding((useMomentProgress()))
	local v9 = { useSignalBinding(v5.store.getScrubPosition), v8 }
	local mapped = React.joinBindings(v9):map(function(list)
		local v10 = list[1]
		local item = list[2]

		if v10 == nil then
			v10 = item.ratio
		end

		return {
			time = v10 * item.duration,
			duration = item.duration,
			ratio = v10
		}
	end)

	local mapped2 = mapped:map(function(p3)
		return p3.ratio
	end)

	return React.createElement(view, {
		tag = "size-full-300",
		LayoutOrder = p2.LayoutOrder,
		stateLayer = { affordance = stateLayerAffordance.None },
		onStateChanged = function(p3)
			local v12 = p3 == controlState.Hover or p3 == controlState.Selected
			local v13 = p3 == controlState.Pressed or p3 == controlState.SelectedPressed

			setState(v12)
			setState2(v13)
		end
	}, {
		DragContainer = React.createElement(view, {
			tag = "size-full",
			ZIndex = 2,
			ref = ref
		}, {
			DragDetector = React.createElement("UIDragDetector", {
				CursorIcon = "",
				DragAxis = Vector2.new(1, 0),
				DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
				[React.Event.DragStart] = function(p3, p4)
					setState3(true)

					if v5.controller then
						v5.controller.pause(0)
					end

					v6(p4)
				end,
				[React.Event.DragContinue] = function(p3, p4)
					v6(p4)
				end,
				[React.Event.DragEnd] = function(p3, p4)
					local v15 = v6(p4)
					v5.store.setScrubPosition(nil)
					setState3(false)

					if v5.controller then
						v5.controller.play()
						local duration = v5.controller.getState(false).duration
						v5.controller.seek(v15 * duration)
					end
				end
			})
		}),
		ScrubberBar = React.createElement(module4, {
			isHovering = state,
			isPressed = state2 or state3,
			progressRatio = mapped2
		}),
		PreviewPopover = React.createElement(module7, {
			progress = mapped,
			progressRatio = mapped2
		})
	})
end

return React.memo(Scrubber)
