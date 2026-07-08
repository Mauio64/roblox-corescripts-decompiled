local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local ParentParent = script.Parent.Parent
local ThemedTextLabel = require(ParentParent.Components.PortedComponents.ThemedTextLabel)
local ModalDialog = require(ParentParent.Components.ModalDialog)
local ShowHelpModalThunk = require(ParentParent.Thunks.ShowHelpModalThunk)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v11 = Roact.PureComponent:extend("HelpModal")
local FFlagTopBarSignalizeScreenSize = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeScreenSize

function v11.init(p1) -- line: 32
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy), Display (copy), Signals (copy)
	function p1.onDismiss() -- line: 33
		-- upvalues: p1 (copy)
		p1.props.showHelpModal(false)
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		p1.disposeScreenSize = Signals.createEffect(function(p2) -- line: 40
			-- upvalues: p1 (copy), getViewportSize (copy)
			p1:setState({
				screenSize = getViewportSize(p2)
			})
		end)
	end
end
function v11.willUnmount(p3) -- line: 48
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	if FFlagTopBarSignalizeScreenSize then
		p3.disposeScreenSize()
	end
end
function v11.render(p4) -- line: 54
	-- upvalues: withLocalization (copy), Roact (copy), ModalDialog (copy), FFlagTopBarSignalizeScreenSize (copy), ThemedTextLabel (copy)
	return withLocalization({
		mainHeader = "CoreScripts.Feedback.Help.MainHeader",
		instructionLabel = "CoreScripts.Feedback.Help.Instructions"
	})(function(p5) -- line: 58
		-- upvalues: Roact (copy), ModalDialog (copy), p4 (copy), FFlagTopBarSignalizeScreenSize (copy), ThemedTextLabel (copy)
		return Roact.createElement(ModalDialog, {
			maxHeight = 130,
			maxWidth = 540,
			showCloseButton = true,
			visible = p4.props.visible,
			screenSize = if not FFlagTopBarSignalizeScreenSize then p4.props.screenSize else p4.state.screenSize,
			titleText = p5.mainHeader,
			contents = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
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

return RoactRodux.connect(function(p6) -- line: 96
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	return {
		screenSize = if not FFlagTopBarSignalizeScreenSize then p6.displayOptions.screenSize else nil,
		visible = p6.common.showHelpModal
	}
end, function(p7) -- line: 101
	-- upvalues: ShowHelpModalThunk (copy)
	return {
		showHelpModal = function(p8) -- line: 103
			-- upvalues: p7 (copy), ShowHelpModalThunk (copy)
			p7(ShowHelpModalThunk(p8))
		end
	}
end)(v11)
