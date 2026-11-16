local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)

require("@luauforge/deferred/giM")
local module = require("@luauforge/bundled/dTM")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local v5 = {
	title = "Feature.Avatar.Title.DeleteSet",
	body = "Feature.Avatar.Label.DeleteSetBody",
	delete = "Feature.Avatar.Action.Delete",
	cancel = "Feature.Avatar.Action.Cancel"
}

local function useDeleteFolderPromptProps()
	local v6 = useNavigation()
	local v7 = useLocalization(v5)

	local v8 = v6.getParam("onDeleteFolder")

	if v8 == nil then
		mutedError("[DeleteFolderPrompt] onDeleteFolder param is missing")
		v8 = function()
			return Promise.reject("[DeleteFolderPrompt] onDeleteFolder param is missing")
		end
	end

	local ref = React.useRef(false)

	local v9 = React.useCallback(function()
		module.closeOverlay(v6)
	end, { v6 })

	local v10 = React.useCallback(function()
		module.navigateToNextOverlay(v6, avatarScreen.FolderErrorDialog)
	end, { v6 })

	local v11 = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true

		v8():andThen(function()
			v9()
		end):catch(v10):finally(function()
			ref.current = false
		end)
	end, { v8, v9, v10 })

	return {
		titleText = v7.title,
		bodyText = v7.body,
		confirmButtonText = v7.delete,
		cancelButtonText = v7.cancel,
		onConfirm = v11,
		onClose = v9
	}
end

return useDeleteFolderPromptProps
