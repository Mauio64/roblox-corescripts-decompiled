local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GetGameNameAndDescription = require(CorePackages.Workspace.Packages.GameDetailRodux).GetGameNameAndDescription
local v6 = require(RobloxGui.Modules.Common.httpRequest)(HttpRbxApiService)
local ParentParent = script.Parent.Parent
local SetPlaceInfo = require(ParentParent.Actions.SetPlaceInfo)

return function(p1) -- line: 16
	-- upvalues: GetGameNameAndDescription (copy), v6 (copy), SetPlaceInfo (copy)
	return function(p2) -- line: 17
		-- upvalues: p1 (copy), GetGameNameAndDescription (copy), v6 (copy), SetPlaceInfo (copy)
		if p1 == 0 then
			return
		end

		GetGameNameAndDescription(v6, p1):andThen(function(p3) -- line: 21
			-- upvalues: p2 (copy), SetPlaceInfo (copy)
			p2:dispatch(SetPlaceInfo(p3.Name, p3.Description))
		end):catch(function() -- line: 23
			warn("Unable to fetch place info for TrustAndSafety.")
		end)
	end
end
