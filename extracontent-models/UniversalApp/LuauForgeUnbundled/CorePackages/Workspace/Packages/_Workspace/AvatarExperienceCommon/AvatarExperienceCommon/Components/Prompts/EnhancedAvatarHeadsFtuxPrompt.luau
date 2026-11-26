local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Localization").Hooks.useLocalization
local AXPartialPageModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/AXPartialPageModal/AXPartialPageModal")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local view = Foundation.View
local text = Foundation.Text
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/InputHandlers")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/FocusNavigationUtils").FocusNavigationEventNameEnum
local useFocusOnMountEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useFocusOnMountEffect")

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function EnhancedAvatarHeadsFtuxPrompt(p2)
	local v5 = useNavigation()
	local v6 = useLocalization({
		confirmButtonText = "Feature.Avatar.Action.GotIt",
		enhancedAvatarHeadsTitle = "Feature.Avatar.Title.EnhancedAvatarHeads",
		enhancedAvatarHeadsMessage = "Feature.Avatar.Message.EnhancedAvatarHeads"
	})

	local params = v5.state.params or {}
	local onConfirm = p2.onConfirm or params.onConfirm

	local v7 = React.useCallback(function()
		v5.goBack()
	end, { v5 })

	local v8 = React.useCallback(function()
		v7()

		if onConfirm then
			onConfirm()
		end
	end, { onConfirm, v7 })

	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local v9 = ReactFocusNavigation.useEventMap(navigateBacks, ref)
	local v10 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					p3.cancelled = true
					v8()
				end)
			}
		}
	end, { v8 })
	ReactFocusNavigation.useEventHandlerMap(v10, v9)

	React.useEffect(function()
		setState(true)
	end, {})

	useFocusOnMountEffect(ref, 0.15)

	local v11 = {
		ViewFrame = React.createElement(
			view,
			{
				tag = "col align-x-left align-y-top size-full-0 auto-y padding-bottom-xxlarge"
			},
			{
				PromptBodyTitle = React.createElement(text, {
					tag = "auto-xy padding-bottom-small padding-top-medium text-heading-small text-wrap text-align-x-left",
					Text = v6.enhancedAvatarHeadsTitle,
					LayoutOrder = 1
				}),
				PromptBodyText = React.createElement(text, {
					tag = "auto-xy text-body-large text-wrap text-align-x-left",
					Text = v6.enhancedAvatarHeadsMessage,
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
			onBackgroundPress = v8,
			buttonStackProps = {
				rowLayout = false,
				buttons = {
					{
						props = {
							onActivated = v8,
							text = v6.confirmButtonText,
							variant = buttonVariant.Emphasis,
							size = inputSize.Medium
						}
					}
				}
			}
		}, v11)
	})
end

return EnhancedAvatarHeadsFtuxPrompt
