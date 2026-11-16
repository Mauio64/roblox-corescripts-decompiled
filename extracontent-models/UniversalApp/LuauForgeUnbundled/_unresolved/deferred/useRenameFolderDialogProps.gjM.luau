local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)

require("@luauforge/deferred/giH")
local module = require("@luauforge/bundled/dTM")

local module2 = require("@luauforge/deferred/giV")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local isFolderNameValid = module2.Utils.isFolderNameValid
local mapFolderMutationError = module2.Utils.mapFolderMutationError
local folderErrorReason = module2.Enums.FolderErrorReason
local constants = module2.Constants

local v5 = {
	title = "Feature.Avatar.Title.RenameSet",
	rename = "Feature.Avatar.Action.Rename",
	cancel = "Feature.Avatar.Action.Cancel"
}

local function errorScreenForReason(p2)
	if p2 == folderErrorReason.Duplicate then
		return avatarScreen.DuplicateFolderNameDialog
	end

	if p2 == folderErrorReason.NameNotAllowed then
		return avatarScreen.FolderNameNotAllowedDialog
	end

	return avatarScreen.FolderErrorDialog
end

local function useRenameFolderDialogProps()
	local v6 = useNavigation()
	local v7 = useLocalization(v5)

	local onSubmit = v6.getParam("onSubmit")

	if onSubmit == nil then
		mutedError("[RenameFolderDialog] onSubmit param is missing")
		onSubmit = function(p2)
			return Promise.reject("[RenameFolderDialog] onSubmit param is missing")
		end
	end

	local v8 = v6.getParam("currentName") or ""
	local v9 = v6.getParam("defaultText") or v8

	local v10 = v6.getParam("checkIsDuplicateFolderName") or function(p2): boolean
		return false
	end

	local ref = React.useRef(false)

	local v11 = React.useCallback(function()
		module.closeOverlay(v6)
	end, { v6 })

	local v12 = React.useCallback(function(p2, p3)
		local v13

		if p2 == folderErrorReason.Duplicate then
			v13 = avatarScreen.DuplicateFolderNameDialog
		elseif p2 == folderErrorReason.NameNotAllowed then
			v13 = avatarScreen.FolderNameNotAllowedDialog
		else
			v13 = avatarScreen.FolderErrorDialog
		end

		local v14 = {
			folderName = p3,
			onSubmit = onSubmit,
			checkIsDuplicateFolderName = v10,
			currentName = v8,
			backScreen = avatarScreen.RenameFolderDialog
		}

		module.navigateToNextOverlay(v6, v13, v14)
	end, { v6, onSubmit, v10, v8 })

	local v13 = React.useCallback(function(p2)
		if ref.current then
			return
		end

		if v10(p2) then
			v12(folderErrorReason.Duplicate, p2)
			return
		end

		ref.current = true

		onSubmit(p2):andThen(function()
			v11()
		end):catch(function(p3)
			v12(mapFolderMutationError(p3), p2)
		end):finally(function()
			ref.current = false
		end)
	end, { onSubmit, v11, v10, v12 })

	return {
		titleText = v7.title,
		confirmButtonText = v7.rename,
		cancelButtonText = v7.cancel,
		onClose = v11,
		onConfirm = v13,
		defaultText = v9,
		isTextValid = isFolderNameValid,
		maxLength = constants.MAX_NAME_LENGTH
	}
end

return useRenameFolderDialogProps
