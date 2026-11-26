return {
	computeContentTopOffset = function(p2, p3, p4)
		if p2 <= 0 then
			return 0
		end

		return (math.max(0, p2 / p3 - p4))
	end,
	computeInitialScrollY = function(p2, p3, p4, p5)
		return (math.max(0, (p2 <= 0 and 0 or math.max(0, p2 / p3 - p4)) - p5))
	end,
	computeInitialScrollYForSize = function(p2, data)
		local fullBleedAspectRatio = data.fullBleedAspectRatio
		local headerBarHeight = data.headerBarHeight
		local fullBleedOverlapOffset = data.fullBleedOverlapOffset
		local hasFullBleed = data.hasFullBleed
		local bannerBottomVisiblePercent = data.bannerBottomVisiblePercent

		local v5 = p2.X / fullBleedAspectRatio
		local v6

		if bannerBottomVisiblePercent == nil then
			local x = p2.X
			v6 = math.max(
				0,
				(x <= 0 and 0 or math.max(0, x / fullBleedAspectRatio - headerBarHeight)) - fullBleedOverlapOffset
			)
		else
			v6 = math.max(0, (math.floor(v5 - bannerBottomVisiblePercent * v5)))
		end

		local x = p2.X
		local v7 = math.max(
			0,
			(x <= 0 and 0 or math.max(0, x / fullBleedAspectRatio - headerBarHeight)) - (not hasFullBleed and 0 or fullBleedOverlapOffset)
		)

		if v7 == 0 then
			v7 = headerBarHeight
		end

		return (math.min(v6, (math.max(0, math.min(v7, p2.Y * 0.75) - headerBarHeight))))
	end,
	computeCanvasPaddingTop = function(p2, p3, p4, p5)
		local canvasPaddingTop = math.max(0, p2 - (not p3 and 0 or p4))

		if canvasPaddingTop == 0 then
			canvasPaddingTop = p5
		end

		return canvasPaddingTop
	end,
	getNoBannerFadeParams = function(p2)
		return (math.max(60, p2 * 1.5))
	end,
	getHeaderFadeParams = function(p2, p3, p4)
		local v5 = math.max(0, p2 - p4)

		local v6 = p3 > 0 and p3 < p2

		local v7 = if v6 then math.max(1, p3 - v5) else math.max(1, (p2 - v5) / 3)

		return v5, v7
	end,
	shouldShowStickyBar = function(p2, p3, p4, p5)
		local v5 = p4 + p5 <= p2
		return p3 < p2 or v5
	end
}
