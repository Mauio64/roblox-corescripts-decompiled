local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Frame = require(AppChat.Components.Common.Frame)
local ChatAbuseReport = require(script.Parent.ChatAbuseReport)
local InputHandlers = require(AppChatParent.InputHandlers)

require(AppChatParent.ReactFocusNavigation)

local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function AbuseReportScreen(p1) -- line: 15
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), Frame (copy), ChatAbuseReport (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local navigation = p1.navigation
	local v14 = navigation.getParam("conversationId", nil)
	local v15 = navigation.getParam("participantId", nil)
	local v16 = React.useMemo(function() -- line: 20
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), navigation (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2) -- line: 23
					-- upvalues: navigation (copy)
					navigation.pop()
					p2:cancel()
				end)
			}
		}
	end, { navigation })
	local v17 = React.createElement(Frame, {
		horizontalAlignment = Enum.HorizontalAlignment.Center,
		verticalAlignment = Enum.VerticalAlignment.Center,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		constraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(800, 450)
		}),
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		}),
		abuseReportFlow = React.createElement(ChatAbuseReport, {
			conversationId = v14,
			participantId = v15,
			onAbandon = navigation.pop,
			onComplete = navigation.pop
		})
	})

	return React.createElement(AppFocusRoot, {
		isIsolated = true,
		isAutoFocusRoot = true,
		isFocusable = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		customEventHandlers = v16
	}, { v17 })
end

return AbuseReportScreen
