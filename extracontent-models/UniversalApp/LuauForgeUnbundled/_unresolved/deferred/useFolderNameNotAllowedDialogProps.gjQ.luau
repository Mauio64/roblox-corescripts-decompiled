local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

require("@luauforge/deferred/giM")
local module = require("@luauforge/bundled/dTM")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local function useFolderNameNotAllowedDialogProps()
	local v5 = useNavigation()
	local v6 = useLocalization({
		title = "Feature.Avatar.Heading.SetNameNotAllowed",
		body = "Feature.Avatar.Label.SetNameNotAllowedBody",
		ok = "CommonUI.Controls.Action.OK"
	})

	local v7 = v5.getParam("backScreen")

	if v7 == nil then
		v7 = avatarScreen.CreateFolderDialog
		mutedError("[FolderNameNotAllowedDialog] backScreen param is missing")
	end

	local v8 = v5.getParam("folderName") or ""
	local param = v5.getParam("onSubmit")
	local param2 = v5.getParam("checkIsDuplicateFolderName")
	local param3 = v5.getParam("currentName")

	local v9 = React.useCallback(function()
		module.navigateToNextOverlay(v5, v7, {
			onSubmit = param,
			checkIsDuplicateFolderName = param2,
			defaultText = v8,
			currentName = param3
		})
	end, { v5, v7, param, param2, v8, param3 })

	return {
		titleText = v6.title,
		bodyText = v6.body,
		confirmButtonText = v6.ok,
		onConfirm = v9,
		onClose = v9
	}
end

return useFolderNameNotAllowedDialogProps
