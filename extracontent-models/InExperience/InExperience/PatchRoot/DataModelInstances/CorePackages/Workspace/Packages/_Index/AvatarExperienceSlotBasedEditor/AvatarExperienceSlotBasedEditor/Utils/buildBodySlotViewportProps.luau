local Constants = require(script.Parent.Parent.Constants)
local BodyAssetTypes = Constants.BodyAssetTypes

local function buildBodySlotViewportProps(color: Color3, p)
	local hex = color:ToHex()
	local lookAssetInfos = {}

	for _, bodyAssetType in BodyAssetTypes do
		local value = tostring(bodyAssetType.Value)
		local v = p[value]

		if not v then
			continue
		end

		for k, _ in v do
			lookAssetInfos[k] = { id = k, assetType = tonumber(value), quantityOwned = 1 }
		end
	end

	return {
		lookDetails = {
			lookAssetInfos = lookAssetInfos,
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
