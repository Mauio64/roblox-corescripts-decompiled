local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/deferred/hhZ")
local module3 = require("@luauforge/deferred/hia")

require("@luauforge/bundled/dWP")
local module4 = require("@luauforge/bundled/dWO")

local fFlagAXUseSignalsForAdjustmentTypeSelected = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForAdjustmentTypeSelected
local getAdjustmentTypeSelectedStore

if fFlagAXUseSignalsForAdjustmentTypeSelected then
	getAdjustmentTypeSelectedStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getAdjustmentTypeSelectedStore
else
	getAdjustmentTypeSelectedStore = nil
end

local focusable = RoactGamepad.Focusable

local function AdjustmentTypeButton(props)
	local theme = useStyle().Theme
	local v5 = module(module2)

	local color = theme.BackgroundUIDefault.Color
	local transparency = theme.BackgroundUIDefault.Transparency

	if props.isSelected then
		color = theme.UIDefault.Color
		transparency = theme.UIDefault.Transparency
	end

	local v6 = useDispatch()
	return React.createElement(focusable.ImageButton, {
		Size = UDim2.fromScale(1 / 3, 1),
		BackgroundColor3 = color,
		BackgroundTransparency = transparency,
		LayoutOrder = props.LayoutOrder,
		ref = props.buttonRef,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionUp = props.NextSelectionUp,
		[React.Event.Activated] = function()
			v6(module3(v5.avatarRefineAccessoryAdjustTap(props.adjustmentType)))

			if fFlagAXUseSignalsForAdjustmentTypeSelected then
				getAdjustmentTypeSelectedStore(false).setAdjustmentType(props.adjustmentType)
			else
				v6(module4(props.adjustmentType))
			end
		end
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		Image = React.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
			BackgroundTransparency = 1,
			Image = images[props.iconName],
			ImageColor3 = theme.IconDefault.Color,
			ImageTransparency = theme.IconDefault.Transparency
		})
	})
end

return AdjustmentTypeButton
