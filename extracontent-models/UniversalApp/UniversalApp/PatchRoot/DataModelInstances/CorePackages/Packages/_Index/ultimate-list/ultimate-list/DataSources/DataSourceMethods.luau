local ancestor = script:FindFirstAncestor("ultimate-list")

require(script.Parent)

local exhaustiveMatch = require(ancestor.Util.exhaustiveMatch)

return {
	get = function(p1, n1: number) -- line: 8
		-- upvalues: exhaustiveMatch (copy)
		assert(n1 >= 1, "index < 1")

		if p1.type == "array" then
			local function get(n2: number) -- line: 15
				-- upvalues: p1 (copy), get (copy)
				if n2 < 1 or n2 > #p1.array then
					return nil
				end

				return {
					before = function() -- line: 21
						-- upvalues: get (copy), n2 (copy)
						return get(n2 - 1)
					end,
					value = p1.array[n2],
					after = function() -- line: 27
						-- upvalues: get (copy), n2 (copy)
						return get(n2 + 1)
					end
				}
			end

			return (get(n1))
		end

		if p1.type == "mutableSource" then
			return p1.methods.get(n1)
		end

		return exhaustiveMatch(p1.type)
	end,
	getByRange = function(p2, vector3: Vector3) -- line: 41
		-- upvalues: exhaustiveMatch (copy)
		if p2.type == "array" then
			return table.move(p2.array, vector3.X, vector3.Y, 1, {})
		end

		if p2.type == "mutableSource" then
			if p2.methods.getByRange == nil then
				local t1 = {}
				local v9 = p2.methods.get(vector3.X)

				for _ = 0, vector3.Y - vector3.X do
					if v9 == nil then
						return t1
					end

					table.insert(t1, v9.value)
					v9 = v9.after()
				end

				return t1
			end

			return p2.methods.getByRange(vector3.X, vector3.Y)
		end

		return exhaustiveMatch(p2.type)
	end,
	back = function(p3) -- line: 67
		-- upvalues: exhaustiveMatch (copy)
		if p3.type == "array" then
			return p3.array[#p3.array]
		end

		if p3.type == "mutableSource" then
			if p3.methods.back == nil then
				local v12 = p3.methods.get(p3.methods.length())

				return v12 and v12.value
			end

			return p3.methods.back()
		end

		return exhaustiveMatch(p3.type)
	end,
	length = function(p4) -- line: 82
		-- upvalues: exhaustiveMatch (copy)
		if p4.type == "array" then
			return #p4.array
		end

		if p4.type == "mutableSource" then
			return p4.methods.length()
		end

		return exhaustiveMatch(p4.type)
	end,
	equals = function(p5, p6) -- line: 93
		-- upvalues: exhaustiveMatch (copy)
		if p5.type ~= p6.type then
			return false
		end

		if p5.type == "array" then
			assert(p6.type == "array", "Luau")

			return p5.array == p6.array
		end

		if p5.type == "mutableSource" then
			assert(p6.type == "mutableSource", "Luau")

			return p5.methods == p6.methods
		end

		return exhaustiveMatch(p5.type)
	end
}
