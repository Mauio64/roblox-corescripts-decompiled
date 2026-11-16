local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local NetworkingCurrentlyWearing = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/NetworkingCurrentlyWearing")
local AssetInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")

return Rodux.createReducer({}, {
	[NetworkingCurrentlyWearing.GetItemDetails.Succeeded.name] = function(p2, p3)
		local v6 = {}

		for k, v7 in p3.responseBody.data do
			local v8 = AssetInfo.fromAsset(v7)
			v6[v8.id] = v8
		end

		return Cryo.Dictionary.join(p2, v6)
	end
})
