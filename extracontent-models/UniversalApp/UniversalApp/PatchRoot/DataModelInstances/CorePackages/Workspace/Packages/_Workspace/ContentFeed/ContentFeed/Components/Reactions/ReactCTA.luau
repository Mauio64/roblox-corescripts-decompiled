local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local FeedContext = require(ParentParent.App.FeedContext)
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local ControlState = Foundation.Enums.ControlState
local Icon = Foundation.Icon
local FoundationImage = Foundation.Image
local View = Foundation.View
local useRef = React.useRef
local useTokens = Foundation.Hooks.useTokens
local v12 = game:DefineFastInt("ContentFeedLongPressThresholdMs", 500)

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), React (copy), FeedContext (copy), useRef (copy), ControlState (copy), v12 (copy), View (copy), FoundationImage (copy), Icon (copy)
	local v14 = useTokens()
	local v15 = React.useContext(FeedContext)
	local v16 = useRef(nil)
	local v17 = React.useCallback(function(p1) -- line: 30
		-- upvalues: ControlState (copy), v16 (copy), v12 (copy), t1 (copy)
		if p1 == ControlState.Pressed then
			v16.current = tick()
			task.delay(v12 / 1000, function() -- line: 33
				-- upvalues: v16 (copy), t1 (copy)
				if v16.current ~= nil then
					t1.onLongPress()
				end
			end)

			return
		end

		if p1 == ControlState.Default then
			if v16.current == nil then
				return
			end

			local v19 = tick() - (v16.current or 0)

			v16.current = nil

			if v19 < v12 / 1000 then
				t1.onShortPress()
			end
		end
	end, {
		t1.onLongPress,
		t1.onShortPress
	})

	return React.createElement(View, {
		tag = "radius-medium auto-xy padding-small bg-action-subtle",
		isDisabled = v15.isZooming,
		onStateChanged = v17
	}, {
		ReactIcon = if not t1.activeReaction then nil else React.createElement(FoundationImage, {
			ZIndex = 2,
			tag = "anchor-center-center position-center-center size-600-600",
			Image = t1.activeReaction
		}),
		ReactCTA = if t1.activeReaction then nil else React.createElement(Icon, {
			name = "icons/controls/emoteOff",
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			style = v14.Color.ActionEmphasis.Foreground
		})
	})
end
