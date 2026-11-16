local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent

local SetIsSubjectToChinaPolicies = require(parent.Actions.SetIsSubjectToChinaPolicies)

return (Rodux.createReducer(true, {
	[SetIsSubjectToChinaPolicies.name] = function(_, p)
		return p.isSubjectToChinaPolicies
	end
}))
