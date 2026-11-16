local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")

local parent = script.Parent

local OpenPrompt = require(parent.Actions.OpenPrompt)
local PromptType = require(parent.PromptType)

local OpenSetFavoritePrompt = require(parent.Thunks.OpenSetFavoritePrompt)
local OpenSaveAvatarPrompt = require(parent.Thunks.OpenSaveAvatarPrompt)
local OpenDeleteOutfitPrompt = require(parent.Thunks.OpenDeleteOutfitPrompt)
local OpenRenameOutfitPrompt = require(parent.Thunks.OpenRenameOutfitPrompt)
local OpenUpdateOutfitPrompt = require(parent.Thunks.OpenUpdateOutfitPrompt)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local showSaveAvatarTimeoutFeatureRestriction = require(parent.showSaveAvatarTimeoutFeatureRestriction)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXUseUFRForTimeoutPromptInExperience = AvatarExperienceFlags.FFlagAXUseUFRForTimeoutPromptInExperience

local function ConnectAvatarEditorServiceEvents(object)
	local connections = {}

	table.insert(connections, AvatarEditorService.OpenPromptSaveAvatar:Connect(function(p, p2)
		AvatarExperienceCommon.Stores.getTimeoutStatusStore().fetchStatusAsync():andThen(function(p3)
			if not p3.isTimedOut then
				object:dispatch(OpenSaveAvatarPrompt(p, p2))
			elseif FFlagAXUseUFRForTimeoutPromptInExperience then
				showSaveAvatarTimeoutFeatureRestriction()
			else
				object:dispatch(OpenPrompt(PromptType.SaveAvatarTimeout, {}))
			end
		end)
	end))

	table.insert(connections, AvatarEditorService.OpenAllowInventoryReadAccess:Connect(function()
		object:dispatch(OpenPrompt(PromptType.AllowInventoryReadAccess, {}))
	end))

	table.insert(connections, AvatarEditorService.OpenPromptCreateOufit:Connect(function(humanoidDescription, rigType)
		object:dispatch(OpenPrompt(PromptType.CreateOutfit, {
			humanoidDescription = humanoidDescription,
			rigType = rigType
		}))
	end))

	table.insert(connections, AvatarEditorService.OpenPromptSetFavorite:Connect(function(p, p2, p3)
		object:dispatch(OpenSetFavoritePrompt(p, p2, p3))
	end))

	table.insert(connections, AvatarEditorService.OpenPromptDeleteOutfit:Connect(function(p)
		object:dispatch(OpenDeleteOutfitPrompt(p))
	end))

	table.insert(connections, AvatarEditorService.OpenPromptRenameOutfit:Connect(function(p)
		object:dispatch(OpenRenameOutfitPrompt(p))
	end))

	table.insert(connections, AvatarEditorService.OpenPromptUpdateOutfit:Connect(function(p, p2, p3)
		object:dispatch(OpenUpdateOutfitPrompt(p, p2, p3))
	end))

	return connections
end

return ConnectAvatarEditorServiceEvents
