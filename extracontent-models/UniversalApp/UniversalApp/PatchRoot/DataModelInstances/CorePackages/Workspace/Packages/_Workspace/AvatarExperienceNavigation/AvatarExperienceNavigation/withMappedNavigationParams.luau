local Parent = script:FindFirstAncestor("AvatarExperienceNavigation").Parent
local Roact = require(Parent.Roact)
local Cryo = require(Parent.Cryo)
local ArgCheck = require(Parent.ArgCheck)
local ReactIs = require(Parent.ReactIs)

local function withMappedNavigationParams(p1, p2) -- line: 12
	-- upvalues: ArgCheck (copy), ReactIs (copy), Roact (copy), Cryo (copy)
	ArgCheck.assert(ReactIs.isValidElementType(p1), "withMappedNavigationParams must be called with a Roact component (stateful or functional)")

	local v9 = p2 or {}

	if v9.forwardRef == nil then
		v9.forwardRef = true
	end

	return function(p3) -- line: 23
		-- upvalues: Roact (copy), p1 (copy), Cryo (copy), v9 (copy)
		local v11 = p3.navigation.state.params or {}

		return Roact.createElement(p1, Cryo.Dictionary.join(p3, v11, {
			[Roact.Ref] = v9.forwardRef and p3[Roact.Ref] or Cryo.None
		}))
	end
end

return withMappedNavigationParams
