local inExperienceUIVRIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedExperimentDefinition").InExperienceUIVRIXP
local isInExperienceUIVREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedExperimentDefinition").isInExperienceUIVREnabled

local v5 = if isInExperienceUIVREnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/LuauPolyfill") else nil

local vector2 = Vector2.new(0, 0)
local v6 = CFrame.new(0, 0, 0)

local v7 = game:DefineFastInt("SpatialUIResolutionScale", 100) / 100
local defineFastInt = game:DefineFastInt("SpatialUIPanelDragBarDistance", 10)
local defineFastInt2 = game:DefineFastInt("SpatialUIPanelZOffset", 100)
local fFlagEnableInExperienceUIPCVRFix = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedFlags").FFlagEnableInExperienceUIPCVRFix

local defineFastInt3 = game:DefineFastInt("SpatialUIChromeSubMenuHeight", 448)

local v8 = {
	ScreenUI = "ScreenUI",
	SpatialUI = "SpatialUI",
	SpatialUIPartOnly = "SpatialUIPartOnly",
	SpatialUIRoact = "SpatialUIRoact"
}

local v9 = {
	Chat = "Chat",
	RobloxGui = "RobloxGui",
	BottomBar = "BottomBar",
	MoreMenu = "MoreMenu",
	ChromeSubMenu = "ChromeSubMenu",
	ToolTipsContainer = "ToolTipsContainer"
}

local v10 = {
	MainUIGroup = "MainUIGroup",
	MenuUIGroup = "MenuUIGroup",
	ChatUIGroup = "ChatUIGroup",
	ChromeSubMenuUIGroup = "ChromeSubMenuUIGroup",
	WristUIGroup = "WristUIGroup"
}

local v11 = 800 / v7

local function pixelToScaledSize(p2)
	return p2 / v11
end

local function getScaledResolutionForPart(p2, p3)
	return Vector2.new(p2 / v11, p3 / v11)
end

local function panelDistanceWithSpacing(p2, p3, p4)
	local v12 = p4 / v11

	local v13 = p2.X * 0.5 + p3.X * 0.5 + v12
	local v14 = p2.Y * 0.5 + p3.Y * 0.5 + v12
	return Vector2.new(v13, v14)
end

local function alignPanelLeftToAnchor(p2, p3)
	return p3.X * 0.5 - p2.X * 0.5
end

local function alignPanelTopToAnchor(p2, p3)
	return p2.Y * 0.5 - p3.Y * 0.5
end

local function alignPanelBottomToAnchor(p2, p3)
	return p3.Y * 0.5 - p2.Y * 0.5
end

local function getAdditionalZOffsetIfNeeded()
	if inExperienceUIVRIXP:isMovePanelToCenter() then
		return defineFastInt2 / 1000
	end

	return 0
end

local v12 = {
	PANEL_TO_PANEL = 10,
	PANEL_TO_BOTTOMBAR = 10,
	PANEL_TO_DRAGBAR = defineFastInt,
	PANEL_TO_CHROME_BOTTOM_OFFSET = 24
}

local function getPanelAroundLeftOrRightEdgeRotation(p2, p3)
	local v13 = p2.X * 0.5 + v12.PANEL_TO_PANEL / v11 * 0.5

	local vector3 = if p3 > 0 then Vector3.new(v13, 0, 0) else Vector3.new(-1 * v13, 0, 0)

	local cframe = CFrame.new(vector3)
	local cframe2 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(p3)))
	local cframe3 = CFrame.new(-vector3)
	return cframe * cframe2 * cframe3
end

local v13

if isInExperienceUIVREnabled then
	v13 = Vector2.new(943 / v11, 640 / v11)
else
	v13 = Vector2.new(0.532, 0.3395) * (10 / 3)
end

local v14

if isInExperienceUIVREnabled then
	v14 = Vector2.new(434 / v11, 264 / v11)
else
	v14 = Vector2.new(0.1365, 0.1995) * (10 / 3)
end

local v15

if isInExperienceUIVREnabled then
	v15 = Vector2.new(800 / v11, 640 / v11)
else
	v15 = Vector2.new(0.532, 0.3395) * (10 / 3)
end

local v16

