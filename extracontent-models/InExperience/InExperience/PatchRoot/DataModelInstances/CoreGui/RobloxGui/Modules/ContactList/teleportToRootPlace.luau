local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local TeleportService = game:GetService("TeleportService")
local GamesMultigetPlaceDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GamesByPlaceId.GamesMultigetPlaceDetails
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local v6 = require(RobloxGui.Modules.Common.httpRequest)(HttpRbxApiService)

return function() -- line: 14
	-- upvalues: GamesMultigetPlaceDetails (copy), v6 (copy), TeleportService (copy)
	if game.PlaceId ~= 0 then
		GamesMultigetPlaceDetails(v6, game.PlaceId):andThen(function(p1) -- line: 16
			-- upvalues: TeleportService (copy)
			local universeRootPlaceId = p1.responseBody[1].universeRootPlaceId

			TeleportService:Teleport(universeRootPlaceId)
		end, function() -- line: 19
		end)
	end
end
