local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local default = require(ParentParentParent.VoiceChatCore).CoreVoiceManager.default
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local ControlState = Foundation.Enums.ControlState
local Icon = Foundation.Icon
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local FoundationText = Foundation.Text
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization
local useScaledValue = Foundation.Hooks.useScaledValue
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useTokens = Foundation.Hooks.useTokens
local CaptureTriggerType = require(ParentParent.Enums.CaptureTriggerType)
local Constants = require(ParentParent.Constants)

return function(t1: {[any]: any}) -- line: 33
	-- upvalues: useLocalization (copy), useScaledValue (copy), useTokens (copy), React (copy), useSelector (copy), Constants (copy), ControlState (copy), default (copy), CaptureTriggerType (copy), View (copy), Popover (copy), Icon (copy), Foundation (copy), PopoverAlign (copy), FoundationText (copy)
	local v21 = useLocalization({
		voiceChatMutedLabel = "Feature.Captures.Label.VideoCaptureVoiceChatMutedTooltip",
		voiceChatMutedTitle = "Feature.Captures.Title.VideoCaptureVoiceChatMutedTooltip"
	})
	local v22 = useScaledValue(320)
	local v23 = useTokens()
	local v24, v25 = React.useState(false)
	local v26 = useSelector(function(p1) -- line: 43
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].IsVideoCaptureActive.triggerType
	end)
	local v27 = React.useCallback(function(p2) -- line: 47
		-- upvalues: ControlState (copy), v25 (copy), v24 (copy)
		if p2 == ControlState.Pressed then
			v25(not v24)
		end
	end, { v24 })
	local v28 = React.useCallback(function() -- line: 53
		-- upvalues: v25 (copy)
		v25(false)
	end, {})

	if not default:UserVoiceEnabled() or not default:IsInitialized() then
		return nil
	end

	if v26 ~= CaptureTriggerType.UserCapture and v26 ~= CaptureTriggerType.DeveloperCapture then
		return nil
	end

	if game:GetEngineFeature("ReenableMomentsVoice") then
		return nil
	end

	return React.createElement(View, {
		tag = "anchor-center-center clip position-center-center radius-circle size-700-700",
		LayoutOrder = t1.layoutOrder,
		onStateChanged = v27
	}, {
		Popover = React.createElement(Popover.Root, {
			isOpen = v24
		}, {
			Anchor = React.createElement(Popover.Anchor, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}, {
				DeafenIcon = React.createElement(Icon, {
					name = "icons/controls/headphoneDeafen_small",
					size = Foundation.Enums.IconSize.Small,
					style = v23.Color.Content.Emphasis
				})
			}),
			Content = React.createElement(Popover.Content, {
				hasArrow = false,
				align = PopoverAlign.Center,
				onPressedOutside = v28,
				side = {
					offset = v23.Size.Size_500,
					position = t1.popoverSide
				}
			}, {
				Tooltip = React.createElement(View, {
					tag = "auto-xy col gap-xsmall padding-y-small padding-x-medium",
					sizeConstraint = {
						MaxSize = Vector2.new(v22, 1e999)
					}
				}, {
					Title = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-truncate-end text-align-x-left text-title-small",
						Text = v21.voiceChatMutedTitle
					}),
					Subtitle = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-wrap text-align-x-left text-body-small",
						Text = v21.voiceChatMutedLabel
					})
				})
			})
		})
	})
end
