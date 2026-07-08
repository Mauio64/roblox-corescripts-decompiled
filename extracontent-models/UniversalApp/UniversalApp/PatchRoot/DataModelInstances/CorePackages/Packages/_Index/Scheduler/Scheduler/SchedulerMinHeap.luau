local t1 = {}
local u2 = nil
local u3 = nil
local u4 = nil

function t1.push(t2: {[any]: any}, t3: {[any]: any}) -- line: 22
	-- upvalues: u3 (ref)
	local v7 = #t2 + 1

	t2[v7] = t3
	u3(t2, t3, v7)
end
function t1.peek(t4: {[any]: any}) -- line: 29
	return t4[1]
end
function t1.pop(t5: {[any]: any}) -- line: 33
	-- upvalues: u4 (ref)
	local v10 = t5[1]

	if v10 ~= nil then
		local v11 = t5[#t5]

		t5[#t5] = nil

		if v11 ~= v10 then
			t5[1] = v11
			u4(t5, v11, 1)
		end

		return v10
	end

	return nil
end
function u3(t6: {[any]: any}, t7: {[any]: any}, n1: number) -- line: 49
	-- upvalues: u2 (ref)
	while true do
		local v15 = math.floor(n1 / 2)
		local v16 = t6[v15]

		if v16 == nil or not (u2(v16, t7) > 0) then
			break
		end

		t6[v15] = t7
		t6[n1] = v16
		n1 = v15
	end
end
function u4(t8: {[any]: any}, t9: {[any]: any}, n2: number) -- line: 65
	-- upvalues: u2 (ref)
	local v20 = #t8

	while n2 < v20 do
		local v21 = n2 * 2
		local v22 = t8[v21]
		local v23 = v21 + 1
		local v24 = t8[v23]

		if v22 ~= nil and u2(v22, t9) < 0 then
			if v24 ~= nil and u2(v24, v22) < 0 then
				t8[n2] = v24
				t8[v23] = t9
				n2 = v23
			else
				t8[n2] = v22
				t8[v21] = t9
				n2 = v21
			end

			continue
		end

		if v24 == nil or not (u2(v24, t9) < 0) then
			return
		end

		t8[n2] = v24
		t8[v23] = t9
		n2 = v23
	end
end
function u2(t10: {[any]: any}, t11: {[any]: any}) -- line: 95
	local v27 = t10.sortIndex - t11.sortIndex

	if v27 == 0 then
		return t10.id - t11.id
	end

	return v27
end

return t1
