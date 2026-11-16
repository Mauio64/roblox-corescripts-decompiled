local ultimatelist = script:FindFirstAncestor("ultimate-list")

local DataSourceMethods = require(ultimatelist.DataSources.DataSourceMethods)
require(ultimatelist.DataSources)
require(ultimatelist.Dimensions)
local exhaustiveMatch = require(ultimatelist.Util.exhaustiveMatch)

local function binarySearchIndexRangeInView(p, callback, p2: number, p3: number, p4: string)
	local function compareInView(p5): string
		local v

		if p4 == "x" then
			v = p5.position.X.Offset
		elseif p4 == "y" then
			v = p5.position.Y.Offset
		else
			v = exhaustiveMatch(p4)
		end

		local v2

		if p4 == "x" then
			v2 = p5.size.X.Offset
		elseif p4 == "y" then
			v2 = p5.size.Y.Offset
		else
			v2 = exhaustiveMatch(p4)
		end

		if v + v2 < p2 then
			return "before"
		end

		return if p2 + p3 < v then "after" else "inside"
	end

	local length = DataSourceMethods.length(p)
	local v = length
	local v2 = 1

	while v2 <= v do
		local v3 = (v2 + v) // 2

		local v4 = DataSourceMethods.get(p, v3)
		assert(v4 ~= nil, "get() returned nil, meaning the length is inaccurate")

		local v5 = compareInView(callback(v4.value, v3))

		if v5 == "after" then
			v = v3 - 1
		elseif v5 == "before" then
			v2 = v3 + 1
		elseif v5 == "inside" then
			local v6 = v4
			local v7 = v3

			while v7 > 1 do
				v6 = v6.before()

				if v6 == nil or compareInView(callback(v6.value, v7 - 1)) ~= "inside" then
					break
				end

				v7 -= 1
			end

			while v3 < length do
				v4 = v4.after()

				if v4 == nil or compareInView(callback(v4.value, v3 + 1)) ~= "inside" then
					break
				end

				v3 += 1
			end

			return (Vector3.new(v7, v3))
		else
			exhaustiveMatch(v5)
		end
	end

	return Vector3.new(0, 0, 0)
end

return binarySearchIndexRangeInView
