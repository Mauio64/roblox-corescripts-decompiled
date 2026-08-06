local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local useNavigation = require(AvatarExperienceCommonParent.Navigation).useNavigation
local useLocalization = require(AvatarExperienceCommonParent.Localization).Hooks.useLocalization
local AXPartialPageModal = require(AvatarExperienceCommon.Components.AXPartialPageModal.AXPartialPageModal)
local Foundation = require(AvatarExperienceCommonParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local ReactFocusNavigation = require(AvatarExperienceCommonParent.ReactFocusNavigation)
local InputHandlers = require(AvatarExperienceCommonParent.InputHandlers)
local FocusNavigationEventNameEnum = require(AvatarExperienceCommonParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local useFocusOnMountEffect = require(AvatarExperienceCommon.Hooks.useFocusOnMountEffect)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function EnhancedAvatarHeadsFtuxPrompt(t2: {[any]: any}) -- line: 29
	-- upvalues: useNavigation (copy), useLocalization (copy), React (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useFocusOnMountEffect (copy), View (copy), FoundationText (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy)
	local v19 = useNavigation()
	local v20 = useLocalization({
		confirmButtonText = "Feature.Avatar.Action.GotIt",
		enhancedAvatarHeadsTitle = "Feature.Avatar.Title.EnhancedAvatarHeads",
		enhancedAvatarHeadsMessage = "Feature.Avatar.Message.EnhancedAvatarHeads"
	})
	local v21 = v19.state.params or {}
	local v22 = t2.onConfirm or v21.onConfirm
	local v23 = React.useCallback(function() -- line: 40
		-- upvalues: v19 (copy)
		v19.goBack()
	end, { v19 })
	local v24 = React.useCallback(function() -- line: 44
		-- upvalues: v23 (copy), v22 (copy)
		v23()

		if v22 then
			v22()
		end
	end, {
		v22,
		v23
	})
	local v25, v26 = React.useState(false)
	local v27 = React.useRef(nil)
	local v28 = ReactFocusNavigation.useEventMap(t1, v27)
	local v29 = React.useMemo(function() -- line: 55
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v24 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 58
					-- upvalues: v24 (copy)
					p1.cancelled = true
					v24()
				end)
			}
		}
	end, { v24 })

	ReactFocusNavigation.useEventHandlerMap(v29, v28)
	React.useEffect(function() -- line: 67
		-- upvalues: v26 (copy)
		v26(true)
	end, {})
	useFocusOnMountEffect(v27, 0.15)

	local t3 = {
		ViewFrame = React.createElement(View, {
			tag = "col align-x-left align-y-top size-full-0 auto-y padding-bottom-xxlarge"
		}, {
			PromptBodyTitle = React.createElement(FoundationText, {
				tag = "auto-xy padding-bottom-small padding-top-medium text-heading-small text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = v20.enhancedAvatarHeadsTitle
			}),
			PromptBodyText = React.createElement(FoundationText, {
				tag = "auto-xy text-body-large text-wrap text-align-x-left",
				LayoutOrder = 2,
				Text = v20.enhancedAvatarHeadsMessage
			})
		})
	}

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		SelectionGroup = true,
		Size = UDim2.fromScale(1, 1),
		ref = v27,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}, {
		Modal = React.createElement(AXPartialPageModal, {
			visible = v25,
			onBackgroundPress = v24,
			buttonStackProps = {
				rowLayout = false,
				buttons = {{
					props = {
						onActivated = v24,
						text = v20.confirmButtonText,
						variant = ButtonVariant.Emphasis,
						size = InputSize.Medium
					}
				}}
			}
		}, t3)
	})
end

return EnhancedAvatarHeadsFtuxPrompt
