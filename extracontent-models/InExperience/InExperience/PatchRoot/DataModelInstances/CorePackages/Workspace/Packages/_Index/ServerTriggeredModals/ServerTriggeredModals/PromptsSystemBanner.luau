local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint

local PromptStyle = require(script.Parent.SduiV2.PromptStyle)
local usePromptEntries = require(script.Parent.SduiV2.usePromptEntries)
local FFlagPromptsActionEventLogging = require(ServerTriggeredModals.Flags.FFlagPromptsActionEventLogging)

local function PromptsSystemBanner(props)
	local v = usePromptEntries(props.configKey, PromptStyle.SystemBanner)[1]

	if not v then
		return props.contentSlot
	end

	local createElement = React.createElement
	local v2 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SystemBanner = 0,
		ContentContainer = 0
	}

	local createElement2 = React.createElement
	local v3 = {
		configKey = props.configKey,
		identifier = v.identifier,
		appPage = props.appPage,
		additionalAnalyticsData = 0,
		shouldDisplayLoading = false,
		shouldDisplayError = false,
		LayoutOrder = 1
	}
	local additionalAnalyticsData

	if FFlagPromptsActionEventLogging then
		additionalAnalyticsData = { promptInstanceId = 0 }
		local promptInstanceId

		if v.identifier then
			promptInstanceId = v.identifier
		end

		additionalAnalyticsData.promptInstanceId = promptInstanceId
	end

	v3.additionalAnalyticsData = additionalAnalyticsData
	children.SystemBanner = createElement2(SduiFeatureEntryPoint, v3)

	children.ContentContainer = React.createElement(
		"Frame",
		{ LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 },
		{
			UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
			Content = props.contentSlot
		}
	)
	return createElement("Frame", v2, children)
end

return PromptsSystemBanner
