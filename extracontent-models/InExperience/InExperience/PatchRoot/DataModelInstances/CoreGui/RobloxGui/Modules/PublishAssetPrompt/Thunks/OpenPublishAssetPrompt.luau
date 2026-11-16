local parent = script.Parent.Parent
local OpenPublishAssetPrompt = require(parent.Actions.OpenPublishAssetPrompt)
local PromptType = require(parent.PromptType)

return function(accessory, p, p2: string, p3)
	return function(object)
		if accessory:IsA("Accessory") then
			local model = Instance.new("Model")
			model.Parent = accessory.Parent
			accessory.Parent = model

			local basePart = accessory:FindFirstChildWhichIsA("BasePart", true)

			if basePart == nil then
				print("Error: accessory to be published does not contain a BasePart")
			else
				model.PrimaryPart = basePart
				accessory = model
			end
		end

		object:dispatch(OpenPublishAssetPrompt(PromptType.PublishAssetSingleStep, accessory, p, p2, p3))
	end
end
