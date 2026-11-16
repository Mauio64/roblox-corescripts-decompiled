local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Promise = require(CorePackages.Packages.Promise)

local httpRequest = require(RobloxGui.Modules.Common.httpRequest)

local v = httpRequest(HttpRbxApiService)

local parent = script.Parent.Parent
local GameNameFetched = require(parent.Actions.GameNameFetched)

local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription

return function(object)
	if game.GameId == 0 then
		return Promise.resolve()
	end

	return GetGameNameAndDescription(v, game.GameId):andThen(function(p)
		object:dispatch(GameNameFetched(p.Name))

		return p.Name
	end, function()
		warn("Unable to get game name for Avatar Editor Prompts")
		return Promise.reject()
	end)
end
