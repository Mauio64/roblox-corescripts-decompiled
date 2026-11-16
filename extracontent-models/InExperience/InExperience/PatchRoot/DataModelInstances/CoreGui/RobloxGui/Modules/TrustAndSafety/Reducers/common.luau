local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent

local ShowToast = require(parent.Actions.ShowToast)

return Rodux.createReducer({ toastTitle = nil, toastSubtitle = nil }, {
	[ShowToast.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			toastTitle = p2.toastTitle,
			toastSubtitle = p2.toastSubtitle
		})
	end
})
