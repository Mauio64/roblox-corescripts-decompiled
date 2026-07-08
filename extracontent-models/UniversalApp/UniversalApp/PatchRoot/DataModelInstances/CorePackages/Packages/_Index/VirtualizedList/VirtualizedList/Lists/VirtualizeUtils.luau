local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Error = require(ParentParentParent.LuauPolyfill).Error
local HttpService = game:GetService("HttpService")
local t1 = {}
local invariant = require(ParentParent.jsUtils.invariant)

local function elementsThatOverlapOffsets(p1, n1: number, p2: ((...any) -> ...any)) -- line: 26
	-- upvalues: invariant (copy), HttpService (copy)
	local t2 = {}
	local n2 = 0

	for i = 1, n1 do
		local v14 = p2(i)
		local v15 = v14.offset + v14.length

		for j = 1, #p1 do
			if t2[j] ~= nil or not (v15 >= p1[j]) then
				continue
			end

			t2[j] = i
			n2 += 1

			if j == #p1 then
				if n2 ~= #p1 then
					invariant(n2 == #p1, "bad offsets input, should be in increasing order: %s", HttpService:JSONEncode(p1))
				end

				return t2
			end
		end
	end

	return t2
end

t1.elementsThatOverlapOffsets = elementsThatOverlapOffsets

function t1.newRangeCount(p3, p4) -- line: 65
	return p4.last - p4.first + 1 - math.max(0, math.min(p4.last, p3.last) + 1 - math.max(p4.first, p3.first))
end
function t1.computeWindowedRenderLimits(p5, p6: ((...any) -> ...any), n3: number, n4: number, t3: {[any]: any}, p7: ((...any) -> ...any), p8) -- line: 82
	-- upvalues: elementsThatOverlapOffsets (copy), Error (copy), HttpService (copy)
	local v26 = p6(p5)

	if v26 == 0 then
		return t3
	end

	local offset = p8.offset
	local velocity = p8.velocity
	local visibleLength = p8.visibleLength
	local v30 = math.max(0, offset)
	local v31 = v30 + visibleLength
	local v32 = (n4 - 1) * visibleLength
	local v33 = if not (velocity > 1) then not (velocity < -1) and "none" or "before" else "after"
	local v34 = math.max(0, v30 - 0.5 * v32)
	local v35 = math.max(0, v31 + 0.5 * v32)

	if v34 > p7(v26).offset then
		return {
			first = math.max(1, v26 - n3),
			last = v26
		}
	end

	local v36, v37, v38, v39 = table.unpack(elementsThatOverlapOffsets({
		v34,
		v30,
		v31,
		v35
	}, v26, p7), 1, 4)

	if v36 == nil then
		v36 = 1
	end

	if v37 == nil then
		v37 = math.max(1, v36)
	end

	if v39 == nil then
		v39 = v26
	end

	if v38 == nil then
		v38 = math.min(v39, v37 + n3 - 1)
	end

	local t4 = {
		first = v37,
		last = v38
	}
	local v41 = t4.last - t4.first + 1 - math.max(0, math.min(t4.last, t3.last) + 1 - math.max(t4.first, t3.first))

	while not (v37 <= v36) or not (v39 <= v38) do
		local v42 = n3 <= v41
		local v43 = v37 <= t3.first or v37 > t3.last
		local v44 = v36 < v37 and (not v42 or not v43)
		local v45 = v38 >= t3.last or v38 < t3.first
		local v46 = v38 < v39 and (not v42 or not v45)

		if v42 and not v44 and not v46 then
			break
		end

		if v44 and (v33 ~= "after" or not v46 or not v45) then
			if v43 then
				v41 += 1
			end

			v37 -= 1
		end

		if v46 and (v33 ~= "before" or not v44 or not v43) then
			if v45 then
				v41 += 1
			end

			v38 += 1
		end
	end

	if not (v37 <= v38) or not (v37 >= 1) or not (v38 <= v26) or not (v36 <= v37) or not (v38 <= v39) or not (v37 <= t4.first) or not (v38 >= t4.last) then
		error(Error.new("Bad window calculation " .. HttpService:JSONEncode({
			first = v37,
			last = v38,
			itemCount = v26,
			overscanFirst = v36,
			overscanLast = v39,
			visible = t4
		})))
	end

	return {
		first = v37,
		last = v38
	}
end
function t1.keyExtractor(p9, n5: number) -- line: 204
	if typeof(p9) == "table" and p9.key ~= nil then
		return p9.key
	end

	if typeof(p9) == "table" and p9.id ~= nil then
		return p9.id
	end

	return (tostring(n5))
end

return t1
