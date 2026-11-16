local parent = script.Parent.Parent

local FloatVector = require(parent.util.FloatVector)

local NelderMead = {}
NelderMead.__index = NelderMead

function NelderMead.new(list, objectFunction, terminateFunction)
	local self = setmetatable({}, NelderMead)

	if list and #list > 0 then
		local item = list[1]

		for _, item2 in list do
			if not item:checkCompatible(item2) then
				error("initial simplex has vectors that are not compatible")
			end
		end
	else
		error("must provide an initial simplex")
	end

	self.simplex = {}

	for _, item in list do
		table.insert(self.simplex, FloatVector.new(item))
	end

	self.objectFunction = objectFunction
	self.terminateFunction = terminateFunction
	return self
end

function NelderMead.evaluate(data)
	local simplex = data.simplex

	local v = {}
	local count = 0

	local function fn(p) -- 5 equivalent calls inferred from this helper
		local v2 = v[p]

		if not v2 then
			v2 = data.objectFunction(p)
			v[p] = v2
		end

		return v2
	end

	while not data.terminateFunction(simplex, count) do
		v = {}

		table.sort(simplex, function(a, b): boolean
			return fn(a) < fn(b) -- inferred equivalent call
		end)

		local v2 = simplex[#simplex]

		local v3 = {}

		for _ = 1, simplex[1]:getSize() do
			table.insert(v3, 0)
		end

		local v4 = FloatVector.new(v3)

		for i = 1, #simplex - 1 do
			v4 += simplex[i]
		end

		local v5 = v4 / (#simplex - 1) - v2
		local v6 = v2 + v5 * 2
		local v7 = fn(v6) -- inferred equivalent call
		local v8 = fn(simplex[1]) -- inferred equivalent call
		local v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19

		if v8 < v7 then
			if v7 < fn(simplex[#simplex - 1]) then -- inferred equivalent call
				simplex[#simplex] = v6
			else
				v9 = simplex[1]
				v10 = v[v9]

				if not v10 then
					v10 = data.objectFunction(v9)
					v[v9] = v10
				end

				if v7 < v10 then
					v11 = v6 + v5
					v12 = v[v11]

					if not v12 then
						v12 = data.objectFunction(v11)
						v[v11] = v12
					end

					if v12 < v7 then
						simplex[#simplex] = v11
					else
						simplex[#simplex] = v6
					end
				else
					v13 = v2 + v5 * 0.5
					v14 = v2 + v5 * 1.5
					v15 = v[v13]

					if not v15 then
						v15 = data.objectFunction(v13)
						v[v13] = v15
					end

					v16 = v[v14]

					if not v16 then
						v16 = data.objectFunction(v14)
						v[v14] = v16
					end

					if v15 < v16 then
						v14 = v13
					end

					v17 = v[v14]

					if not v17 then
						v17 = data.objectFunction(v14)
						v[v14] = v17
					end

					v18 = simplex[#simplex - 1]
					v19 = v[v18]

					if not v19 then
						v19 = data.objectFunction(v18)
						v[v18] = v19
					end

					if v17 < v19 then
						simplex[#simplex] = v14
					else
						for i = 1, #simplex do
							simplex[i] = (simplex[i] - simplex[1]) * 0.8 + simplex[1]
						end
					end
				end
			end
		else
			v9 = simplex[1]
			v10 = v[v9]

			if not v10 then
				v10 = data.objectFunction(v9)
				v[v9] = v10
			end

			if v7 < v10 then
				v11 = v6 + v5
				v12 = v[v11]

				if not v12 then
					v12 = data.objectFunction(v11)
					v[v11] = v12
				end

				if v12 < v7 then
					simplex[#simplex] = v11
				else
					simplex[#simplex] = v6
				end
			else
				v13 = v2 + v5 * 0.5
				v14 = v2 + v5 * 1.5
				v15 = v[v13]

				if not v15 then
					v15 = data.objectFunction(v13)
					v[v13] = v15
				end

				v16 = v[v14]

				if not v16 then
					v16 = data.objectFunction(v14)
					v[v14] = v16
				end

				if v15 < v16 then
					v14 = v13
				end

				v17 = v[v14]

				if not v17 then
					v17 = data.objectFunction(v14)
					v[v14] = v17
				end

				v18 = simplex[#simplex - 1]
				v19 = v[v18]

				if not v19 then
					v19 = data.objectFunction(v18)
					v[v18] = v19
				end

				if v17 < v19 then
					simplex[#simplex] = v14
				else
					for i = 1, #simplex do
						simplex[i] = (simplex[i] - simplex[1]) * 0.8 + simplex[1]
					end
				end
			end
		end

		count += 1
	end
end

function NelderMead.calculateMaxLengthBetweenVertices(list)
	local maxValue = 0

	for i = 1, #list - 1 do
		for j = i + 1, #list do
			maxValue = math.max(maxValue, ((list[j] - list[i]):magnitude()))
		end
	end

	return maxValue
end

return NelderMead
