local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Promise = require(CorePackages.Packages.Promise)
local v6 = require(RobloxGui.Modules.Common.httpRequest)(HttpRbxApiService)
local ParentParent = script.Parent.Parent
local SetGameName = require(ParentParent.Actions.SetGameName)
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription
local ParentParent2 = script.Parent.Parent

if require(ParentParent2.Flags.FFlagTopBarDeprecateGameInfoRodux) then
	return nil
end

return function(p1) -- line: 28
	-- upvalues: Promise (copy), GetGameNameAndDescription (copy), v6 (copy), SetGameName (copy)
	if game.GameId == 0 then
		return Promise.resolve()
	end

	return GetGameNameAndDescription(v6, game.GameId):andThen(function(p2) -- line: 33
		-- upvalues: p1 (copy), SetGameName (copy)
		p1:dispatch(SetGameName(p2.Name))

		return p2.Name
	end, function() -- line: 37
		-- upvalues: Promise (copy)
		warn("Unable to get game name for Gamepad Menu")

		return Promise.reject()
	end)
end
