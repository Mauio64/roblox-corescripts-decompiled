local Parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(Parent.React)

local function useRefCache() -- line: 7
	-- upvalues: React (copy)
	local v4 = React.useRef(nil)

	if v4.current == nil then
		local t1 = {}

		setmetatable(t1, {
			__index = function(_, p2) -- line: 14
				-- upvalues: React (copy), t1 (copy)
				local v8 = React.createRef()

				t1[p2] = v8

				return v8
			end,
			__tostring = function(p3) -- line: 19
				local s1 = "{"

				for k, v in pairs(p3) do
					s1 = ("%s\n\t%s -> %s"):format(s1, tostring(k), (tostring(v)))
				end

				return s1 .. "\n}"
			end
		})
		v4.current = t1
	end

	return v4.current
end

return useRefCache
