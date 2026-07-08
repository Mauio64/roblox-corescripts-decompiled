local AssetService = game:GetService("AssetService")
local AvatarCreationService = game:GetService("AvatarCreationService")
local ExperienceAuthService = game:GetService("ExperienceAuthService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local scriptParent = script.Parent
local OpenPublishAssetPrompt = require(scriptParent.Thunks.OpenPublishAssetPrompt)
local OpenPublishAvatarPrompt = require(scriptParent.Thunks.OpenPublishAvatarPrompt)
local OpenPublishAvatarAssetPrompt = require(scriptParent.Thunks.OpenPublishAvatarAssetPrompt)
local OpenResultModal = require(scriptParent.Thunks.OpenResultModal)
local SetHumanoidModel = require(scriptParent.Actions.SetHumanoidModel)
local SetAccessoryInstance = require(scriptParent.Actions.SetAccessoryInstance)
local SetPriceInRobux = require(scriptParent.Actions.SetPriceInRobux)
local OpenValidationErrorModal = require(scriptParent.Actions.OpenValidationErrorModal)
local EngineFeature = game:GetEngineFeature("PromptImportAnimationClipFromVideoAsyncEnabled")

local function updateModelAttachmentsWithWrapDeformers(p1) -- line: 26
	-- upvalues: RobloxReplicatedStorage (copy)
	p1.Parent = RobloxReplicatedStorage

	for _, child in p1:GetChildren() do
		if child:IsA("MeshPart") then
			local WrapDeformer = child:FindFirstChildWhichIsA("WrapDeformer")

			if WrapDeformer then
				for _, child2 in child:GetChildren() do
					if child2:IsA("Attachment") then
						child2.CFrame = WrapDeformer:GetDeformedCFrameAsync(child2.CFrame)
					end
				end
			end
		end
	end
end
local function ConnectAssetServiceEvents(p2) -- line: 50
	-- upvalues: ExperienceAuthService (copy), EngineFeature (copy), OpenPublishAssetPrompt (copy), AssetService (copy), OpenPublishAvatarPrompt (copy), OpenPublishAvatarAssetPrompt (copy), OpenResultModal (copy), AvatarCreationService (copy), SetAccessoryInstance (copy), SetPriceInRobux (copy), updateModelAttachmentsWithWrapDeformers (copy), SetHumanoidModel (copy), OpenValidationErrorModal (copy)
	local t1 = {}

	table.insert(t1, ExperienceAuthService.OpenAuthPrompt:Connect(function(p3, p4, p5) -- line: 56
		-- upvalues: EngineFeature (copy), p2 (copy), OpenPublishAssetPrompt (copy), AssetService (copy), OpenPublishAvatarPrompt (copy), OpenPublishAvatarAssetPrompt (copy)
		local v29 = EngineFeature and p5.isVideoToAnimationFlow

		if #p4 == 1 and (p4[1] == Enum.ExperienceAuthScope.CreatorAssetsCreate and not v29) then
			if p5.instanceToPublish then
				p2:dispatch(OpenPublishAssetPrompt(p5.instanceToPublish, p5.assetType, p3, p4))

				return
			end

			if p5.serializedInstance then
				local v30 = AssetService:DeserializeInstance(p5.serializedInstance)

				p2:dispatch(OpenPublishAssetPrompt(v30, p5.assetType, p3, p4))

				return
			end

			if p5.outfitToPublish then
				p2:dispatch(OpenPublishAvatarPrompt(p3, p4))

				return
			end

			if p5.accessoryToPublish then
				local accessoryType = p5.accessoryType

				p2:dispatch(OpenPublishAvatarAssetPrompt(accessoryType, p3, p4))
			end
		end
	end))
	table.insert(t1, AssetService.OpenPublishResultModal:Connect(function(p6) -- line: 86
		-- upvalues: p2 (copy), OpenResultModal (copy)
		p2:dispatch(OpenResultModal(p6))
	end))

	local function checkNewEventsExist() -- line: 90
		-- upvalues: AvatarCreationService (copy)
		return AvatarCreationService.UgcValidationSuccess and AvatarCreationService.UgcValidationFailure
	end

	if pcall(checkNewEventsExist) then
		table.insert(t1, AvatarCreationService.UgcValidationSuccess:Connect(function(p7, p8, p9) -- line: 98
			-- upvalues: p2 (copy), AvatarCreationService (copy), SetAccessoryInstance (copy), SetPriceInRobux (copy), updateModelAttachmentsWithWrapDeformers (copy), SetHumanoidModel (copy)
			local v36 = p2:getState()

			if v36 and v36.promptRequest.promptInfo.promptType == "PublishAvatarAsset" then
				local v37 = AvatarCreationService:DeserializeAvatarModel(p8)

				p2:dispatch(SetAccessoryInstance(v37))

				if p9 then
					p2:dispatch(SetPriceInRobux(p9))
				end

				return
			end

			if v36 and p7 == v36.promptRequest.promptInfo.guid then
				local v38 = AvatarCreationService:DeserializeAvatarModel(p8)

				updateModelAttachmentsWithWrapDeformers(v38)
				p2:dispatch(SetHumanoidModel(v38))
				p2:dispatch(SetPriceInRobux(p9))
			end
		end))
	end

	if pcall(checkNewEventsExist) then
		table.insert(t1, AvatarCreationService.UgcValidationFailure:Connect(function(p10, p11) -- line: 128
			-- upvalues: p2 (copy), OpenValidationErrorModal (copy)
			local v41 = p2:getState()

			if v41 and p10 == v41.promptRequest.promptInfo.guid then
				p2:dispatch(OpenValidationErrorModal(p11))
			end
		end))
	end

	return t1
end

return ConnectAssetServiceEvents
