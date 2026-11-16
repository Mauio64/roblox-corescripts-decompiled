local HttpRbxApiService = game:GetService("HttpRbxApiService")
local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent

local SetGameNameAndDescription = require(parent.Actions.SetGameNameAndDescription)

local httpRequest = require(parent.Network.httpRequest)
local v = httpRequest(HttpRbxApiService)

local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription

local function requestGameNameAndDescription(object)
	if game.GameId == 0 then
		return
	end

	GetGameNameAndDescription(v, game.GameId):andThen(function(p)
		object:dispatch(SetGameNameAndDescription(p.Name, p.Description))
	end):catch(function()
		warn("Unable to retrieve game name for in game menu")
	end)
end

return requestGameNameAndDescription
