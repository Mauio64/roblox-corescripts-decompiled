local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)

require("@luauforge/deferred/gNn")
local module = require("@luauforge/bundled/dXh")

local module2 = require("@luauforge/deferred/gNB")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local isFolderNameValid = module2.Utils.isFolderNameValid
local mapFolderMutationError = module2.Utils.mapFolderMutationError
local folderErrorReason = module2.Enums.FolderErrorReason
local constants = module2.Constants

local v5 = {
	title = "Feature.Avatar.Title.CreateSet",
	create = "Feature.Avatar.Action.CreateSet",
	cancel = "Feature.Avatar.Action.Cancel"
}

local function errorScreenForReason(p2)
	if p2 == folderErrorReason.Duplicate then
		return avatarScreen.DuplicateFolderNameDialog
	end

	if p2 == folderErrorReason.NameNotAllowed then
		return avatarScreen.FolderNameNotAllowedDialog
	end

	if p2 == folderErrorReason.FolderLimit then
		return avatarScreen.FolderLimitReachedDialog
	end

	return avatarScreen.FolderErrorDialog
end

local function useCreateFolderDialogProps()
	local v6 = useNavigation()
	local v7 = useLocalization(v5)

	local onSubmit = v6.getParam("onSubmit")

	if onSubmit == nil then
		mutedError("[CreateFolderDialog] onSubmit param is missing")
		onSubmit = function(p2)
			return Promise.reject("[CreateFolderDialog] onSubmit param is missing")
		end
	end

	local v8 = v6.getParam("checkIsDuplicateFolderName") or function(p2): boolean
		return false
	end

	local param = v6.getParam("defaultText")

	local ref = React.useRef(false)

	local v9 = React.useCallback(function()
		module.closeOverlay(v6)
	end, { v6 })

	local v10 = React.useCallback(function(p2, p3)
		local v11

		if p2 == folderErrorReason.Duplicate then
			v11 = avatarScreen.DuplicateFolderNameDialog
		elseif p2 == folderErrorReason.NameNotAllowed then
			v11 = avatarScreen.FolderNameNotAllowedDialog
		elseif p2 == folderErrorReason.FolderLimit then
			v11 = avatarScreen.FolderLimitReachedDialog
		else
			v11 = avatarScreen.FolderErrorDialog
		end

		local v12 = {
			folderName = p3,
			onSubmit = onSubmit,
			checkIsDuplicateFolderName = v8,
			backScreen = avatarScreen.CreateFolderDialog
		}

		module.navigateToNextOverlay(v6, v11, v12)
	end, { v6, onSubmit, v8 })

	local v11 = React.useCallback(function(p2)
		if ref.current then
			return
		end

		if v8(p2) then
			v10(folderErrorReason.Duplicate, p2)
			return
		end

		ref.current = true

		onSubmit(p2):andThen(function()
			v9()
		end):catch(function(p3)
			v10(mapFolderMutationError(p3), p2)
		end):finally(function()
			ref.current = false
		end)
	end, { onSubmit, v9, v8, v10 })

	return {
		titleText = v7.title,
		confirmButtonText = v7.create,
		cancelButtonText = v7.cancel,
		onClose = v9,
		onConfirm = v11,
		defaultText = param,
		isTextValid = isFolderNameValid,
		maxLength = constants.MAX_NAME_LENGTH
	}
end

return useCreateFolderDialogProps
