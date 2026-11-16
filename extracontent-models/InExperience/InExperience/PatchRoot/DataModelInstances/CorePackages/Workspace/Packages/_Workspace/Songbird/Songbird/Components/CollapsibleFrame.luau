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

local v = { stiffness = 300, damping = 30, mass = 1 }

local _ = { isCollapsed = false }

local function CollapsibleFrame(p)
	local v2 = usePrevious(p.isCollapsed)
	local maxSize, v3 = useBinding(Vector2.new(1e999, 1e999))
	local alpha, v4 = useAnimatedBinding(p.isCollapsed and 0 or 1)

	local v5 = useCallback(function(p2)
		v3(p2.AbsoluteCanvasSize)
	end, {})

	useEffect(function()
		if v2 ~= nil then
			if p.isCollapsed or not v2 then
				if p.isCollapsed and not v2 then
					v4(ReactOtter.spring(0, v))
				end
			else
				v4(ReactOtter.spring(1, v))
			end
		end
	end, { p.isCollapsed, v2 })

	local mapped = React.joinBindings({ maxSize = maxSize, alpha = alpha }):map(function(p2)
		local v6 = math.max(p2.maxSize.Y * p2.alpha, 0)

		return Vector2.new(1e999, v6)
	end)

	return React.createElement(Foundation.View, {
		tag = "size-full clip",
		sizeConstraint = { MaxSize = mapped }
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
			[React.Change.AbsoluteCanvasSize] = v5
		}, {
			Container = React.createElement(Foundation.View, { tag = "auto-y size-full-0" }, p.children)
		})
	})
end

return CollapsibleFrame
