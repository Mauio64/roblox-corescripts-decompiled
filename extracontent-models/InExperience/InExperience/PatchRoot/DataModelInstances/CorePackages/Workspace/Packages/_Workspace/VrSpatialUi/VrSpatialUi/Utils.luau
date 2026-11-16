return {
	rescaleCFramePosition = function(cframe: CFrame, p: number)
		return cframe.Rotation + cframe.Position * p
	end
}
