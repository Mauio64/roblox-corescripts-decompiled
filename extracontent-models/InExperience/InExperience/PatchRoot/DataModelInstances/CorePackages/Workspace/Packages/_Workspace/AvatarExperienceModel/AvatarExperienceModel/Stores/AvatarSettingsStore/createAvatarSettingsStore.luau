local parent = script:FindFirstAncestor("AvatarExperienceModel").Parent

local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)

local function createDefaultScalesRules()
	return {
		height = { min = 0.9, max = 1.05, increment = 0.01 },
		width = { min = 0.7, max = 1, increment = 0.01 },
		head = { min = 0.95, max = 1, increment = 0.01 },
		proportion = { min = 0, max = 1, increment = 0.01 },
		bodyType = { min = 0, max = 1, increment = 0.01 }
	}
end

local function createDefaultAccessoryRefinementTypes() -- 2 equivalent calls inferred from this helper
	return { Enum.AssetType.Hat.Value, Enum.AssetType.FaceAccessory.Value }
end

local function createDefaultAdjustmentLimitRule(p: number, p2: number, p3: number)
	return {
		position = { xPosition = p, yPosition = p, zPosition = p },
		rotation = { xRotation = p2, yRotation = p2, zRotation = p2 },
		scale = { xScale = p3, yScale = p3, zScale = p3 }
	}
end

local function createDefaultAccessoryRefinementLowerBounds() -- 2 equivalent calls inferred from this helper
	return {
		hat = createDefaultAdjustmentLimitRule(-0.25, -30, 0.8),
		faceAccessory = createDefaultAdjustmentLimitRule(-0.25, -30, 0.8)
	}
end

local function createDefaultAccessoryRefinementUpperBounds() -- 2 equivalent calls inferred from this helper
	return {
		hat = createDefaultAdjustmentLimitRule(0.25, 30, 1.2),
		faceAccessory = createDefaultAdjustmentLimitRule(0.25, 30, 1.2)
	}
end

local function createAvatarSettingsStore()
	local signal, v = Signals.createSignal(false)
	local signal2, v2 = Signals.createSignal(0)
	local signal3, v3 = Signals.createSignal(createDefaultScalesRules())

	local signal4, v4 = Signals.createSignal(createDefaultAccessoryRefinementTypes()) -- inferred equivalent call

	local signal5, v5 = Signals.createSignal(createDefaultAccessoryRefinementLowerBounds()) -- inferred equivalent call

	local signal6, v6 = Signals.createSignal(createDefaultAccessoryRefinementUpperBounds()) -- inferred equivalent call

	local function setAvatarSettings(p: number?, p2, p3, p4, p5)
		SignalsExperimental.batch(function()
			v(true)
			v2(p)
			v3(p2)
			v4(p3)
			v5(p4)
			v6(p5)
		end)
	end

	local function reset()
		SignalsExperimental.batch(function()
			v(false)
			v2(0)
			v3(createDefaultScalesRules())
			v4(createDefaultAccessoryRefinementTypes()) -- inferred equivalent call
			v5(createDefaultAccessoryRefinementLowerBounds()) -- inferred equivalent call
			v6(createDefaultAccessoryRefinementUpperBounds()) -- inferred equivalent call
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
