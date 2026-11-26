local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local divider = Foundation.Divider
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local usePreferredInput = Responsive.usePreferredInput

local splitPaneStore = require("@luauforge/bundled/dIW").SplitPaneStore
local supportPaneMode = require("@luauforge/bundled/dGL").Enums.SupportPaneMode

local fFlagSplitPaneEducationalTour = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSplitPaneEducationalTour
local splitPaneEducationalTourCollapsedControl

if fFlagSplitPaneEducationalTour then
	splitPaneEducationalTourCollapsedControl = require("@luauforge/bundled/dIW").SplitPaneEducationalTourCollapsedControl
else
	splitPaneEducationalTourCollapsedControl = nil
end

local getSplitPaneEducationalTourStore

if fFlagSplitPaneEducationalTour then
	getSplitPaneEducationalTourStore = require("@luauforge/bundled/dIW").getSplitPaneEducationalTourStore
else
	getSplitPaneEducationalTourStore = nil
end

local function OpenSplitPaneButton()
	local store = splitPaneStore.getStore()
	local v5 = useSignalState(store.getSupportPaneMode)
	local v6 = useSignalState(store.getIsBreakpointEnabled)
	local v7 = useSignalState(store.getIsSplitEligible)
	local v8 = usePreferredInput()
	local v9

	if fFlagSplitPaneEducationalTour then
		v9 = useSignalState(getSplitPaneEducationalTourStore(false).getIsTourActive)
	else
		v9 = false
	end

	local v10 = React.useCallback(function()
		splitPaneStore.getStore().toggleSupportPaneMode(supportPaneMode.Collapsed)
	end, {})

	if not v6 or not v7 or v8 == Responsive.Input.Directional or v5 ~= supportPaneMode.Collapsed then
		return nil
	end

	if fFlagSplitPaneEducationalTour and v9 then
		return React.createElement(splitPaneEducationalTourCollapsedControl)
	end

	return React.createElement(
		view,
		{ tag = "row align-y-center size-0-full auto-x padding-left-xsmall" },
		{
			DividerContainer = React.createElement(view, {
				tag = "size-0-600 auto-x",
				LayoutOrder = 1
			}, {
				Divider = React.createElement(divider, {
					orientation = orientation.Vertical
				})
			}),
			ButtonSlot = React.createElement(
				view,
				{ tag = "size-1000-1000 padding-left-xsmall", LayoutOrder = 2 },
				{
					Button = React.createElement(iconButton, {
						icon = iconName.RectangleRightPaneChevronLeft,
						variant = buttonVariant.Utility,
						size = inputSize.Medium,
						onActivated = v10,
						testId = "open-split-pane-button"
					})
				}
			)
		}
	)
end

return OpenSplitPaneButton
