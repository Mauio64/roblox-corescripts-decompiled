local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

require(SduiSharedUtilities.SduiIntegrationTypes)

local t1 = {}

local function isArrayLike(p1) -- line: 15
	return typeof(p1) == "table" and #p1 > 0
end
local function shallowAssignFromNew(t2: {[any]: any}, t3: {[any]: any}) -- line: 19
	for v10, v11 in t3 do
		t2[v10] = v11
	end
end
local function appendArray(t4: {[any]: any}, t5: {[any]: any}) -- line: 25
	for _, v15 in t5 do
		table.insert(t4, v15)
	end
end
local function mergeInto(t6: {[any]: any}, t7: {[any]: any}, p2, t8: {[any]: any}) -- line: 31
	-- upvalues: mergeInto (copy)
	for v20, v21 in t7 do
		if typeof(v21) == "table" then
			table.insert(t8, (tostring(v20)))

			local v22 = if not p2 then nil else p2(t8, v21, t6[v20])

			if v22 == "replace" then
				t6[v20] = v21
			elseif v22 == "merge" then
				if t6[v20] == nil then
					t6[v20] = v21
				else
					local v23 = t6[v20]

					for v24, v25 in v21 do
						v23[v24] = v25
					end
				end
			elseif v22 == "append" then
				if t6[v20] == nil then
					t6[v20] = v21
				elseif typeof(v21) == "table" and #v21 > 0 then
					local v26 = t6[v20]

					for _, v28 in v21 do
						table.insert(v26, v28)
					end
				else
					local v29 = t6[v20]

					for v30, v31 in v21 do
						v29[v30] = v31
					end
				end
			else
				if t6[v20] == nil then
					t6[v20] = {}
				end

				if typeof(v21) == "table" and #v21 > 0 then
					local v32 = t6[v20]

					for _, v34 in v21 do
						table.insert(v32, v34)
					end
				else
					mergeInto(t6[v20], v21, p2, t8)
				end
			end

			table.remove(t8)
		else
			t6[v20] = v21
		end
	end
end

function t1.merge(t9: {[any]: any}, t10: {[any]: any}, p3) -- line: 78
	-- upvalues: mergeInto (copy)
	local v38 = table.clone(t9)

	mergeInto(v38, t10, p3, {})

	return v38
end

return t1
