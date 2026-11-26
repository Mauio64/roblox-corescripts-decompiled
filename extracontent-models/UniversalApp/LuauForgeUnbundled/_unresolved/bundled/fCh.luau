local module = require("@luauforge/bundled/dPt")
local cameraZoomRadius = module.Constants.CameraZoomRadius
local focusType = module.Enums.FocusType
local module2 = require("@luauforge/bundled/dWP")
local module3 = require("@luauforge/bundled/fCi")
local Extents = require("@game/CorePackages/Packages/_Index/UGCValidation/UGCValidation/util/Extents")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local v5 = {}

v5.XAxisColor = Color3.fromRGB(242, 64, 68)
v5.YAxisColor = Color3.fromRGB(11, 151, 88)
v5.ZAxisColor = Color3.fromRGB(86, 122, 252)
v5.LineDiameter = 0.05
v5.LineThickness = 5
v5.LineHandleData = {
	{
		Color3 = v5.XAxisColor,
		Orientation = CFrame.Angles(0, 0, 0),
		LimitKey = "xPosition",
		Direction = -1,
		AxisType = Extents.X
	},
	{
		Color3 = v5.XAxisColor,
		Orientation = CFrame.Angles(0, 3.141592653589793, 0),
		LimitKey = "xPosition",
		Direction = 1,
		AxisType = Extents.X
	},
	{
		Color3 = v5.YAxisColor,
		Orientation = CFrame.Angles(0, 0, -1.5707963267948966),
		LimitKey = "yPosition",
		Direction = 1,
		AxisType = Extents.Y
	},
	{
		Color3 = v5.YAxisColor,
		Orientation = CFrame.Angles(0, 0, 1.5707963267948966),
		LimitKey = "yPosition",
		Direction = -1,
		AxisType = Extents.Y
	},
	{
		Color3 = v5.ZAxisColor,
		Orientation = CFrame.Angles(0, 1.5707963267948966, 0),
		LimitKey = "zPosition",
		Direction = -1,
		AxisType = Extents.Z
	},
	{
		Color3 = v5.ZAxisColor,
		Orientation = CFrame.Angles(0, -1.5707963267948966, 0),
		LimitKey = "zPosition",
		Direction = 1,
		AxisType = Extents.Z
	}
}

v5.RingData = {
	{
		["Color3"] = v5.XAxisColor,
		Orientation = CFrame.Angles(0, 0, 1.5707963267948966)
	},
	{ ["Color3"] = v5.YAxisColor, Orientation = CFrame.Angles(0, 0, 0) },
	{
		["Color3"] = v5.ZAxisColor,
		Orientation = CFrame.Angles(1.5707963267948966, 0, 0)
	}
}

v5.FontFace = Font.new(
	"rbxasset://fonts/families/BuilderSans.json",
	Enum.FontWeight.ExtraBold,
	Enum.FontStyle.Normal
)

v5.CameraCategories = {
	[Enum.AccessoryType.Hat] = {
		Name = "Hat",
		Title = "Hat",
		CameraFocus = focusType.Head,
		CameraZoomRadius = cameraZoomRadius.AccessoryAdjustment.Hat
	},
	[Enum.AccessoryType.Face] = {
		Name = "Face",
		Title = "Face",
		CameraFocus = focusType.Face,
		CameraZoomRadius = cameraZoomRadius.AccessoryAdjustment.Face
	},
	[Enum.AccessoryType.Neck] = {
		Name = "Neck",
		Title = "Neck",
		CameraFocus = focusType.Neck,
		CameraZoomRadius = cameraZoomRadius.AccessoryAdjustment.Neck
	},
	[Enum.AccessoryType.Shoulder] = {
		Name = "Shoulder",
		Title = "Shoulder",
		CameraFocus = focusType.Shoulders,
		CameraZoomRadius = cameraZoomRadius.AccessoryAdjustment.Shoulder
	},
	[Enum.AccessoryType.Front] = {
		Name = "Front",
		Title = "Front",
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.AccessoryAdjustment.Front
	},
	[Enum.AccessoryType.Back] = {
		Name = "Back",
		Title = "Back",
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.AccessoryAdjustment.Back
	},
	[Enum.AccessoryType.Waist] = {
		Name = "Waist",
		Title = "Waist",
		CameraFocus = focusType.Waist,
		CameraZoomRadius = cameraZoomRadius.AccessoryAdjustment.Waist
	}
}

v5.DefaultSliderValues = {
	[module3.PositionX] = 0,
	[module3.PositionY] = 0,
	[module3.PositionZ] = 0,
	[module3.RotationX] = 0,
	[module3.RotationY] = 0,
	[module3.RotationZ] = 0,
	[module3.Scale] = 1
}

v5.AdjustmentSliderTypeToAdjustmentType = {
	[module3.PositionX] = module2.Position,
	[module3.PositionY] = module2.Position,
	[module3.PositionZ] = module2.Position,
	[module3.RotationX] = module2.Rotation,
	[module3.RotationY] = module2.Rotation,
	[module3.RotationZ] = module2.Rotation,
	[module3.Scale] = module2.Scale
}

return v5
