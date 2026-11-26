local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")
local myUserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myUserBlockingNetworking")
local AssetInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

return Rodux.createReducer({}, {
	[myUserBlockingNetworking.GetItemAndBundleDetails.Succeeded.name] = function(p2, p3)
		local v6 = {}

		for k, v7 in p3.responseBody.data do
			if v7.itemType ~= Enums.ItemTypes.Bundle then
				continue
			end

			local v8 = AssetInfo.fromAsset(v7)
			v6[v8.id] = v8
		end

		return Cryo.Dictionary.union(p2, v6)
	end
})
