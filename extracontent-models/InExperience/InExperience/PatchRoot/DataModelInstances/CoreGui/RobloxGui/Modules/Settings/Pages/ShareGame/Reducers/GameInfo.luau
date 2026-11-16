local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local ShareGame = CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Immutable = AppCommonLib.Immutable

local SetGameInfoCreated = require(ShareGame.Actions.SetGameInfoCreated)

return function(p, p2)
	local v = p or { Created = nil }

	if p2.type == SetGameInfoCreated.name then
		return (Immutable.Set(v, "Created", p2.Created))
	end

	return v
end
