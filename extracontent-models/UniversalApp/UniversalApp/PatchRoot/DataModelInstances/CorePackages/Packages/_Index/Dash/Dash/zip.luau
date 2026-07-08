local function zip(t1: {[any]: any}, t2: {[any]: any}) -- line: 10
	local u4 = nil
	local u5 = nil
	local u6 = nil
	local u7 = nil

	return function() -- line: 12
		-- upvalues: u4 (ref), u6 (ref), t1 (copy), u5 (ref), u7 (ref), t2 (copy)
		local v8, v9 = next(t1, u4)

		u4 = v8
		u6 = v9

		local v10, v11 = next(t2, u5)

		u5 = v10
		u7 = v11

		if not u6 or not u7 then
			return nil
		end

		return u6, u7
	end
end

return zip
