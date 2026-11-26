local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/deferred/hin")
local module2 = require("@luauforge/bundled/dWP")
require("@luauforge/bundled/dKT")

local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useFocusOnMountEffect = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useFocusOnMountEffect

local module3 = require("@luauforge/deferred/hio")

local function AdjustmentTypeButtons(p2)
	local theme = useStyle().Theme
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local v5 = useFocusGuiObject()

	local v6 = p2.adjustmentTypeSelected == module2.Scale
	local v7 = p2.adjustmentTypeSelected == module2.Position

	if module3 then
		useFocusOnMountEffect(ref)
	else
		React.useEffect(function()
			if v5 then
				v5(ref.current)
			end
		end, { v5 })
	end

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			BackgroundTransparency = theme.BackgroundUIDefault.Transparency,
			LayoutOrder = p2.LayoutOrder
		},
		{
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			MoveButton = React.createElement(module, {
				LayoutOrder = 1,
				isSelected = p2.adjustmentTypeSelected == module2.Position,
				adjustmentType = module2.Position,
				iconName = "icons/menu/adjust/position_small",
				buttonRef = ref
			}),
			Divider1 = React.createElement("Frame", {
				Size = UDim2.new(0, 1, 1, 0),
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency,
				LayoutOrder = 2,
				Visible = v6,
				BorderSizePixel = 0
			}),
			RotateButton = React.createElement(module, {
				LayoutOrder = 3,
				isSelected = p2.adjustmentTypeSelected == module2.Rotation,
				adjustmentType = module2.Rotation,
				iconName = "icons/menu/adjust/rotation_small",
				buttonRef = ref2
			}),
			Divider2 = React.createElement("Frame", {
				Size = UDim2.new(0, 1, 1, 0),
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency,
				LayoutOrder = 4,
				Visible = v7,
				BorderSizePixel = 0
			}),
			ScaleButton = React.createElement(module, {
				LayoutOrder = 5,
				isSelected = p2.adjustmentTypeSelected == module2.Scale,
				adjustmentType = module2.Scale,
				iconName = "icons/menu/adjust/scale_small",
				buttonRef = ref3
			})
		}
	)
end

return AdjustmentTypeButtons
