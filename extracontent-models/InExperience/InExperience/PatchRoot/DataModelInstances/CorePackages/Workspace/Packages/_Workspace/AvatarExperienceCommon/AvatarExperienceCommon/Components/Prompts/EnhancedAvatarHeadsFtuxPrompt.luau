local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AXPartialPageModal = require(AvatarExperienceCommon.Components.AXPartialPageModal.AXPartialPageModal)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusOnMountEffect = require(AvatarExperienceCommon.Hooks.useFocusOnMountEffect)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function EnhancedAvatarHeadsFtuxPrompt(p)
	local v = useNavigation()
	local v2 = useLocalization({
		confirmButtonText = "Feature.Avatar.Action.GotIt",
		enhancedAvatarHeadsTitle = "Feature.Avatar.Title.EnhancedAvatarHeads",
		enhancedAvatarHeadsMessage = "Feature.Avatar.Message.EnhancedAvatarHeads"
	})

	local params = v.state.params or {}
	local onConfirm = p.onConfirm or params.onConfirm

	local v3 = React.useCallback(function()
		v.goBack()
	end, { v })

	local v4 = React.useCallback(function()
		v3()

		if onConfirm then
			onConfirm()
		end
	end, { onConfirm, v3 })

	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local v5 = ReactFocusNavigation.useEventMap(navigateBacks, ref)
	local v6 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2)
					p2.cancelled = true
					v4()
				end)
			}
		}
	end, { v4 })
	ReactFocusNavigation.useEventHandlerMap(v6, v5)

	React.useEffect(function()
		setState(true)
	end, {})

	useFocusOnMountEffect(ref, 0.15)

	local v7 = {
		ViewFrame = React.createElement(
			View,
			{ tag = "col align-x-left align-y-top size-full-0 auto-y padding-bottom-xxlarge" },
			{
				PromptBodyTitle = React.createElement(Text, {
					tag = "auto-xy padding-bottom-small padding-top-medium text-heading-small text-wrap text-align-x-left",
					Text = v2.enhancedAvatarHeadsTitle,
					LayoutOrder = 1
				}),
				PromptBodyText = React.createElement(Text, {
					tag = "auto-xy text-body-large text-wrap text-align-x-left",
					Text = v2.enhancedAvatarHeadsMessage,
					LayoutOrder = 2
				})
			}
		)
	}

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ref = ref,
		SelectionGroup = true,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}, {
		Modal = React.createElement(AXPartialPageModal, {
			visible = state,
			onBackgroundPress = v4,
			buttonStackProps = {
				rowLayout = false,
				buttons = {
					{
						props = {
							onActivated = v4,
							text = v2.confirmButtonText,
							variant = ButtonVariant.Emphasis,
							size = InputSize.Medium
						}
					}
				}
			}
		}, v7)
	})
end

return EnhancedAvatarHeadsFtuxPrompt
