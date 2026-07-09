local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local isComponent = require(Modules.AvatarExperience.Common.isComponent)

require(CorePackages.Packages.Dash)

local t1 = {
	forwardRef = true,
	required = true
}

local function withContextValue(p1, p2, s1: string, t2: {[any]: any}?) -- line: 33
	-- upvalues: ArgCheck (copy), isComponent (copy), Cryo (copy), t1 (copy), Roact (copy)
	ArgCheck.assert(isComponent(p1), "withContextValue must be called with a Roact component (stateful or functional)")
	ArgCheck.assert(isComponent(p2), "withContextValue must be called with a Roact component for contextConsumer")
	ArgCheck.isType(s1, "string", "withContextValue propName")

	local v13 = Cryo.Dictionary.join(t1, t2 or {})

	return function(p3) -- line: 46
		-- upvalues: s1 (copy), Roact (copy), p2 (copy), v13 (copy), ArgCheck (copy), p1 (copy), Cryo (copy)
		local v15 = p3[s1]

		return Roact.createElement(p2, {
			render = function(p4) -- line: 49
				-- upvalues: v15 (copy), v13 (copy), ArgCheck (copy), p1 (copy), s1 (copy), Roact (copy), Cryo (copy), p3 (copy)
				local v17 = v15 or p4

				if v13.required then
					ArgCheck.assert(v17, string.format("withContextValue can only be used within the context provider hierarchy. The wrapped component %q is unable to get access to %q from props or context.", tostring(p1), s1))
				end

				return Roact.createElement(p1, Cryo.Dictionary.join(p3, {
					[s1] = v17,
					[Roact.Ref] = v13.forwardRef and p3[Roact.Ref] or nil
				}))
			end
		})
	end
end

return withContextValue
