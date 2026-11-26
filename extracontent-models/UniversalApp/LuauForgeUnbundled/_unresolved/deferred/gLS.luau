local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dzP")
local Promise = require(CorePackages.Packages.Promise)

local module2 = require("@luauforge/bundled/dRg")
local module3 = require("@luauforge/bundled/dFm")
local module4 = require("@luauforge/bundled/dzE")

local module5 = require("@luauforge/bundled/fCI")
local v5

if require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRefetchInventoryOnUpdate then
	v5 = require("@luauforge/bundled/gLT")
else
	v5 = require("@luauforge/bundled/dRw")
end

require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local v6 = {
	toastMessage = "Feature.Avatar.Message.FailedDeleteCostume",
	isLocalized = false,
	toastType = module4.InformationMessage
}

local function keyMapper(p2)
	return module2.DeleteOutfitsKey .. p2
end

return function(p2)
	module.isType(p2, "string", "DeleteOutfit thunk expects id to be a string")

	return function(p3, p4)
		local avatarEditorService = p4.avatarEditorService
		return performFetch.Single(module2.DeleteOutfitsKey .. p2, function(object)
			return Promise.new(function(callback, callback2)
				if module5.doAESCallAndAwaitResult(
					avatarEditorService,
					avatarEditorService.NoPromptDeleteOutfit,
					avatarEditorService.PromptDeleteOutfitCompleted,
					p2
				) == Enum.AvatarPromptResult.Success then
					object:dispatch(v5(p2))
					callback()
				else
					object:dispatch(module3(v6))
					callback2()
				end
			end)
		end)(p3)
	end
end
