local parent = script.Parent.Parent

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local selectSnapshotSources = require(script.Parent.selectSnapshotSources)

local CaptureService = require(parent.Services.CaptureService)

local function snapToVoxelGrid(position: Vector3) -- 1 equivalent call inferred from this helper
	return (Vector3.new(math.floor(position.X / 4) * 4, math.floor(position.Y / 4) * 4, math.floor(position.Z / 4) * 4))
end

local function getAppliedDescription(instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if humanoid == nil then
		return nil
	end

	local success, result = pcall(function()
		return humanoid:GetAppliedDescription()
	end)
	return if success then result else nil
end

local function freeze(instance)
	if instance:IsA("Sound") or instance:IsA("AudioPlayer") or instance:IsA("Explosion") then
		instance:Destroy()
	elseif instance:IsA("BasePart") then
		instance.Anchored = true
	elseif instance:IsA("VideoFrame") then
		instance.Playing = false
	end
end

return {
	captureSnapshotTree = function(options)
		local v = options or {}
		local camera = v.camera or Workspace.CurrentCamera

		if camera == nil then
			return nil
		end

		local localPlayer = Players.LocalPlayer
		local localCharacter = v.localCharacter

		if not localCharacter then
			if localPlayer == nil then
				localCharacter = nil
			else
				localCharacter = localPlayer.Character
			end
		end

		local maxDepth = v.maxDepth or 800
		local fovMargin = v.fovMargin or 25
		local cframe = camera.CFrame
		local fieldOfView = camera.FieldOfView
		local aspect = camera.ViewportSize.X / math.max(camera.ViewportSize.Y, 1)

		local v2 = selectSnapshotSources({
			root = v.sceneRoot or Workspace,
			cameraCFrame = cframe,
			fieldOfView = fieldOfView,
			aspect = aspect,
			maxDepth = maxDepth,
			fovMargin = fovMargin,
			nearRadius = 30,
			localCharacter = localCharacter
		})

		if #v2.looseParts == 0 and #v2.characters == 0 then
			return nil
		end

		local snapshotHeader = Instance.new("Configuration")
		snapshotHeader.Name = "SnapshotHeader"
		snapshotHeader:SetAttribute("PresentationOrigin", snapToVoxelGrid(cframe.Position)) -- inferred equivalent call
		snapshotHeader:SetAttribute("SelectionCameraCFrame", cframe)
		snapshotHeader:SetAttribute("SelectionFovDeg", fieldOfView)
		snapshotHeader:SetAttribute("SelectionAspect", aspect)
		snapshotHeader:SetAttribute("SelectionFovMarginDeg", fovMargin)
		snapshotHeader:SetAttribute("SelectionMaxDepth", maxDepth)
		snapshotHeader:SetAttribute("SelectionNearRadius", 30)

		local clone = table.clone(v2.looseParts)
		local v3 = #clone + 1

		for _, character in v2.characters do
			table.insert(clone, character)
		end

		table.insert(clone, snapshotHeader)

		local success, result = pcall(function()
			return CaptureService:CloneForSnapshot(clone, true)
		end)

		snapshotHeader:Destroy()

		if not success then
			warn("CloneForSnapshot failed with error:", result)
			return nil
		end

		local roots = result:GetRoots()

		for _, folder in roots do
			for _, descendant in folder:GetDescendants() do
				freeze(descendant)
			end

			freeze(folder)
		end

		for k, character in v2.characters do
			local root = roots[v3 + k - 1]

			if not (root ~= nil and root.ClassName == character.ClassName and root.Name == character.Name) then
				continue
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local result2

			if humanoid ~= nil then
				local success2
				success2, result2 = pcall(function()
					return humanoid:GetAppliedDescription()
				end)

				if not success2 then
					result2 = nil
				end
			end

			if result2 == nil then
				continue
			end

			result2.Name = "Scene3DInspectDescription"
			result2.Parent = root
		end

		return result
	end,
	HEADER_NAME = "SnapshotHeader",
	AVATAR_DESCRIPTION_NAME = "Scene3DInspectDescription"
}
