local AvatarEditorService = game:GetService("AvatarEditorService")

local parent = script.Parent.Parent
local OpenPrompt = require(parent.Actions.OpenPrompt)

local GetOutfitName = require(parent.Network.GetOutfitName)

local PromptType = require(parent.PromptType)

return function(outfitId)
	return function(object)
		GetOutfitName(outfitId):andThen(function(outfitName)
			object:dispatch(OpenPrompt(PromptType.RenameOutfit, {
				outfitId = outfitId,
				outfitName = outfitName
			}))
		end, function(_)
			AvatarEditorService:SignalRenameOutfitFailed()
		end)
	end
end
