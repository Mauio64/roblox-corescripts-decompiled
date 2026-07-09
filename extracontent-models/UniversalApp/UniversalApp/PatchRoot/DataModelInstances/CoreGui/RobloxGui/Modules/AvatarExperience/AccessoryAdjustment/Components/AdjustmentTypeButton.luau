local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.AccessoryAdjustment.Services.Analytics)
local SendRefinementAnalytics = require(Modules.AvatarExperience.AccessoryAdjustment.Thunks.SendRefinementAnalytics)

require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentType)

local SetAdjustmentType = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetAdjustmentType)
local Focusable = RoactGamepad.Focusable

local function AdjustmentTypeButton(t1: {[any]: any}) -- line: 39
	-- upvalues: useStyle (copy), useRoactService (copy), Analytics (copy), useDispatch (copy), React (copy), Focusable (copy), SendRefinementAnalytics (copy), SetAdjustmentType (copy), ImageSetLabel (copy), IconSize (copy), Images (copy)
	local Theme = useStyle().Theme
	local v19 = useRoactService(Analytics)
	local BackgroundUIDefaultColor = Theme.BackgroundUIDefault.Color
	local BackgroundUIDefaultTransparency = Theme.BackgroundUIDefault.Transparency

	if t1.isSelected then
		BackgroundUIDefaultColor = Theme.UIDefault.Color
		BackgroundUIDefaultTransparency = Theme.UIDefault.Transparency
	end

	local v22 = useDispatch()

	return React.createElement(Focusable.ImageButton, {
		Size = UDim2.fromScale(0.3333333333333333, 1),
		BackgroundColor3 = BackgroundUIDefaultColor,
		BackgroundTransparency = BackgroundUIDefaultTransparency,
		LayoutOrder = t1.LayoutOrder,
		ref = t1.buttonRef,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight,
		NextSelectionUp = t1.NextSelectionUp,
		[React.Event.Activated] = function() -- line: 63
			-- upvalues: v22 (copy), SendRefinementAnalytics (copy), v19 (copy), t1 (copy), SetAdjustmentType (copy)
			v22(SendRefinementAnalytics(v19.avatarRefineAccessoryAdjustTap(t1.adjustmentType)))
			v22(SetAdjustmentType(t1.adjustmentType))
		end
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Image = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
			Image = Images[t1.iconName],
			ImageColor3 = Theme.IconDefault.Color,
			ImageTransparency = Theme.IconDefault.Transparency
		})
	})
end

return AdjustmentTypeButton
