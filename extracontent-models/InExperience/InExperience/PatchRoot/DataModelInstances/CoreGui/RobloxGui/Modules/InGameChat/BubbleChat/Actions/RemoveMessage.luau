local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)
local Types = require(script.Parent.Parent.Types)

return makeActionCreator(script.Name, function(p1) -- line: 7
	-- upvalues: maybeAssert (copy), Types (copy)
	maybeAssert(Types.IMessage(p1))

	return {
		message = p1
	}
end)
