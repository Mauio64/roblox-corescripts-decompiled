local ancestor = script:FindFirstAncestor("ultimate-list")
local DataSourceMethods = require(ancestor.DataSources.DataSourceMethods)

require(ancestor.DataSources)
require(ancestor.Dimensions)

local exhaustiveMatch = require(ancestor.Util.exhaustiveMatch)

local function binarySearchIndexRangeInView(p1, p2: ((...any) -> ...any), n1: number, n2: number, s1: string) -- line: 8
	-- upvalues: exhaustiveMatch (copy), DataSourceMethods (copy)
	local function compareInView(p3) -- line: 18
		-- upvalues: s1 (copy), exhaustiveMatch (copy), n1 (copy), n2 (copy)
		local v20 = if s1 ~= "x" then if s1 ~= "y" then exhaustiveMatch(s1) else p3.position.Y.Offset else p3.position.X.Offset

		if v20 + (if s1 ~= "x" then (if s1 ~= "y" then exhaustiveMatch(s1) else p3.size.Y.Offset) else p3.size.X.Offset) < n1 then
			return "before"
		end

		if v20 > n1 + n2 then
			return "after"
		end

		return "inside"
	end

	local n3 = 1
	local v12 = DataSourceMethods.length(p1)
	local v13 = v12

	while n3 <= v13 do
		local v14 = (n3 + v13) // 2
		local v15 = DataSourceMethods.get(p1, v14)

		assert(v15 ~= nil, "get() returned nil, meaning the length is inaccurate")

		local v16 = compareInView((p2(v15.value, v14)))

		if v16 ~= "after" then
			if v16 == "before" then
				n3 = v14 + 1

				continue
			end

			if v16 == "inside" then
				local v17 = v14
				local v18 = v15

				while v17 > 1 do
					v18 = v18.before()

					if v18 == nil or compareInView(p2(v18.value, v17 - 1)) ~= "inside" then
						break
					end

					v17 -= 1
				end

				while v14 < v12 do
					v15 = v15.after()

					if v15 == nil or compareInView(p2(v15.value, v14 + 1)) ~= "inside" then
						return (Vector3.new(v17, v14))
					end

					v14 += 1
				end

				return (Vector3.new(v17, v14))
			end

			exhaustiveMatch(v16)

			continue
		end

		v13 = v14 - 1
	end

	return (Vector3.new(0, 0, 0))
end

return binarySearchIndexRangeInView
