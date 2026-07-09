local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useStyle = UIBlox.Core.Style.useStyle
local Modules = CoreGui.RobloxGui.Modules
local AdjustmentTypeButton = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AdjustmentTypeButton)
local AdjustmentType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentType)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local Focusable = RoactGamepad.Focusable

local function AdjustmentTypeButtons(t1: {[any]: any}) -- line: 46
	-- upvalues: useStyle (copy), React (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), useFocusGuiObject (copy), AdjustmentType (copy), Focusable (copy), AdjustmentTypeButton (copy)
	local Theme = useStyle().Theme
	local v16 = React.useRef(nil)
	local v17 = React.useRef(nil)
	local v18 = React.useRef(nil)
	local v19 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useFocusGuiObject()
	local v20 = t1.adjustmentTypeSelected == AdjustmentType.Scale
	local v21 = t1.adjustmentTypeSelected == AdjustmentType.Position

	if FFlagAXMigrateAXToGlobalAutofocus and v19 then
		React.useEffect(function() -- line: 58
			-- upvalues: v19 (copy), v16 (copy)
			v19(v16.current)
		end, { v19 })
	end

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = Theme.BackgroundUIDefault.Transparency,
		LayoutOrder = t1.LayoutOrder,
		ref = if not FFlagAXMigrateAXToGlobalAutofocus then t1.frameRef else nil,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v16 else nil,
		restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then t1.NextSelectionDown else nil
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
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
		MoveButton = React.createElement(AdjustmentTypeButton, {
			LayoutOrder = 1,
			iconName = "icons/menu/adjust/position_small",
			isSelected = t1.adjustmentTypeSelected == AdjustmentType.Position,
			adjustmentType = AdjustmentType.Position,
			buttonRef = v16,
			NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then t1.NextSelectionLeft else nil,
			NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then t1.NextSelectionUp else nil,
			NextSelectionRight = if not FFlagAXMigrateAXToGlobalAutofocus then v17 else nil
		}),
		Divider1 = React.createElement("Frame", {
			LayoutOrder = 2,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 1, 1, 0),
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency,
			Visible = v20
		}),
		RotateButton = React.createElement(AdjustmentTypeButton, {
			LayoutOrder = 3,
			iconName = "icons/menu/adjust/rotation_small",
			isSelected = t1.adjustmentTypeSelected == AdjustmentType.Rotation,
			adjustmentType = AdjustmentType.Rotation,
			buttonRef = v17,
			NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then t1.NextSelectionUp else nil,
			NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then v16 else nil,
			NextSelectionRight = if not FFlagAXMigrateAXToGlobalAutofocus then v18 else nil
		}),
		Divider2 = React.createElement("Frame", {
			LayoutOrder = 4,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 1, 1, 0),
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency,
			Visible = v21
		}),
		ScaleButton = React.createElement(AdjustmentTypeButton, {
			LayoutOrder = 5,
			iconName = "icons/menu/adjust/scale_small",
			isSelected = t1.adjustmentTypeSelected == AdjustmentType.Scale,
			adjustmentType = AdjustmentType.Scale,
			buttonRef = v18,
			NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then t1.NextSelectionUp else nil,
			NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then v17 else nil,
			NextSelectionRight = if not FFlagAXMigrateAXToGlobalAutofocus then t1.NextSelectionRight else nil
		})
	})
end

return AdjustmentTypeButtons
