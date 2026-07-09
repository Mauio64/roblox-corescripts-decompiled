local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local SetAvatarSettings = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarSettings)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local t1 = {
	ObtainedAvatarRules = false,
	[Constants.AvatarSettings.minDeltaBodyColorDifference] = 0,
	[Constants.AvatarSettings.scalesRules] = {
		height = {
			min = 0.9,
			max = 1.05,
			increment = 0.01
		},
		width = {
			min = 0.7,
			max = 1,
			increment = 0.01
		},
		head = {
			min = 0.95,
			max = 1,
			increment = 0.01
		},
		proportion = {
			min = 0,
			max = 1,
			increment = 0.01
		},
		bodyType = {
			min = 0,
			max = 1,
			increment = 0.01
		}
	},
	[Constants.AvatarSettings.accessoryRefinementTypes] = {
		[1] = Enum.AssetType.Hat.Value,
		[2] = Enum.AssetType.FaceAccessory.Value
	},
	[Constants.AvatarSettings.accessoryRefinementLowerBounds] = {
		hat = {
			position = {
				xPosition = -0.25,
				yPosition = -0.25,
				zPosition = -0.25
			},
			rotation = {
				xRotation = -30,
				yRotation = -30,
				zRotation = -30
			},
			scale = {
				xScale = 0.8,
				yScale = 0.8,
				zScale = 0.8
			}
		},
		faceAccessory = {
			position = {
				xPosition = -0.25,
				yPosition = -0.25,
				zPosition = -0.25
			},
			rotation = {
				xRotation = -30,
				yRotation = -30,
				zRotation = -30
			},
			scale = {
				xScale = 0.8,
				yScale = 0.8,
				zScale = 0.8
			}
		}
	},
	[Constants.AvatarSettings.accessoryRefinementUpperBounds] = {
		hat = {
			position = {
				xPosition = 0.25,
				yPosition = 0.25,
				zPosition = 0.25
			},
			rotation = {
				xRotation = 30,
				yRotation = 30,
				zRotation = 30
			},
			scale = {
				xScale = 1.2,
				yScale = 1.2,
				zScale = 1.2
			}
		},
		faceAccessory = {
			position = {
				xPosition = 0.25,
				yPosition = 0.25,
				zPosition = 0.25
			},
			rotation = {
				xRotation = 30,
				yRotation = 30,
				zRotation = 30
			},
			scale = {
				xScale = 1.2,
				yScale = 1.2,
				zScale = 1.2
			}
		}
	}
}

return Rodux.createReducer(t1, {
	[SetAvatarSettings.name] = function(_: {[any]: any}, p1) -- line: 173
		-- upvalues: Constants (copy)
		return {
			ObtainedAvatarRules = true,
			[Constants.AvatarSettings.scalesRules] = p1.scalesRules,
			[Constants.AvatarSettings.minDeltaBodyColorDifference] = p1.minimumDeltaEBodyColorDifference,
			[Constants.AvatarSettings.accessoryRefinementTypes] = p1.accessoryRefinementTypes,
			[Constants.AvatarSettings.accessoryRefinementLowerBounds] = p1.accessoryRefinementLowerBounds,
			[Constants.AvatarSettings.accessoryRefinementUpperBounds] = p1.accessoryRefinementUpperBounds
		}
	end
})
