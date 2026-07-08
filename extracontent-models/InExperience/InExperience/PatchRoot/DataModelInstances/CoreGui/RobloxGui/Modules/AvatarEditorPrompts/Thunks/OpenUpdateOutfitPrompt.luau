local AvatarEditorService = game:GetService("AvatarEditorService")
local ParentParent = script.Parent.Parent
local OpenPrompt = require(ParentParent.Actions.OpenPrompt)
local GetOutfitName = require(ParentParent.Network.GetOutfitName)
local PromptType = require(ParentParent.PromptType)

return function(p1, p2, p3) -- line: 10
	-- upvalues: GetOutfitName (copy), OpenPrompt (copy), PromptType (copy), AvatarEditorService (copy)
	return function(p4) -- line: 11
		-- upvalues: GetOutfitName (copy), p1 (copy), OpenPrompt (copy), PromptType (copy), p2 (copy), p3 (copy), AvatarEditorService (copy)
		GetOutfitName(p1):andThen(function(p5) -- line: 12
			-- upvalues: p4 (copy), OpenPrompt (copy), PromptType (copy), p1 (copy), p2 (copy), p3 (copy)
			p4:dispatch(OpenPrompt(PromptType.UpdateOutfit, {
				outfitId = p1,
				outfitName = p5,
				humanoidDescription = p2,
				rigType = p3
			}))
		end, function(_) -- line: 19
			-- upvalues: AvatarEditorService (copy)
			AvatarEditorService:SignalUpdateOutfitFailed()
		end)
	end
end
