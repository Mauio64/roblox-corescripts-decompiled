local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Dialog = Foundation.Dialog
local RadioGroup = Foundation.RadioGroup
local Text = Foundation.Text
local View = Foundation.View

local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

local function GenerateTextOptionsDialog(props)
	local v = useCreationFlowStrings()
	local state, setState = React.useState("hype")

	local onActivated = React.useCallback(function()
		local v2

		if props.showTone then
			v2 = state
		end

		props.onSelect(v2)
	end, { props.showTone, state, props.onSelect })

	local createElement = React.createElement
	local tonePanel

	if props.showTone then
		tonePanel = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Heading = React.createElement(Text, {
				Text = v.ToneHeading,
				tag = "auto-xy text-title-medium content-default",
				LayoutOrder = 1
			}),
			Radios = React.createElement(
				RadioGroup.Root,
				{ value = state, onValueChanged = setState, LayoutOrder = 2 },
				{
					Hype = React.createElement(RadioGroup.Item, {
						value = "hype",
						label = v.ToneHype,
						LayoutOrder = 1
					}),
					Neutral = React.createElement(RadioGroup.Item, {
						value = "neutral",
						label = v.ToneNeutral,
						LayoutOrder = 2
					}),
					Cinematic = React.createElement(RadioGroup.Item, {
						value = "cinematic",
						label = v.ToneCinematic,
						LayoutOrder = 3
					}),
					Funny = React.createElement(RadioGroup.Item, {
						value = "funny",
						label = v.ToneFunny,
						LayoutOrder = 4
					})
				}
			)
		})
	end

	local v2 = {
		Layout = createElement(View, { tag = "col gap-medium size-full-0 auto-y" }, {
			TonePanel = tonePanel
		})
	}

	return React.createElement(
		Dialog.Root,
		{
			disablePortal = false,
			hasBackdrop = true,
			onClose = props.onCancel,
			size = Foundation.Enums.DialogSize.Medium
		},
		{
			DialogTitle = React.createElement(Dialog.Title, {
				text = v.GenerateTextOptionsTitle,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, v2),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v.GenerateTextCta,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = onActivated
					},
					{
						text = v.GeneralCtaCancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onCancel
					}
				}
			})
		}
	)
end

return GenerateTextOptionsDialog
