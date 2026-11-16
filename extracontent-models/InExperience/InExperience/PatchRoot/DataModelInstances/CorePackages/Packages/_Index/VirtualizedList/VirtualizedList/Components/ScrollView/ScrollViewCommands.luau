local parent = script.Parent.Parent.Parent.Parent
require(parent.LuauPolyfill)

require(parent.React)

return {
	default = {
		flashScrollIndicators = function(_)
			warn("flashScrollIndicators not implemented")
		end,
		scrollTo = function(p, p2: number, p3: number, flag: boolean)
			if flag then
				p._nativeRef.animateScrollTo(p2, p3)
			else
				p._nativeRef.current.CanvasPosition = Vector2.new(p2, p3)
			end
		end,
		scrollToEnd = function(p, flag: boolean)
			local v = p._nativeRef.current.ScrollingDirection == Enum.ScrollingDirection.Y and 0
				or p._nativeRef.current.AbsoluteCanvasSize.X
			local v2 = p._nativeRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y and 0
				or p._nativeRef.current.AbsoluteCanvasSize.Y

			if flag then
				p._nativeRef.animateScrollTo(v, v2)
			else
				p._nativeRef.current.CanvasPosition = Vector2.new(v, v2)
			end
		end,
		zoomToRect = function(_, _, _: boolean?)
			warn("zoomToRect not implemented")
		end
	}
}
