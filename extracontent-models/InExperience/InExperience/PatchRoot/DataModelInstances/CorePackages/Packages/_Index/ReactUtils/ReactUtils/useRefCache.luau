local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)

local function useRefCache()
	local ref = React.useRef(nil)

	if ref.current == nil then
		local refs = {}

		setmetatable(refs, {
			__index = function(_, p)
				local ref2 = React.createRef()
				refs[p] = ref2
				return ref2
			end,
			__tostring = function(items)
				local v = "{"

				for k, item in pairs(items) do
					v = ("%s\n\t%s -> %s"):format(v, tostring(k), (tostring(item)))
				end

				return v .. "\n}"
			end
		})

		ref.current = refs
	end

	return ref.current
end

return useRefCache
