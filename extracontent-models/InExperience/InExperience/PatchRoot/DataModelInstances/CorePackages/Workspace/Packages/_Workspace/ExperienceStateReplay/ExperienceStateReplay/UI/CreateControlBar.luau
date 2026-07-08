return {
	createControlBar = function(p1) -- line: 4
		p1.ControlBarContainer = Instance.new("Frame")
		p1.ControlBarContainer.Name = "ControlBarContainer"
		p1.ControlBarContainer.BackgroundTransparency = 1
		p1.ControlBarContainer.BorderSizePixel = 0
		p1.ControlBarContainer.AnchorPoint = Vector2.new(0, 1)
		p1.ControlBarContainerVisiblePosition = UDim2.new(0, 0, 1, 0)
		p1.ControlBarContainerNonVisiblePosition = UDim2.new(0, 0, 1.2, 0)
		p1.ControlBarContainer.Position = p1.ControlBarContainerVisiblePosition
		p1.maxControlBarHeight = 45
		p1.ControlBarContainer.Size = UDim2.new(1, 0, 0, p1.maxControlBarHeight)
		p1.ControlBarContainer.Parent = p1.screenGui

		local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

		UIAspectRatioConstraint.AspectRatio = 30
		UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
		UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
		UIAspectRatioConstraint.Parent = p1.ControlBarContainer
		p1.defaultBackgroundColor3 = Color3.fromRGB(20, 20, 20)
		p1.defaultBackgroundTransparency = 0.15
		p1.defaultButtonsTimeControlBarXSize = 0.275
		p1.defaultHelpBarXSize = 0.025
		p1.defaultScrubberControlBarXSize = 1 - p1.defaultButtonsTimeControlBarXSize - p1.defaultHelpBarXSize
		p1.ButtonsTimeControlBar = Instance.new("Frame")
		p1.ButtonsTimeControlBar.Name = "ButtonsTimeControlBar"
		p1.ButtonsTimeControlBar.BackgroundColor3 = p1.defaultBackgroundColor3
		p1.ButtonsTimeControlBar.BackgroundTransparency = p1.defaultBackgroundTransparency
		p1.ButtonsTimeControlBar.BorderSizePixel = 0
		p1.ButtonsTimeControlBar.SizeConstraint = Enum.SizeConstraint.RelativeXY
		p1.ButtonsTimeControlBar.Size = UDim2.new(p1.defaultButtonsTimeControlBarXSize, 0, 1, 0)
		p1.ButtonsTimeControlBar.Parent = p1.ControlBarContainer

		local UIPadding = Instance.new("UIPadding")

		UIPadding.PaddingLeft = UDim.new(0.02, 0)
		UIPadding.Parent = p1.ButtonsTimeControlBar
		p1.ScrubberControlBar = Instance.new("Frame")
		p1.ScrubberControlBar.Name = "ScrubberControlBar"
		p1.ScrubberControlBar.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
		p1.ScrubberControlBar.BackgroundTransparency = 0.5
		p1.ScrubberControlBar.BorderSizePixel = 0
		p1.ScrubberControlBar.SizeConstraint = Enum.SizeConstraint.RelativeXY
		p1.ScrubberControlBar.Size = UDim2.new(p1.defaultScrubberControlBarXSize, 0, 1, 0)
		p1.ScrubberControlBar.Parent = p1.ControlBarContainer

		local UIFlexItem = Instance.new("UIFlexItem")

		UIFlexItem.FlexMode = Enum.UIFlexMode.Fill
		UIFlexItem.Parent = p1.ScrubberControlBar
		p1.HelpBar = Instance.new("Frame")
		p1.HelpBar.Name = "HelpBar"
		p1.HelpBar.BackgroundColor3 = p1.defaultBackgroundColor3
		p1.HelpBar.BackgroundTransparency = p1.defaultBackgroundTransparency
		p1.HelpBar.BorderSizePixel = 0
		p1.HelpBar.SizeConstraint = Enum.SizeConstraint.RelativeXY
		p1.HelpBar.Size = UDim2.new(p1.defaultHelpBarXSize, 0, 1, 0)
		p1.HelpBar.Parent = p1.ControlBarContainer
		p1.maxViewportScalingWidth = p1.maxControlBarHeight * UIAspectRatioConstraint.AspectRatio

		local function setupControlBarScaling() -- line: 73
			-- upvalues: p1 (copy), UIAspectRatioConstraint (copy), UIPadding (copy)
			p1.firstThresholdCheck = true
			p1.lastCheckAboveThreshold = false

			local CurrentCamera = workspace.CurrentCamera

			if not CurrentCamera then
				warn("No current camera found in workspace")

				return
			end

			CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 81
				-- upvalues: CurrentCamera (copy), p1 (copy), UIAspectRatioConstraint (copy), UIPadding (copy)
				if CurrentCamera.ViewportSize.X > p1.maxViewportScalingWidth then
					if not p1.firstBoundaryCheck and p1.lastCheckAboveThreshold then
						return
					end

					p1.lastCheckAboveThreshold = true
					UIAspectRatioConstraint.Parent = nil

					local v10 = p1.ButtonsTimeControlBar.AbsoluteSize.X * UIPadding.PaddingLeft.Scale + UIPadding.PaddingLeft.Offset

					UIPadding.PaddingLeft = UDim.new(0, v10)
					p1.ButtonsTimeControlBar.Size = UDim2.new(0, p1.ButtonsTimeControlBar.AbsoluteSize.X, 1, 0)
					p1.HelpBar.Size = UDim2.new(0, p1.HelpBar.AbsoluteSize.X, 1, 0)
				else
					if not p1.firstBoundaryCheck and not p1.lastCheckAboveThreshold then
						return
					end

					p1.lastCheckAboveThreshold = false
					UIAspectRatioConstraint.Parent = p1.ControlBarContainer
					UIPadding.PaddingLeft = UDim.new(0.02, 0)
					p1.ButtonsTimeControlBar.Size = UDim2.new(p1.defaultButtonsTimeControlBarXSize, 0, 1, 0)
					p1.HelpBar.Size = UDim2.new(p1.defaultHelpBarXSize, 0, 1, 0)
				end

				p1.firstBoundaryCheck = false
			end)
		end

		setupControlBarScaling()
		workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(setupControlBarScaling)

		function p1.createUIListLayout(p2, n1: number) -- line: 124
			local UIListLayout = Instance.new("UIListLayout")

			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.Padding = UDim.new(0, n1)
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Parent = p2

			return UIListLayout
		end

		p1.createUIListLayout(p1.ControlBarContainer, 0)
		p1.createUIListLayout(p1.ButtonsTimeControlBar, 7.5)
	end
}
