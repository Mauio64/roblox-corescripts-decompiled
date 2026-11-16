local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

require("@luauforge/deferred/giM")
local module = require("@luauforge/bundled/dTM")

local module2 = require("@luauforge/deferred/giV")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local constants = module2.Constants

local function useFolderLimitReachedDialogProps()
	local v5 = useNavigation()
	local v6 = useLocalization({
		title = "Feature.Avatar.Heading.SetLimitReached",
		body = {
			"Feature.Avatar.Label.SetLimitReachedBody",
			setLimit = constants.MAX_FOLDERS
		},
		ok = "CommonUI.Controls.Action.OK"
	})

	local v7 = React.useCallback(function()
		module.closeOverlay(v5)
	end, { v5 })

	return {
		titleText = v6.title,
		bodyText = v6.body,
		confirmButtonText = v6.ok,
		onConfirm = v7,
		onClose = v7
	}
end

return useFolderLimitReachedDialogProps
