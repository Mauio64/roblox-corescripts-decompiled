local function createEvent()
	local v = {}

	return {
		fire = function(...)
			for _, v2 in v do
				v2(...)
			end
		end,
		connect = function(callback)
			local flag = true
			local function fn(...)
				if flag then
					callback(...)
				end
			end
			local clone = table.clone(v)
			table.insert(clone, fn)
			v = clone
			return function()
				flag = false
				local index = table.find(v, fn)

				if index ~= nil then
					local clone2 = table.clone(v)
					table.remove(clone2, index)
					v = clone2
				end
			end
		end
	}
end

return createEvent
