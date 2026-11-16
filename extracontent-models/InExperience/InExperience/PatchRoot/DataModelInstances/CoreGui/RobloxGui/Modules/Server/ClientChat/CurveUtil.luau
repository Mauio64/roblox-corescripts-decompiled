local CurveUtil = {}

function CurveUtil.Expt(_, p, p2, p3, p4)
	if math.abs(p2 - p) < 0.01 then
		return p2
	end

	local expty = CurveUtil:Expty(p, p2, p3, p4)

	return p + (p2 - p) * expty
end

function CurveUtil:Expty(_, _, p, p2)
	return 1 - math.exp(-(-math.log(1 - p)) * p2)
end

function CurveUtil.Sign(_, p): number
	if p > 0 then
		return 1
	end

	return if p < 0 then -1 else 0
end

function CurveUtil.BezierValForT(_, p, p2, p3, p4, p5)
	local v = (1 - p5) * (1 - p5) * (1 - p5)
	local v2 = 3 * p5 * (1 - p5) * (1 - p5)
	local v3 = 3 * p5 * p5 * (1 - p5)
	local v4 = p5 * p5 * p5
	return v * p + v2 * p2 + v3 * p3 + v4 * p4
end

CurveUtil._BezierPt2ForT = { x = 0, y = 0 }
function CurveUtil.BezierPt2ForT(_, p, p2, p3, p4, p5, p6, p7, p8, p9)
	CurveUtil._BezierPt2ForT.x = CurveUtil:BezierValForT(p, p3, p5, p7, p9)
	CurveUtil._BezierPt2ForT.y = CurveUtil:BezierValForT(p2, p4, p6, p8, p9)
	return CurveUtil._BezierPt2ForT
end

function CurveUtil.YForPointOf2PtLine(_, p, p2, p3)
	local v = (p.y - p2.y) / (p.x - p2.x)

	local v2 = p.y - v * p.x
	return v * p3 + v2
end

function CurveUtil.DeltaTimeToTimescale(_, p)
	return p / (1 / 60)
end

function CurveUtil.SecondsToTick(_, p)
	return 1 / 60 / p
end

function CurveUtil:ExptValueInSeconds(p, p2, p3)
	return 1 - math.pow(p / p2, 1 / (60 * p3))
end

function CurveUtil:NormalizedDefaultExptValueInSeconds(p)
	return self:ExptValueInSeconds(0.01, 1, p)
end

return CurveUtil
