local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local ParentParent = script.Parent.Parent
local ThemedTextLabel = require(ParentParent.Components.PortedComponents.ThemedTextLabel)
local ModalDialog = require(ParentParent.Components.ModalDialog)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ShowOnboardingModalThunk = require(ParentParent.Thunks.ShowOnboardingModalThunk)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v15 = Roact.PureComponent:extend("OnboardingModal")
local FFlagTopBarSignalizeScreenSize = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeScreenSize

function v15.init(p1) -- line: 35
	-- upvalues: ExperienceStateCaptureService (copy), FFlagTopBarSignalizeScreenSize (copy), Display (copy), Signals (copy)
	function p1.onDismiss() -- line: 36
		-- upvalues: p1 (copy)
		p1.props.showOnboardingModal(false)
	end
	function p1.onCancel() -- line: 40
		-- upvalues: ExperienceStateCaptureService (copy)
		ExperienceStateCaptureService:ToggleCaptureMode()
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		p1.disposeScreenSize = Signals.createEffect(function(p2) -- line: 47
			-- upvalues: p1 (copy), getViewportSize (copy)
			p1:setState({
				screenSize = getViewportSize(p2)
			})
		end)
	end
end
function v15.willUnmount(p3) -- line: 55
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	if FFlagTopBarSignalizeScreenSize then
		p3.disposeScreenSize()
	end
end
function v15.render(p4) -- line: 61
	-- upvalues: withLocalization (copy), Roact (copy), ModalDialog (copy), FFlagTopBarSignalizeScreenSize (copy), ButtonStack (copy), ButtonType (copy), ThemedTextLabel (copy)
	return withLocalization({
		mainHeader = "CoreScripts.Feedback.Onboarding.MainHeader",
		instructionLabel = "CoreScripts.Feedback.Onboarding.Instructions",
		cancel = "CoreScripts.Feedback.Onboarding.Cancel",
		start = "CoreScripts.Feedback.Onboarding.Start"
	})(function(p5) -- line: 67
		-- upvalues: Roact (copy), ModalDialog (copy), p4 (copy), FFlagTopBarSignalizeScreenSize (copy), ButtonStack (copy), ButtonType (copy), ThemedTextLabel (copy)
		return Roact.createElement(ModalDialog, {
			maxHeight = 200,
			maxWidth = 540,
			showCloseButton = true,
			visible = p4.props.visible,
			screenSize = if not FFlagTopBarSignalizeScreenSize then p4.props.screenSize else p4.state.screenSize,
			titleText = p5.mainHeader,
			actionButtons = Roact.createElement(ButtonStack, {
				buttonHeight = 36,
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = p4.onCancel,
							text = p5.cancel
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isDisabled = false,
							onActivated = p4.onDismiss,
							text = p5.start
						}
					}
				}
			}),
			contents = Roact.createElement("Frame", {
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
					TextWrapped = true,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 76, 0.5, 0),
					Size = UDim2.new(1, 0, 0.4, 36),
					Text = p5.instructionLabel,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			onDismiss = p4.onDismiss
		})
	end)
end

return RoactRodux.connect(function(p6) -- line: 126
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	return {
		screenSize = if not FFlagTopBarSignalizeScreenSize then p6.displayOptions.screenSize else nil,
		visible = p6.common.showOnboardingModal
	}
end, function(p7) -- line: 131
	-- upvalues: ShowOnboardingModalThunk (copy)
	return {
		showOnboardingModal = function(p8) -- line: 133
			-- upvalues: p7 (copy), ShowOnboardingModalThunk (copy)
			p7(ShowOnboardingModalThunk(p8))
		end
	}
end)(v15)
