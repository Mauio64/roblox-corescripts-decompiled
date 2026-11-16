local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local selectActiveBackgroundPreview = AvatarExperienceCommon.Backgrounds.selectActiveBackgroundPreview
local selectTryOnBackgroundId = AvatarExperienceCommon.Backgrounds.selectTryOnBackgroundId

local v5 = {}

local function getTopY(instance)
	local v6 = instance.Size / 2
	local cframe = instance.CFrame
	return instance.Position.Y + math.abs(cframe.XVector.Y) * v6.X + math.abs(cframe.YVector.Y) * v6.Y + math.abs(cframe.ZVector.Y) * v6.Z
end

function v5.alignSceneToRug(folder): boolean
	if folder:GetAttribute("AXClassicAvatarSceneAligned") then
		return true
	end

	local count = 0
	local total = 0
	local total2 = 0
	local maxValue = -1e999

	for i, part in folder:GetDescendants() do
		if not (part:IsA("BasePart") and part.Name == "Rug-Round") then
			continue
		end

		count += 1
		total += part.Position.X
		total2 += part.Position.Z
		local v6 = part.Size / 2
		local cframe = part.CFrame
		maxValue = math.max(
			maxValue,
			part.Position.Y + math.abs(cframe.XVector.Y) * v6.X + math.abs(cframe.YVector.Y) * v6.Y + math.abs(cframe.ZVector.Y) * v6.Z
		)
	end

	if count == 0 then
		return false
	end

	local vector3 = Vector3.new(-(total / count), -maxValue, -(total2 / count))
	folder:PivotTo(CFrame.Angles(0, -2.2689280275926285, 0) * CFrame.new(vector3) * folder:GetPivot())
	folder:SetAttribute("AXClassicAvatarSceneAligned", true)
	return true
end

function v5.resolve(p2)
	local avatarEditorScene = (p2 or ReplicatedStorage):FindFirstChild("AvatarEditorScene")

	if not avatarEditorScene then
		return nil
	end

	local avatarSceneClassic = avatarEditorScene:FindFirstChild("AvatarSceneClassic")
		or avatarEditorScene:FindFirstChild("Model")
		or Workspace:FindFirstChild("AvatarSceneNew")

	if not (avatarSceneClassic and avatarSceneClassic:IsA("Model") and v5.alignSceneToRug(avatarSceneClassic)) then
		return nil
	end

	avatarSceneClassic.Name = avatarSceneClassic.Parent == Workspace and "AvatarSceneNew"
		or "AvatarSceneClassic"
	return { scene = avatarSceneClassic, storageParent = avatarEditorScene }
end

function v5.hasBackground(p2): boolean
	return selectTryOnBackgroundId(p2) ~= nil
		or selectActiveBackground(p2) ~= nil
		or selectActiveBackgroundPreview(p2) ~= nil
end

function v5.sync(p2, p3, parent, p4, p5, p6, p7)
	local v6 = p5 and p6 and not (p7 or v5.hasBackground(p4))

	if v6 then
		if p3 then
			p3.Parent = parent
		end

		p2.scene.Name = "AvatarSceneNew"
		p2.scene.Parent = Workspace
	else
		p2.scene.Parent = p2.storageParent
		p2.scene.Name = "AvatarSceneClassic"

		if p3 then
			p3.Parent = Workspace
		end
	end

	return v6
end

function v5.hide(p2)
	p2.scene.Parent = p2.storageParent
	p2.scene.Name = "AvatarSceneClassic"
end

return v5
