local t1 = {
	ScreenUI = "ScreenUI",
	SpatialUI = "SpatialUI",
	SpatialUIPartOnly = "SpatialUIPartOnly",
	SpatialUIRoact = "SpatialUIRoact"
}
local t2 = {
	Chat = "Chat",
	RobloxGui = "RobloxGui",
	BottomBar = "BottomBar",
	MoreMenu = "MoreMenu"
}
local t3 = {
	MainUIGroup = "MainUIGroup",
	WristUIGroup = "WristUIGroup"
}
local v4 = Vector2.new(0.1365, 0.1995) * 3.3333333333333335
local v5 = Vector2.new(0.532, 0.3395) * 3.3333333333333335
local cFrame = CFrame.new(v5.X * 0.5 + v4.X * 0.5 + 0.06666666666666667, (v5.Y - v4.Y) / 2, 0)
local t4 = {
	[t2.Chat] = {
		type = t1.SpatialUI,
		spatialPanelProps = {
			name = "ExperienceChat",
			faceCamera = true,
			lerp = true,
			partSize = v4,
			virtualScreenSize = v4 * 800
		}
	},
	[t2.RobloxGui] = {
		type = t1.SpatialUIPartOnly,
		spatialPanelProps = {
			name = "RobloxGuiPanel-PartOnly",
			faceCamera = true,
			lerp = true,
			transparency = 0.5,
			partSize = v5
		}
	}
}
local t5 = {
	[t2.Chat] = {
		uiGroup = t3.MainUIGroup,
		cameraFixedPanelProp = {
			uiGroupElementOffset = cFrame
		}
	},
	[t2.RobloxGui] = {
		uiGroup = t3.MainUIGroup,
		cameraFixedPanelProp = {
			uiGroupElementOffset = CFrame.new(0, 0, 0)
		}
	}
}
local v9 = CFrame.new(0, -v5.Y * 0.5 - 0.075 - 0.03333333333333333, 0) * CFrame.Angles(0, 3.141592653589793, 0)
local v10 = CFrame.new(0.4, -0.36, 0) * CFrame.Angles(0, 3.141592653589793, 0)
local t6 = {
	[t2.BottomBar] = t3.MainUIGroup,
	[t2.MoreMenu] = t3.MainUIGroup
}
local t7 = {
	[t2.BottomBar] = v9,
	[t2.MoreMenu] = v10
}

return {
	VR_PANEL_RESOLUTION_MULTIPLIER = 800,
	BOTTOM_BAR_BASE_PART_SIZE = 0.15,
	SpatialUIType = t1,
	SpatialUIGroupType = t3,
	PanelType = t2,
	DEFAULT_VR_PANEL_SIZE = Vector2.new(10, 10),
	COMPAT_PANEL_PROPS_MAP = t4,
	SPATIAL_PANEL_POSITION_PROPS_MAP = t5,
	ROACT_PANEL_UIGROUP_MAP = t6,
	ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP = t7
}
