local Parent = script:FindFirstAncestor("AppBlox").Parent
local FFlagLuaAppClampBannerPaddingToViewport = require(Parent.SharedFlags).FFlagLuaAppClampBannerPaddingToViewport

return {
	computeContentTopOffset = function(n1: number, n2: number, n3: number) -- line: 16
		if n1 <= 0 then
			return 0
		end

		return (math.max(0, n1 / n2 - n3))
	end,
	computeInitialScrollY = function(n4: number, n5: number, n6: number, n7: number) -- line: 32
		return (math.max(0, ((if not (n4 <= 0) then math.max(0, n4 / n5 - n6) else 0)) - n7))
	end,
	computeInitialScrollYForSize = function(vector2: Vector2, t1: {[any]: any}) -- line: 114
		-- upvalues: FFlagLuaAppClampBannerPaddingToViewport (copy)
		local fullBleedAspectRatio = t1.fullBleedAspectRatio
		local headerBarHeight = t1.headerBarHeight
		local fullBleedOverlapOffset = t1.fullBleedOverlapOffset
		local hasFullBleed = t1.hasFullBleed
		local bannerBottomVisiblePercent = t1.bannerBottomVisiblePercent
		local v32 = vector2.X / fullBleedAspectRatio
		local v33

		if bannerBottomVisiblePercent ~= nil then
			v33 = math.max(0, (math.floor(v32 - bannerBottomVisiblePercent * v32)))
		else
			local vector2X = vector2.X

			v33 = math.max(0, ((if not (vector2X <= 0) then math.max(0, vector2X / fullBleedAspectRatio - headerBarHeight) else 0)) - fullBleedOverlapOffset)
		end

		local vector2X = vector2.X
		local v36 = math.max(0, ((if not (vector2X <= 0) then math.max(0, vector2X / fullBleedAspectRatio - headerBarHeight) else 0)) - (not hasFullBleed and 0 or fullBleedOverlapOffset))

		if v36 == 0 then
			v36 = headerBarHeight
		end

		if FFlagLuaAppClampBannerPaddingToViewport then
			v36 = math.min(v36, vector2.Y * 0.75)
		end

		return (math.min(v33, (math.max(0, v36 - headerBarHeight))))
	end,
	computeCanvasPaddingTop = function(n8: number, b1: boolean, n9: number, n10: number) -- line: 68
		local v20 = math.max(0, n8 - (not b1 and 0 or n9))

		if v20 == 0 then
			v20 = n10
		end

		return v20
	end,
	getNoBannerFadeParams = function(n11: number) -- line: 46
		return (math.max(60, n11 * 1.5))
	end,
	getHeaderFadeParams = function(n12: number, n13: number, n14: number) -- line: 86
		local v24 = math.max(0, n12 - n14)

		return v24, if not (n13 > 0 and n13 < n12) then math.max(1, (n12 - v24) / 3) else math.max(1, n13 - v24)
	end,
	shouldShowStickyBar = function(n15: number, n16: number, n17: number, n18: number) -- line: 54
		local v15 = n15 >= n17 + n18

		return n16 < n15 or v15
	end
}
