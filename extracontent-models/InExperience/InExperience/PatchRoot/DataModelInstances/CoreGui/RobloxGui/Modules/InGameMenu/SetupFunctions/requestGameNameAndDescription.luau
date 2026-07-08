local HttpRbxApiService = game:GetService("HttpRbxApiService")
local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local SetGameNameAndDescription = require(ParentParent.Actions.SetGameNameAndDescription)
local v5 = require(ParentParent.Network.httpRequest)(HttpRbxApiService)
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription

local function requestGameNameAndDescription(p1) -- line: 13
	-- upvalues: GetGameNameAndDescription (copy), v5 (copy), SetGameNameAndDescription (copy)
	if game.GameId == 0 then
		return
	end

	GetGameNameAndDescription(v5, game.GameId):andThen(function(p2) -- line: 18
		-- upvalues: p1 (copy), SetGameNameAndDescription (copy)
		p1:dispatch(SetGameNameAndDescription(p2.Name, p2.Description))
	end):catch(function() -- line: 20
		warn("Unable to retrieve game name for in game menu")
	end)
end

return requestGameNameAndDescription
