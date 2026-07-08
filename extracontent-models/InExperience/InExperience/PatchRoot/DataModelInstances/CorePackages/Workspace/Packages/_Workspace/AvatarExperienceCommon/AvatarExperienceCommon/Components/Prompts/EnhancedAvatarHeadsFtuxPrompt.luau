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
local FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss = require(AvatarExperienceCommonParent.AvatarExperienceFlags).FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function EnhancedAvatarHeadsFtuxPrompt(t2: {[any]: any}) -- line: 32
	-- upvalues: useNavigation (copy), useLocalization (copy), React (copy), FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useFocusOnMountEffect (copy), View (copy), FoundationText (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy)
	local v20 = useNavigation()
	local v21 = useLocalization({
		confirmButtonText = "Feature.Avatar.Action.GotIt",
		enhancedAvatarHeadsTitle = "Feature.Avatar.Title.EnhancedAvatarHeads",
		enhancedAvatarHeadsMessage = "Feature.Avatar.Message.EnhancedAvatarHeads"
	})
	local v22 = v20.state.params or {}
	local v23 = t2.onConfirm or v22.onConfirm
	local v24 = React.useCallback(function() -- line: 43
		-- upvalues: v20 (copy)
		v20.goBack()
	end, { v20 })
	local v25 = React.useCallback(function() -- line: 47
		-- upvalues: v24 (copy), v23 (copy)
		v24()

		if v23 then
			v23()
		end
	end, {
		v23,
		v24
	})
	local v26, v27 = React.useState(false)
	local v28 = nil

	if FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss then
		v28 = React.useRef(nil)
	end

	if FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss then
		local v29 = ReactFocusNavigation.useEventMap(t1, v28)
		local v30 = React.useMemo(function() -- line: 62
			-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v25 (copy)
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(p1) -- line: 65
						-- upvalues: v25 (copy)
						p1.cancelled = true
						v25()
					end)
				}
			}
		end, { v25 })

		ReactFocusNavigation.useEventHandlerMap(v30, v29)
	end

	React.useEffect(function() -- line: 75
		-- upvalues: v27 (copy)
		v27(true)
	end, {})

	if FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss then
		useFocusOnMountEffect(v28, 0.15)
	end

	local function v31() -- line: 86
		-- upvalues: React (copy), View (copy), FoundationText (copy), v21 (copy)
		return {
			ViewFrame = React.createElement(View, {
				tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
			}, {
				PromptBodyTitle = React.createElement(FoundationText, {
					tag = "auto-xy padding-bottom-small padding-top-medium text-align-x-left text-heading-small text-wrap",
					LayoutOrder = 1,
					Text = v21.enhancedAvatarHeadsTitle
				}),
				PromptBodyText = React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left text-body-large text-wrap",
					LayoutOrder = 2,
					Text = v21.enhancedAvatarHeadsMessage
				})
			})
		}
	end

	if FFlagAXEnhancedAvatarHeadsFtuxConsoleDismiss then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			SelectionGroup = true,
			Size = UDim2.fromScale(1, 1),
			ref = v28,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}, {
			Modal = React.createElement(AXPartialPageModal, {
				visible = v26,
				onBackgroundPress = v25,
				buttonStackProps = {
					rowLayout = false,
					buttons = {{
						props = {
							onActivated = v25,
							text = v21.confirmButtonText,
							variant = ButtonVariant.Emphasis,
							size = InputSize.Medium
						}
					}}
				}
			}, (v31()))
		})
	end

	return (React.createElement(AXPartialPageModal, {
		visible = v26,
		onBackgroundPress = v25,
		buttonStackProps = {
			rowLayout = false,
			buttons = {{
				props = {
					onActivated = v25,
					text = v21.confirmButtonText,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium
				}
			}}
		}
	}, (v31())))
end

return EnhancedAvatarHeadsFtuxPrompt
