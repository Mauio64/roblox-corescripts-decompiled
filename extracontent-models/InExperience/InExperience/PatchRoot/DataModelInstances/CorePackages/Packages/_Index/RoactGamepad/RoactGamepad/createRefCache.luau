local parent = script.Parent.Parent
local Roact = require(parent.Roact)

local function createRefCache()
	local refs = {}

	setmetatable(refs, {
		__index = function(_, p)
			local ref = Roact.createRef()
			refs[p] = ref

			return ref
		end,
		__tostring = function(items)
			local v = "{"

			for k, item in pairs(items) do
				v = ("%s\n\t%s -> %s"):format(v, tostring(k), (tostring(item)))
			end

			return v .. "\n}"
		end
	})

	return refs
end

return createRefCache
