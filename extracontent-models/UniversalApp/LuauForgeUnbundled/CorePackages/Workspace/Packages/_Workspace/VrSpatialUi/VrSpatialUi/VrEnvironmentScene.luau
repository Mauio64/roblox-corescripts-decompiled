local getSceneOverridesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/Style").getSceneOverridesStore

local v5 = nil

local function applyColorToBaseParts(folder, largerShapes)
	for i, part in folder:GetDescendants() do
		if part:IsA("BasePart") then
			part.Color = largerShapes
		end
	end
end

local function applySceneOverrides(p2)
	if not p2 then
		return
	end

	local vrEnvironment = workspace:FindFirstChild("VR Environment")

	if not vrEnvironment then
		return
	end

	local core_Platform = vrEnvironment:FindFirstChild("Core_Platform")

	if core_Platform then
		applyColorToBaseParts(core_Platform, p2.LargerShapes)
	end

	local midGround_CubeFloor = vrEnvironment:FindFirstChild("MidGround_CubeFloor")

	if midGround_CubeFloor then
		applyColorToBaseParts(midGround_CubeFloor, p2.LargerShapes)
	end
end

return {
	initialize = function()
		if v5 then
			v5()
			v5 = nil
		end

		local sceneOverridesStore = getSceneOverridesStore()
		applySceneOverrides(sceneOverridesStore.getSceneOverrides())
		v5 = sceneOverridesStore.subscribe(function(p2)
			applySceneOverrides(p2)
		end)
	end,
	deinitialize = function()
		if v5 then
			v5()
			v5 = nil
		end
	end,
	getVrEnvironment = function()
		return workspace:FindFirstChild("VR Environment")
	end
}
