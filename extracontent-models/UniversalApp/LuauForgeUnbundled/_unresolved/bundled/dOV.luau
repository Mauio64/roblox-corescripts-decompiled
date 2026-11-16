local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dOW")
local module2 = require("@luauforge/bundled/dNQ")

local v5 = {
	ObtainedAvatarRules = false,
	[module2.AvatarSettings.minDeltaBodyColorDifference] = 0,
	[module2.AvatarSettings.scalesRules] = {
		height = { min = 0.9, max = 1.05, increment = 0.01 },
		width = { min = 0.7, max = 1, increment = 0.01 },
		head = { min = 0.95, max = 1, increment = 0.01 },
		proportion = { min = 0, max = 1, increment = 0.01 },
		bodyType = { min = 0, max = 1, increment = 0.01 }
	},
	[module2.AvatarSettings.accessoryRefinementTypes] = {
		Enum.AssetType.Hat.Value,
		Enum.AssetType.FaceAccessory.Value
	}
}

v5[module2.AvatarSettings.accessoryRefinementLowerBounds] = {
	hat = {
		position = { xPosition = -0.25, yPosition = -0.25, zPosition = -0.25 },
		rotation = { xRotation = -30, yRotation = -30, zRotation = -30 },
		scale = { xScale = 0.8, yScale = 0.8, zScale = 0.8 }
	},
	faceAccessory = {
		position = { xPosition = -0.25, yPosition = -0.25, zPosition = -0.25 },
		rotation = { xRotation = -30, yRotation = -30, zRotation = -30 },
		scale = { xScale = 0.8, yScale = 0.8, zScale = 0.8 }
	}
}

v5[module2.AvatarSettings.accessoryRefinementUpperBounds] = {
	hat = {
		position = { xPosition = 0.25, yPosition = 0.25, zPosition = 0.25 },
		rotation = { xRotation = 30, yRotation = 30, zRotation = 30 },
		scale = { xScale = 1.2, yScale = 1.2, zScale = 1.2 }
	},
	faceAccessory = {
		position = { xPosition = 0.25, yPosition = 0.25, zPosition = 0.25 },
		rotation = { xRotation = 30, yRotation = 30, zRotation = 30 },
		scale = { xScale = 1.2, yScale = 1.2, zScale = 1.2 }
	}
}

return Rodux.createReducer(v5, {
	[module.name] = function(p2, data)
		return {
			ObtainedAvatarRules = true,
			[module2.AvatarSettings.scalesRules] = data.scalesRules,
			[module2.AvatarSettings.minDeltaBodyColorDifference] = data.minimumDeltaEBodyColorDifference,
			[module2.AvatarSettings.accessoryRefinementTypes] = data.accessoryRefinementTypes,
			[module2.AvatarSettings.accessoryRefinementLowerBounds] = data.accessoryRefinementLowerBounds,
			[module2.AvatarSettings.accessoryRefinementUpperBounds] = data.accessoryRefinementUpperBounds
		}
	end
})
