local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dTM")

require("@luauforge/deferred/giM")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/bundled/dMx")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local function useDuplicateOutfitNameDialogProps()
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = v5.getParam("outfitType")

	if not v7 then
		v7 = module2.OutfitTypes.Avatar
		mutedError("outfitType is required")
	end

	local v8 = v5.getParam("outfitName")

	if not v8 then
		mutedError("outfitName is required")
		v8 = ""
	end

	local onComplete = v5.getParam("onComplete")

	if not onComplete then
		mutedError("onComplete is required")

		onComplete = function(p2, p3) end
	end

	local v9 = v5.getParam("backScreen")

	if not v9 then
		v9 = avatarScreen.AddOutfitDialog
		mutedError("backScreen is required")
	end

	local param = v5.getParam("outfitId")

	local v10 = useLocalization({
		title = "Feature.Avatar.Heading.UsedName",
		body = "Feature.Avatar.Label.UsedNameLong",
		confirm = "Feature.Avatar.Action.Save",
		cancel = "Feature.Avatar.Label.Back"
	})

	local v11 = React.useCallback(function()
		v6(navigateWithLock(function()
			module.navigateToNextOverlay(v5, v9, {
				outfitType = v7,
				defaultName = v8,
				onComplete = onComplete,
				outfitId = param
			})
		end))
	end, { v5, v7, v8, onComplete, v9, param, v6 })

	local v12 = React.useCallback(function()
		module.closeOverlay(v5)
	end, { v5 })

	local v13 = React.useCallback(function()
		onComplete(v8, v12)
	end, { onComplete, v8, v12 })

	return {
		titleText = v10.title,
		bodyText = v10.body,
		confirmButtonText = v10.confirm,
		cancelButtonText = v10.cancel,
		onConfirm = v13,
		onClose = v11
	}
end

return useDuplicateOutfitNameDialogProps
