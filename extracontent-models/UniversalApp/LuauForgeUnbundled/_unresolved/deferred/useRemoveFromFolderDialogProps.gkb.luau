local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

require("@luauforge/deferred/giM")
local module = require("@luauforge/bundled/dTM")

local module2 = require("@luauforge/deferred/giV")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local useFoldersStore = module2.Hooks.useFoldersStore

local v5 = {
	title = "Feature.Avatar.Title.RemoveFromSet",
	body = "Feature.Avatar.Label.RemoveFromSetBody",
	remove = "Feature.Avatar.Action.Remove",
	cancel = "Feature.Avatar.Action.Cancel"
}

local function useRemoveFromFolderDialogProps()
	local v6 = useNavigation()
	local v7 = useLocalization(v5)
	local v8 = useFoldersStore()

	local v9 = v6.getParam("outfitIds") or {}
	local param = v6.getParam("folderId")

	local v10 = React.useMemo(function()
		local result = {}

		for k, v11 in v9 do
			local v12 = tonumber(v11)

			if v12 ~= nil then
				table.insert(result, v12)
			end
		end

		return result
	end, { v9 })

	local ref = React.useRef(false)

	local v11 = React.useCallback(function()
		module.closeOverlay(v6)
	end, { v6 })

	local v12 = React.useCallback(function()
		module.navigateToNextOverlay(v6, avatarScreen.FolderItemsErrorDialog)
	end, { v6 })

	local removeItemsFromFolder = v8.removeItemsFromFolder
	local v13 = React.useCallback(function()
		if param == nil then
			mutedError("[RemoveFromFolderDialog] folderId param is missing")
			v11()
		else
			if ref.current then
				return
			end

			ref.current = true

			removeItemsFromFolder(param, v10):andThen(function()
				ref.current = false
				v11()
			end, function()
				ref.current = false
				v12()
			end)
		end
	end, { removeItemsFromFolder, param, v10, v11, v12 })

	return {
		titleText = v7.title,
		bodyText = v7.body,
		confirmButtonText = v7.remove,
		cancelButtonText = v7.cancel,
		onConfirm = v13,
		onClose = v11
	}
end

return useRemoveFromFolderDialogProps
