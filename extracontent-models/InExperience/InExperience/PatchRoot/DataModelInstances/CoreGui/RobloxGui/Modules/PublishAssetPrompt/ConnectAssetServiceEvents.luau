local AssetService = game:GetService("AssetService")
local AvatarCreationService = game:GetService("AvatarCreationService")
local ExperienceAuthService = game:GetService("ExperienceAuthService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")

local parent = script.Parent
local OpenPublishAssetPrompt = require(parent.Thunks.OpenPublishAssetPrompt)
local OpenPublishAvatarPrompt = require(parent.Thunks.OpenPublishAvatarPrompt)
local OpenPublishAvatarAssetPrompt = require(parent.Thunks.OpenPublishAvatarAssetPrompt)
local OpenPublishMakeupLookPrompt = require(parent.Thunks.OpenPublishMakeupLookPrompt)
local OpenResultModal = require(parent.Thunks.OpenResultModal)
local SetHumanoidModel = require(parent.Actions.SetHumanoidModel)
local SetAccessoryInstance = require(parent.Actions.SetAccessoryInstance)
local SetPriceInRobux = require(parent.Actions.SetPriceInRobux)
local OpenValidationErrorModal = require(parent.Actions.OpenValidationErrorModal)
local PurchasePrompt = require(CorePackages.Workspace.Packages.PurchasePrompt)
local PublishAssetAnalytics = PurchasePrompt.PublishAssetAnalytics

local GetFFlagUploadMakeupSupport = require(parent.Flags.GetFFlagUploadMakeupSupport)

local FFlagPublishAssetPromptItemDetailsTelemetry = require(parent.Flags.FFlagPublishAssetPromptItemDetailsTelemetry)

local engineFeature = game:GetEngineFeature("PromptImportAnimationClipFromVideoAsyncEnabled")

local function updateModelAttachmentsWithWrapDeformers(instance)
	instance.Parent = RobloxReplicatedStorage

	for _, part in instance:GetChildren() do
		if not part:IsA("MeshPart") then
			continue
		end

		local wrapDeformer = part:FindFirstChildWhichIsA("WrapDeformer")

		if not wrapDeformer then
			continue
		end

		for _, attachment in part:GetChildren() do
			if attachment:IsA("Attachment") then
				attachment.CFrame = wrapDeformer:GetDeformedCFrameAsync(attachment.CFrame)
			end
		end
	end
end

local function setAnalyticsItemDetails(data)
	if data.instanceToPublish or data.serializedInstance then
		PublishAssetAnalytics.setItemDetails(PublishAssetAnalytics.ItemType.Asset, data.assetType.Name)
	elseif data.outfitToPublish then
		PublishAssetAnalytics.setItemDetails(PublishAssetAnalytics.ItemType.Outfit, Enum.OutfitType.Avatar.Name)
	elseif data.makeupLookToPublish then
		PublishAssetAnalytics.setItemDetails(PublishAssetAnalytics.ItemType.Outfit, Enum.OutfitType.Makeup.Name)
	elseif data.accessoryToPublish then
		PublishAssetAnalytics.setItemDetails(PublishAssetAnalytics.ItemType.Asset, data.accessoryType.Name)
	end
end

local function ConnectAssetServiceEvents(object)
	local connections = {}

	table.insert(connections, ExperienceAuthService.OpenAuthPrompt:Connect(function(p, list, data)
		local isVideoToAnimationFlow = engineFeature and data.isVideoToAnimationFlow

		if #list == 1 and list[1] == Enum.ExperienceAuthScope.CreatorAssetsCreate and not isVideoToAnimationFlow then
			if FFlagPublishAssetPromptItemDetailsTelemetry then
				setAnalyticsItemDetails(data)
			end

			if data.instanceToPublish then
				object:dispatch(OpenPublishAssetPrompt(data.instanceToPublish, data.assetType, p, list))
			elseif data.serializedInstance then
				object:dispatch(OpenPublishAssetPrompt(
					AssetService:DeserializeInstance(data.serializedInstance),
					data.assetType,
					p,
					list
				))
			elseif data.outfitToPublish then
				object:dispatch(OpenPublishAvatarPrompt(p, list))
			elseif GetFFlagUploadMakeupSupport() and data.makeupLookToPublish then
				object:dispatch(OpenPublishMakeupLookPrompt(p, list, data.makeupEntries))
			elseif data.accessoryToPublish then
				object:dispatch(OpenPublishAvatarAssetPrompt(data.accessoryType, p, list))
			end
		end
	end))

	table.insert(connections, AssetService.OpenPublishResultModal:Connect(function(p)
		object:dispatch(OpenResultModal(p))
	end))

	local function checkNewEventsExist()
		return AvatarCreationService.UgcValidationSuccess and AvatarCreationService.UgcValidationFailure
	end

	if pcall(checkNewEventsExist) then
		table.insert(connections, AvatarCreationService.UgcValidationSuccess:Connect(function(p, p2, p3)
			local state = object:getState()

			if
				state
				and (state.promptRequest.promptInfo.promptType == "PublishAvatarAsset" or GetFFlagUploadMakeupSupport() and state.promptRequest.promptInfo.promptType == "PublishMakeupLook")
			then
				object:dispatch(SetAccessoryInstance((AvatarCreationService:DeserializeAvatarModel(p2))))

				if p3 then
					object:dispatch(SetPriceInRobux(p3))
				end
			elseif state and state.promptRequest.promptInfo.guid == p then
				local deserializeAvatarModel = AvatarCreationService:DeserializeAvatarModel(p2)

				updateModelAttachmentsWithWrapDeformers(deserializeAvatarModel)

				object:dispatch(SetHumanoidModel(deserializeAvatarModel))
				object:dispatch(SetPriceInRobux(p3))
			end
		end))
	end

	if pcall(checkNewEventsExist) then
		table.insert(connections, AvatarCreationService.UgcValidationFailure:Connect(function(p, p2)
			local state = object:getState()

			if state and state.promptRequest.promptInfo.guid == p then
				object:dispatch(OpenValidationErrorModal(p2))
			end
		end))
	end

	return connections
end

return ConnectAssetServiceEvents
