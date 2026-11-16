local parent = script:FindFirstAncestor("VrSpatialUi").Parent
local Style = require(parent.Style)
local getSceneOverridesStore = Style.getSceneOverridesStore

local v = nil

local function getVrEnvironment() -- 1 equivalent call inferred from this helper
	return workspace:FindFirstChild("VR Environment")
end

local function applyColorToBaseParts(folder, largerShapes: Color3)
	for _, part in folder:GetDescendants() do
		if part:IsA("BasePart") then
			part.Color = largerShapes
		end
	end
end

local function applySceneOverrides(p)
	if not p then
		return
	end

	local vrEnvironment = getVrEnvironment() -- inferred equivalent call

	if not vrEnvironment then
		return
	end

	local core_Platform = vrEnvironment:FindFirstChild("Core_Platform")

	if core_Platform then
		applyColorToBaseParts(core_Platform, p.LargerShapes)
	end

	local midGround_CubeFloor = vrEnvironment:FindFirstChild("MidGround_CubeFloor")

	if midGround_CubeFloor then
		applyColorToBaseParts(midGround_CubeFloor, p.LargerShapes)
	end
end

local function deinitialize() -- 1 equivalent call inferred from this helper
	if v then
		v()
		v = nil
	end
end

return {
	initialize = function()
		deinitialize() -- inferred equivalent call
		local sceneOverridesStore = getSceneOverridesStore()
		applySceneOverrides(sceneOverridesStore.getSceneOverrides())
		v = sceneOverridesStore.subscribe(function(p)
			applySceneOverrides(p)
		end)
	end,
	deinitialize = deinitialize,
	getVrEnvironment = getVrEnvironment
}
