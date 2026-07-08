return {
	shouldShowGradientsForScrollingFrame = function(p1) -- line: 11
		local AbsoluteSizeX = p1.AbsoluteSize.X
		local XOffset = p1.CanvasSize.X.Offset
		local CanvasPositionX = p1.CanvasPosition.X

		return AbsoluteSizeX < XOffset, CanvasPositionX > 20, CanvasPositionX + AbsoluteSizeX < XOffset - 20
	end
}
