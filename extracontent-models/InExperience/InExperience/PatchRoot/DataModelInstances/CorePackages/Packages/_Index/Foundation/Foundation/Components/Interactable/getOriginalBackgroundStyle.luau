local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)

require(Foundation.Components.Types)

local function getOriginalBackgroundStyle(p1, p2) -- line: 11
	-- upvalues: ReactIs (copy), React (copy)
	if ReactIs.isBinding(p1) and ReactIs.isBinding(p2) then
		return React.joinBindings({
			Color3 = p1,
			Transparency = p2
		})
	end

	if ReactIs.isBinding(p1) then
		return p1:map(function(p3) -- line: 21
			-- upvalues: p2 (copy)
			return {
				Color3 = p3,
				Transparency = p2
			}
		end)
	end

	if ReactIs.isBinding(p2) then
		return p2:map(function(p4) -- line: 25
			-- upvalues: p1 (copy)
			return {
				Color3 = p1,
				Transparency = p4
			}
		end)
	end

	return {
		Color3 = p1,
		Transparency = p2
	}
end

return getOriginalBackgroundStyle
