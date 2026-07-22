local AssetService = game:GetService("AssetService")
local AvatarCreationService = game:GetService("AvatarCreationService")
local ExperienceAuthService = game:GetService("ExperienceAuthService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local scriptParent = script.Parent
local OpenPublishAssetPrompt = require(scriptParent.Thunks.OpenPublishAssetPrompt)
local OpenPublishAvatarPrompt = require(scriptParent.Thunks.OpenPublishAvatarPrompt)
local OpenPublishAvatarAssetPrompt = require(scriptParent.Thunks.OpenPublishAvatarAssetPrompt)
local OpenPublishMakeupLookPrompt = require(scriptParent.Thunks.OpenPublishMakeupLookPrompt)
local OpenResultModal = require(scriptParent.Thunks.OpenResultModal)
local SetHumanoidModel = require(scriptParent.Actions.SetHumanoidModel)
local SetAccessoryInstance = require(scriptParent.Actions.SetAccessoryInstance)
local SetPriceInRobux = require(scriptParent.Actions.SetPriceInRobux)
local OpenValidationErrorModal = require(scriptParent.Actions.OpenValidationErrorModal)
local GetFFlagUploadMakeupSupport = require(scriptParent.Flags.GetFFlagUploadMakeupSupport)
local EngineFeature = game:GetEngineFeature("PromptImportAnimationClipFromVideoAsyncEnabled")

local function updateModelAttachmentsWithWrapDeformers(p1) -- line: 28
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
local function ConnectAssetServiceEvents(p2) -- line: 52
	-- upvalues: ExperienceAuthService (copy), EngineFeature (copy), OpenPublishAssetPrompt (copy), AssetService (copy), OpenPublishAvatarPrompt (copy), GetFFlagUploadMakeupSupport (copy), OpenPublishMakeupLookPrompt (copy), OpenPublishAvatarAssetPrompt (copy), OpenResultModal (copy), AvatarCreationService (copy), SetAccessoryInstance (copy), SetPriceInRobux (copy), updateModelAttachmentsWithWrapDeformers (copy), SetHumanoidModel (copy), OpenValidationErrorModal (copy)
	local t1 = {}

	table.insert(t1, ExperienceAuthService.OpenAuthPrompt:Connect(function(p3, p4, p5) -- line: 58
		-- upvalues: EngineFeature (copy), p2 (copy), OpenPublishAssetPrompt (copy), AssetService (copy), OpenPublishAvatarPrompt (copy), GetFFlagUploadMakeupSupport (copy), OpenPublishMakeupLookPrompt (copy), OpenPublishAvatarAssetPrompt (copy)
		local v31 = EngineFeature and p5.isVideoToAnimationFlow

		if #p4 == 1 and (p4[1] == Enum.ExperienceAuthScope.CreatorAssetsCreate and not v31) then
			if p5.instanceToPublish then
				p2:dispatch(OpenPublishAssetPrompt(p5.instanceToPublish, p5.assetType, p3, p4))

				return
			end

			if p5.serializedInstance then
				local v32 = AssetService:DeserializeInstance(p5.serializedInstance)

				p2:dispatch(OpenPublishAssetPrompt(v32, p5.assetType, p3, p4))

				return
			end

			if p5.outfitToPublish then
				p2:dispatch(OpenPublishAvatarPrompt(p3, p4))

				return
			end

			if GetFFlagUploadMakeupSupport() and p5.makeupLookToPublish then
				local makeupEntries = p5.makeupEntries

				p2:dispatch(OpenPublishMakeupLookPrompt(p3, p4, makeupEntries))

				return
			end

			if p5.accessoryToPublish then
				local accessoryType = p5.accessoryType

				p2:dispatch(OpenPublishAvatarAssetPrompt(accessoryType, p3, p4))
			end
		end
	end))
	table.insert(t1, AssetService.OpenPublishResultModal:Connect(function(p6) -- line: 91
		-- upvalues: p2 (copy), OpenResultModal (copy)
		p2:dispatch(OpenResultModal(p6))
	end))

	local function checkNewEventsExist() -- line: 95
		-- upvalues: AvatarCreationService (copy)
		return AvatarCreationService.UgcValidationSuccess and AvatarCreationService.UgcValidationFailure
	end

	if pcall(checkNewEventsExist) then
		table.insert(t1, AvatarCreationService.UgcValidationSuccess:Connect(function(p7, p8, p9) -- line: 103
			-- upvalues: p2 (copy), GetFFlagUploadMakeupSupport (copy), AvatarCreationService (copy), SetAccessoryInstance (copy), SetPriceInRobux (copy), updateModelAttachmentsWithWrapDeformers (copy), SetHumanoidModel (copy)
			local v39 = p2:getState()

			if v39 and (v39.promptRequest.promptInfo.promptType == "PublishAvatarAsset" or GetFFlagUploadMakeupSupport() and v39.promptRequest.promptInfo.promptType == "PublishMakeupLook") then
				local v40 = AvatarCreationService:DeserializeAvatarModel(p8)

				p2:dispatch(SetAccessoryInstance(v40))

				if p9 then
					p2:dispatch(SetPriceInRobux(p9))
				end

				return
			end

			if v39 and p7 == v39.promptRequest.promptInfo.guid then
				local v41 = AvatarCreationService:DeserializeAvatarModel(p8)

				updateModelAttachmentsWithWrapDeformers(v41)
				p2:dispatch(SetHumanoidModel(v41))
				p2:dispatch(SetPriceInRobux(p9))
			end
		end))
	end

	if pcall(checkNewEventsExist) then
		table.insert(t1, AvatarCreationService.UgcValidationFailure:Connect(function(p10, p11) -- line: 142
			-- upvalues: p2 (copy), OpenValidationErrorModal (copy)
			local v44 = p2:getState()

			if v44 and p10 == v44.promptRequest.promptInfo.guid then
				p2:dispatch(OpenValidationErrorModal(p11))
			end
		end))
	end

	return t1
end

return ConnectAssetServiceEvents
