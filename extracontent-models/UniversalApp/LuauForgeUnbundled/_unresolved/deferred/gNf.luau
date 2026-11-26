local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local module2 = require("@luauforge/deferred/gJI")
local actions = RoactNavigation.Actions

local slotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local defineFastFlag = game:DefineFastFlag("AXEnableCloseButtonOnBlockingSavePrompt", false)

local defineFastFlag2 = game:DefineFastFlag("AXEnableBackgroundCloseBlockingSavePrompt", false)

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function SaveAvatarOnLeaveAvatarExperiencePrompt(p2)
	local v5 = useNavigation()
	local v6 = useSelector(selectScreenSize)
	local param = v5.getParam("saveAndContinue")
	local param2 = v5.getParam("continueWithoutSave")

	local v7 = useLocalization({
		saveButtonLabel = "Feature.Avatar.Action.Save",
		leaveButtonLabel = "Feature.Avatar.Action.Leave",
		saveTitle = "Feature.Avatar.Label.Title.BlockingSavePrompt",
		saveBodyText = "Feature.Avatar.Label.Message.BlockingSavePrompt"
	})

	local v8 = useCallback(function()
		v5.dispatch(actions.back({ immediate = true }))
	end, { v5 })

	local v9 = useCallback(function()
		if param then
			param()
		end

		slotBasedEditorAnalytics.trackSaveBlockPromptSaveClick()
		v8()
	end, { param, v8 })

	local v10 = useCallback(function()
		if param2 then
			param2()
		end

		slotBasedEditorAnalytics.trackSaveBlockPromptLeaveClick()
		v8()
	end, { param2, v8 })

	return React.createElement("TextButton", {
		Text = "",
		AutoButtonColor = false,
		Selectable = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		[React.Event.Activated] = function()
			if defineFastFlag2 then
				v8()
			end
		end,
		ZIndex = 3
	}, {
		SaveOnLeavePrompt = React.createElement(interactiveAlert, {
			title = v7.saveTitle,
			bodyText = v7.saveBodyText,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.Secondary,
						props = { onActivated = v10, text = v7.leaveButtonLabel }
					},
					{
						buttonType = buttonType.PrimaryContextual,
						props = { onActivated = v9, text = v7.saveButtonLabel }
					}
				}
			},
			screenSize = v6,
			onCloseClicked = if defineFastFlag then v8 else nil
		})
	})
end

return (module2(SaveAvatarOnLeaveAvatarExperiencePrompt))
