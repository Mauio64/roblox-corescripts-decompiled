local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local Actions = RoactNavigation.Actions
local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics
local v16 = game:DefineFastFlag("AXEnableCloseButtonOnBlockingSavePrompt", false)
local v17 = game:DefineFastFlag("AXEnableBackgroundCloseBlockingSavePrompt", false)

local function selectScreenSize(p1) -- line: 30
	return p1.ScreenSize
end
local function SaveAvatarOnLeaveAvatarExperiencePrompt(_: {[any]: any}) -- line: 34
	-- upvalues: useNavigation (copy), useSelector (copy), selectScreenSize (copy), useLocalization (copy), useCallback (copy), Actions (copy), SlotBasedEditorAnalytics (copy), React (copy), v17 (copy), InteractiveAlert (copy), ButtonType (copy), v16 (copy)
	local v22 = useNavigation()
	local v23 = useSelector(selectScreenSize)
	local v24 = v22.getParam("saveAndContinue")
	local v25 = v22.getParam("continueWithoutSave")
	local v26 = useLocalization({
		saveButtonLabel = "Feature.Avatar.Action.Save",
		leaveButtonLabel = "Feature.Avatar.Action.Leave",
		saveTitle = "Feature.Avatar.Label.Title.BlockingSavePrompt",
		saveBodyText = "Feature.Avatar.Label.Message.BlockingSavePrompt"
	})
	local v27 = useCallback(function() -- line: 47
		-- upvalues: v22 (copy), Actions (copy)
		v22.dispatch(Actions.back({
			immediate = true
		}))
	end, { v22 })
	local v28 = useCallback(function() -- line: 53
		-- upvalues: v24 (copy), SlotBasedEditorAnalytics (copy), v27 (copy)
		if v24 then
			v24()
		end

		SlotBasedEditorAnalytics.trackSaveBlockPromptSaveClick()
		v27()
	end, {
		v24,
		v27
	})
	local v29 = useCallback(function() -- line: 61
		-- upvalues: v25 (copy), SlotBasedEditorAnalytics (copy), v27 (copy)
		if v25 then
			v25()
		end

		SlotBasedEditorAnalytics.trackSaveBlockPromptLeaveClick()
		v27()
	end, {
		v25,
		v27
	})

	return React.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		Selectable = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[React.Event.Activated] = function() -- line: 79
			-- upvalues: v17 (copy), v27 (copy)
			if v17 then
				v27()
			end
		end,
		ZIndex = 3
	}, {
		SaveOnLeavePrompt = React.createElement(InteractiveAlert, {
			title = v26.saveTitle,
			bodyText = v26.saveBodyText,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = v29,
							text = v26.leaveButtonLabel
						}
					},
					{
						buttonType = ButtonType.PrimaryContextual,
						props = {
							onActivated = v28,
							text = v26.saveButtonLabel
						}
					}
				}
			},
			screenSize = v23,
			onCloseClicked = if not v16 then nil else v27
		})
	})
end

return (withOverlayFocusHandling(SaveAvatarOnLeaveAvatarExperiencePrompt))
