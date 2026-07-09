local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local isComponent = require(Modules.AvatarExperience.Common.isComponent)

require(CorePackages.Packages.Dash)

local function withMappedProps(p1, p2: ((...any) -> ...any)) -- line: 18
	-- upvalues: ArgCheck (copy), isComponent (copy), Roact (copy)
	ArgCheck.assert(isComponent(p1), "withMappedProps must be called with a Roact component (stateful or functional)")
	ArgCheck.isType(p2, "function", "withMappedProps mapper")

	return function(p3) -- line: 25
		-- upvalues: p2 (copy), Roact (copy), p1 (copy)
		local v10 = p2(p3)

		return Roact.createElement(p1, v10)
	end
end

return withMappedProps
