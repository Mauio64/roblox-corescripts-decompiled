local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dTM")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/deferred/giM")

local module2 = require("@luauforge/bundled/dMx")

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module3 = require("@luauforge/deferred/giO")

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local function useDuplicateOutfitDialogProps()
	local v5 = useNavigation()
	local v6 = v5.getParam("outfitType")

	if not v6 then
		v6 = module2.OutfitTypes.Avatar
		mutedError("outfitType is required")
	end

	local v7 = v5.getParam("duplicateOutfitName")

	if not v7 then
		mutedError("duplicateOutfitName is required")
		v7 = ""
	end

	local v8 = v5.getParam("saveAsNew")

	if v8 == nil then
		mutedError("saveAsNew is required")
		v8 = true
	end

	local v9 = v5.getParam("onOverlayClosed")

	if not v9 then
		mutedError("onOverlayClosed is required")

		v9 = function() end
	end

	local v10 = useLocalization({
		title = v6 == module2.OutfitTypes.Avatar and "Feature.Avatar.Label.Title.DuplicateAvatar" or "Feature.Avatar.Title.DuplicateMakeupLook",
		subtitle = v6 == module2.OutfitTypes.Avatar and {
			"Feature.Avatar.Message.AddAvatarAgain",
			prevAvatar = v7
		} or {
			"Feature.Avatar.Label.DuplicateMakeupLookDialog",
			lookName = v7
		},
		add = v8 and "Feature.Avatar.Label.Add" or "Feature.Avatar.Label.Replace",
		cancel = "Feature.Avatar.Action.Cancel"
	})

	local v11 = React.useCallback(function()
		module.closeOverlay(v5)
	end, { v5 })

	local v12 = module3(v5, v6, v9, true)

	local v13 = React.useCallback(function()
		if v8 then
		end

		v12()
	end, { v12, v8 })

	return {
		titleText = v10.title,
		bodyText = v10.subtitle,
		cancelButtonText = v10.cancel,
		confirmButtonText = v10.add,
		onClose = v11,
		onConfirm = v13
	}
end

return useDuplicateOutfitDialogProps
