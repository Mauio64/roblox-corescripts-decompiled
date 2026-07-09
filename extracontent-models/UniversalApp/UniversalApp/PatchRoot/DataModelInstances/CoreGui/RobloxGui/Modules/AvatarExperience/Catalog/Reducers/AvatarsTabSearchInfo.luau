local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetAvatarsTabSearchInfo = require(Modules.AvatarExperience.Catalog.Actions.SetAvatarsTabSearchInfo)

return Rodux.createReducer({}, {
	[SetAvatarsTabSearchInfo.name] = function(p1, p2) -- line: 20
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			searchUuid = p2.searchUuid,
			keyword = p2.keyword
		})
	end
})
