local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local Utils = require(Modules.AvatarExperience.ProfilePictureEditor.Utils)
local WritePPEConfig = require(Modules.AvatarExperience.ProfilePictureEditor.Thunks.WritePPEConfig)
local Analytics = require(Modules.AvatarExperience.ProfilePictureEditor.Services.Analytics)

local function selectScreenSize(p1) -- line: 37
	return p1.ScreenSize
end
local function selectPpeState(p2) -- line: 41
	return p2.AvatarExperience.ProfilePictureEditor
end
local function ProfilePictureEditorRevertToDefaultPrompt(t1: {[any]: any}) -- line: 45
	-- upvalues: useDispatch (copy), useRoactService (copy), Analytics (copy), useSelector (copy), selectScreenSize (copy), selectPpeState (copy), NavigationUtils (copy), Utils (copy), WritePPEConfig (copy), PPEThumbnailType (copy), AvatarScreen (copy), useLocalization (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v25 = useDispatch()
	local v26 = useRoactService(Analytics)
	local v27 = useSelector(selectScreenSize)
	local v28 = useSelector(selectPpeState)

	local function v29() -- line: 56
		-- upvalues: v28 (copy), Utils (copy), v25 (copy), WritePPEConfig (copy), v26 (copy), PPEThumbnailType (copy)
		local lastSuccessfulPoseEmoteAssetId = v28.ProfilePictureParams.lastSuccessfulPoseEmoteAssetId
		local rotateSliderValue = v28.CameraSliders.rotateSliderValue
		local v33 = Utils.getYRotDegFromSliderValue(rotateSliderValue)
		local v34 = v28.ProfilePictureParams.fieldOfViewDeg or 30

		v25(WritePPEConfig(v26, PPEThumbnailType.Closeup, lastSuccessfulPoseEmoteAssetId, -1, v33, v34))
		v25(WritePPEConfig(v26, PPEThumbnailType.FullBody, lastSuccessfulPoseEmoteAssetId, -1, v33, v34))
	end

	local v30 = useLocalization({
		titleText = "Feature.Avatar.Title.RevertToDefault",
		bodyText = "Feature.Avatar.Message.RevertToDefault",
		revertButtonText = "Feature.Avatar.Action.Revert",
		cancelButtonText = "Feature.Avatar.Action.Cancel"
	})

	return React.createElement(InteractiveAlert, {
		title = v30.titleText,
		bodyText = v30.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = function() -- line: 52
							-- upvalues: NavigationUtils (copy), t1 (copy)
							NavigationUtils.closeOverlay(t1.navigation)
						end,
						text = v30.cancelButtonText
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = function() -- line: 90
							-- upvalues: v29 (copy), t1 (copy), AvatarScreen (copy)
							v29()

							if t1.onBack then
								t1.onBack()

								return
							end

							t1.navigation.navigate(AvatarScreen.Catalog)
						end,
						text = v30.revertButtonText
					}
				}
			}
		},
		screenSize = v27
	})
end

return (withMappedNavigationParams((withOverlayFocusHandling(ProfilePictureEditorRevertToDefaultPrompt))))
