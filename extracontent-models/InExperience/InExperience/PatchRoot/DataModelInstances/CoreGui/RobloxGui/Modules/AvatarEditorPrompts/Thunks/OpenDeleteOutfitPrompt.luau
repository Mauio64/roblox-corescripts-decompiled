local AvatarEditorService = game:GetService("AvatarEditorService")
game:GetService("CorePackages")
game:GetService("HttpRbxApiService")

local parent = script.Parent.Parent
local OpenPrompt = require(parent.Actions.OpenPrompt)

local GetOutfitName = require(parent.Network.GetOutfitName)

local PromptType = require(parent.PromptType)

return function(outfitId)
	return function(object)
		GetOutfitName(outfitId):andThen(function(outfitName)
			object:dispatch(OpenPrompt(PromptType.DeleteOutfit, {
				outfitId = outfitId,
				outfitName = outfitName
			}))
		end, function(_)
			AvatarEditorService:SignalDeleteOutfitFailed()
		end)
	end
end
