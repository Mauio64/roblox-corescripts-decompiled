local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local ScrubberBar = require(script.Parent.ScrubberBar)
local MomentContext = require(script.Parent.Parent.MomentContext)
local useMomentProgress = require(script.Parent.Parent.Hooks.useMomentProgress)
local PreviewPopover = require(script.Parent.PreviewPopover)
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useSignalBinding = SignalsReact.useSignalBinding

local function Scrubber(t1: {[any]: any}) -- line: 23
	-- upvalues: MomentContext (copy), React (copy), useMomentProgress (copy), useSignalBinding (copy), View (copy), StateLayerAffordance (copy), ControlState (copy), ScrubberBar (copy), PreviewPopover (copy)
	local v15 = MomentContext.useMoment()
	local v16, v17 = React.useState(false)
	local v18, v19 = React.useState(false)
	local v20, v21 = React.useState(false)
	local v22 = React.useRef(nil)
	local v23 = React.useCallback(function(vector2: Vector2) -- line: 31
		-- upvalues: v22 (copy), v15 (copy)
		local current = v22.current

		if current == nil then
			return 0
		end

		local v31 = math.clamp((vector2.X - current.AbsolutePosition.X) / current.AbsoluteSize.X, 0, 1)

		v15.store.setScrubPosition(v31)

		return v31
	end, { v15.store.setScrubPosition })
	local v24 = useMomentProgress()
	local v25 = useSignalBinding(v24)
	local v26 = useSignalBinding(v15.store.getScrubPosition)
	local v27 = React.joinBindings({
		v26,
		v25
	}):map(function(t2: {[any]: any}) -- line: 51
		local v33 = t2[1]
		local v34 = t2[2]
		local v35 = if v33 == nil then v34.ratio else v33

		return {
			time = v35 * v34.duration,
			duration = v34.duration,
			ratio = v35
		}
	end)
	local v28 = v27:map(function(p1) -- line: 63
		return p1.ratio
	end)

	return React.createElement(View, {
		tag = "size-full-300",
		LayoutOrder = t1.LayoutOrder,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onStateChanged = function(p2) -- line: 71
			-- upvalues: ControlState (copy), v17 (copy), v19 (copy)
			local v38 = p2 == ControlState.Hover or p2 == ControlState.Selected
			local v39 = p2 == ControlState.Pressed or p2 == ControlState.SelectedPressed

			v17(v38)
			v19(v39)
		end
	}, {
		DragContainer = React.createElement(View, {
			tag = "size-full",
			ZIndex = 2,
			ref = v22
		}, {
			DragDetector = React.createElement("UIDragDetector", {
				CursorIcon = "",
				DragAxis = Vector2.new(1, 0),
				DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
				[React.Event.DragStart] = function(_, vector2: Vector2) -- line: 89
					-- upvalues: v21 (copy), v15 (copy), v23 (copy)
					v21(true)

					if v15.controller then
						v15.controller.pause(0)
					end

					v23(vector2)
				end,
				[React.Event.DragContinue] = function(_, vector2: Vector2) -- line: 97
					-- upvalues: v23 (copy)
					v23(vector2)
				end,
				[React.Event.DragEnd] = function(_, vector2: Vector2) -- line: 100
					-- upvalues: v23 (copy), v15 (copy), v21 (copy)
					local v46 = v23(vector2)

					v15.store.setScrubPosition(nil)
					v21(false)

					if v15.controller then
						v15.controller.play()

						local duration = v15.controller.getState(false).duration

						v15.controller.seek(v46 * duration)
					end
				end
			})
		}),
		ScrubberBar = React.createElement(ScrubberBar, {
			isHovering = v16,
			isPressed = v18 or v20,
			progressRatio = v28
		}),
		PreviewPopover = React.createElement(PreviewPopover, {
			progress = v27,
			progressRatio = v28
		})
	})
end

return React.memo(Scrubber)
