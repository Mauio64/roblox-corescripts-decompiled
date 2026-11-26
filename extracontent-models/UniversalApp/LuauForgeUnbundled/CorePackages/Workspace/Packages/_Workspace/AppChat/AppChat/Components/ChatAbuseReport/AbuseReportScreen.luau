local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local Frame = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Common/Frame")
local ChatAbuseReport = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatAbuseReport/ChatAbuseReport")

local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local appFocusRoot = FocusNavigationUtils.AppFocusRoot
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function AbuseReportScreen(p2)
	local navigation = p2.navigation
	local param = navigation.getParam("conversationId", nil)
	local param2 = navigation.getParam("participantId", nil)

	local v5 = React.useMemo(function()
		local v6 = {}
		v6[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				navigation.pop()
				object:cancel()
			end)
		}

		return v6
	end, { navigation })

	local element = React.createElement(
		Frame,
		{
			horizontalAlignment = Enum.HorizontalAlignment.Center,
			verticalAlignment = Enum.VerticalAlignment.Center,
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
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
				conversationId = param,
				participantId = param2,
				onAbandon = navigation.pop,
				onComplete = navigation.pop
			})
		}
	)

	return React.createElement(appFocusRoot, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		isAutoFocusRoot = true,
		isFocusable = true,
		customEventHandlers = v5
	}, { element })
end

return AbuseReportScreen
