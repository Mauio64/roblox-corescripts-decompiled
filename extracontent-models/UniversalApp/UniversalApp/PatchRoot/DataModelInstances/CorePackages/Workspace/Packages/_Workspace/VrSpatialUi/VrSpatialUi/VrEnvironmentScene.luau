local Parent = script:FindFirstAncestor("VrSpatialUi").Parent
local getSceneOverridesStore = require(Parent.Style).getSceneOverridesStore
local u3 = nil

local function applyColorToBaseParts(p1, color3: Color3) -- line: 28
	for _, descendant in p1:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Color = color3
		end
	end
end
local function applySceneOverrides(t1: {[any]: any}?) -- line: 36
	-- upvalues: applyColorToBaseParts (copy)
	if not t1 then
		return
	end

	local v11 = workspace:FindFirstChild("VR Environment")

	if not v11 then
		return
	end

	local Core_Platform = v11:FindFirstChild("Core_Platform")

	if Core_Platform then
		applyColorToBaseParts(Core_Platform, t1.LargerShapes)
	end

	local MidGround_CubeFloor = v11:FindFirstChild("MidGround_CubeFloor")

	if MidGround_CubeFloor then
		applyColorToBaseParts(MidGround_CubeFloor, t1.LargerShapes)
	end
end

return {
	initialize = function() -- line: 64
		-- upvalues: u3 (ref), getSceneOverridesStore (copy), applySceneOverrides (copy)
		if u3 then
			u3()
			u3 = nil
		end

		local v14 = getSceneOverridesStore()

		applySceneOverrides(v14.getSceneOverrides())
		u3 = v14.subscribe(function(p2) -- line: 69
			-- upvalues: applySceneOverrides (copy)
			applySceneOverrides(p2)
		end)
	end,
	deinitialize = function() -- line: 57
		-- upvalues: u3 (ref)
		if u3 then
			u3()
			u3 = nil
		end
	end,
	getVrEnvironment = function() -- line: 24
		return workspace:FindFirstChild("VR Environment")
	end
}
