return {
	shouldShowGradientsForScrollingFrame = function(data): (boolean, boolean, boolean)
		local x = data.AbsoluteSize.X
		local offset = data.CanvasSize.X.Offset
		local x2 = data.CanvasPosition.X

		return x < offset, x2 > 20, x2 + x < offset - 20
	end
}
