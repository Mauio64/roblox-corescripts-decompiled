local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Constants = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Constants
local Modules = CoreGui.RobloxGui.Modules
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local AdjustmentType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentType)
local AdjustmentSliderType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentSliderType)
local AxisType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AxisType)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local t1 = {
	XAxisColor = Color3.fromRGB(242, 64, 68),
	YAxisColor = Color3.fromRGB(11, 151, 88),
	ZAxisColor = Color3.fromRGB(86, 122, 252),
	LineDiameter = 0.05,
	LineThickness = 5
}

t1.LineHandleData = {
	[1] = {
		LimitKey = "xPosition",
		Direction = -1,
		Color3 = t1.XAxisColor,
		Orientation = CFrame.Angles(0, 0, 0),
		AxisType = AxisType.X
	},
	[2] = {
		LimitKey = "xPosition",
		Direction = 1,
		Color3 = t1.XAxisColor,
		Orientation = CFrame.Angles(0, 3.141592653589793, 0),
		AxisType = AxisType.X
	},
	[3] = {
		LimitKey = "yPosition",
		Direction = 1,
		Color3 = t1.YAxisColor,
		Orientation = CFrame.Angles(0, 0, -1.5707963267948966),
		AxisType = AxisType.Y
	},
	[4] = {
		LimitKey = "yPosition",
		Direction = -1,
		Color3 = t1.YAxisColor,
		Orientation = CFrame.Angles(0, 0, 1.5707963267948966),
		AxisType = AxisType.Y
	},
	[5] = {
		LimitKey = "zPosition",
		Direction = -1,
		Color3 = t1.ZAxisColor,
		Orientation = CFrame.Angles(0, 1.5707963267948966, 0),
		AxisType = AxisType.Z
	},
	[6] = {
		LimitKey = "zPosition",
		Direction = 1,
		Color3 = t1.ZAxisColor,
		Orientation = CFrame.Angles(0, -1.5707963267948966, 0),
		AxisType = AxisType.Z
	}
}
t1.RingData = {
	[1] = {
		Color3 = t1.XAxisColor,
		Orientation = CFrame.Angles(0, 0, 1.5707963267948966)
	},
	[2] = {
		Color3 = t1.YAxisColor,
		Orientation = CFrame.Angles(0, 0, 0)
	},
	[3] = {
		Color3 = t1.ZAxisColor,
		Orientation = CFrame.Angles(1.5707963267948966, 0, 0)
	}
}
t1.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
t1.CameraCategories = {
	[Enum.AccessoryType.Hat] = {
		Name = "Hat",
		Title = "Hat",
		CameraFocus = Constants2.FocusType.Head,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AccessoryAdjustment.Hat
	},
	[Enum.AccessoryType.Face] = {
		Name = "Face",
		Title = "Face",
		CameraFocus = Constants2.FocusType.Face,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AccessoryAdjustment.Face
	},
	[Enum.AccessoryType.Neck] = {
		Name = "Neck",
		Title = "Neck",
		CameraFocus = Constants2.FocusType.Neck,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AccessoryAdjustment.Neck
	},
	[Enum.AccessoryType.Shoulder] = {
		Name = "Shoulder",
		Title = "Shoulder",
		CameraFocus = Constants2.FocusType.Shoulders,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AccessoryAdjustment.Shoulder
	},
	[Enum.AccessoryType.Front] = {
		Name = "Front",
		Title = "Front",
		CameraFocus = Constants2.FocusType.Arms,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AccessoryAdjustment.Front
	},
	[Enum.AccessoryType.Back] = {
		Name = "Back",
		Title = "Back",
		CameraFocus = Constants2.FocusType.Arms,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AccessoryAdjustment.Back
	},
	[Enum.AccessoryType.Waist] = {
		Name = "Waist",
		Title = "Waist",
		CameraFocus = Constants2.FocusType.Waist,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AccessoryAdjustment.Waist
	}
}
t1.DefaultSliderValues = {
	[AdjustmentSliderType.PositionX] = 0,
	[AdjustmentSliderType.PositionY] = 0,
	[AdjustmentSliderType.PositionZ] = 0,
	[AdjustmentSliderType.RotationX] = 0,
	[AdjustmentSliderType.RotationY] = 0,
	[AdjustmentSliderType.RotationZ] = 0,
	[AdjustmentSliderType.Scale] = 1
}
t1.AdjustmentSliderTypeToAdjustmentType = {
	[AdjustmentSliderType.PositionX] = AdjustmentType.Position,
	[AdjustmentSliderType.PositionY] = AdjustmentType.Position,
	[AdjustmentSliderType.PositionZ] = AdjustmentType.Position,
	[AdjustmentSliderType.RotationX] = AdjustmentType.Rotation,
	[AdjustmentSliderType.RotationY] = AdjustmentType.Rotation,
	[AdjustmentSliderType.RotationZ] = AdjustmentType.Rotation,
	[AdjustmentSliderType.Scale] = AdjustmentType.Scale
}

return t1
