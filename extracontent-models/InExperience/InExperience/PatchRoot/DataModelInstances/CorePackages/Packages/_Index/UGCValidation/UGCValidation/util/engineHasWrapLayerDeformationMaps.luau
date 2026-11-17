return function()
	local wrapLayer = Instance.new("WrapLayer")
	local v = pcall(function()
		return wrapLayer.RotateScaleDeformationMap
	end)

	wrapLayer:Destroy()
	return v
end
