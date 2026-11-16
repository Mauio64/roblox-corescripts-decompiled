local parent = script:FindFirstAncestor("InExperienceShop").Parent

local Promise = require(parent.Promise)
local getProductInfo = require(script.Parent.getProductInfo)
require(script.Parent.multiGetProductInfo)

local function streamMultiGetProductInfo(list, p)
	local count = #list

	if count == 0 then
		return Promise.resolve({})
	end

	local v = table.create(count)
	local count2 = 0

	return Promise.new(function(callback)
		for i, item in ipairs(list) do
			getProductInfo(item.id, item.infoType):andThen(function(p2)
				return { request = item, ok = true, value = p2 }
			end):catch(function(err)
				return { request = item, ok = false, err = err }
			end):andThen(function(p2)
				v[i] = p2
				p.onResult(p2)
				count2 += 1

				if count2 == count then
					callback(v)
				end
			end)
		end
	end)
end

return streamMultiGetProductInfo
