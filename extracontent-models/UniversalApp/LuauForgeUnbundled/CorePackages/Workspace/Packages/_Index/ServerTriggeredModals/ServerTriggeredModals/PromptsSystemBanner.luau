local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local sduiFeatureEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities").SduiFeatureEntryPoint

local PromptStyle = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptStyle")
local usePromptEntries = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/usePromptEntries")
local FFlagPromptsActionEventLogging = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPromptsActionEventLogging")

local function PromptsSystemBanner(props)
	local v5 = usePromptEntries(props.configKey, PromptStyle.SystemBanner)[1]

	if not v5 then
		return props.contentSlot
	end

	local createElement = React.createElement
	local v7 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SystemBanner = 0,
		ContentContainer = 0
	}

	local createElement2 = React.createElement
	local v9 = {
		configKey = props.configKey,
		identifier = v5.identifier,
		appPage = props.appPage,
		additionalAnalyticsData = 0,
		shouldDisplayLoading = false,
		shouldDisplayError = false,
		LayoutOrder = 1
	}
	local v10

	if FFlagPromptsActionEventLogging then
		v10 = { promptInstanceId = 0 }
		local v11 = if v5.identifier then v5.identifier else nil
		v10.promptInstanceId = v11
	end

	v9.additionalAnalyticsData = v10
	children.SystemBanner = createElement2(sduiFeatureEntryPoint, v9)

	children.ContentContainer = React.createElement(
		"Frame",
		{ LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 },
		{
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			Content = props.contentSlot
		}
	)
	return createElement("Frame", v7, children)
end

return PromptsSystemBanner
