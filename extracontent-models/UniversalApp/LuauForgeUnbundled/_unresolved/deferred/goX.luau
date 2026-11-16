local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local module = require("@luauforge/deferred/goY")
local module2 = require("@luauforge/deferred/gma")
require("@luauforge/bundled/dHK")
local module3 = require("@luauforge/deferred/goZ")

local module4 = require("@luauforge/deferred/gpa")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useDeviceOrientation = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useDeviceOrientation
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode

local module5 = require("@luauforge/deferred/gpb")

local module6 = require("@luauforge/deferred/gpc")

local extended = Roact.PureComponent:extend("SceneUIContainer")

extended.defaultProps = { isVisible = true }

function extended:init()
	self.robuxBalanceRef = Roact.createRef()
	self.quickMenuRef = Roact.createRef()
end

function extended:renderRobloxBalanceContainer()
	return Roact.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		LayoutOrder = 2
	}, {
		RobuxBalance = Roact.createElement(module2, {
			[Roact.Ref] = self.robuxBalanceRef,
			NextSelectionLeft = self.quickMenuRef
		})
	})
end

function extended:getRow1Children()
	local showRobuxBalance = self.props.showRobuxBalance

	local row1Children = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5)
		}),
		QuickMenuButton = 0,
		RobuxBalanceContainer = 0
	}
	local v5

	if self.props.showQuickMenuButton then
		v5 = Roact.createElement(module6, {
			[Roact.Ref] = self.quickMenuRef,
			NextSelectionRight = self.robuxBalanceRef
		})
	end

	row1Children.QuickMenuButton = v5

	local v6 = if not module5 then showRobuxBalance and self:renderRobloxBalanceContainer() else nil
	row1Children.RobuxBalanceContainer = v6
	return row1Children
end

function extended:render()
	local isVisible = self.props.isVisible

	local forwardRef = self.props.forwardRef
	local v5

	if self.props.deviceOrientation == deviceOrientationMode.Landscape then
		local designTokens = self.props.designTokens

		if module4() then
			v5 = self.props.statusBarHeight + designTokens.Size.Size_300
		else
			v5 = ((self.props.globalGuiInset or {}).top or 0) + designTokens.Size.Size_300
		end
	else
		v5 = 4
	end

	return Roact.createElement(focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 72),
		Position = UDim2.new(0, -12, 0, v5),
		Visible = isVisible,
		[Roact.Ref] = forwardRef,
		restorePreviousChildFocus = true,
		defaultChild = self.quickMenuRef
	}, {
		Row1 = Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 36),
				Visible = self.props.row1ChildrenVisible
			},
			self:getRow1Children()
		),
		FullViewIndicator = Roact.createElement(module, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 40)
		})
	})
end

return Roact.forwardRef(function(p2, p3)
	local v5 = module3()
	local v6 = useDesignTokens()
	local v7 = useDeviceOrientation()
	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p2, {
			forwardRef = p3,
			showQuickMenuButton = v5,
			designTokens = v6,
			deviceOrientation = v7
		})
	)
end)
