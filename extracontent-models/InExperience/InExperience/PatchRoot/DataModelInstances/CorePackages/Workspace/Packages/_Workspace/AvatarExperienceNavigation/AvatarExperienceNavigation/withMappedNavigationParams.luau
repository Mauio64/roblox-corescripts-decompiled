local parent = script:FindFirstAncestor("AvatarExperienceNavigation").Parent

local Roact = require(parent.Roact)
local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local ReactIs = require(parent.ReactIs)

local function withMappedNavigationParams(p, options)
	ArgCheck.assert(
		ReactIs.isValidElementType(p),
		"withMappedNavigationParams must be called with a Roact component (stateful or functional)"
	)

	local v = options or {}

	if v.forwardRef == nil then
		v.forwardRef = true
	end

	return function(p2)
		local params = p2.navigation.state.params or {}
		return Roact.createElement(p, Cryo.Dictionary.join(p2, params, {
			[Roact.Ref] = v.forwardRef and p2[Roact.Ref] or Cryo.None
		}))
	end
end

return withMappedNavigationParams