if isInExperienceUIVREnabled then
	v16 = Vector2.new(317 / v11, (not fFlagEnableInExperienceUIPCVRFix and 292 or defineFastInt3) / v11)
else
	v16 = vector2
end

local v17 = if isInExperienceUIVREnabled then Vector2.new(943 / v11, 64 / v11) else vector2
local v18 = if isInExperienceUIVREnabled then Vector2.new(v17.X, 120 / v11) else vector2
local v19 = if isInExperienceUIVREnabled then Vector2.new(296 / v11, 40 / v11) else vector2
local v20

if isInExperienceUIVREnabled then
	v20 = {}
	v20[v10.MenuUIGroup] = getPanelAroundLeftOrRightEdgeRotation(
		v15,
		inExperienceUIVRIXP:isMovePanelToCenter() and 0 or 15
	)

	v20[v10.ChatUIGroup] = getPanelAroundLeftOrRightEdgeRotation(
		v14,
		inExperienceUIVRIXP:isMovePanelToCenter() and 0 or -15
	)
else
	v20 = {}
end

local v21

if isInExperienceUIVREnabled then
	local newCFrame = CFrame.new
	local v22

	if inExperienceUIVRIXP:isMovePanelToCenter() then
		v22 = 0
	else
		local v23 = v12.PANEL_TO_PANEL / v11
		local v24 = v13.X * 0.5 + v15.X * 0.5 + v23
		local v25 = v13.Y * 0.5 + v15.Y * 0.5 + v23
		v22 = -1 * Vector2.new(v24, v25).X
	end

	v21 = newCFrame(
		v22,
		v13.Y * 0.5 - v15.Y * 0.5,
		not inExperienceUIVRIXP:isMovePanelToCenter() and 0 or defineFastInt2 / 1000
	) * v20[v10.MenuUIGroup]
else
	v21 = CFrame.new(0.4, -0.36, 0) * CFrame.Angles(0, 3.141592653589793, 0)
end

local v22

if isInExperienceUIVREnabled then
	local newCFrame = CFrame.new
	local v23

	if inExperienceUIVRIXP:isMovePanelToCenter() then
		v23 = v14.X * 0.5 - v13.X * 0.5
	else
		local v24 = v12.PANEL_TO_PANEL / v11
		local v25 = v13.X * 0.5 + v14.X * 0.5 + v24
		local v26 = v13.Y * 0.5 + v14.Y * 0.5 + v24
		v23 = Vector2.new(v25, v26).X
	end

	v22 = newCFrame(
		v23,
		v13.Y * 0.5 - v14.Y * 0.5,
		not inExperienceUIVRIXP:isMovePanelToCenter() and 0 or defineFastInt2 / 1000
	) * v20[v10.ChatUIGroup]
else
	v22 = CFrame.new(v13.X * 0.5 + v14.X * 0.5 + 1 / 15, (v13.Y - v14.Y) / 2, 0)
end

local v23

if isInExperienceUIVREnabled then
	v23 = CFrame.new(
		0,
		v16.Y * 0.5 - v13.Y * 0.5 + v12.PANEL_TO_CHROME_BOTTOM_OFFSET / v11,
		not inExperienceUIVRIXP:isMovePanelToCenter() and 0 or defineFastInt2 / 1000
	) * CFrame.Angles(0, 3.141592653589793, 0)
else
	v23 = v6
end

if isInExperienceUIVREnabled then
	v6 = CFrame.new(
		0,
		v18.Y * 0.5 - v13.Y * 0.5 - v12.PANEL_TO_BOTTOMBAR / v11,
		not inExperienceUIVRIXP:isMovePanelToCenter() and 0 or defineFastInt2 / 1000
	) * CFrame.Angles(0, 3.141592653589793, 0)
end

local v24 = {}
v24[v9.Chat] = {
	type = v8.SpatialUI,
	spatialPanelProps = {
		name = "ExperienceChat",
		faceCamera = true,
		lerp = true,
		partSize = v14,
		virtualScreenSize = v14 * v11
	}
}

v24[v9.RobloxGui] = {
	type = v8.SpatialUIPartOnly,
	spatialPanelProps = {
		name = "RobloxGuiPanel-PartOnly",
		faceCamera = true,
		lerp = true,
		partSize = v13,
		transparency = 0.5
	}
}

