local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local React = require(Parent.React)
local SduiFeatureEntryPoint = require(Parent.SduiSharedUtilities).SduiFeatureEntryPoint
local PromptStyle = require(script.Parent.SduiV2.PromptStyle)
local usePromptEntries = require(script.Parent.SduiV2.usePromptEntries)

local function PromptsSystemBanner(t1: {[any]: any}) -- line: 17
	-- upvalues: usePromptEntries (copy), PromptStyle (copy), React (copy), SduiFeatureEntryPoint (copy)
	local v8 = usePromptEntries(t1.configKey, PromptStyle.SystemBanner)[1]

	if not v8 then
		return t1.contentSlot
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SystemBanner = React.createElement(SduiFeatureEntryPoint, {
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			LayoutOrder = 1,
			configKey = t1.configKey,
			identifier = v8.identifier,
			appPage = t1.appPage
		}),
		ContentContainer = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			Content = t1.contentSlot
		})
	})
end

return PromptsSystemBanner
