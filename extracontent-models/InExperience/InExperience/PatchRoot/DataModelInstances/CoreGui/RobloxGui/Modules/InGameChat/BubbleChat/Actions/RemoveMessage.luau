local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local maybeAssert = require(script.Parent.Parent.Helpers.maybeAssert)
local Types = require(script.Parent.Parent.Types)

return makeActionCreator(script.Name, function(message)
	maybeAssert(Types.IMessage(message))

	return { message = message }
end)
