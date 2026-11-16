local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dMx")

require("@luauforge/deferred/giH")
local module2 = require("@luauforge/bundled/dTM")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module3 = require("@luauforge/deferred/giK")
local isOutfitNameValid = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.isOutfitNameValid
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local v5 = {
	[module.OutfitTypes.Avatar] = {
		title = "Feature.Avatar.Label.Title.AvatarName",
		add = "Feature.Avatar.Label.Add",
		cancel = "Feature.Avatar.Action.Cancel"
	},
	[module.OutfitTypes.Makeup] = {
		title = "Feature.Avatar.Title.SaveMakeupLook",
		add = "Feature.Avatar.Label.Add",
		cancel = "Feature.Avatar.Action.Cancel"
	}
}

local function useAddOutfitDialogProps()
	local v6 = useNavigation()
	local v7 = v6.getParam("outfitType")

	if not v7 then
		v7 = module.OutfitTypes.Avatar
		mutedError("outfitType is missing")
	end

	local onComplete = v6.getParam("onComplete")

	if not onComplete then
		mutedError("onComplete is missing")

		onComplete = function(p2, p3) end
	end

	local param = v6.getParam("defaultName")

	local v8 = useLocalization(v5[v7])

	local v9 = React.useCallback(function()
		module2.closeOverlay(v6)
	end, { v6 })

	local v10 = useDispatch()

	local v11 = module3(v7)

	local v12 = React.useCallback(function(p2)
		if v11(p2) then
			v10(navigateWithLock(function()
				module2.navigateToNextOverlay(v6, avatarScreen.DuplicateOutfitNameDialog, {
					outfitName = p2,
					outfitType = v7,
					onComplete = onComplete,
					backScreen = avatarScreen.AddOutfitDialog
				})
			end))
		else
			onComplete(p2, v9)
		end
	end, { onComplete, v11, v9, v10, v6, v7 })

	return {
		titleText = v8.title,
		confirmButtonText = v8.add,
		cancelButtonText = v8.cancel,
		onClose = v9,
		onConfirm = v12,
		defaultText = param,
		isTextValid = isOutfitNameValid
	}
end

return useAddOutfitDialogProps
