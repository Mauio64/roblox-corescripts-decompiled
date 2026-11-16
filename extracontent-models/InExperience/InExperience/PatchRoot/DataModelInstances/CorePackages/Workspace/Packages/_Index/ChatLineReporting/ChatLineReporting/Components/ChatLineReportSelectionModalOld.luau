local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Constants = require(ChatLineReporting.Common.Constants)
local ChatLineReportInfo = require(ChatLineReporting.Components.ChatLineReportInfo)
local ChatLineReportModalWindow = require(ChatLineReporting.Components.ChatLineReportModalWindow)
local ChatLineReportSelectableLine = require(ChatLineReporting.Components.ChatLineReportSelectableLine)
local isSystemMessage = require(ChatLineReporting.Common.isSystemMessage)

local FFlagChatLineSelectionModalCleanupSizeListeners = require(ChatLineReporting.Flags.FFlagChatLineSelectionModalCleanupSizeListeners)

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(parent.Foundation)
local Empty = Foundation.Empty
local RadioGroup = Foundation.RadioGroup
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local function createChildren(messages, _, localizedText, state)
	local v = -1
	local result = {}
	local children = {}

	for k, item in pairs(messages) do
		if isSystemMessage(item) then
			continue
		end

		v += 1
		result[k] = v

		table.insert(children, React.createElement(RadioGroup.Item, {
			value = k,
			label = React.createElement(ChatLineReportSelectableLine, {
				message = item,
				localizedText = localizedText,
				scrollViewSizeX = state
			})
		}))
	end

	return children, result
end

local function useAbsoluteSizeListener(fn, p)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(fn)
	ref2.current = fn

	return React.useCallback(function(current)
		if p then
			p.current = current
		end

		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end

		if current then
			ref.current = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				ref2.current(current)
			end)
		end
	end, {})
end

local function ChatLineReportSelectionModalOld(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(0)
	local ref2 = React.useRef(nil)
	local state3, setState3 = React.useState(0)
	local ref3 = React.useRef(nil)
	local localizedText = useLocalization(Constants.ChatLineLocalizationKeys)

	local children, v = createChildren(props.messages, props.setSelectedMessage, localizedText, state3)
	local empty = Cryo.isEmpty(children)

	local v2 = useLayerCollector()
	local absoluteSize = v2.absoluteSize
	local ref4, ref5

	if FFlagChatLineSelectionModalCleanupSizeListeners then
		ref4 = useAbsoluteSizeListener(function(p)
			setState2(p.AbsoluteSize.Y)
		end)
		ref5 = useAbsoluteSizeListener(function(p)
			setState3(p.AbsoluteSize.X)
		end, ref2)
	end

	React.useEffect(function()
		if FFlagChatLineSelectionModalCleanupSizeListeners then
			return
		end

		if ref.current then
			ref.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState2(ref.current.AbsoluteSize.Y)
			end)
		end
	end, { ref.current, absoluteSize })

	React.useEffect(function()
		if FFlagChatLineSelectionModalCleanupSizeListeners then
			return
		end

		if ref2.current then
			ref2.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState3(ref2.current.AbsoluteSize.X)
			end)
		end
	end, { ref2.current, absoluteSize })

	React.useEffect(function()
		local scrollingFrame = ref2.current and ref2.current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if scrollingFrame then
			ref3.current = scrollingFrame
			ref3.current.CanvasPosition = Vector2.new(0, Constants.SelectionModalCanvasPositionTopPadding)
			ref3.current.Selectable = false
		end
	end, { ref2.current })

	local onInfoClicked = React.useCallback(function()
		setState(not state)
	end, { state, setState })

	local createElement = React.createElement
	local v3 = {
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y - v2.insets.top),
		position = UDim2.new(0.5, 0, 0, v2.insets.top + Constants.SelectionModalPositionOffset),
		anchorPoint = Vector2.new(0.5, 0),
		title = localizedText.ChatSelectionModalTitle,
		onCloseClicked = props.onBack,
		onInfoClicked = onInfoClicked,
		buttonStackProps = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = props.onContinue,
						text = localizedText.ChatSelectionModalButton,
						isDisabled = empty or props.selectedMessage == nil
					}
				}
			}
		}
	}

	local v4 = {
		infoView = React.createElement(ChatLineReportInfo, { visible = state }),
		messageView = 0
	}
	local messageView

	if empty then
		messageView = React.createElement(Empty, {})
	else
		local createElement2 = React.createElement
		local v5 = {
			Size = UDim2.new(
				1,
				0,
				0,
				(math.min(
					absoluteSize.Y - v2.insets.top - Constants.SelectionModalScreenSizeOffset,
					state2 + Constants.SelectionModalRadioGroupOffset,
					not props.maxContentHeight and 1e999 or props.maxContentHeight
				))
			),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				scrollBarVisibility = ScrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			ref = 0,
			LayoutOrder = 1
		}

		if not FFlagChatLineSelectionModalCleanupSizeListeners then
			ref5 = ref2
		end

		v5.ref = ref5

		local v6 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12)
			}),
			RadioGroup = 0
		}

		local createElement3 = React.createElement
		local root = RadioGroup.Root
		local v7 = {
			onValueChanged = function(p)
				props.setSelectedMessage(props.messages[p])
				props.analyticsDispatch({
					type = Constants.AnalyticsActions.SetChatLineSelected,
					selected_chat_line_index = v[p]
				})
			end,
			ref = 0
		}

		if not FFlagChatLineSelectionModalCleanupSizeListeners then
			ref4 = ref
		end

		v7.ref = ref4
		v6.RadioGroup = createElement3(root, v7, children)
		messageView = createElement2(ScrollView, v5, v6)
	end

	v4.messageView = messageView
	return createElement(ChatLineReportModalWindow, v3, v4)
end

return ChatLineReportSelectionModalOld
