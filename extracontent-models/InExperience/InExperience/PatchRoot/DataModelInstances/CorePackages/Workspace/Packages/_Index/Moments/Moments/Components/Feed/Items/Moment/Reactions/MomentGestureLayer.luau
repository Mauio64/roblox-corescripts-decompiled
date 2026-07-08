local Parent = script:FindFirstAncestor("Moments").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local View = Foundation.View
local useSignalState = SignalsReact.useSignalState
local MomentContext = require(script.Parent.Parent.MomentContext)
local useMomentGestures = require(script.Parent.useMomentGestures)
local useReactionCommit = require(script.Parent.useReactionCommit)

local function MomentGestureLayer(t1: {[any]: any}) -- line: 33
	-- upvalues: MomentContext (copy), useReactionCommit (copy), useSignalState (copy), React (copy), useMomentGestures (copy), View (copy)
	local v12 = MomentContext.useMoment()
	local controller = v12.controller
	local store = v12.store
	local v15 = useReactionCommit()
	local v16 = useSignalState(store.getIsModerated)
	local v17 = useSignalState(store.getIsScrubbing)
	local v18 = React.useCallback(function() -- line: 49
		-- upvalues: controller (copy)
		if controller ~= nil then
			controller.toggle()
		end
	end, { controller })
	local v19 = React.useCallback(function(vector2: Vector2) -- line: 55
		-- upvalues: v15 (copy)
		v15("doubleTap", vector2, nil)
	end, { v15 })
	local v20 = useMomentGestures(not v16 and not v17, {
		onSingleTapConfirmed = v18,
		onDoubleTap = v19
	})

	return React.createElement(View, {
		tag = "size-full",
		Active = true,
		BackgroundTransparency = 1,
		ref = v20.ref,
		ZIndex = t1.ZIndex
	})
end

return React.memo(MomentGestureLayer)
