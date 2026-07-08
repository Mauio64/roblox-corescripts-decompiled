local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetIsSubjectToChinaPolicies = require(ParentParent.Actions.SetIsSubjectToChinaPolicies)

return (Rodux.createReducer(true, {
	[SetIsSubjectToChinaPolicies.name] = function(_, p2) -- line: 11
		return p2.isSubjectToChinaPolicies
	end
}))
