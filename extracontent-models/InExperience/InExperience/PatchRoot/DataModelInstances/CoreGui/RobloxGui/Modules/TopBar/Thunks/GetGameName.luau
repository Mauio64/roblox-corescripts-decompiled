local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Promise = require(CorePackages.Packages.Promise)

local httpRequest = require(RobloxGui.Modules.Common.httpRequest)

local v = httpRequest(HttpRbxApiService)

local parent = script.Parent.Parent
local SetGameName = require(parent.Actions.SetGameName)

local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription

local parent2 = script.Parent.Parent
local FFlagTopBarDeprecateGameInfoRodux = require(parent2.Flags.FFlagTopBarDeprecateGameInfoRodux)

if FFlagTopBarDeprecateGameInfoRodux then
	return nil
end

return function(object)
	if game.GameId == 0 then
		return Promise.resolve()
	end

	return GetGameNameAndDescription(v, game.GameId):andThen(function(p)
		object:dispatch(SetGameName(p.Name))

		return p.Name
	end, function()
		warn("Unable to get game name for Gamepad Menu")
		return Promise.reject()
	end)
end
