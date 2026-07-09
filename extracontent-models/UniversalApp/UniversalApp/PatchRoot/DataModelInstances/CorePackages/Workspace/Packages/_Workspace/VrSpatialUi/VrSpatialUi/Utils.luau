return {
	rescaleCFramePosition = function(cFrame: CFrame, n1: number) -- line: 1
		return cFrame.Rotation + cFrame.Position * n1
	end
}
