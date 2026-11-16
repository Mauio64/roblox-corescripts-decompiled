local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)
local VoiceChatCore = require(parent2.VoiceChatCore)
local default = VoiceChatCore.CoreVoiceManager.default
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)

local ControlState = Foundation.Enums.ControlState
local Icon = Foundation.Icon
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local Text = Foundation.Text
local View = Foundation.View

local useLocalization = Localization.Hooks.useLocalization
local useScaledValue = Foundation.Hooks.useScaledValue
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens

local CaptureTriggerType = require(parent.Enums.CaptureTriggerType)
local Constants = require(parent.Constants)

return function(p)
	local v = useLocalization({
		voiceChatMutedLabel = "Feature.Captures.Label.VideoCaptureVoiceChatMutedTooltip",
		voiceChatMutedTitle = "Feature.Captures.Title.VideoCaptureVoiceChatMutedTooltip"
	})

	local v2 = useScaledValue(320)
	local v3 = useTokens()

	local state, setState = React.useState(false)

	local v4 = useSelector(function(p2)
		return p2[Constants.RoduxKey].IsVideoCaptureActive.triggerType
	end)

	local onStateChanged = React.useCallback(function(p2)
		if p2 == ControlState.Pressed then
			setState(not state)
		end
	end, { state })

	local onPressedOutside = React.useCallback(function()
		setState(false)
	end, {})

	if
		not (default:UserVoiceEnabled() and default:IsInitialized())
		or v4 ~= CaptureTriggerType.UserCapture and v4 ~= CaptureTriggerType.DeveloperCapture
		or game:GetEngineFeature("ReenableMomentsVoice")
	then
		return nil
	end

	return React.createElement(
		View,
		{
			LayoutOrder = p.layoutOrder,
			onStateChanged = onStateChanged,
			tag = "anchor-center-center clip position-center-center radius-circle size-700-700"
		},
		{
			Popover = React.createElement(Popover.Root, { isOpen = state }, {
				Anchor = React.createElement(
					Popover.Anchor,
					{ AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5) },
					{
						DeafenIcon = React.createElement(Icon, {
							name = "icons/controls/headphoneDeafen_small",
							size = Foundation.Enums.IconSize.Small,
							style = v3.Color.Content.Emphasis
						})
					}
				),
				Content = React.createElement(Popover.Content, {
					align = PopoverAlign.Center,
					hasArrow = false,
					onPressedOutside = onPressedOutside,
					side = { offset = v3.Size.Size_500, position = p.popoverSide }
				}, {
					Tooltip = React.createElement(View, {
						sizeConstraint = { MaxSize = Vector2.new(v2, 1e999) },
						tag = "auto-xy col gap-xsmall padding-y-small padding-x-medium"
					}, {
						Title = React.createElement(Text, {
							tag = "size-full-0 auto-y text-truncate-end text-align-x-left text-title-small",
							Text = v.voiceChatMutedTitle
						}),
						Subtitle = React.createElement(Text, {
							tag = "size-full-0 auto-y text-wrap text-align-x-left text-body-small",
							Text = v.voiceChatMutedLabel
						})
					})
				})
			})
		}
	)
end
