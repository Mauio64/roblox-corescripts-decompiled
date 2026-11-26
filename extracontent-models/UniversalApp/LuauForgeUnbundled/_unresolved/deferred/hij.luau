local module = require("@luauforge/bundled/dRg")
local module2 = require("@luauforge/deferred/hii")
local module3 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dKT")

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local v5 = {
	position = { xPosition = 0.25, yPosition = 0.25, zPosition = 0.25 },
	rotation = { xRotation = 15, yRotation = 30, zRotation = 30 },
	scale = { xScale = 1.2, yScale = 1.2, zScale = 1.2 }
}

return function(p2)
	local avatarSetting = p2.AvatarExperience.AvatarEditor.AvatarSettings[module.AvatarSettings.accessoryRefinementUpperBounds]
	local v6 = module2(p2)

	if not v6 then
		return v5
	end

	local v7 = module3.AssetTypeIdStringToName[v6]

	if v7 then
		return avatarSetting[string.lower((string.sub(v7, 1, 1))) .. string.sub(v7, 2)]
	end

	mutedError(`[selectUpperAdjustmentLimits] No accessory type name found for asset type id: {v6}`)
	return v5
end
