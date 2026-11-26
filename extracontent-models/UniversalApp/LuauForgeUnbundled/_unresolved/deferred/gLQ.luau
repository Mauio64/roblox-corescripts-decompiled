local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/dzP")
local Promise = require(CorePackages.Packages.Promise)

local module2 = require("@luauforge/bundled/dRg")
local module3 = require("@luauforge/bundled/dFm")
local module4 = require("@luauforge/bundled/dzE")

local module5 = require("@luauforge/bundled/fCI")

local module6 = require("@luauforge/bundled/dSk")

require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local v5 = {
	toastMessage = "Feature.Avatar.Message.AvatarRenamed",
	isLocalized = false,
	toastType = module4.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.Message.FailedAvatarRename",
	isLocalized = false,
	toastType = module4.InformationMessage
}

local function keyMapper(p2)
	return module2.RenameOutfitKey .. p2
end

return function(p2, p3, p4)
	module.isType(p2, "table", "RenameOutfit thunk expects avatarEditorAnalytics to be a table")
	module.isType(p3, "string", "RenameOutfit thunk expects id to be a string")
	module.isType(p4, "string", "RenameOutfit thunk expects name to be a string")

	return function(p5, p6)
		local avatarEditorService = p6.avatarEditorService
		return performFetch.Single(module2.RenameOutfitKey .. p3, function(object)
			return Promise.new(function(callback, callback2)
				if module5.doAESCallAndAwaitResult(
					avatarEditorService,
					avatarEditorService.NoPromptRenameOutfit,
					avatarEditorService.PromptRenameOutfitCompleted,
					p3,
					p4
				) == Enum.AvatarPromptResult.Success then
					object:dispatch(module6(p3, p4))
					object:dispatch(module3(v5))
					callback()
				else
					object:dispatch(module3(v6))
					callback2()
				end
			end)
		end)(p5)
	end
end
