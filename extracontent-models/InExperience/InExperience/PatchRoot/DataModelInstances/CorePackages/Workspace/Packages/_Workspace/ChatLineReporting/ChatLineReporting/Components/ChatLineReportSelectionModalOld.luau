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
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(ChatLineReportingParent.Foundation)
local Empty = Foundation.Empty
local RadioGroup = Foundation.RadioGroup
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local function createChildren(p1, _, p3, p4) -- line: 44
	-- upvalues: isSystemMessage (copy), React (copy), RadioGroup (copy), ChatLineReportSelectableLine (copy)
	local t1 = {}
	local t2 = {}
	local n1 = -1

	for k, v in pairs(p1) do
		if not isSystemMessage(v) then
			n1 += 1
			t2[k] = n1
			table.insert(t1, React.createElement(RadioGroup.Item, {
				value = k,
				label = React.createElement(ChatLineReportSelectableLine, {
					chatLineReportingReworkEnabled = false,
					message = v,
					localizedText = p3,
					scrollViewSizeX = p4
				})
			}))
		end
	end

	return t1, t2
end
local function ChatLineReportSelectionModalOld(t3: {[any]: any}) -- line: 72
	-- upvalues: React (copy), useLocalization (copy), Constants (copy), createChildren (copy), Cryo (copy), useLayerCollector (copy), FFlagChatLineReportingFocusFixesEnabled (copy), ChatLineReportModalWindow (copy), ButtonType (copy), ChatLineReportInfo (copy), Empty (copy), ScrollView (copy), ScrollBarVisibility (copy), RadioGroup (copy)
	local v32, v33 = React.useState(false)
	local v34 = React.useRef(nil)
	local v35, v36 = React.useState(0)
	local v37 = React.useRef(nil)
	local v38, v39 = React.useState(0)
	local v40 = React.useRef(nil)
	local v41 = useLocalization(Constants.ChatLineLocalizationKeys)
	local v42, v43 = createChildren(t3.messages, t3.setSelectedMessage, v41, v38)
	local v44 = Cryo.isEmpty(v42)
	local v45 = useLayerCollector()
	local absoluteSize = v45.absoluteSize

	React.useEffect(function() -- line: 87
		-- upvalues: v34 (copy), v36 (copy)
		if v34.current then
			v34.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 89
				-- upvalues: v36 (copy), v34 (copy)
				v36(v34.current.AbsoluteSize.Y)
			end)
		end
	end, {
		v34.current,
		absoluteSize
	})
	React.useEffect(function() -- line: 95
		-- upvalues: v37 (copy), v39 (copy)
		if v37.current then
			v37.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 97
				-- upvalues: v39 (copy), v37 (copy)
				v39(v37.current.AbsoluteSize.X)
			end)
		end
	end, {
		v37.current,
		absoluteSize
	})
	React.useEffect(function() -- line: 104
		-- upvalues: v37 (copy), v40 (copy), Constants (copy), FFlagChatLineReportingFocusFixesEnabled (copy)
		if v37.current then
			local ScrollingFrame = v37.current:FindFirstChildWhichIsA("ScrollingFrame", true)

			if ScrollingFrame then
				v40.current = ScrollingFrame
				v40.current.CanvasPosition = Vector2.new(0, Constants.SelectionModalCanvasPositionTopPadding)

				if FFlagChatLineReportingFocusFixesEnabled then
					v40.current.Selectable = false
				end
			end
		end
	end, { v37.current })

	local v47 = React.useCallback(function() -- line: 118
		-- upvalues: v33 (copy), v32 (copy)
		v33(not v32)
	end, {
		v32,
		v33
	})

	return React.createElement(ChatLineReportModalWindow, {
		screenSize = Vector2.new(absoluteSize.X, absoluteSize.Y - v45.insets.top),
		position = UDim2.new(0.5, 0, 0, v45.insets.top + Constants.SelectionModalPositionOffset),
		anchorPoint = Vector2.new(0.5, 0),
		title = v41.ChatSelectionModalTitle,
		onCloseClicked = t3.onBack,
		onInfoClicked = v47,
		buttonStackProps = {
			buttons = {{
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = t3.onContinue,
					text = v41.ChatSelectionModalButton,
					isDisabled = v44 or t3.selectedMessage == nil
				}
			}}
		}
	}, {
		infoView = React.createElement(ChatLineReportInfo, {
			visible = v32
		}),
		messageView = if not v44 then React.createElement(ScrollView, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, (math.min(absoluteSize.Y - v45.insets.top - Constants.SelectionModalScreenSizeOffset, v35 + Constants.SelectionModalRadioGroupOffset, not t3.maxContentHeight and 1e999 or t3.maxContentHeight))),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				scrollBarVisibility = ScrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			ref = v37
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12)
			}),
			RadioGroup = React.createElement(RadioGroup.Root, {
				onValueChanged = function(p5) -- line: 172
					-- upvalues: t3 (copy), Constants (copy), v43 (copy)
					t3.setSelectedMessage(t3.messages[p5])
					t3.analyticsDispatch({
						type = Constants.AnalyticsActions.SetChatLineSelected,
						selected_chat_line_index = v43[p5]
					})
				end,
				ref = v34
			}, v42)
		}) else React.createElement(Empty, {})
	})
end

return ChatLineReportSelectionModalOld
