local t1 = {
	advanceCriticalDampedSpring = function(n1: number, n2: number, n3: number, n4: number, n5: number) -- line: 25
		local v7 = 6.283185307179586 * n5
		local v8 = n1 - n3
		local v9 = v7 * n4
		local v10 = math.exp(-v9)
		local v11 = n2 + v7 * v8
		local v12 = (v8 + v11 * n4) * v10
		local v13 = (n2 - v11 * v9) * v10

		return n3 + v12, v13
	end,
	offsetForIndex = function(n6: number, n7: number) -- line: 45
		return (n6 - 1) * n7
	end,
	clampIndex = function(n8: number, n9: number) -- line: 50
		if n9 <= 0 then
			return 1
		end

		return (math.clamp(n8, 1, n9))
	end,
	projectSnapOffset = function(n10: number, n11: number, n12: number) -- line: 62
		return n10 - n11 * n12
	end
}

function t1.resolveSnapIndex(n13: number, n14: number, n15: number, n16: number, n17: number) -- line: 77
	-- upvalues: t1 (copy)
	if n16 <= 0 or n15 <= 0 then
		return 1
	end

	local v26 = n13 / n15
	local v27 = t1.projectSnapOffset(n13, n14, n17) - n13
	local v28 = n15 * 0.5
	local v29 = if not (v28 < v27) then if not (v27 < -v28) then math.round(v26) + 1 else math.ceil(v26) else math.floor(v26) + 2

	return t1.clampIndex(v29, n16)
end
function t1.getVisibleWindow(n18: number, n19: number, n20: number) -- line: 109
	-- upvalues: t1 (copy)
	if n20 <= 0 then
		return {
			startIndex = 1,
			endIndex = 0
		}
	end

	local v33 = t1.clampIndex(n18, n20)

	return {
		startIndex = math.max(1, v33 - n19),
		endIndex = math.min(n20, v33 + n19)
	}
end
function t1.reindexAfterRemoval(n21: number, n22: number, n23: number) -- line: 130
	-- upvalues: t1 (copy)
	if n23 <= 0 then
		return 1
	end

	if n22 < n21 then
		return t1.clampIndex(n21 - 1, n23)
	end

	return t1.clampIndex(n21, n23)
end
function t1.neighborForRemoval(n24: number, n25: number) -- line: 145
	if n24 < n25 then
		return n24 + 1
	end

	return n24 - 1
end
function t1.nearestIndexForOffset(n26: number, n27: number, n28: number) -- line: 155
	-- upvalues: t1 (copy)
	if n28 <= 0 then
		return 1
	end

	if n27 <= 0 then
		return 1
	end

	return t1.clampIndex(math.round(n26 / n27) + 1, n28)
end
function t1.resolveSettleIndex(n29: number, n30: number, n31: number, n32: number, n33: number, n34: number?) -- line: 178
	-- upvalues: t1 (copy)
	if n32 <= 0 or n31 <= 0 then
		return t1.clampIndex(n29, n32)
	end

	local v48 = (n30 - t1.offsetForIndex(n29, n31)) / n31

	if n33 < v48 then
		local v49 = math.max(1, (math.round(v48)))

		if n34 ~= nil then
			v49 = math.min(v49, n34)
		end

		n29 += v49
	elseif v48 < -n33 then
		local v50 = math.min(-1, (math.round(v48)))

		if n34 ~= nil then
			v50 = math.max(v50, -n34)
		end

		n29 += v50
	end

	return t1.clampIndex(n29, n32)
end

return t1
