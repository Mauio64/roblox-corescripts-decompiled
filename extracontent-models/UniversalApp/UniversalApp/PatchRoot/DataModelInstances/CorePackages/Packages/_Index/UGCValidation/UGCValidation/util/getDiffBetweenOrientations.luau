local function getDiffBetweenOrientations(cframe: CFrame, cframe2: CFrame)
	local _, v = (cframe * cframe2:Inverse()):ToAxisAngle()
	return (math.deg(v))
end

return getDiffBetweenOrientations
