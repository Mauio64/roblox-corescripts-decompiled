local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)

local Frame = require(AppChat.Components.Common.Frame)
local ChatAbuseReport = require(script.Parent.ChatAbuseReport)

local InputHandlers = require(parent.InputHandlers)
require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function AbuseReportScreen(p)
	local navigation = p.navigation
	local param = navigation.getParam("conversationId", nil)
	local param2 = navigation.getParam("participantId", nil)

	local customEventHandlers = React.useMemo(function()
		local v = {}
		v[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				navigation.pop()
				object:cancel()
			end)
		}

		return v
	end, { navigation })

	local element = React.createElement(
		Frame,
		{
			horizontalAlignment = Enum.HorizontalAlignment.Center,
			verticalAlignment = Enum.VerticalAlignment.Center,
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			constraint = React.createElement("UISizeConstraint", { MaxSize = Vector2.new(800, 450) }),
			padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12)
			}),
			abuseReportFlow = React.createElement(ChatAbuseReport, {
				conversationId = param,
				participantId = param2,
				onAbandon = navigation.pop,
				onComplete = navigation.pop
			})
		}
	)

	return React.createElement(AppFocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		isAutoFocusRoot = true,
		isFocusable = true,
		customEventHandlers = customEventHandlers
	}, { element })
end

return AbuseReportScreen
