local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsCreateAvatarPosts

local dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
local creationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/creationFlowStrings")

return function(props)
	local v5 = useCreationFlowStrings()
	local v6

	if fFlagMomentsCreateAvatarPosts then
		v6 = useLocalization({
			body = props.bodyLocalizationKey or creationFlowStrings.LeaveMomentCreationBody
		})
	end

	local createElement = React.createElement
	local root = dialog.Root
	local v7 = {
		disablePortal = false,
		size = Foundation.Enums.DialogSize.Medium,
		hasBackdrop = true
	}

	local children = {
		DialogTitle = React.createElement(dialog.Title, {
			text = v5.LeaveMomentCreationTitle,
			LayoutOrder = 1
		}),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	local createElement3 = React.createElement
	local text = dialog.Text
	local v11 = if fFlagMomentsCreateAvatarPosts then v6.body else v5.LeaveMomentCreationBody
	children.DialogContent = createElement2(content, { LayoutOrder = 2 }, {
		DialogText = createElement3(text, { Text = v11 })
	})

	children.DialogActions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = v5.GeneralCtaLeave,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				onActivated = props.onConfirm
			},
			{
				text = v5.GeneralCtaCancel,
				variant = Foundation.Enums.ButtonVariant.Standard,
				onActivated = props.onCancel
			}
		}
	})
	return createElement(root, v7, children)
end
