local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Promise = require(CorePackages.Packages.Promise)
local v6 = require(RobloxGui.Modules.Common.httpRequest)(HttpRbxApiService)
local ParentParent = script.Parent.Parent
local GameNameFetched = require(ParentParent.Actions.GameNameFetched)
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription

return function(p1) -- line: 20
	-- upvalues: Promise (copy), GetGameNameAndDescription (copy), v6 (copy), GameNameFetched (copy)
	if game.GameId == 0 then
		return Promise.resolve()
	end

	return GetGameNameAndDescription(v6, game.GameId):andThen(function(p2) -- line: 25
		-- upvalues: p1 (copy), GameNameFetched (copy)
		p1:dispatch(GameNameFetched(p2.Name))

		return p2.Name
	end, function() -- line: 29
		-- upvalues: Promise (copy)
		warn("Unable to get game name for Avatar Editor Prompts")

		return Promise.reject()
	end)
end
