local scriptParent = script.Parent

require(scriptParent.Types)

local function iterable(t1: {[any]: any}) -- line: 11
	local n1 = 1
	local u5 = true
	local u6 = nil

	return function() -- line: 16
		-- upvalues: u5 (ref), t1 (copy), n1 (ref), u6 (ref)
		if u5 then
			local v7 = t1[n1]

			if v7 ~= nil then
				local v8 = n1

				n1 += 1

				return v8, v7
			end

			u5 = false
		end

		repeat
			u6 = next(t1, u6)
		until typeof(u6) ~= "number" or not (u6 > 0) or not (u6 < n1) or u6 % 1 ~= 0

		if u6 == nil then
			return nil
		end

		return u6, t1[u6]
	end
end

return iterable
