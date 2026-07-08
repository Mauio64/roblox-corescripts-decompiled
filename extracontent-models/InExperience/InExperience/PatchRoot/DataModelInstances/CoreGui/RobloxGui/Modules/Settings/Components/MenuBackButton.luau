local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local Utility = require(RobloxGui.Modules.Settings.Utility)
local BackButtonController = require(RobloxGui.Modules.Settings.BackButtonController)
local v13 = Roact.PureComponent:extend("MenuBackButton")
local v14 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local Theme = require(RobloxGui.Modules.Settings.Theme)

v13.validateProps = t.strictInterface({
	HubBar = t.instanceOf("ImageLabel"),
	backEnabled = t.boolean,
	BackBarRef = t.optional(t.table),
	LayoutOrder = t.optional(t.integer)
})
v13.defaultProps = {
	backEnabled = BackButtonController.hasReturnUniverse()
}

function v13.init(p1) -- line: 38
	-- upvalues: BackButtonController (copy), Roact (copy)
	p1:setState({
		text = BackButtonController.getMenuText()
	})

	local v17, v18 = Roact.createBinding(nil)

	p1.sizeBinding = v17
	p1.updateSizeBinding = v18

	local v19, v20 = Roact.createBinding(nil)

	p1.sizeConstraintBinding = v19
	p1.updateSizeConstraintBinding = v20

	local v21, v22 = Roact.createBinding(nil)

	p1.visibleBinding = v21
	p1.updateVisibleBinding = v22

	local v23, v24 = Roact.createBinding(nil)

	p1.buttonHeightBinding = v23
	p1.updateButtonHeightBinding = v24

	local v25, v26 = Roact.createBinding(nil)

	p1.textSizeBinding = v25
	p1.updateTextSizeBinding = v26

	local v27, v28 = Roact.createBinding(nil)

	p1.textSizeConstraintBinding = v27
	p1.updateTextSizeConstraintBinding = v28
	p1.textLabelRef = Roact.createRef()
end
function v13.didMount(p2) -- line: 52
	p2.updateSizeBinding(p2.props.HubBar.Size)
	p2.updateVisibleBinding(p2.props.HubBar.Visible)
	p2:updateViewport()
end
function v13.didUpdate(p3, p4) -- line: 58
	if p3.props.HubBar ~= p4.HubBar then
		p3.updateSizeBinding(p3.props.HubBar.Size)
		p3.updateVisibleBinding(p3.props.HubBar.Visible)
	end
end
function v13.updateViewport(p5) -- line: 65
	-- upvalues: Theme (copy), Utility (copy), v14 (copy)
	local v33 = Theme.textSize(24)

	if Utility:IsSmallTouchScreen() then
		v33 = Theme.textSize(18)
	elseif v14 then
		v33 = Theme.textSize(36)
	end

	p5.updateTextSizeConstraintBinding(v33)

	local v34 = Utility:IsPortrait()
	local v35 = if not v14 then Theme.LargeButtonHeight else 120

	if v34 or Utility:IsSmallTouchScreen() then
		v35 = Theme.ButtonHeight
		v33 = v34 and Theme.textSize(16) or Theme.textSize(24)
	end

	p5.updateTextSizeBinding(v33)
	p5.updateButtonHeightBinding(v35)

	if p5.textLabelRef:getValue() and p5.props.BackBarRef:getValue() then
		local v36 = p5.textLabelRef:getValue().AbsolutePosition.X - p5.props.BackBarRef:getValue().AbsolutePosition.X

		p5.updateSizeConstraintBinding(Vector2.new(p5.props.BackBarRef:getValue().AbsoluteSize.X - v36, 1e999))
	end
