local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)

local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")

local parent = script.Parent.Parent
local ThemedTextLabel = require(parent.Components.PortedComponents.ThemedTextLabel)
local ModalDialog = require(parent.Components.ModalDialog)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local ShowOnboardingModalThunk = require(parent.Thunks.ShowOnboardingModalThunk)

local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization
local extended = Roact.PureComponent:extend("OnboardingModal")

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local GetFFlagEnableSendImageFeedbackToBackend = require(RobloxGui.Modules.Flags.GetFFlagEnableSendImageFeedbackToBackend)

function extended:init()
	function self.onDismiss()
		self.props.showOnboardingModal(false)
	end

	function self.onCancel()
		ExperienceStateCaptureService:ToggleCaptureMode()
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		self.disposeScreenSize = Signals.createEffect(function(p)
			self:setState({ screenSize = getViewportSize(p) })
		end)
	end
end

function extended.willUnmount(p)
	if FFlagTopBarSignalizeScreenSize then
		p.disposeScreenSize()
	end
end

function extended.render(data)
	return withLocalization({
		mainHeader = "CoreScripts.Feedback.Onboarding.MainHeader",
		instructionLabel = GetFFlagEnableSendImageFeedbackToBackend() and "CoreScripts.Feedback.Onboarding.InstructionsWithImage" or "CoreScripts.Feedback.Onboarding.Instructions",
		cancel = "CoreScripts.Feedback.Onboarding.Cancel",
		start = "CoreScripts.Feedback.Onboarding.Start"
	})(function(props)
		local createElement = Roact.createElement
		local children = {
			visible = data.props.visible,
			screenSize = 0,
			titleText = 0,
			maxHeight = 200,
			maxWidth = 540,
			showCloseButton = true,
			actionButtons = 0,
			contents = 0,
			onDismiss = 0
		}
		local screenSize

		if FFlagTopBarSignalizeScreenSize then
			screenSize = data.state.screenSize
		else
			screenSize = data.props.screenSize
		end

		children.screenSize = screenSize
		children.titleText = props.mainHeader

		children.actionButtons = Roact.createElement(ButtonStack, {
			buttonHeight = 36,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = data.onCancel, text = props.cancel }
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = { isDisabled = false, onActivated = data.onDismiss, text = props.start }
				}
			}
		})

		children.contents = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			InstructionLabel = Roact.createElement(ThemedTextLabel, {
				LayoutOrder = 1,
				fontKey = "Body",
				themeKey = "TextDefault",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 76, 0.5, 0),
				Size = UDim2.new(1, 0, 0.4, 36),
				Text = props.instructionLabel,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})

		children.onDismiss = data.onDismiss
		return createElement(ModalDialog, children)
	end)
end

return RoactRodux.connect(function(p)
	local screenSize

	if not FFlagTopBarSignalizeScreenSize then
		screenSize = p.displayOptions.screenSize
	end

	return { screenSize = screenSize, visible = p.common.showOnboardingModal }
end, function(callback)
	return {
		showOnboardingModal = function(p)
			callback(ShowOnboardingModalThunk(p))
		end
	}
end)(extended)
