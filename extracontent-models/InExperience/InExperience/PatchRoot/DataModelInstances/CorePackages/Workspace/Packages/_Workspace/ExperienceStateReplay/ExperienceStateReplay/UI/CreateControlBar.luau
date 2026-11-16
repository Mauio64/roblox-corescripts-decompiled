return {
	createControlBar = function(state)
		state.ControlBarContainer = Instance.new("Frame")
		state.ControlBarContainer.Name = "ControlBarContainer"
		state.ControlBarContainer.BackgroundTransparency = 1
		state.ControlBarContainer.BorderSizePixel = 0
		state.ControlBarContainer.AnchorPoint = Vector2.new(0, 1)
		state.ControlBarContainerVisiblePosition = UDim2.new(0, 0, 1, 0)
		state.ControlBarContainerNonVisiblePosition = UDim2.new(0, 0, 1.2, 0)
		state.ControlBarContainer.Position = state.ControlBarContainerVisiblePosition
		state.maxControlBarHeight = 45
		state.ControlBarContainer.Size = UDim2.new(1, 0, 0, state.maxControlBarHeight)
		state.ControlBarContainer.Parent = state.screenGui

		local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
		uiAspectRatioConstraint.AspectRatio = 30
		uiAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
		uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
		uiAspectRatioConstraint.Parent = state.ControlBarContainer

		state.defaultBackgroundColor3 = Color3.fromRGB(20, 20, 20)
		state.defaultBackgroundTransparency = 0.15
		state.defaultButtonsTimeControlBarXSize = 0.275
		state.defaultHelpBarXSize = 0.025
		state.defaultScrubberControlBarXSize = 1 - state.defaultButtonsTimeControlBarXSize - state.defaultHelpBarXSize

		state.ButtonsTimeControlBar = Instance.new("Frame")
		state.ButtonsTimeControlBar.Name = "ButtonsTimeControlBar"
		state.ButtonsTimeControlBar.BackgroundColor3 = state.defaultBackgroundColor3
		state.ButtonsTimeControlBar.BackgroundTransparency = state.defaultBackgroundTransparency
		state.ButtonsTimeControlBar.BorderSizePixel = 0
		state.ButtonsTimeControlBar.SizeConstraint = Enum.SizeConstraint.RelativeXY
		state.ButtonsTimeControlBar.Size = UDim2.new(state.defaultButtonsTimeControlBarXSize, 0, 1, 0)
		state.ButtonsTimeControlBar.Parent = state.ControlBarContainer

		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingLeft = UDim.new(0.02, 0)
		uiPadding.Parent = state.ButtonsTimeControlBar

		state.ScrubberControlBar = Instance.new("Frame")
		state.ScrubberControlBar.Name = "ScrubberControlBar"
		state.ScrubberControlBar.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
		state.ScrubberControlBar.BackgroundTransparency = 0.5
		state.ScrubberControlBar.BorderSizePixel = 0
		state.ScrubberControlBar.SizeConstraint = Enum.SizeConstraint.RelativeXY
		state.ScrubberControlBar.Size = UDim2.new(state.defaultScrubberControlBarXSize, 0, 1, 0)
		state.ScrubberControlBar.Parent = state.ControlBarContainer

		local uiFlexItem = Instance.new("UIFlexItem")
		uiFlexItem.FlexMode = Enum.UIFlexMode.Fill
		uiFlexItem.Parent = state.ScrubberControlBar

		state.HelpBar = Instance.new("Frame")
		state.HelpBar.Name = "HelpBar"
		state.HelpBar.BackgroundColor3 = state.defaultBackgroundColor3
		state.HelpBar.BackgroundTransparency = state.defaultBackgroundTransparency
		state.HelpBar.BorderSizePixel = 0
		state.HelpBar.SizeConstraint = Enum.SizeConstraint.RelativeXY
		state.HelpBar.Size = UDim2.new(state.defaultHelpBarXSize, 0, 1, 0)
		state.HelpBar.Parent = state.ControlBarContainer

		state.maxViewportScalingWidth = state.maxControlBarHeight * uiAspectRatioConstraint.AspectRatio

		local function setupControlBarScaling()
			state.firstThresholdCheck = true
			state.lastCheckAboveThreshold = false
			local currentCamera = workspace.CurrentCamera

			if currentCamera then
				currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					if currentCamera.ViewportSize.X > state.maxViewportScalingWidth then
						if not state.firstBoundaryCheck and state.lastCheckAboveThreshold then
							return
						end

						state.lastCheckAboveThreshold = true

						uiAspectRatioConstraint.Parent = nil

						local v = state.ButtonsTimeControlBar.AbsoluteSize.X * uiPadding.PaddingLeft.Scale + uiPadding.PaddingLeft.Offset
						uiPadding.PaddingLeft = UDim.new(0, v)

						state.ButtonsTimeControlBar.Size = UDim2.new(
							0,
							state.ButtonsTimeControlBar.AbsoluteSize.X,
							1,
							0
						)
						state.HelpBar.Size = UDim2.new(0, state.HelpBar.AbsoluteSize.X, 1, 0)
					else
						if not (state.firstBoundaryCheck or state.lastCheckAboveThreshold) then
							return
						end

						state.lastCheckAboveThreshold = false

						uiAspectRatioConstraint.Parent = state.ControlBarContainer
						uiPadding.PaddingLeft = UDim.new(0.02, 0)

						state.ButtonsTimeControlBar.Size = UDim2.new(state.defaultButtonsTimeControlBarXSize, 0, 1, 0)
						state.HelpBar.Size = UDim2.new(state.defaultHelpBarXSize, 0, 1, 0)
					end

					state.firstBoundaryCheck = false
				end)
			else
				warn("No current camera found in workspace")
			end
		end
		setupControlBarScaling()
		workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(setupControlBarScaling)

		function state.createUIListLayout(parent, p: number)
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.Padding = UDim.new(0, p)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.Parent = parent
			return uiListLayout
		end

		state.createUIListLayout(state.ControlBarContainer, 0)
		state.createUIListLayout(state.ButtonsTimeControlBar, 7.5)
	end
}
