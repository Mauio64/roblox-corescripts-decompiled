local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local React = require(ChatLineReportingParent.React)
local Cryo = require(ChatLineReportingParent.Cryo)
local UIBlox = require(ChatLineReportingParent.UIBlox)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useLocalization = require(ChatLineReportingParent.Localization).Hooks.useLocalization
local FFlagChatLineReportingFocusFixesEnabled = require(ChatLineReportingParent.SharedFlags).FFlagChatLineReportingFocusFixesEnabled
local Constants = require(ChatLineReporting.Common.Constants)
local ChatLineReportInfo = require(ChatLineReporting.Components.ChatLineReportInfo)
local ChatLineReportModalWindow = require(ChatLineReporting.Components.ChatLineReportModalWindow)
local ChatLineReportSelectableLine = require(ChatLineReporting.Components.ChatLineReportSelectableLine)
local isSystemMessage = require(ChatLineReporting.Common.isSystemMessage)
local ChatLineSelectionMode = require(ChatLineReporting.Enums.ChatLineSelectionMode)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(ChatLineReportingParent.Foundation)
local Empty = Foundation.Empty
local RadioGroup = Foundation.RadioGroup
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local View = Foundation.View

local function ChatLineReportSelectionModal(t1: {[any]: any}) -- line: 46
	-- upvalues: ChatLineSelectionMode (copy), React (copy), useLocalization (copy), Constants (copy), Cryo (copy), isSystemMessage (copy), useLayerCollector (copy), FFlagChatLineReportingFocusFixesEnabled (copy), ChatLineReportModalWindow (copy), ButtonType (copy), ChatLineReportInfo (copy), View (copy), Empty (copy), ScrollView (copy), ScrollBarVisibility (copy), RadioGroup (copy), ChatLineReportSelectableLine (copy)
	local v24 = t1.mode or ChatLineSelectionMode.Radio
	local v25, v26 = React.useState(false)
	local v27 = React.useRef(nil)
	local v28, v29 = React.useState(0)
	local v30 = React.useRef(nil)
	local v31 = useLocalization(Constants.ChatLineLocalizationKeys)
	local v32 = React.useMemo(function() -- line: 54
		-- upvalues: Cryo (copy), t1 (copy), isSystemMessage (copy)
		return Cryo.List.filter(t1.messages, function(p1) -- line: 55
			-- upvalues: isSystemMessage (copy)
			return not isSystemMessage(p1)
		end)
	end, { t1.messages })
	local v33 = Cryo.isEmpty(v32)
	local v34 = useLayerCollector()
	local absoluteSize = v34.absoluteSize

	React.useEffect(function() -- line: 64
		-- upvalues: v27 (copy), v29 (copy)
		if v27.current then
			v27.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 66
				-- upvalues: v29 (copy), v27 (copy)
				v29(v27.current.AbsoluteSize.Y)
			end)
		end
	end, {
		v27.current,
		absoluteSize
	})
	React.useEffect(function() -- line: 73
		-- upvalues: v30 (copy), Constants (copy), FFlagChatLineReportingFocusFixesEnabled (copy)
		if v30.current then
			local ScrollingFrame = v30.current:FindFirstChildWhichIsA("ScrollingFrame", true)

			if ScrollingFrame then
				ScrollingFrame.CanvasPosition = Vector2.new(0, Constants.SelectionModalCanvasPositionTopPadding)

				if FFlagChatLineReportingFocusFixesEnabled then
					ScrollingFrame.Selectable = false
				end
			end
		end
	end, { v30.current })

	local v36 = React.useCallback(function() -- line: 85
		-- upvalues: v26 (copy)
		v26(function(p2) -- line: 86
			return not p2
		end)
	end, {})
	local v37 = React.useCallback(function(p3) -- line: 91
		-- upvalues: t1 (copy), v32 (copy), Constants (copy)
		if t1.setSelectedMessage then
			t1.setSelectedMessage(v32[p3])
		end

		t1.analyticsDispatch({
			type = Constants.AnalyticsActions.SetChatLineSelected,
			selected_chat_line_index = p3
		})
	end, {
		t1.setSelectedMessage,
		t1.analyticsDispatch
	})

	return React.createElement(ChatLineReportModalWindow, {
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y - v34.insets.top),
		position = if not t1.isCentered then UDim2.new(0.5, 0, 0, v34.insets.top + Constants.SelectionModalPositionOffset) else UDim2.fromScale(0.5, 0.5),
		anchorPoint = if not t1.isCentered then Vector2.new(0.5, 0) else Vector2.new(0.5, 0.5),
		title = v31.ChatSelectionModalTitle,
		onCloseClicked = t1.onBack,
		onInfoClicked = v36,
		buttonStackProps = if v24 ~= ChatLineSelectionMode.Radio then nil else {
			buttons = {{
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = t1.onContinue,
					text = v31.ChatSelectionModalButton,
					isDisabled = v33 or t1.selectedMessage == nil
				}
			}}
		}
	}, {
		infoView = React.createElement(ChatLineReportInfo, {
			visible = v25
		}),
		messageView = if not v33 then React.createElement(ScrollView, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, (math.min(absoluteSize.Y - v34.insets.top - Constants.SelectionModalScreenSizeOffset, v28, not t1.maxContentHeight and 1e999 or t1.maxContentHeight))),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				scrollBarVisibility = ScrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			},
			ref = v30
		}, React.createElement(View, {
			tag = "col auto-y padding-y-medium",
			Size = UDim2.new(1, 0, 0, 0),
			ref = v27
		}, {
			RadioList = v24 == ChatLineSelectionMode.Radio and React.createElement(RadioGroup.Root, {
				onValueChanged = v37
			}, Cryo.List.map(v32, function(p4, p5) -- line: 172
				-- upvalues: React (copy), RadioGroup (copy), ChatLineReportSelectableLine (copy), v31 (copy)
				return React.createElement(RadioGroup.Item, {
					key = p4.messageId,
					value = p5,
					label = React.createElement(ChatLineReportSelectableLine, {
						tag = "shrink",
						adjustForRadioGroup = true,
						scrollViewSizeX = 0,
						chatLineReportingReworkEnabled = true,
						message = p4,
						localizedText = v31
					})
				})
			end)),
			DirectList = v24 == ChatLineSelectionMode.Direct and React.createElement(View, {
				tag = "col size-full-0 auto-y padding-right-medium"
			}, Cryo.List.map(v32, function(p6, p7) -- line: 192
				-- upvalues: React (copy), View (copy), t1 (copy), Constants (copy), ChatLineReportSelectableLine (copy), v31 (copy)
				return React.createElement(View, {
					tag = "size-full-0 auto-y padding-small radius-medium",
					key = p6.messageId,
					onActivated = function() -- line: 198
						-- upvalues: t1 (copy), p6 (copy), Constants (copy), p7 (copy)
						if t1.setSelectedMessage then
							t1.setSelectedMessage(p6)
						end

						t1.analyticsDispatch({
							type = Constants.AnalyticsActions.SetChatLineSelected,
							selected_chat_line_index = p7
						})
						t1.onContinue(p6)
					end
				}, React.createElement(ChatLineReportSelectableLine, {
					scrollViewSizeX = 0,
					chatLineReportingReworkEnabled = true,
					message = p6,
					localizedText = v31
				}))
			end))
		})) else React.createElement(View, {
			tag = "margin-medium auto-xy"
		}, React.createElement(Empty, {
			text = v31.ChatSelectionModalNoMessages
		}))
	})
end

return React.memo(ChatLineReportSelectionModal)
