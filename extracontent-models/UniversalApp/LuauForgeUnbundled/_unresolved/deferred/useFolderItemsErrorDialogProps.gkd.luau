local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

require("@luauforge/deferred/giM")
local module = require("@luauforge/bundled/dTM")

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local v5 = {
	title = "Feature.Avatar.Heading.SetUpdateFailed",
	body = "Feature.Avatar.Label.GenericSetError",
	ok = "CommonUI.Controls.Action.OK"
}

local function useFolderItemsErrorDialogProps()
	local v6 = useNavigation()
	local v7 = useLocalization(v5)

	local v8 = React.useCallback(function()
		module.closeOverlay(v6)
	end, { v6 })

	return {
		titleText = v7.title,
		bodyText = v7.body,
		confirmButtonText = v7.ok,
		onConfirm = v8,
		onClose = v8
	}
end

return useFolderItemsErrorDialogProps
