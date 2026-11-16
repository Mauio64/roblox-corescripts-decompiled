local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local ChatActionsRow = require(BuildExperience.Components.Chat.ChatActionsRow)
local TextArea = require(BuildExperience.FoundationFork.TextArea)

local useHardwareInsets = require(script.Parent.useHardwareInsets)

local View = Foundation.View

local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useOverlay = Foundation.Hooks.useOverlay
local useTokens = Foundation.Hooks.useTokens

local function noop() end

local function ChatSheetLauncher(props)
	local v = useLocalization({
		composerPlaceholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER
	})

	local v2 = useTokens()
	local v3 = useOverlay()
	local bottom = useHardwareInsets(v3).bottom
	local small = v2.Margin.Small

	local element = React.createElement(
		View,
		{
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 0),
			tag = "size-full-0 auto-y"
		},
		{
			Background = React.createElement(View, {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, bottom),
				Size = UDim2.new(1, 0, 1, bottom),
				tag = "bg-surface-100",
				ZIndex = 0,
				selection = { Selectable = false }
			}),
			Content = React.createElement(View, {
				ZIndex = 1,
				tag = "col size-full-0 auto-y",
				padding = {
					top = UDim.new(0, small),
					left = UDim.new(0, small),
					right = UDim.new(0, small),
					bottom = UDim.new(0, small + bottom)
				},
				selection = { Selectable = false }
			}, {
				Composer = React.createElement(TextArea, {
					text = "",
					onChanged = noop,
					label = "",
					placeholder = props.placeholder or v.composerPlaceholder,
					width = UDim.new(1, 0),
					size = InputSize.Large,
					maxLines = 5,
					isDisabled = true,
					testId = "--chat-sheet-launcher-composer",
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
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 2,
				onActivated = props.onActivated,
				testId = props.testId or "chat-sheet-launcher",
				selection = { Selectable = false },
				stateLayer = { affordance = StateLayerAffordance.None }
			})
		}
	)

	if v3 == nil then
		return element
	end

	return ReactRoblox.createPortal(element, v3)
end

return ChatSheetLauncher
