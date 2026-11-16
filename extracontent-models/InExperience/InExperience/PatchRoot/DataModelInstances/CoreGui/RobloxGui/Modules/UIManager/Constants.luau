local spatialUIType = {
	ScreenUI = "ScreenUI",
	SpatialUI = "SpatialUI",
	SpatialUIPartOnly = "SpatialUIPartOnly",
	SpatialUIRoact = "SpatialUIRoact"
}

local panelType = {
	Chat = "Chat",
	RobloxGui = "RobloxGui",
	BottomBar = "BottomBar",
	MoreMenu = "MoreMenu"
}

local spatialUIGroupType = { MainUIGroup = "MainUIGroup", WristUIGroup = "WristUIGroup" }

local partSize = Vector2.new(0.1365, 0.1995) * (10 / 3)

local partSize2 = Vector2.new(0.532, 0.3395) * (10 / 3)

local cframe = CFrame.new(partSize2.X * 0.5 + partSize.X * 0.5 + 1 / 15, (partSize2.Y - partSize.Y) / 2, 0)

local v = {
	[panelType.Chat] = {
		type = spatialUIType.SpatialUI,
		spatialPanelProps = {
			name = "ExperienceChat",
			faceCamera = true,
			lerp = true,
			partSize = partSize,
			virtualScreenSize = partSize * 800
		}
	},
	[panelType.RobloxGui] = {
		type = spatialUIType.SpatialUIPartOnly,
		spatialPanelProps = {
			name = "RobloxGuiPanel-PartOnly",
			faceCamera = true,
			lerp = true,
			partSize = partSize2,
			transparency = 0.5
		}
	}
}

local v2 = {
	[panelType.Chat] = {
		uiGroup = spatialUIGroupType.MainUIGroup,
		cameraFixedPanelProp = { uiGroupElementOffset = cframe }
	},
	[panelType.RobloxGui] = {
		uiGroup = spatialUIGroupType.MainUIGroup,
		cameraFixedPanelProp = { uiGroupElementOffset = CFrame.new(0, 0, 0) }
	}
}

local v3 = CFrame.new(0, -partSize2.Y * 0.5 - 0.075 - 1 / 30, 0) * CFrame.Angles(0, 3.141592653589793, 0)

local v4 = CFrame.new(0.4, -0.36, 0) * CFrame.Angles(0, 3.141592653589793, 0)

local mainUIGroups = {
	[panelType.BottomBar] = spatialUIGroupType.MainUIGroup,
	[panelType.MoreMenu] = spatialUIGroupType.MainUIGroup
}

local v5 = { [panelType.BottomBar] = v3, [panelType.MoreMenu] = v4 }

return {
	SpatialUIType = spatialUIType,
	SpatialUIGroupType = spatialUIGroupType,
	PanelType = panelType,
	DEFAULT_VR_PANEL_SIZE = Vector2.new(10, 10),
	VR_PANEL_RESOLUTION_MULTIPLIER = 800,
	BOTTOM_BAR_BASE_PART_SIZE = 0.15,
	COMPAT_PANEL_PROPS_MAP = v,
	SPATIAL_PANEL_POSITION_PROPS_MAP = v2,
	ROACT_PANEL_UIGROUP_MAP = mainUIGroups,
	ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP = v5
}
