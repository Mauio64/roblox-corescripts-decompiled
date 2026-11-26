local bodyAssetTypes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Constants").BodyAssetTypes

local function buildBodySlotViewportProps(p2, p3)
	local hex = p2:ToHex()
	local v5 = {}

	for k, bodyAssetType in bodyAssetTypes do
		local value = tostring(bodyAssetType.Value)
		local v6 = p3[value]

		if not v6 then
			continue
		end

		for k2, v7 in v6 do
			v5[k2] = { id = k2, assetType = tonumber(value), quantityOwned = 1 }
		end
	end

	return {
		lookDetails = {
			lookAssetInfos = v5,
			lookBundleInfos = {},
			avatarProperties = {
				bodyColor3s = {
					headColor3 = hex,
					leftArmColor3 = hex,
					leftLegColor3 = hex,
					rightArmColor3 = hex,
					rightLegColor3 = hex,
					torsoColor3 = hex
				},
				playerAvatarType = "R15"
			}
		}
	}
end

return buildBodySlotViewportProps
