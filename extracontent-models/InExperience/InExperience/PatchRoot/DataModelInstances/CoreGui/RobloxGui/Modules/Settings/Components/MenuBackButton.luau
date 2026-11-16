local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Foundation = require(CorePackages.Packages.Foundation)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags2.FFlagResponsiveUnitsDeprecateTenFoot
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local Utility = require(RobloxGui.Modules.Settings.Utility)
local BackButtonController = require(RobloxGui.Modules.Settings.BackButtonController)

local extended = Roact.PureComponent:extend("MenuBackButton")
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local v = TenFootInterface:IsEnabled() and not FFlagResponsiveUnitsDeprecateTenFoot
local Theme = require(RobloxGui.Modules.Settings.Theme)

extended.validateProps = t.strictInterface({
	HubBar = t.instanceOf("ImageLabel"),
	backEnabled = t.boolean,
	BackBarRef = t.optional(t.table),
	LayoutOrder = t.optional(t.integer)
})

extended.defaultProps = {
	backEnabled = BackButtonController.hasReturnUniverse()
}

function extended:init()
	self:setState({
		text = BackButtonController.getMenuText()
	})

	local binding, updateSizeBinding = Roact.createBinding(nil)
	self.sizeBinding = binding
	self.updateSizeBinding = updateSizeBinding
	local binding2, updateSizeConstraintBinding = Roact.createBinding(nil)
	self.sizeConstraintBinding = binding2
	self.updateSizeConstraintBinding = updateSizeConstraintBinding
	local binding3, updateVisibleBinding = Roact.createBinding(nil)
	self.visibleBinding = binding3
	self.updateVisibleBinding = updateVisibleBinding
	local binding4, updateButtonHeightBinding = Roact.createBinding(nil)
	self.buttonHeightBinding = binding4
	self.updateButtonHeightBinding = updateButtonHeightBinding
	local binding5, updateTextSizeBinding = Roact.createBinding(nil)
	self.textSizeBinding = binding5
	self.updateTextSizeBinding = updateTextSizeBinding
	local binding6, updateTextSizeConstraintBinding = Roact.createBinding(nil)
	self.textSizeConstraintBinding = binding6
	self.updateTextSizeConstraintBinding = updateTextSizeConstraintBinding

	self.textLabelRef = Roact.createRef()
end

function extended:didMount()
	self.updateSizeBinding(self.props.HubBar.Size)
	self.updateVisibleBinding(self.props.HubBar.Visible)
	self:updateViewport()
end

function extended.didUpdate(data, p)
	if data.props.HubBar ~= p.HubBar then
		data.updateSizeBinding(data.props.HubBar.Size)
		data.updateVisibleBinding(data.props.HubBar.Visible)
	end
end

function extended:updateViewport()
	local v2 = Theme.textSize(24)

	if Utility:IsSmallTouchScreen() then
		v2 = Theme.textSize(18)
	elseif v then
		v2 = Theme.textSize(36)
	end

	self.updateTextSizeConstraintBinding(v2)

	local isPortrait = Utility:IsPortrait()
	local v3 = v and 120 or Theme.LargeButtonHeight

	if isPortrait or Utility:IsSmallTouchScreen() then
		v3 = Theme.ButtonHeight
		v2 = isPortrait and Theme.textSize(16) or Theme.textSize(24)
	end

	self.updateTextSizeBinding(v2)
	self.updateButtonHeightBinding(v3)

	if self.textLabelRef:getValue() and self.props.BackBarRef:getValue() then
		local v4 = self.textLabelRef:getValue().AbsolutePosition.X - self.props.BackBarRef:getValue().AbsolutePosition.X
		self.updateSizeConstraintBinding(Vector2.new(self.props.BackBarRef:getValue().AbsoluteSize.X - v4, 1e999))
	end
end

