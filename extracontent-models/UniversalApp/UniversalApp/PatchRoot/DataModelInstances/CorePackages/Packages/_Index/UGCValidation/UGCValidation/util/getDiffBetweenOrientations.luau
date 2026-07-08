local function getDiffBetweenOrientations(cFrame: CFrame, cFrame2: CFrame) -- line: 3
	local _, v5 = (cFrame * cFrame2:Inverse()):ToAxisAngle()

	return (math.deg(v5))
end

return getDiffBetweenOrientations