if isInExperienceUIVREnabled then
	v24 = v5.Object.assign(v24, {
		[v9.MoreMenu] = {
			type = v8.SpatialUI,
			spatialPanelProps = {
				name = "MoreMenu",
				faceCamera = true,
				lerp = true,
				partSize = v15,
				virtualScreenSize = v15 * v11
			}
		},
		[v9.ChromeSubMenu] = {
			type = v8.SpatialUI,
			spatialPanelProps = {
				name = "ChromeSubMenu",
				faceCamera = true,
				lerp = true,
				partSize = v16,
				virtualScreenSize = v16 * v11
			}
		},
		[v9.ToolTipsContainer] = {
			type = v8.SpatialUI,
			spatialPanelProps = {
				name = "ToolTipsContainer",
				faceCamera = true,
				lerp = true,
				partSize = v18,
				virtualScreenSize = v18 * v11
			}
		}
	})
end

local chat = v9.Chat
local v27 = if isInExperienceUIVREnabled then v10.ChatUIGroup else v10.MainUIGroup
local v25 = {
	[chat] = {
		uiGroup = v27,
		cameraFixedPanelProp = { uiGroupElementOffset = v22 }
	},
	[v9.RobloxGui] = {
		uiGroup = v10.MainUIGroup,
		cameraFixedPanelProp = { uiGroupElementOffset = CFrame.new(0, 0, 0) }
	}
}

if isInExperienceUIVREnabled then
	v25 = v5.Object.assign(v25, {
		[v9.MoreMenu] = {
			uiGroup = v10.MenuUIGroup,
			cameraFixedPanelProp = { uiGroupElementOffset = v21 }
		},
		[v9.ChromeSubMenu] = {
			uiGroup = v10.ChromeSubMenuUIGroup,
			cameraFixedPanelProp = { uiGroupElementOffset = v23 }
		},
		[v9.ToolTipsContainer] = {
			uiGroup = v10.MainUIGroup,
			cameraFixedPanelProp = { uiGroupElementOffset = v6 }
		}
	})
end

local v28

if isInExperienceUIVREnabled then
	local newCFrame = CFrame.new
	local v29 = v12.PANEL_TO_BOTTOMBAR / v11
	local v30 = v13.X * 0.5 + v17.X * 0.5 + v29
	local v31 = v13.Y * 0.5 + v17.Y * 0.5 + v29
	v28 = newCFrame(0, -1 * Vector2.new(v30, v31).Y, 0) * CFrame.Angles(0, 3.141592653589793, 0)
else
	v28 = CFrame.new(0, -v13.Y * 0.5 - 0.075 - 1 / 30, 0) * CFrame.Angles(0, 3.141592653589793, 0)
end

local v29 = { [v9.BottomBar] = v10.MainUIGroup }
local moreMenu = v9.MoreMenu
local v30 = if isInExperienceUIVREnabled then v10.MenuUIGroup else v10.MainUIGroup
v29[moreMenu] = v30

if isInExperienceUIVREnabled then
	v29 = v5.Object.assign(v29, {
		[v9.Chat] = v10.ChatUIGroup,
		[v9.ChromeSubMenu] = v10.ChromeSubMenuUIGroup,
		[v9.ToolTipsContainer] = v10.MainUIGroup
	})
end

local v31 = {}
v31[v9.BottomBar] = v28
v31[v9.MoreMenu] = v21

if isInExperienceUIVREnabled then
	v31 = v5.Object.assign(v31, {
		[v9.Chat] = v22,
		[v9.ChromeSubMenu] = v23,
		[v9.ToolTipsContainer] = v6
	})
end

local function getDragBarOffsetForPanel(bottomBar, p2, p3, p4)
	if not p2 then
		local spatialPanelProps = v24[bottomBar].spatialPanelProps
		p2 = if spatialPanelProps then spatialPanelProps.partSize else vector2
	end

	local PANEL_TO_DRAGBAR = v12.PANEL_TO_DRAGBAR

	if p4 then
		PANEL_TO_DRAGBAR += p4
	end

	local v32 = v31[bottomBar]

	if p3 == true then
		v32 *= CFrame.Angles(0, -3.141592653589793, 0)
	end

	local newCFrame = CFrame.new
	local v33 = v19
	local v34 = PANEL_TO_DRAGBAR / v11

	local v35 = p2.X * 0.5 + v33.X * 0.5 + v34
	local v36 = p2.Y * 0.5 + v33.Y * 0.5 + v34
	return v32 * newCFrame(0, -1 * Vector2.new(v35, v36).Y, 0)
