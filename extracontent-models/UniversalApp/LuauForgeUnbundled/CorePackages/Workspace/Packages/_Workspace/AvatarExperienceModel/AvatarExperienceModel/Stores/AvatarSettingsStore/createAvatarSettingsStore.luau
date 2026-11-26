local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/SignalsExperimental")

local function createDefaultScalesRules()
	return {
		height = { min = 0.9, max = 1.05, increment = 0.01 },
		width = { min = 0.7, max = 1, increment = 0.01 },
		head = { min = 0.95, max = 1, increment = 0.01 },
		proportion = { min = 0, max = 1, increment = 0.01 },
		bodyType = { min = 0, max = 1, increment = 0.01 }
	}
end

local function createDefaultAccessoryRefinementTypes()
	return { Enum.AssetType.Hat.Value, Enum.AssetType.FaceAccessory.Value }
end

local function createDefaultAdjustmentLimitRule(p2, p3, p4)
	return {
		position = { xPosition = p2, yPosition = p2, zPosition = p2 },
		rotation = { xRotation = p3, yRotation = p3, zRotation = p3 },
		scale = { xScale = p4, yScale = p4, zScale = p4 }
	}
end

local function createDefaultAccessoryRefinementLowerBounds()
	return {
		hat = createDefaultAdjustmentLimitRule(-0.25, -30, 0.8),
		faceAccessory = createDefaultAdjustmentLimitRule(-0.25, -30, 0.8)
	}
end

local function createDefaultAccessoryRefinementUpperBounds()
	return {
		hat = createDefaultAdjustmentLimitRule(0.25, 30, 1.2),
		faceAccessory = createDefaultAdjustmentLimitRule(0.25, 30, 1.2)
	}
end

local function createAvatarSettingsStore()
	local signal, v5 = Signals.createSignal(false)
	local signal2, v6 = Signals.createSignal(0)
	local signal3, v7 = Signals.createSignal(createDefaultScalesRules())
	local signal4, v8 = Signals.createSignal({ Enum.AssetType.Hat.Value, Enum.AssetType.FaceAccessory.Value })
	local signal5, v9 = Signals.createSignal({
		hat = createDefaultAdjustmentLimitRule(-0.25, -30, 0.8),
		faceAccessory = createDefaultAdjustmentLimitRule(-0.25, -30, 0.8)
	})
	local signal6, v10 = Signals.createSignal({
		hat = createDefaultAdjustmentLimitRule(0.25, 30, 1.2),
		faceAccessory = createDefaultAdjustmentLimitRule(0.25, 30, 1.2)
	})

	local function setAvatarSettings(p2, p3, p4, p5, p6)
		SignalsExperimental.batch(function()
			v5(true)
			v6(p2)
			v7(p3)
			v8(p4)
			v9(p5)
			v10(p6)
		end)
	end

	local function reset()
		SignalsExperimental.batch(function()
			v5(false)
			v6(0)
			v7(createDefaultScalesRules())
			v8({ Enum.AssetType.Hat.Value, Enum.AssetType.FaceAccessory.Value })
			v9({
				hat = createDefaultAdjustmentLimitRule(-0.25, -30, 0.8),
				faceAccessory = createDefaultAdjustmentLimitRule(-0.25, -30, 0.8)
			})
			v10({
				hat = createDefaultAdjustmentLimitRule(0.25, 30, 1.2),
				faceAccessory = createDefaultAdjustmentLimitRule(0.25, 30, 1.2)
			})
		end)
	end

	return {
		getObtainedAvatarRules = signal,
		getMinDeltaBodyColorDifference = signal2,
		getScalesRules = signal3,
		getAccessoryRefinementTypes = signal4,
		getAccessoryRefinementLowerBounds = signal5,
		getAccessoryRefinementUpperBounds = signal6,
		setAvatarSettings = setAvatarSettings,
		reset = reset
	}
end

return createAvatarSettingsStore
