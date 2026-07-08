local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)

local function createRefCache() -- line: 10
	-- upvalues: Roact (copy)
	local t1 = {}

	setmetatable(t1, {
		__index = function(_, p2) -- line: 14
			-- upvalues: Roact (copy), t1 (copy)
			local v7 = Roact.createRef()

			t1[p2] = v7

			return v7
		end,
		__tostring = function(p3) -- line: 20
			local s1 = "{"

			for k, v in pairs(p3) do
				s1 = ("%s\n\t%s -> %s"):format(s1, tostring(k), (tostring(v)))
			end

			return s1 .. "\n}"
		end
	})

	return t1
end

return createRefCache
