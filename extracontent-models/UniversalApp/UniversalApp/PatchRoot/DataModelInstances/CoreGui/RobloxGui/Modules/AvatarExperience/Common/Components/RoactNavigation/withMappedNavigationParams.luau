local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local isComponent = require(Modules.AvatarExperience.Common.isComponent)

local function withMappedNavigationParams(p1, p2) -- line: 13
	-- upvalues: ArgCheck (copy), isComponent (copy), Roact (copy), Cryo (copy)
	ArgCheck.assert(isComponent(p1), "withMappedNavigationParams must be called with a Roact component (stateful or functional)")

	local v10 = p2 or {}

	if v10.forwardRef == nil then
		v10.forwardRef = true
	end

	return function(p3) -- line: 24
		-- upvalues: Roact (copy), p1 (copy), Cryo (copy), v10 (copy)
		local v12 = p3.navigation.state.params or {}

		return Roact.createElement(p1, Cryo.Dictionary.join(p3, v12, {
			[Roact.Ref] = v10.forwardRef and p3[Roact.Ref] or Cryo.None
		}))
	end
end

return withMappedNavigationParams