end

local cframesByMainUIGroup = {
	[v10.MainUIGroup] = CFrame.new(0, v31[v9.BottomBar].Y - 0.075 - 1 / 15, 0)
}

if isInExperienceUIVREnabled then
	local assign = v5.Object.assign
	local v32 = {
		[v10.MainUIGroup] = getDragBarOffsetForPanel(v9.BottomBar, v17, true)
	}
	local chatUIGroup = v10.ChatUIGroup
	local chat2 = v9.Chat
	local spatialPanelProps = v24[chat2].spatialPanelProps
	local v33 = if spatialPanelProps then spatialPanelProps.partSize else vector2

	local PANEL_TO_DRAGBAR = v12.PANEL_TO_DRAGBAR

	local v34 = v31[chat2]

	local newCFrame = CFrame.new
	local v35 = PANEL_TO_DRAGBAR / v11

	local v36 = v33.X * 0.5 + v19.X * 0.5 + v35
	local v37 = v33.Y * 0.5 + v19.Y * 0.5 + v35
	v32[chatUIGroup] = v34 * newCFrame(0, -1 * Vector2.new(v36, v37).Y, 0)
	local menuUIGroup = v10.MenuUIGroup
	local moreMenu2 = v9.MoreMenu
	local spatialPanelProps2 = v24[moreMenu2].spatialPanelProps
	local v38 = if spatialPanelProps2 then spatialPanelProps2.partSize else vector2

	local PANEL_TO_DRAGBAR2 = v12.PANEL_TO_DRAGBAR

	local v39 = v31[moreMenu2]

	local newCFrame2 = CFrame.new
	local v40 = PANEL_TO_DRAGBAR2 / v11

	local v41 = v38.X * 0.5 + v19.X * 0.5 + v40
	local v42 = v38.Y * 0.5 + v19.Y * 0.5 + v40
	v32[menuUIGroup] = v39 * newCFrame2(0, -1 * Vector2.new(v41, v42).Y, 0)
	local chromeSubMenuUIGroup = v10.ChromeSubMenuUIGroup
	local chromeSubMenu = v9.ChromeSubMenu
	local spatialPanelProps3 = v24[chromeSubMenu].spatialPanelProps
	local v43 = if spatialPanelProps3 then spatialPanelProps3.partSize else vector2

	local PANEL_TO_DRAGBAR3 = v12.PANEL_TO_DRAGBAR

	local v44 = v31[chromeSubMenu] * CFrame.Angles(0, -3.141592653589793, 0)

	local newCFrame3 = CFrame.new
	local v45 = PANEL_TO_DRAGBAR3 / v11

	local v46 = v43.X * 0.5 + v19.X * 0.5 + v45
	local v47 = v43.Y * 0.5 + v19.Y * 0.5 + v45
	v32[chromeSubMenuUIGroup] = v44 * newCFrame3(0, -1 * Vector2.new(v46, v47).Y, 0)
	cframesByMainUIGroup = assign(cframesByMainUIGroup, v32)
end

return {
	SpatialUIType = v8,
	SpatialUIGroupType = v10,
	PanelType = v9,
	DEFAULT_VR_PANEL_SIZE = Vector2.new(10, 10),
	VR_PANEL_RESOLUTION_MULTIPLIER = v11,
	BOTTOM_BAR_BASE_PART_SIZE = 0.15,
	COMPAT_PANEL_PROPS_MAP = v24,
	SPATIAL_PANEL_POSITION_PROPS_MAP = v25,
	ROACT_PANEL_UIGROUP_MAP = v29,
	ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP = v31,
	UIGROUP_DRAGBAR_OFFSET_MAP = cframesByMainUIGroup,
	UIGROUP_INITITIAL_ROTATION_MAP = v20,
	DRAG_BAR_SIZE = v19,
	BOTTOM_BAR_SIZE = v17,
	SPATIAL_TOOLTIP_SPACING = 2
}
