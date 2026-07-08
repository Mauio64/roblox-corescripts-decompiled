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
local FrontButtonController = require(RobloxGui.Modules.Settings.FrontButtonController)
local v13 = Roact.PureComponent:extend("MenuFrontButton")
local v14 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local Theme = require(RobloxGui.Modules.Settings.Theme)
local v16 = game:DefineFastFlag("ShowTeleportHistoryFrontButton", false)

v13.validateProps = t.strictInterface({
	HubBar = t.instanceOf("ImageLabel"),
	frontEnabled = t.boolean,
	FrontBarRef = t.optional(t.table),
	LayoutOrder = t.optional(t.integer)
})
v13.defaultProps = {
	frontEnabled = v16 and FrontButtonController.hasReturnUniverse()
}

function v13.init(p1) -- line: 38
	-- upvalues: FrontButtonController (copy), Roact (copy)
	p1:setState({
		text = FrontButtonController.getMenuText()
	})

	local v18, v19 = Roact.createBinding(nil)

	p1.sizeBinding = v18
	p1.updateSizeBinding = v19

	local v20, v21 = Roact.createBinding(nil)

	p1.sizeConstraintBinding = v20
	p1.updateSizeConstraintBinding = v21

	local v22, v23 = Roact.createBinding(nil)

	p1.visibleBinding = v22
	p1.updateVisibleBinding = v23

	local v24, v25 = Roact.createBinding(nil)

	p1.buttonHeightBinding = v24
	p1.updateButtonHeightBinding = v25

	local v26, v27 = Roact.createBinding(nil)

	p1.textSizeBinding = v26
	p1.updateTextSizeBinding = v27

	local v28, v29 = Roact.createBinding(nil)

	p1.textSizeConstraintBinding = v28
	p1.updateTextSizeConstraintBinding = v29
	p1.textLabelRef = Roact.createRef()
end
function v13.didMount(p2) -- line: 50
	p2.updateSizeBinding(p2.props.HubBar.Size)
	p2.updateVisibleBinding(p2.props.HubBar.Visible)
	p2:updateViewport()
end
function v13.didUpdate(p3, p4) -- line: 55
	if p3.props.HubBar ~= p4.HubBar then
		p3.updateSizeBinding(p3.props.HubBar.Size)
		p3.updateVisibleBinding(p3.props.HubBar.Visible)
	end
end
function v13.updateViewport(p5) -- line: 61
	-- upvalues: Theme (copy), Utility (copy), v14 (copy)
	local v34 = Theme.textSize(24)

	if Utility:IsSmallTouchScreen() then
		v34 = Theme.textSize(18)
	elseif v14 then
		v34 = Theme.textSize(36)
	end

	p5.updateTextSizeConstraintBinding(v34)

	local v35 = Utility:IsPortrait()
	local v36 = if not v14 then Theme.LargeButtonHeight else 120

	if v35 or Utility:IsSmallTouchScreen() then
		v36 = Theme.ButtonHeight
		v34 = v35 and Theme.textSize(16) or Theme.textSize(24)
	end

	p5.updateTextSizeBinding(v34)
	p5.updateButtonHeightBinding(v36)

	if p5.textLabelRef:getValue() and p5.props.FrontBarRef:getValue() then
		local v37 = p5.textLabelRef:getValue().AbsolutePosition.X - p5.props.FrontBarRef:getValue().AbsolutePosition.X

		p5.updateSizeConstraintBinding(Vector2.new(p5.props.FrontBarRef:getValue().AbsoluteSize.X - v37, 1e999))
	end
end
function v13.render(p6) -- line: 85
	-- upvalues: Roact (copy), ExternalEventConnection (copy), Theme (copy), FrontButtonController (copy), FFlagCoreUiMigrateUIBloxToFoundation (copy), Foundation (copy), ImageSetLabel (copy), Images (copy)
	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		LayoutOrder = p6.props.LayoutOrder,
		Visible = Roact.joinBindings({
			p6.state.text,
			p6.visibleBinding
		}):map(function(p7) -- line: 94
			-- upvalues: p6 (copy)
			return p6.props.frontEnabled and (p7[1] ~= nil and p7[2])
		end),
		Size = Roact.joinBindings({
			p6.sizeBinding,
			p6.buttonHeightBinding
		}):map(function(p8) -- line: 97
			local v41 = p8[1]
			local v42 = p8[2]

			if v41 and v42 then
				return UDim2.new(UDim.new(v41.X.Scale * 0.5, v41.X.Offset * 0.5), UDim.new(0, v42 + 6))
			end

			return UDim2.new()
		end),
		[Roact.Ref] = p6.props.FrontBarRef
	}, {
		SizeConnection = Roact.createElement(ExternalEventConnection, {
			event = p6.props.HubBar:GetPropertyChangedSignal("Size"),
			callback = function() -- line: 113
				-- upvalues: p6 (copy)
				p6.updateSizeBinding(p6.props.HubBar.Size)
			end
		}),
		VisibleConnection = Roact.createElement(ExternalEventConnection, {
			event = p6.props.HubBar:GetPropertyChangedSignal("Visible"),
			callback = function() -- line: 119
				-- upvalues: p6 (copy)
				p6.updateVisibleBinding(p6.props.HubBar.Visible)
			end
		}),
		ViewportSizeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),
			callback = function() -- line: 125
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
			Size = p6.buttonHeightBinding:map(function(p9) -- line: 139
				if p9 then
					return UDim2.new(0, 0, 0, p9)
				end

				return UDim2.new()
			end),
			AutomaticSize = Enum.AutomaticSize.X,
			ScaleType = Enum.ScaleType.Stretch,
			SliceCenter = Rect.new(8, 6, 46, 44),
			[Roact.Event.MouseEnter] = function(p10) -- line: 149
				-- upvalues: Theme (copy)
				p10.BackgroundColor3 = Theme.color("DefaultButtonHover")
				p10.BackgroundTransparency = Theme.transparency("DefaultButtonHover")
			end,
			[Roact.Event.MouseLeave] = function(p11) -- line: 153
				-- upvalues: Theme (copy)
				p11.BackgroundColor3 = Theme.color("DefaultButton")
				p11.BackgroundTransparency = Theme.transparency("DefaultButton")
			end,
			[Roact.Event.Activated] = function(_) -- line: 157
				-- upvalues: FrontButtonController (copy)
				FrontButtonController.initiateFrontButtonTeleport()
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
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
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
					LayoutOrder = 1,
					[Roact.Ref] = p6.textLabelRef
				}, {
					UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
						MaxTextSize = p6.textSizeConstraintBinding
					}),
					UISizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = p6.sizeConstraintBinding
					})
				}),
				ImageLabel = if not FFlagCoreUiMigrateUIBloxToFoundation then Roact.createElement(ImageSetLabel, {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Image = Images["icons/actions/cycleRight"],
					Size = UDim2.new(1, 0, 0.75, 0)
				}, {
					UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {})
				}) else Roact.createElement(Foundation.Icon, {
					name = "icons/actions/cycleRight",
					LayoutOrder = 2,
					size = Foundation.Enums.IconSize.Large
				})
			})
		})
	})
end

return v13
