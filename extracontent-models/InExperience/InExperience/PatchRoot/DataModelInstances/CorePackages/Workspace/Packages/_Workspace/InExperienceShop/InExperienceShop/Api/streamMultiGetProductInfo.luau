local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local Promise = require(Parent.Promise)
local getProductInfo = require(script.Parent.getProductInfo)

require(script.Parent.multiGetProductInfo)

local function streamMultiGetProductInfo(t1: {[any]: any}, t2: {[any]: any}) -- line: 20
	-- upvalues: Promise (copy), getProductInfo (copy)
	local v7 = #t1

	if v7 == 0 then
		return Promise.resolve({})
	end

	local t3 = table.create(v7)
	local n1 = 0

	return Promise.new(function(resolve) -- line: 32
		-- upvalues: t1 (copy), getProductInfo (copy), t3 (copy), t2 (copy), n1 (ref), v7 (copy)
		for i, v in ipairs(t1) do
			getProductInfo(v.id, v.infoType):andThen(function(p1) -- line: 35
				-- upvalues: v (copy)
				return {
					ok = true,
					request = v,
					value = p1
				}
			end):catch(function(p2) -- line: 38
				-- upvalues: v (copy)
				return {
					ok = false,
					request = v,
					err = p2
				}
			end):andThen(function(p3) -- line: 41
				-- upvalues: t3 (copy), i (copy), t2 (copy), n1 (ref), v7 (copy), resolve (copy)
				t3[i] = p3
				t2.onResult(p3)
				n1 += 1

				if n1 == v7 then
					resolve(t3)
				end
			end)
		end
	end)
end

return streamMultiGetProductInfo
