local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local dialog = Foundation.Dialog
local radioGroup = Foundation.RadioGroup
local text = Foundation.Text
local view = Foundation.View

local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")

local function GenerateTextOptionsDialog(props)
	local v5 = useCreationFlowStrings()
	local state, setState = React.useState("hype")

	local v6 = React.useCallback(function()
		local v7 = if props.showTone then state else nil
		props.onSelect(v7)
	end, { props.showTone, state, props.onSelect })

	local createElement = React.createElement

	local v11 = if props.showTone then React.createElement(
		view,
		{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 1 },
		{
			Heading = React.createElement(text, {
				Text = v5.ToneHeading,
				tag = "auto-xy text-title-medium content-default",
				LayoutOrder = 1
			}),
			Radios = React.createElement(
				radioGroup.Root,
				{ value = state, onValueChanged = setState, LayoutOrder = 2 },
				{
					Hype = React.createElement(radioGroup.Item, {
						value = "hype",
						label = v5.ToneHype,
						LayoutOrder = 1
					}),
					Neutral = React.createElement(radioGroup.Item, {
						value = "neutral",
						label = v5.ToneNeutral,
						LayoutOrder = 2
					}),
					Cinematic = React.createElement(radioGroup.Item, {
						value = "cinematic",
						label = v5.ToneCinematic,
						LayoutOrder = 3
					}),
					Funny = React.createElement(radioGroup.Item, {
						value = "funny",
						label = v5.ToneFunny,
						LayoutOrder = 4
					})
				}
			)
		}
	) else nil
	local v7 = {
		Layout = createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, {
			TonePanel = v11
		})
	}

	return React.createElement(
		dialog.Root,
		{
			disablePortal = false,
			hasBackdrop = true,
			onClose = props.onCancel,
			size = Foundation.Enums.DialogSize.Medium
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = v5.GenerateTextOptionsTitle,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, v7),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v5.GenerateTextCta,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = v6
					},
					{
						text = v5.GeneralCtaCancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onCancel
					}
				}
			})
		}
	)
end

return GenerateTextOptionsDialog
