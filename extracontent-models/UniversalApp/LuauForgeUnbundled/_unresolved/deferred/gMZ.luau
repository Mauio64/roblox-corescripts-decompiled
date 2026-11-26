local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eie")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local module2 = require("@luauforge/deferred/gJI")

local module3 = require("@luauforge/deferred/gJH")
local module4 = require("@luauforge/bundled/dXh")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module5 = require("@luauforge/bundled/dWC")
local module6 = require("@luauforge/bundled/fCV")
local module7 = require("@luauforge/deferred/gNa")
local module8 = require("@luauforge/deferred/fDS")

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function selectPpeState(p2)
	return p2.AvatarExperience.ProfilePictureEditor
end

local function ProfilePictureEditorRevertToDefaultPrompt(p2)
	local v5 = useDispatch()
	local v6 = module(module8)

	local v7 = useSelector(selectScreenSize)
	local v8 = useSelector(selectPpeState)

	local function onActivated()
		module4.closeOverlay(p2.navigation)
	end

	local function fn()
		local lastSuccessfulPoseEmoteAssetId = v8.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId

		local rotateSliderValue = v8.CameraSliders.rotateSliderValue
		local yRotDegFromSliderValue = module6.getYRotDegFromSliderValue(rotateSliderValue)

		local fieldOfViewDeg = v8.ProfilePictureParams.fieldOfViewDeg or 30
		v5(module7(
			v6,
			module5.Closeup,
			lastSuccessfulPoseEmoteAssetId,
			-1,
			yRotDegFromSliderValue,
			fieldOfViewDeg
		))

		v5(module7(
			v6,
			module5.FullBody,
			lastSuccessfulPoseEmoteAssetId,
			-1,
			yRotDegFromSliderValue,
			fieldOfViewDeg
		))
	end

	local function onActivated2()
		fn()

		if p2.onBack then
			p2.onBack()
		else
			p2.navigation.navigate(avatarScreen.Catalog)
		end
	end

	local v9 = useLocalization({
		titleText = "Feature.Avatar.Title.RevertToDefault",
		bodyText = "Feature.Avatar.Message.RevertToDefault",
		revertButtonText = "Feature.Avatar.Action.Revert",
		cancelButtonText = "Feature.Avatar.Action.Cancel"
	})

	return React.createElement(interactiveAlert, {
		title = v9.titleText,
		bodyText = v9.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = onActivated, text = v9.cancelButtonText },
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = onActivated2, text = v9.revertButtonText },
					isDefaultChild = false
				}
			}
		},
		screenSize = v7
	})
end

return (module3((module2(ProfilePictureEditorRevertToDefaultPrompt))))
