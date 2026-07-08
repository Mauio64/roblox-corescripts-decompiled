local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)

local t1 = {}

local function replaceNil(p1) -- line: 19
	-- upvalues: t1 (copy)
	if p1 == nil then
		return t1
	end

	return p1
end
local function newWeakMap() -- line: 26
	return (setmetatable({}, {
		__mode = "kv"
	}))
end

return {
	memoize3 = function(p2: ((...any) -> ...any)) -- line: 33
		-- upvalues: t1 (copy)
		local self = nil

		return function(p3, p4, p5) -- line: 36
			-- upvalues: t1 (copy), self (ref), p2 (copy)
			local v11 = if p3 ~= nil then p3 else t1
			local v12 = if p4 ~= nil then p4 else t1
			local v13 = if p5 ~= nil then p5 else t1

			if not self then
				self = setmetatable({}, {
					__mode = "kv"
				})
			end

			local v14 = self[v11]
			local v15 = nil

			if v14 then
				v15 = v14[v12]

				if v15 then
					local v16 = v15[v13]

					if v16 ~= nil then
						if v16 == t1 then
							return nil
						end

						return v16
					end
				end
			else
				v14 = setmetatable({}, {
					__mode = "kv"
				})
				self[v11] = v14
			end

			if not v15 then
				v15 = setmetatable({}, {
					__mode = "kv"
				})
				v14[v12] = v15
			end

			local v17 = p2(p3, p4, p5)

			v15[v13] = if v17 ~= nil then v17 else t1

			return v17
		end
	end
}
