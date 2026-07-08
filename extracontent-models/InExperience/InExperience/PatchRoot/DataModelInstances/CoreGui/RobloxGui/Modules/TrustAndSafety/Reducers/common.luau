local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local ShowToast = require(ParentParent.Actions.ShowToast)

return Rodux.createReducer({
	toastTitle = nil,
	toastSubtitle = nil
}, {
	[ShowToast.name] = function(p1, p2) -- line: 14
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			toastTitle = p2.toastTitle,
			toastSubtitle = p2.toastSubtitle
		})
	end
})
