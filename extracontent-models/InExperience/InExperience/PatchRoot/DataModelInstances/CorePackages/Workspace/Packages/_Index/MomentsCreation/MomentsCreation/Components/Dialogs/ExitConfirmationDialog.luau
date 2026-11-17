local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts

local Dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
local creationFlowStrings = require(MomentsCreation.creationFlowStrings)

return function(props)
	local v = useCreationFlowStrings()
	local v2

	if FFlagMomentsCreateAvatarPosts then
		v2 = useLocalization({
			body = props.bodyLocalizationKey or creationFlowStrings.LeaveMomentCreationBody
		})
	end

	local createElement = React.createElement
	local root = Dialog.Root
	local v3 = {
		disablePortal = false,
		size = Foundation.Enums.DialogSize.Medium,
		hasBackdrop = true
	}

	local children = {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v.LeaveMomentCreationTitle,
			LayoutOrder = 1
		}),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content

	local createElement3 = React.createElement
	local text = Dialog.Text
	local text2

	if FFlagMomentsCreateAvatarPosts then
		text2 = v2.body
	else
		text2 = v.LeaveMomentCreationBody
	end

	children.DialogContent = createElement2(content, { LayoutOrder = 2 }, {
		DialogText = createElement3(text, { Text = text2 })
	})

	children.DialogActions = React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = v.GeneralCtaLeave,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				onActivated = props.onConfirm
			},
			{
				text = v.GeneralCtaCancel,
				variant = Foundation.Enums.ButtonVariant.Standard,
				onActivated = props.onCancel
			}
		}
	})
	return createElement(root, v3, children)
end