end
function v13.render(p6) -- line: 93
	-- upvalues: Roact (copy), ExternalEventConnection (copy), Theme (copy), BackButtonController (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Foundation (copy), ImageSetLabel (copy), Images (copy)
	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, 0),
		LayoutOrder = p6.props.LayoutOrder,
		Visible = Roact.joinBindings({
			p6.state.text,
			p6.visibleBinding
		}):map(function(p7) -- line: 103
			-- upvalues: p6 (copy)
			return p6.props.backEnabled and (p7[1] ~= nil and p7[2])
		end),
		Size = Roact.joinBindings({
			p6.sizeBinding,
			p6.buttonHeightBinding
		}):map(function(p8) -- line: 106
			local v40 = p8[1]
			local v41 = p8[2]

			if v40 and v41 then
				return UDim2.new(UDim.new(v40.X.Scale * 0.5, v40.X.Offset * 0.5), UDim.new(0, v41 + 6))
			end

			return UDim2.new()
		end),
		[Roact.Ref] = p6.props.BackBarRef
	}, {
		SizeConnection = Roact.createElement(ExternalEventConnection, {
			event = p6.props.HubBar:GetPropertyChangedSignal("Size"),
			callback = function() -- line: 122
				-- upvalues: p6 (copy)
				p6.updateSizeBinding(p6.props.HubBar.Size)
			end
		}),
		VisibleConnection = Roact.createElement(ExternalEventConnection, {
			event = p6.props.HubBar:GetPropertyChangedSignal("Visible"),
			callback = function() -- line: 128
				-- upvalues: p6 (copy)
				p6.updateVisibleBinding(p6.props.HubBar.Visible)
			end
		}),
		ViewportSizeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),
			callback = function() -- line: 134
				-- upvalues: p6 (copy)
				p6:updateViewport()
			end
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 10)
		}),
		ImageButton = Roact.createElement("ImageButton", {
			Image = "",
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.color("DefaultButton"),
			BackgroundTransparency = Theme.transparency("DefaultButton", 1),
			Position = UDim2.new(0, 0, 0, 0),
			Size = p6.buttonHeightBinding:map(function(p9) -- line: 148
				if p9 then
					return UDim2.new(0, 0, 0, p9)
				end

				return UDim2.new()
			end),
			AutomaticSize = Enum.AutomaticSize.X,
			ScaleType = Enum.ScaleType.Stretch,
			SliceCenter = Rect.new(8, 6, 46, 44),
			[Roact.Event.MouseEnter] = function(p10) -- line: 158
				-- upvalues: Theme (copy)
				p10.BackgroundColor3 = Theme.color("DefaultButtonHover")
				p10.BackgroundTransparency = Theme.transparency("DefaultButtonHover")
			end,
			[Roact.Event.MouseLeave] = function(p11) -- line: 162
				-- upvalues: Theme (copy)
				p11.BackgroundColor3 = Theme.color("DefaultButton")
				p11.BackgroundTransparency = Theme.transparency("DefaultButton")
			end,
			[Roact.Event.Activated] = function(_) -- line: 166
				-- upvalues: BackButtonController (copy)
				BackButtonController.initiateBackButtonTeleport(Enum.AdTeleportMethod.InGameMenuBackButton)
			end
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = Theme.DefaultCornerRadius
			}),
			UIStroke = Roact.createElement("UIStroke", {
				Color = Theme.color("DefaultButtonStroke"),
				Transparency = Theme.transparency("DefaultButtonStroke"),
				Thickness = Theme.DefaultStokeThickness
			}),
			Frame = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 4, 0, 0)
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingRight = UDim.new(0, 12)
				}),
				Container = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ImageLabel = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = Images["icons/actions/cycleLeft"],
					Size = UDim2.new(1, 0, 0.75, 0)
				}, {
					UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {})
				}) else Roact.createElement(Foundation.Icon, {
					name = "icons/actions/cycleLeft",
					LayoutOrder = 1,
					size = Foundation.Enums.IconSize.Large
				}),
				TextLabel = Roact.createElement("TextLabel", {
					Text = p6.state.text,
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextYAlignment = Enum.TextYAlignment.Center,
					Font = Theme.font(Enum.Font.SourceSansBold, "Bold"),
					TextSize = p6.textSizeBinding,
					TextScaled = true,
					TextWrapped = true,
					LayoutOrder = 2,
					[Roact.Ref] = p6.textLabelRef
				}, {
					UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
						MaxTextSize = p6.textSizeConstraintBinding
					}),
					UISizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = p6.sizeConstraintBinding
					})
				})
			})
		})
	})
end

return v13
