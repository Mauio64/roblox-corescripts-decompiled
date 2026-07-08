local CorePackages = game:GetService("CorePackages")
local ShareGame = game:GetService("CoreGui").RobloxGui.Modules.Settings.Pages.ShareGame
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local SetGameInfoCreated = require(ShareGame.Actions.SetGameInfoCreated)

return function(p1, p2) -- line: 10
	-- upvalues: SetGameInfoCreated (copy), Immutable (copy)
	local v7 = p1 or {
		Created = nil
	}

	if p2.type == SetGameInfoCreated.name then
		v7 = Immutable.Set(v7, "Created", p2.Created)
	end

	return v7
end
