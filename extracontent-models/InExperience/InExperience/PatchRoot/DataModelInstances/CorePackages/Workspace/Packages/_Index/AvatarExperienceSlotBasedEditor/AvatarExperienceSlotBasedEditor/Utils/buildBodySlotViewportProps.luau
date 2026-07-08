local BodyAssetTypes = require(script.Parent.Parent.Constants).BodyAssetTypes

local function buildBodySlotViewportProps(color3: Color3, t1: {[any]: any}) -- line: 18
	-- upvalues: BodyAssetTypes (copy)
	local t2 = {}
	local v6 = color3:ToHex()

	for _, v8 in BodyAssetTypes do
		local str = tostring(v8.Value)
		local v10 = t1[str]

		if v10 then
			for v11, _ in v10 do
				t2[v11] = {
					quantityOwned = 1,
					id = v11,
					assetType = tonumber(str)
				}
			end
		end
	end

	return {
		lookDetails = {
			lookAssetInfos = t2,
			lookBundleInfos = {},
			avatarProperties = {
				playerAvatarType = "R15",
				bodyColor3s = {
					headColor3 = v6,
					leftArmColor3 = v6,
					leftLegColor3 = v6,
					rightArmColor3 = v6,
					rightLegColor3 = v6,
					torsoColor3 = v6
				}
			}
		}
	}
end

return buildBodySlotViewportProps
