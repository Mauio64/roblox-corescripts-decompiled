local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/dMx")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dHK")
require("@luauforge/bundled/dMc")

require("@luauforge/deferred/giH")
local module3 = require("@luauforge/bundled/dTM")

local module4 = require("@luauforge/bundled/eeH")
local module5 = require("@luauforge/bundled/geT")
local module6 = require("@luauforge/deferred/ghk")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module7 = require("@luauforge/deferred/giK")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local isOutfitNameValid = AvatarExperienceCommon.Utils.isOutfitNameValid

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local v5 = {
	[module.OutfitTypes.Avatar] = {
		title = "Feature.Avatar.Label.Title.AvatarName",
		ok = "CommonUI.Controls.Action.OK",
		cancel = "Feature.Avatar.Action.Cancel"
	},
	[module.OutfitTypes.Makeup] = {
		title = "Feature.Avatar.Title.RenameMakeupLook",
		ok = "CommonUI.Controls.Action.OK",
		cancel = "Feature.Avatar.Action.Cancel"
	}
}

local function selectOutfitInfos(p2)
	return p2.AvatarExperience.AvatarEditor.OutfitInfos
end

local function useRenameOutfitDialogProps()
	local v6 = useNavigation()
	local v7 = v6.getParam("outfitId") or ""

	React.useEffect(function()
		if v7 == "" then
			module3.closeOverlay(v6)
			mutedError("outfitId is required")
		end
	end, { v7, v6 })

	local param = v6.getParam("defaultName")

	local v8 = useSelector(selectOutfitInfos)[v7] or {}

	local outfitType = v8.outfitType or module.OutfitTypes.Avatar
	local v9 = param or v8.name or ""

	local v10 = module4(module5)

	local v11 = useDispatch()

	local v12 = useLocalization(v5[outfitType])

	local v13 = React.useCallback(function()
		module3.closeOverlay(v6)
	end, { v6 })

	local v14 = module7(outfitType, v7)

	local v15 = React.useCallback(function(p2, callback)
		v11(module6(v10, v7, p2))
		callback()
	end, { v11, v10, v7 })

	local v16 = React.useCallback(function(p2)
		if p2 == v8.name then
			v13()
		elseif v14(p2) then
			v11(navigateWithLock(function()
				module3.navigateToNextOverlay(v6, avatarScreen.DuplicateOutfitNameDialog, {
					outfitName = p2,
					outfitType = outfitType,
					onComplete = v15,
					backScreen = avatarScreen.RenameOutfitDialog,
					outfitId = v7
				})
			end))
		else
			v15(p2, v13)
		end
	end, { v15, v14, v13, v8.name, v11, v6, outfitType, v7 })

	return {
		titleText = v12.title,
		confirmButtonText = v12.ok,
		cancelButtonText = v12.cancel,
		onClose = v13,
		onConfirm = v16,
		defaultText = v9,
		isTextValid = isOutfitNameValid
	}
end

return useRenameOutfitDialogProps
