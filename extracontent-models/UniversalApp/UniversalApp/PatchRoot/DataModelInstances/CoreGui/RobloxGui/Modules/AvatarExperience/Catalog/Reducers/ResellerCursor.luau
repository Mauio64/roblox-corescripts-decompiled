local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetResellerCursor = require(Modules.AvatarExperience.Catalog.Actions.SetResellerCursor)
local t1 = {
	nextPageCursor = nil,
	hasMoreRows = nil
}

return Rodux.createReducer(t1, {
	[SetResellerCursor.name] = function(p1, p2) -- line: 23
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			nextPageCursor = p2.cursor,
			hasMoreRows = p2.cursor ~= nil
		})
	end
})
