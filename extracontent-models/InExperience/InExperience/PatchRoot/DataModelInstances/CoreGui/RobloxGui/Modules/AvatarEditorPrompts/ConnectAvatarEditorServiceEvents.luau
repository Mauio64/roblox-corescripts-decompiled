local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")
local scriptParent = script.Parent
local OpenPrompt = require(scriptParent.Actions.OpenPrompt)
local PromptType = require(scriptParent.PromptType)
local OpenSetFavoritePrompt = require(scriptParent.Thunks.OpenSetFavoritePrompt)
local OpenSaveAvatarPrompt = require(scriptParent.Thunks.OpenSaveAvatarPrompt)
local OpenDeleteOutfitPrompt = require(scriptParent.Thunks.OpenDeleteOutfitPrompt)
local OpenRenameOutfitPrompt = require(scriptParent.Thunks.OpenRenameOutfitPrompt)
local OpenUpdateOutfitPrompt = require(scriptParent.Thunks.OpenUpdateOutfitPrompt)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local FFlagAXAvatarTimeoutFlowIE = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlowIE

local function ConnectAvatarEditorServiceEvents(p1) -- line: 18
	-- upvalues: AvatarEditorService (copy), FFlagAXAvatarTimeoutFlowIE (copy), AvatarExperienceCommon (copy), OpenPrompt (copy), PromptType (copy), OpenSaveAvatarPrompt (copy), OpenSetFavoritePrompt (copy), OpenDeleteOutfitPrompt (copy), OpenRenameOutfitPrompt (copy), OpenUpdateOutfitPrompt (copy)
	local t1 = {}

	table.insert(t1, AvatarEditorService.OpenPromptSaveAvatar:Connect(function(p2, p3) -- line: 21
		-- upvalues: FFlagAXAvatarTimeoutFlowIE (copy), AvatarExperienceCommon (copy), p1 (copy), OpenPrompt (copy), PromptType (copy), OpenSaveAvatarPrompt (copy)
		if FFlagAXAvatarTimeoutFlowIE then
			AvatarExperienceCommon.Stores.getTimeoutStatusStore().fetchStatusAsync():andThen(function(p4) -- line: 24
				-- upvalues: p1 (copy), OpenPrompt (copy), PromptType (copy), OpenSaveAvatarPrompt (copy), p2 (copy), p3 (copy)
				if p4.isTimedOut then
					p1:dispatch(OpenPrompt(PromptType.SaveAvatarTimeout, {}))

					return
				end

				p1:dispatch(OpenSaveAvatarPrompt(p2, p3))
			end)

			return
		end

		p1:dispatch(OpenSaveAvatarPrompt(p2, p3))
	end))
	table.insert(t1, AvatarEditorService.OpenAllowInventoryReadAccess:Connect(function() -- line: 36
		-- upvalues: p1 (copy), OpenPrompt (copy), PromptType (copy)
		p1:dispatch(OpenPrompt(PromptType.AllowInventoryReadAccess, {}))
	end))
	table.insert(t1, AvatarEditorService.OpenPromptCreateOufit:Connect(function(p5, p6) -- line: 40
		-- upvalues: p1 (copy), OpenPrompt (copy), PromptType (copy)
		p1:dispatch(OpenPrompt(PromptType.CreateOutfit, {
			humanoidDescription = p5,
			rigType = p6
		}))
	end))
	table.insert(t1, AvatarEditorService.OpenPromptSetFavorite:Connect(function(p7, p8, p9) -- line: 47
		-- upvalues: p1 (copy), OpenSetFavoritePrompt (copy)
		p1:dispatch(OpenSetFavoritePrompt(p7, p8, p9))
	end))
	table.insert(t1, AvatarEditorService.OpenPromptDeleteOutfit:Connect(function(p10) -- line: 51
		-- upvalues: p1 (copy), OpenDeleteOutfitPrompt (copy)
		p1:dispatch(OpenDeleteOutfitPrompt(p10))
	end))
	table.insert(t1, AvatarEditorService.OpenPromptRenameOutfit:Connect(function(p11) -- line: 55
		-- upvalues: p1 (copy), OpenRenameOutfitPrompt (copy)
		p1:dispatch(OpenRenameOutfitPrompt(p11))
	end))
	table.insert(t1, AvatarEditorService.OpenPromptUpdateOutfit:Connect(function(p12, p13, p14) -- line: 59
		-- upvalues: p1 (copy), OpenUpdateOutfitPrompt (copy)
		p1:dispatch(OpenUpdateOutfitPrompt(p12, p13, p14))
	end))

	return t1
end

return ConnectAvatarEditorServiceEvents
