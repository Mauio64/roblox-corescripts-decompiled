local ParentParent = script.Parent.Parent
local FloatVector = require(ParentParent.util.FloatVector)
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}, p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 24
	-- upvalues: t1 (copy), FloatVector (copy)
	local self = setmetatable({}, t1)

	if t2 and #t2 > 0 then
		local v8 = t2[1]

		for _, v10 in t2 do
			if not v8:checkCompatible(v10) then
				error("initial simplex has vectors that are not compatible")
			end
		end
	else
		error("must provide an initial simplex")
	end

	self.simplex = {}

	for _, v12 in t2 do
		table.insert(self.simplex, FloatVector.new(v12))
	end

	self.objectFunction = p1
	self.terminateFunction = p2

	return self
end
function t1.evaluate(p3) -- line: 51
	-- upvalues: FloatVector (copy)
	local simplex = p3.simplex
	local t3 = {}
	local n1 = 0
	local g27 = nil

	while not p3.terminateFunction(simplex, n1) do
		t3 = {}
		table.sort(simplex, function(p4, p5) -- line: 68
			-- upvalues: t3 (ref), p3 (copy)
			local v51 = t3[p4]

			if not v51 then
				v51 = p3.objectFunction(p4)
				t3[p4] = v51
			end

			local v52 = t3[p5]

			if not v52 then
				v52 = p3.objectFunction(p5)
				t3[p5] = v52
			end

			return v51 < v52
		end)

		local v17 = simplex[#simplex]
		local t4 = {}

		for _ = 1, simplex[1]:getSize() do
			table.insert(t4, 0)
		end

		local v20 = FloatVector.new(t4)

		for i = 1, #simplex - 1 do
			v20 += simplex[i]
		end

		local v22 = v20 / (#simplex - 1) - v17
		local v23 = v17 + v22 * 2
		local v24 = t3[v23]

		if not v24 then
			v24 = p3.objectFunction(v23)
			t3[v23] = v24
		end

		local v25 = simplex[1]
		local v26 = t3[v25]

		if not v26 then
			v26 = p3.objectFunction(v25)
			t3[v25] = v26
		end

		repeat
			if not g27 and v26 < v24 then
				local v28 = simplex[#simplex - 1]
				local v29 = t3[v28]

				if not v29 then
					v29 = p3.objectFunction(v28)
					t3[v28] = v29
				end

				if not (v24 < v29) then
					g27 = true
				end

				if not g27 then
					simplex[#simplex] = v23
				end
			else
				g27 = false

				local v30 = simplex[1]
				local v31 = t3[v30]

				if not v31 then
					v31 = p3.objectFunction(v30)
					t3[v30] = v31
				end

				if v24 < v31 then
					local v32 = v23 + v22
					local v33 = t3[v32]

					if not v33 then
						v33 = p3.objectFunction(v32)
						t3[v32] = v33
					end

					if v33 < v24 then
						simplex[#simplex] = v32
					else
						simplex[#simplex] = v23
					end
				else
					local v34 = v17 + v22 * 0.5
					local v35 = v17 + v22 * 1.5
					local v36 = t3[v34]

					if not v36 then
						v36 = p3.objectFunction(v34)
						t3[v34] = v36
					end

					local v37 = t3[v35]

					if not v37 then
						v37 = p3.objectFunction(v35)
						t3[v35] = v37
					end

					local v38 = if not (v36 < v37) then v35 else v34
					local v39 = t3[v38]

					if not v39 then
						v39 = p3.objectFunction(v38)
						t3[v38] = v39
					end

					local v40 = simplex[#simplex - 1]
					local v41 = t3[v40]

					if not v41 then
						v41 = p3.objectFunction(v40)
						t3[v40] = v41
					end

					if v39 < v41 then
						simplex[#simplex] = v38
					else
						for i = 1, #simplex do
							simplex[i] = (simplex[i] - simplex[1]) * 0.8 + simplex[1]
						end
					end
				end
			end
		until not g27

		n1 += 1
	end
end
function t1.calculateMaxLengthBetweenVertices(t5: {[any]: any}) -- line: 122
	local n2 = 0

	for i = 1, #t5 - 1 do
		for j = i + 1, #t5 do
			n2 = math.max(n2, ((t5[j] - t5[i]):magnitude()))
		end
	end

	return n2
end

return t1