function extended:render()
	local createElement = Roact.createElement
	local backBarRefsByRef = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, 0),
		LayoutOrder = self.props.LayoutOrder,
		Visible = Roact.joinBindings({ self.state.text, self.visibleBinding }):map(function(list)
			local backEnabled = self.props.backEnabled

			if backEnabled then
				return not (list[1] == nil) and list[2]
			end

			return backEnabled
		end),
		Size = Roact.joinBindings({ self.sizeBinding, self.buttonHeightBinding }):map(function(list)
			local item = list[1]
			local item2 = list[2]

			if item and item2 then
				return UDim2.new(UDim.new(item.X.Scale * 0.5, item.X.Offset * 0.5), UDim.new(0, item2 + 6))
			end

			return UDim2.new()
		end),
		[Roact.Ref] = self.props.BackBarRef
	}
	local v2 = {
		SizeConnection = Roact.createElement(ExternalEventConnection, {
			event = self.props.HubBar:GetPropertyChangedSignal("Size"),
			callback = function()
				self.updateSizeBinding(self.props.HubBar.Size)
			end
		}),
		VisibleConnection = Roact.createElement(ExternalEventConnection, {
			event = self.props.HubBar:GetPropertyChangedSignal("Visible"),
			callback = function()
				self.updateVisibleBinding(self.props.HubBar.Visible)
			end
		}),
		ViewportSizeChangedConnection = Roact.createElement(ExternalEventConnection, {
			event = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),
			callback = function()
				self:updateViewport()
			end
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 10)
		}),
		ImageButton = 0
	}

	local createElement2 = Roact.createElement
	local v3 = {
		Image = "",
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.color("DefaultButton"),
		BackgroundTransparency = Theme.transparency("DefaultButton", 1),
		Position = UDim2.new(0, 0, 0, 0),
		Size = self.buttonHeightBinding:map(function(p)
			if p then
				return UDim2.new(0, 0, 0, p)
			end

			return UDim2.new()
		end),
		AutomaticSize = Enum.AutomaticSize.X,
		ScaleType = Enum.ScaleType.Stretch,
		SliceCenter = Rect.new(8, 6, 46, 44),
		[Roact.Event.MouseEnter] = function(p)
			p.BackgroundColor3 = Theme.color("DefaultButtonHover")
			p.BackgroundTransparency = Theme.transparency("DefaultButtonHover")
		end,
		[Roact.Event.MouseLeave] = function(p)
			p.BackgroundColor3 = Theme.color("DefaultButton")
			p.BackgroundTransparency = Theme.transparency("DefaultButton")
		end,
		[Roact.Event.Activated] = function(_)
			BackButtonController.initiateBackButtonTeleport(Enum.AdTeleportMethod.InGameMenuBackButton)
		end
	}
	local v4 = {
		UICorner = Roact.createElement("UICorner", { CornerRadius = Theme.DefaultCornerRadius }),
		UIStroke = Roact.createElement("UIStroke", {
			Color = Theme.color("DefaultButtonStroke"),
			Transparency = Theme.transparency("DefaultButtonStroke"),
			Thickness = Theme.DefaultStokeThickness
		}),
		Frame = 0
	}

	local createElement3 = Roact.createElement
	local v5 = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 4, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local v6 = {
		UIPadding = Roact.createElement("UIPadding", { PaddingRight = UDim.new(0, 12) }),
		Container = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		ImageLabel = 0,
		TextLabel = 0
	}
	local imageLabel

	if FFlagCoreUiMigrateUIBloxToFoundation then
		imageLabel = Roact.createElement(Foundation.Icon, {
			name = "icons/actions/cycleLeft",
			size = Foundation.Enums.IconSize.Large,
			LayoutOrder = 1
		})
	else
		imageLabel = Roact.createElement(ImageSetLabel, {
			Image = Images["icons/actions/cycleLeft"],
			Size = UDim2.new(1, 0, 0.75, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {})
		})
	end

	v6.ImageLabel = imageLabel

	v6.TextLabel = Roact.createElement("TextLabel", {
		Text = self.state.text,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextYAlignment = Enum.TextYAlignment.Center,
		Font = Theme.font(Enum.Font.SourceSansBold, "Bold"),
		TextSize = self.textSizeBinding,
		TextScaled = true,
		TextWrapped = true,
		LayoutOrder = 2,
		[Roact.Ref] = self.textLabelRef
	}, {
		UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
			MaxTextSize = self.textSizeConstraintBinding
		}),
		UISizeConstraint = Roact.createElement("UISizeConstraint", {
			MaxSize = self.sizeConstraintBinding
		})
	})
	v4.Frame = createElement3("Frame", v5, v6)
	v2.ImageButton = createElement2("ImageButton", v3, v4)
	return createElement("Frame", backBarRefsByRef, v2)
end

return extended
