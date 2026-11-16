local loadAsset = require(script.Parent.loadAsset)

local cframe = CFrame.Angles(0, 3.141592653589793, 0)

local function pinToParent(p, parent) -- 1 equivalent call inferred from this helper
	p.WorldPivot = parent:GetPivot()
end

local function findBackgroundFolder(instance)
	local avatarBackground = instance:FindFirstChild("AvatarBackground")

	if avatarBackground ~= nil then
		return avatarBackground
	end

	if instance:FindFirstChild("ImageId") ~= nil and instance:FindFirstChild("Color") ~= nil then
		return instance
	end

	for _, child in instance:GetChildren() do
		if child:FindFirstChild("ImageId") ~= nil and child:FindFirstChild("Color") ~= nil then
			return child
		end
	end

	return nil
end

local function readBackgroundData(result)
	local backgroundFolder = findBackgroundFolder(result)

	if backgroundFolder == nil then
		return nil
	end

	local imageId = backgroundFolder:FindFirstChild("ImageId")
	local color = backgroundFolder:FindFirstChild("Color")

	if imageId == nil or not imageId:IsA("IntValue") or (color == nil or not color:IsA("Color3Value")) then
		return nil
	end

	return { imageId = imageId.Value, backgroundColor = color.Value }
end

local function hasMeshes(instance): boolean -- 3 equivalent calls inferred from this helper
	return instance:FindFirstChild("texture_mesh") ~= nil and instance:FindFirstChild("color_mesh") ~= nil
end

local function extractCycloramaModel(model)
	local avatarCyclorama = model:FindFirstChild("AvatarCyclorama")

	if avatarCyclorama ~= nil and avatarCyclorama:IsA("Model") and hasMeshes(avatarCyclorama) then -- inferred equivalent call
		return avatarCyclorama
	end

	local model2 = model:FindFirstChildWhichIsA("Model")

	if model2 ~= nil and hasMeshes(model2) then -- inferred equivalent call
		return model2
	end

	if model:IsA("Model") and hasMeshes(model) then -- inferred equivalent call
		return model
	end

	return nil
end

local function loadCyclorama()
	local success, result = pcall(loadAsset.loadAsset, 94967210842404)

	if not success then
		warn(`avatarBackground: cyclorama {94967210842404} failed to load: {result}`)
		return nil
	end

	if result == nil or typeof(result) ~= "Instance" then
		warn(`avatarBackground: cyclorama {94967210842404} loaded a {typeof(result)}, expected an Instance`)
		return nil
	end

	local avatarCyclorama = extractCycloramaModel(result)

	if avatarCyclorama == nil then
		warn(`avatarBackground: cyclorama {94967210842404} has no Model holding both texture_mesh and color_mesh`)
		result:Destroy()
		return nil
	end

	if avatarCyclorama ~= result then
		avatarCyclorama.Parent = nil
		result:Destroy()
	end

	avatarCyclorama.Name = "AvatarCyclorama"
	return avatarCyclorama
end

local function loadBackgroundData(p: number)
	local success, result = pcall(loadAsset.loadAsset, p)

	if not success then
		warn(`avatarBackground: background {p} failed to load: {result}`)
		return nil
	end

	if result == nil or typeof(result) ~= "Instance" then
		warn(`avatarBackground: background {p} loaded a {typeof(result)}, expected an Instance`)
		return nil
	end

	local v = readBackgroundData(result)

	if v == nil then
		warn(`avatarBackground: background {p} has no folder with an ImageId IntValue and a Color Color3Value`)
	end

	result:Destroy()
	return v
end

local function applyTexture(part, imageId: number)
	local formatted = `rbxassetid://{imageId}`

	if part:IsA("MeshPart") then
		part.TextureID = formatted
	end

	local success, result = pcall(function()
		part.TextureContent = Content.fromUri(formatted)
	end)

	if not success then
		warn(`avatarBackground: TextureContent assignment failed for {imageId}: {result}`)
	end
end

local function applyBackground(instance, p)
	local texture_mesh = instance:FindFirstChild("texture_mesh")
	local color_mesh = instance:FindFirstChild("color_mesh")

	if texture_mesh ~= nil and texture_mesh:IsA("BasePart") then
		texture_mesh.Anchored = true
		texture_mesh.Transparency = 0.015
		applyTexture(texture_mesh, p.imageId)
	end

	if color_mesh ~= nil and color_mesh:IsA("BasePart") then
		color_mesh.Anchored = true
		color_mesh.Transparency = 0
		color_mesh.Color = p.backgroundColor
	end
end

local function resolveAssetId(value) -- 1 equivalent call inferred from this helper
	if value == false or value == "none" then
		return nil
	end

	if type(value) ~= "number" then
		return 121199209890990
	end

	return if not (value <= 0) then value else nil
end

return {
	attach = function(parent, p)
		p = resolveAssetId(p) -- inferred equivalent call

		if p == nil then
			return nil
		end

		local v = loadCyclorama()

		if v == nil then
			return nil
		end

		local v2 = loadBackgroundData(p)

		if v2 == nil then
			v:Destroy()
			return nil
		end

		applyBackground(v, v2)

		v:PivotTo(CFrame.new() * cframe)
		v.Parent = parent
		pinToParent(v, parent) -- inferred equivalent call
		return v
	end,
	pinToParent = pinToParent,
	REST = cframe,
	applyBackground = applyBackground,
	resolveAssetId = resolveAssetId,
	CYCLORAMA_ASSET_ID = 94967210842404,
	DEFAULT_ASSET_ID = 121199209890990,
	FRONT_VISIBLE_TRANSPARENCY = 0.015
}
