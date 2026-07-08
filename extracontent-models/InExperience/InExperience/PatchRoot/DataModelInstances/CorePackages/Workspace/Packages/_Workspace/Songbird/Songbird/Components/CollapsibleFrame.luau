local Songbird = script:FindFirstAncestor("Songbird")
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local ReactOtter = require(Songbird.Parent.ReactOtter)
local useBinding = React.useBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local usePrevious = ReactUtils.usePrevious
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local t1 = {
	stiffness = 300,
	damping = 30,
	mass = 1
}
local _ = {
	isCollapsed = false
}

local function CollapsibleFrame(t2: {[any]: any}) -- line: 31
	-- upvalues: usePrevious (copy), useBinding (copy), useAnimatedBinding (copy), useCallback (copy), useEffect (copy), ReactOtter (copy), t1 (copy), React (copy), Foundation (copy)
	local v15 = usePrevious(t2.isCollapsed)
	local v16, v17 = useBinding(Vector2.new(1e999, 1e999))
	local v18, v19 = useAnimatedBinding(not t2.isCollapsed and 1 or 0)
	local v20 = useCallback(function(p1) -- line: 36
		-- upvalues: v17 (copy)
		v17(p1.AbsoluteCanvasSize)
	end, {})

	useEffect(function() -- line: 40
		-- upvalues: v15 (copy), t2 (copy), v19 (copy), ReactOtter (copy), t1 (copy)
		if v15 ~= nil then
			if not t2.isCollapsed and v15 then
				v19(ReactOtter.spring(1, t1))

				return
			end

			if t2.isCollapsed and not v15 then
				v19(ReactOtter.spring(0, t1))
			end
		end
	end, {
		t2.isCollapsed,
		v15
	})

	local v21 = React.joinBindings({
		maxSize = v16,
		alpha = v18
	}):map(function(t3: {[any]: any}) -- line: 53
		local v24 = math.max(t3.maxSize.Y * t3.alpha, 0)

		return Vector2.new(1e999, v24)
	end)

	return React.createElement(Foundation.View, {
		tag = "size-full clip",
		sizeConstraint = {
			MaxSize = v21
		}
	}, {
		ScrollingFrame = React.createElement("ScrollingFrame", {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ClipsDescendants = true,
			ScrollingEnabled = false,
			HorizontalScrollBarInset = Enum.ScrollBarInset.None,
			ScrollBarImageTransparency = 1,
			Selectable = false,
			[React.Change.AbsoluteCanvasSize] = v20
		}, {
			Container = React.createElement(Foundation.View, {
				tag = "auto-y size-full-0"
			}, t2.children)
		})
	})
end

return CollapsibleFrame
