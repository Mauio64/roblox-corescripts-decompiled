local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script.Parent.Parent
local OpenPrompt = require(parent.Actions.OpenPrompt)

local GetOutfitName = require(parent.Network.GetOutfitName)

local PromptType = require(parent.PromptType)

return function(outfitId, humanoidDescription, rigType)
	return function(object)
		GetOutfitName(outfitId):andThen(function(outfitName)
			object:dispatch(OpenPrompt(PromptType.UpdateOutfit, {
				outfitId = outfitId,
				outfitName = outfitName,
				humanoidDescription = humanoidDescription,
				rigType = rigType
			}))
		end, function(_)
			AvatarEditorService:SignalUpdateOutfitFailed()
		end)
	end
end
