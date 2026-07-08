local ParentParent = script.Parent.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)
require(ParentParent.React)

return {
	default = {
		flashScrollIndicators = function(_) -- line: 59
			warn("flashScrollIndicators not implemented")
		end,
		scrollTo = function(p2, n1: number, n2: number, b1: boolean) -- line: 62
			if b1 then
				p2._nativeRef.animateScrollTo(n1, n2)

				return
			end

			p2._nativeRef.current.CanvasPosition = Vector2.new(n1, n2)
		end,
		scrollToEnd = function(p3, b2: boolean) -- line: 69
			local v9 = if p3._nativeRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y then p3._nativeRef.current.AbsoluteCanvasSize.X else 0
			local v10 = p3._nativeRef.current.ScrollingDirection ~= Enum.ScrollingDirection.Y and 0 or p3._nativeRef.current.AbsoluteCanvasSize.Y

			if b2 then
				p3._nativeRef.animateScrollTo(v9, v10)

				return
			end

			p3._nativeRef.current.CanvasPosition = Vector2.new(v9, v10)
		end,
		zoomToRect = function(_, _: {[any]: any}, _: boolean?) -- line: 83
			warn("zoomToRect not implemented")
		end
	}
}
