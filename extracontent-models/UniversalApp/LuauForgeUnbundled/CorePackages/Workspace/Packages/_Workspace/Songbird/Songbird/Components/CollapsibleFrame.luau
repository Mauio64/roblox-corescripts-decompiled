local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactOtter")

local useBinding = React.useBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local usePrevious = ReactUtils.usePrevious
local useAnimatedBinding = ReactOtter.useAnimatedBinding

local v5 = { stiffness = 300, damping = 30, mass = 1 }

local v6 = { isCollapsed = false }

local function CollapsibleFrame(p2)
	local v7 = usePrevious(p2.isCollapsed)
	local v8, v9 = useBinding(Vector2.new(1e999, 1e999))
	local v10, v11 = useAnimatedBinding(p2.isCollapsed and 0 or 1)

	local v12 = useCallback(function(p3)
		v9(p3.AbsoluteCanvasSize)
	end, {})

	useEffect(function()
		if v7 ~= nil then
			if p2.isCollapsed or not v7 then
				if p2.isCollapsed and not v7 then
					v11(ReactOtter.spring(0, v5))
				end
			else
				v11(ReactOtter.spring(1, v5))
			end
		end
	end, { p2.isCollapsed, v7 })

	local mapped = React.joinBindings({ maxSize = v8, alpha = v10 }):map(function(p3)
		local v13 = math.max(p3.maxSize.Y * p3.alpha, 0)

		return Vector2.new(1e999, v13)
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
			[React.Change.AbsoluteCanvasSize] = v12
		}, {
			Container = React.createElement(Foundation.View, {
				tag = "auto-y size-full-0"
			}, p2.children)
		})
	})
end

return CollapsibleFrame
