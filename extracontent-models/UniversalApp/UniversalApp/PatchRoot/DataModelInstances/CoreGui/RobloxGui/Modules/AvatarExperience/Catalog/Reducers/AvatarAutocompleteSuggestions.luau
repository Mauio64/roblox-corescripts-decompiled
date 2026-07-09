local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local AddAvatarAutocompleteSuggestion = require(Modules.AvatarExperience.Catalog.Actions.AddAvatarAutocompleteSuggestion)

return (require(CorePackages.Packages.Rodux).createReducer({}, {
	[AddAvatarAutocompleteSuggestion.name] = function(p1, p2) -- line: 24
		-- upvalues: Cryo (copy)
		return (Cryo.Dictionary.join(p1, {
			[p2.prefix] = p2.autocompleteSuggestions
		}))
	end
}))
