local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GameDetailRodux = require(CorePackages.Workspace.Packages.GameDetailRodux)
local GetGameNameAndDescription = GameDetailRodux.GetGameNameAndDescription

local httpRequest = require(RobloxGui.Modules.Common.httpRequest)

local v = httpRequest(HttpRbxApiService)

local parent = script.Parent.Parent
local SetPlaceInfo = require(parent.Actions.SetPlaceInfo)

return function(p)
	return function(object)
		if p == 0 then
			return
		end

		GetGameNameAndDescription(v, p):andThen(function(p2)
			object:dispatch(SetPlaceInfo(p2.Name, p2.Description))
		end):catch(function()
			warn("Unable to fetch place info for TrustAndSafety.")
		end)
	end
end
