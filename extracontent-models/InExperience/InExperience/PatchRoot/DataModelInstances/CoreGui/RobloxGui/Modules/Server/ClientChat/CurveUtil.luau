local t1 = {}

function t1.Expt(_, p2, p3, p4, p5) -- line: 5
	-- upvalues: t1 (copy)
	if math.abs(p3 - p2) < 0.01 then
		return p3
	end

	local v7 = t1:Expty(p2, p3, p4, p5)

	return p2 + (p3 - p2) * v7
end
function t1.Expty(_, _, _, p9, p10) -- line: 17
	return 1 - math.exp(-(-math.log(1 - p9)) * p10)
end
function t1.Sign(_, p12) -- line: 24
	if p12 > 0 then
		return 1
	end

	if p12 < 0 then
		return -1
	end

	return 0
end
function t1.BezierValForT(_, p14, p15, p16, p17, p18) -- line: 34
	local v21 = (1 - p18) * (1 - p18) * (1 - p18)
	local v22 = 3 * p18 * (1 - p18) * (1 - p18)
	local v23 = 3 * p18 * p18 * (1 - p18)
	local v24 = p18 * p18 * p18

	return v21 * p14 + v22 * p15 + v23 * p16 + v24 * p17
end

t1._BezierPt2ForT = {
	x = 0,
	y = 0
}

function t1.BezierPt2ForT(_, p20, p21, p22, p23, p24, p25, p26, p27, p28) -- line: 43
	-- upvalues: t1 (copy)
	t1._BezierPt2ForT.x = t1:BezierValForT(p20, p22, p24, p26, p28)
	t1._BezierPt2ForT.y = t1:BezierValForT(p21, p23, p25, p27, p28)

	return t1._BezierPt2ForT
end
function t1.YForPointOf2PtLine(_, p30, p31, p32) -- line: 55
	local v39 = (p30.y - p31.y) / (p30.x - p31.x)
	local v40 = p30.y - v39 * p30.x

	return v39 * p32 + v40
end
function t1.DeltaTimeToTimescale(_, p34) -- line: 63
	return p34 / 0.016666666666666666
end
function t1.SecondsToTick(_, p36) -- line: 67
	return 0.016666666666666666 / p36
end
function t1.ExptValueInSeconds(_, p38, p39, p40) -- line: 71
	return 1 - math.pow(p38 / p39, 1 / (60 * p40))
end
function t1.NormalizedDefaultExptValueInSeconds(p41, p42) -- line: 75
	return p41:ExptValueInSeconds(0.01, 1, p42)
end

return t1
