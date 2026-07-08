local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Components.Types)

local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)

local function useDefaultTags(p1, s1: string) -- line: 10
	-- upvalues: React (copy), Dash (copy)
	return React.useMemo(function() -- line: 11
		-- upvalues: p1 (copy), s1 (copy), Dash (copy)
		if p1 ~= nil then
			if type(p1) == "string" then
				return `{ s1 } { p1 }`
			end

			return (Dash.join(p1, {
				[s1] = true
			}))
		end

		return s1
	end, {
		p1,
		s1
	})
end

return useDefaultTags
