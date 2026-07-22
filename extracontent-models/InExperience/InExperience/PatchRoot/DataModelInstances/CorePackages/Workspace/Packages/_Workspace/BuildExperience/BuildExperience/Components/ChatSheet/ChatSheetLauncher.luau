local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local ReactRoblox = require(BuildExperienceParent.ReactRoblox)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local ChatActionsRow = require(BuildExperience.Components.Chat.ChatActionsRow)
local TextArea = require(BuildExperience.FoundationFork.TextArea)
local useHardwareInsets = require(BuildExperience.FoundationFork.Sheet.useHardwareInsets)
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useOverlay = Foundation.Hooks.useOverlay
local useTokens = Foundation.Hooks.useTokens

local function noop() -- line: 28
end
local function ChatSheetLauncher(t1: {[any]: any}) -- line: 30
	-- upvalues: useTokens (copy), useOverlay (copy), useHardwareInsets (copy), React (copy), View (copy), TextArea (copy), noop (copy), LocalizationStrings (copy), InputSize (copy), ChatActionsRow (copy), StateLayerAffordance (copy), ReactRoblox (copy)
	local v18 = useTokens()
	local v19 = useOverlay()
	local bottom = useHardwareInsets(v19).bottom
	local Small = v18.Margin.Small
	local v22 = React.createElement(View, {
		tag = "size-full-0 auto-y",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		Background = React.createElement(View, {
			tag = "bg-surface-100",
			ZIndex = 0,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, bottom),
			Size = UDim2.new(1, 0, 1, bottom),
			selection = {
				Selectable = false
			}
		}),
		Content = React.createElement(View, {
			ZIndex = 1,
			tag = "col size-full-0 auto-y",
			padding = {
				top = UDim.new(0, Small),
				left = UDim.new(0, Small),
				right = UDim.new(0, Small),
				bottom = UDim.new(0, Small + bottom)
			},
			selection = {
				Selectable = false
			}
		}, {
			Composer = React.createElement(TextArea, {
				text = "",
				label = "",
				maxLines = 5,
				isDisabled = true,
				testId = "--chat-sheet-launcher-composer",
				onChanged = noop,
				placeholder = t1.placeholder or LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER,
				width = UDim.new(1, 0),
				size = InputSize.Large,
				trailingElement = React.createElement(View, {
					tag = "auto-xy padding-x-xsmall padding-y-small"
				}, {
					Actions = React.createElement(ChatActionsRow, {
						isAssistantResponding = false,
						isComposerEmpty = true,
						onSend = noop,
						onStop = noop
					})
				})
			})
		}),
		TapTarget = React.createElement(View, {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			onActivated = t1.onActivated,
			testId = t1.testId or "chat-sheet-launcher",
			selection = {
				Selectable = false
			},
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		})
	})

	if v19 == nil then
		return v22
	end

	return ReactRoblox.createPortal(v22, v19)
end

return ChatSheetLauncher
