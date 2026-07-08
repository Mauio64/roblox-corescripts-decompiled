local AvatarEditorService = game:GetService("AvatarEditorService")

game:GetService("CorePackages")
game:GetService("HttpRbxApiService")

local ParentParent = script.Parent.Parent
local OpenPrompt = require(ParentParent.Actions.OpenPrompt)
local GetOutfitName = require(ParentParent.Network.GetOutfitName)
local PromptType = require(ParentParent.PromptType)

return function(p1) -- line: 16
	-- upvalues: GetOutfitName (copy), OpenPrompt (copy), PromptType (copy), AvatarEditorService (copy)
	return function(p2) -- line: 17
		-- upvalues: GetOutfitName (copy), p1 (copy), OpenPrompt (copy), PromptType (copy), AvatarEditorService (copy)
		GetOutfitName(p1):andThen(function(p3) -- line: 18
			-- upvalues: p2 (copy), OpenPrompt (copy), PromptType (copy), p1 (copy)
			p2:dispatch(OpenPrompt(PromptType.DeleteOutfit, {
				outfitId = p1,
				outfitName = p3
			}))
		end, function(_) -- line: 23
			-- upvalues: AvatarEditorService (copy)
			AvatarEditorService:SignalDeleteOutfitFailed()
		end)
	end
end
