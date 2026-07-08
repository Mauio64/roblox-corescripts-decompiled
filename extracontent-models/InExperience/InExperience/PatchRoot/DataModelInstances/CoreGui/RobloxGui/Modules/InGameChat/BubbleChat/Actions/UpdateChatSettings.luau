local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local t = require(CorePackages.Packages.t)
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)

return makeActionCreator(script.Name, function(p1) -- line: 10
	-- upvalues: maybeAssert (copy), t (copy)
	maybeAssert(t.table(p1))

	return {
		settings = p1
	}
end)
