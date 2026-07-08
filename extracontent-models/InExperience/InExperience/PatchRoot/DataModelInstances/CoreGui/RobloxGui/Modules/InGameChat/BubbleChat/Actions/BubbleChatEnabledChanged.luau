local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local t = require(CorePackages.Packages.t)
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)

return makeActionCreator(script.Name, function(p1) -- line: 7
	-- upvalues: maybeAssert (copy), t (copy)
	maybeAssert(t.boolean(p1))

	return {
		enabled = p1
	}
end)
