local ParentParent = script.Parent.Parent
local OpenPublishAssetPrompt = require(ParentParent.Actions.OpenPublishAssetPrompt)
local PromptType = require(ParentParent.PromptType)

return function(p1, p2, s1: string, p3) -- line: 12
	-- upvalues: OpenPublishAssetPrompt (copy), PromptType (copy)
	return function(p4) -- line: 13
		-- upvalues: p1 (ref), OpenPublishAssetPrompt (copy), PromptType (copy), p2 (copy), s1 (copy), p3 (copy)
		if p1:IsA("Accessory") then
			local Model = Instance.new("Model")

			Model.Parent = p1.Parent
			p1.Parent = Model

			local BasePart = p1:FindFirstChildWhichIsA("BasePart", true)

			if BasePart == nil then
				print("Error: accessory to be published does not contain a BasePart")
			else
				Model.PrimaryPart = BasePart
				p1 = Model
			end
		end

		p4:dispatch(OpenPublishAssetPrompt(PromptType.PublishAssetSingleStep, p1, p2, s1, p3))
	end
end
