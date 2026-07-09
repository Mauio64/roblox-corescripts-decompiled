local Parent = script:FindFirstAncestor("VrSpatialUi").Parent
local InExperienceUIVRIXP = require(Parent.SharedExperimentDefinition).InExperienceUIVRIXP
local isInExperienceUIVREnabled = require(Parent.SharedExperimentDefinition).isInExperienceUIVREnabled
local LuauPolyfill = nil

if isInExperienceUIVREnabled then
	LuauPolyfill = require(Parent.LuauPolyfill)
end

local vector2 = Vector2.new(0, 0)
local cFrame = CFrame.new(0, 0, 0)
local v7 = game:DefineFastInt("SpatialUIResolutionScale", 100) / 100
local v8 = game:DefineFastInt("SpatialUIPanelDragBarDistance", 10)
local v9 = game:DefineFastInt("SpatialUIPanelZOffset", 100)
local FFlagEnableInExperienceUIPCVRFix = require(Parent.SharedFlags).FFlagEnableInExperienceUIPCVRFix
local v11 = game:DefineFastInt("SpatialUIChromeSubMenuHeight", 448)
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
	MoreMenu = "MoreMenu",
	ChromeSubMenu = "ChromeSubMenu",
	ToolTipsContainer = "ToolTipsContainer"
}
local t3 = {
	MainUIGroup = "MainUIGroup",
	MenuUIGroup = "MenuUIGroup",
	ChatUIGroup = "ChatUIGroup",
	ChromeSubMenuUIGroup = "ChromeSubMenuUIGroup",
	WristUIGroup = "WristUIGroup"
}
local v15 = 800 / v7

local function pixelToScaledSize(n1: number) -- line: 173
	-- upvalues: v15 (copy)
	return n1 / v15
end
local function getScaledResolutionForPart(n2: number, n3: number) -- line: 177
	-- upvalues: v15 (copy)
	return Vector2.new(n2 / v15, n3 / v15)
end
local function panelDistanceWithSpacing(vector2_2: Vector2, vector2_3: Vector2, n4: number) -- line: 181
	-- upvalues: v15 (copy)
	local v97 = n4 / v15
	local v98 = vector2_2.X * 0.5 + vector2_3.X * 0.5 + v97
	local v99 = vector2_2.Y * 0.5 + vector2_3.Y * 0.5 + v97

	return Vector2.new(v98, v99)
end
local function alignPanelLeftToAnchor(vector2_4: Vector2, vector2_5: Vector2) -- line: 188
	return vector2_5.X * 0.5 - vector2_4.X * 0.5
end
local function alignPanelTopToAnchor(vector2_6: Vector2, vector2_7: Vector2) -- line: 192
	return vector2_6.Y * 0.5 - vector2_7.Y * 0.5
end
local function alignPanelBottomToAnchor(vector2_8: Vector2, vector2_9: Vector2) -- line: 196
	return vector2_9.Y * 0.5 - vector2_8.Y * 0.5
end
local function getAdditionalZOffsetIfNeeded() -- line: 200
	-- upvalues: InExperienceUIVRIXP (copy), v9 (copy)
	if InExperienceUIVRIXP:isMovePanelToCenter() then
		return v9 / 1000
	end

	return 0
end

local t4 = {
	PANEL_TO_PANEL = 10,
	PANEL_TO_BOTTOMBAR = 10,
	PANEL_TO_CHROME_BOTTOM_OFFSET = 24,
	PANEL_TO_DRAGBAR = v8
}

local function getPanelAroundLeftOrRightEdgeRotation(vector2_10: Vector2, n5: number) -- line: 217
	-- upvalues: t4 (copy), v15 (copy)
	local v108 = vector2_10.X * 0.5 + t4.PANEL_TO_PANEL / v15 * 0.5
	local v109 = if not (n5 > 0) then Vector3.new(-1 * v108, 0, 0) else Vector3.new(v108, 0, 0)
	local cFrame2 = CFrame.new(v109)
	local cFrame3 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(n5)))
	local cFrame4 = CFrame.new(-v109)

	return cFrame2 * cFrame3 * cFrame4
end

local v25 = if not isInExperienceUIVREnabled then Vector2.new(0.532, 0.3395) * 3.3333333333333335 else Vector2.new(943 / v15, 640 / v15)
local v26 = if not isInExperienceUIVREnabled then Vector2.new(0.1365, 0.1995) * 3.3333333333333335 else Vector2.new(434 / v15, 264 / v15)
local v27 = if not isInExperienceUIVREnabled then Vector2.new(0.532, 0.3395) * 3.3333333333333335 else Vector2.new(800 / v15, 640 / v15)
local vector2_11

if isInExperienceUIVREnabled then
	local v28 = not FFlagEnableInExperienceUIPCVRFix and 292 or v11

	vector2_11 = Vector2.new(317 / v15, v28 / v15)
else
	vector2_11 = vector2
end

local v30 = if not isInExperienceUIVREnabled then vector2 else Vector2.new(943 / v15, 64 / v15)
local v31 = if not isInExperienceUIVREnabled then vector2 else Vector2.new(v30.X, 120 / v15)
local v32 = if not isInExperienceUIVREnabled then vector2 else Vector2.new(296 / v15, 40 / v15)
local v33 = if not isInExperienceUIVREnabled then {} else {
	[t3.MenuUIGroup] = getPanelAroundLeftOrRightEdgeRotation(v27, not InExperienceUIVRIXP:isMovePanelToCenter() and 15 or 0),
	[t3.ChatUIGroup] = getPanelAroundLeftOrRightEdgeRotation(v26, not InExperienceUIVRIXP:isMovePanelToCenter() and -15 or 0)
}
local v39

if isInExperienceUIVREnabled then
	local new = CFrame.new
	local n6

	if InExperienceUIVRIXP:isMovePanelToCenter() then
		n6 = 0
	else
		local v36 = t4.PANEL_TO_PANEL / v15
		local v37 = v25.X * 0.5 + v27.X * 0.5 + v36
		local v38 = v25.Y * 0.5 + v27.Y * 0.5 + v36

		n6 = -1 * Vector2.new(v37, v38).X
	end

	v39 = new(n6, v25.Y * 0.5 - v27.Y * 0.5, not InExperienceUIVRIXP:isMovePanelToCenter() and 0 or v9 / 1000) * v33[t3.MenuUIGroup]
else
	v39 = CFrame.new(0.4, -0.36, 0) * CFrame.Angles(0, 3.141592653589793, 0)
end

local v45

if isInExperienceUIVREnabled then
	local new = CFrame.new
	local v41

	if InExperienceUIVRIXP:isMovePanelToCenter() then
		v41 = v26.X * 0.5 - v25.X * 0.5
	else
		local v42 = t4.PANEL_TO_PANEL / v15
		local v43 = v25.X * 0.5 + v26.X * 0.5 + v42
		local v44 = v25.Y * 0.5 + v26.Y * 0.5 + v42

		v41 = Vector2.new(v43, v44).X
	end

	v45 = new(v41, v25.Y * 0.5 - v26.Y * 0.5, not InExperienceUIVRIXP:isMovePanelToCenter() and 0 or v9 / 1000) * v33[t3.ChatUIGroup]
else
	v45 = CFrame.new(v25.X * 0.5 + v26.X * 0.5 + 0.06666666666666667, (v25.Y - v26.Y) / 2, 0)
end

local v46 = if not isInExperienceUIVREnabled then cFrame else CFrame.new(0, vector2_11.Y * 0.5 - v25.Y * 0.5 + t4.PANEL_TO_CHROME_BOTTOM_OFFSET / v15, not InExperienceUIVRIXP:isMovePanelToCenter() and 0 or v9 / 1000) * CFrame.Angles(0, 3.141592653589793, 0)
local v47 = if not isInExperienceUIVREnabled then cFrame else CFrame.new(0, v31.Y * 0.5 - v25.Y * 0.5 - t4.PANEL_TO_BOTTOMBAR / v15, not InExperienceUIVRIXP:isMovePanelToCenter() and 0 or v9 / 1000) * CFrame.Angles(0, 3.141592653589793, 0)
local t5 = {
	[t2.Chat] = {
		type = t1.SpatialUI,
		spatialPanelProps = {
			name = "ExperienceChat",
			faceCamera = true,
			lerp = true,
			partSize = v26,
			virtualScreenSize = v26 * v15
		}
	},
	[t2.RobloxGui] = {
		type = t1.SpatialUIPartOnly,
		spatialPanelProps = {
			name = "RobloxGuiPanel-PartOnly",
			faceCamera = true,
			lerp = true,
			transparency = 0.5,
			partSize = v25
		}
	}
}

if isInExperienceUIVREnabled then
	t5 = LuauPolyfill.Object.assign(t5, {
		[t2.MoreMenu] = {
			type = t1.SpatialUI,
			spatialPanelProps = {
				name = "MoreMenu",
				faceCamera = true,
				lerp = true,
				partSize = v27,
				virtualScreenSize = v27 * v15
			}
		},
		[t2.ChromeSubMenu] = {
			type = t1.SpatialUI,
			spatialPanelProps = {
				name = "ChromeSubMenu",
				faceCamera = true,
				lerp = true,
				partSize = vector2_11,
				virtualScreenSize = vector2_11 * v15
			}
		},
		[t2.ToolTipsContainer] = {
			type = t1.SpatialUI,
			spatialPanelProps = {
				name = "ToolTipsContainer",
				faceCamera = true,
				lerp = true,
				partSize = v31,
				virtualScreenSize = v31 * v15
			}
		}
	})
end

local t6 = {
	[t2.Chat] = {
		uiGroup = if not isInExperienceUIVREnabled then t3.MainUIGroup else t3.ChatUIGroup,
		cameraFixedPanelProp = {
			uiGroupElementOffset = v45
		}
	},
	[t2.RobloxGui] = {
		uiGroup = t3.MainUIGroup,
		cameraFixedPanelProp = {
			uiGroupElementOffset = CFrame.new(0, 0, 0)
		}
	}
}

if isInExperienceUIVREnabled then
	t6 = LuauPolyfill.Object.assign(t6, {
		[t2.MoreMenu] = {
			uiGroup = t3.MenuUIGroup,
			cameraFixedPanelProp = {
				uiGroupElementOffset = v39
			}
		},
		[t2.ChromeSubMenu] = {
			uiGroup = t3.ChromeSubMenuUIGroup,
			cameraFixedPanelProp = {
				uiGroupElementOffset = v46
			}
		},
		[t2.ToolTipsContainer] = {
			uiGroup = t3.MainUIGroup,
			cameraFixedPanelProp = {
				uiGroupElementOffset = v47
			}
		}
	})
end

local v54

if isInExperienceUIVREnabled then
	local new = CFrame.new
	local v51 = t4.PANEL_TO_BOTTOMBAR / v15
	local v52 = v25.X * 0.5 + v30.X * 0.5 + v51
	local v53 = v25.Y * 0.5 + v30.Y * 0.5 + v51

	v54 = new(0, -1 * Vector2.new(v52, v53).Y, 0) * CFrame.Angles(0, 3.141592653589793, 0)
else
	v54 = CFrame.new(0, -v25.Y * 0.5 - 0.075 - 0.03333333333333333, 0) * CFrame.Angles(0, 3.141592653589793, 0)
end

local t7 = {
	[t2.BottomBar] = t3.MainUIGroup,
	[t2.MoreMenu] = if not isInExperienceUIVREnabled then t3.MainUIGroup else t3.MenuUIGroup
}

if isInExperienceUIVREnabled then
	t7 = LuauPolyfill.Object.assign(t7, {
		[t2.Chat] = t3.ChatUIGroup,
		[t2.ChromeSubMenu] = t3.ChromeSubMenuUIGroup,
		[t2.ToolTipsContainer] = t3.MainUIGroup
	})
end

local t8 = {
	[t2.BottomBar] = v54,
	[t2.MoreMenu] = v39
}

if isInExperienceUIVREnabled then
	t8 = LuauPolyfill.Object.assign(t8, {
		[t2.Chat] = v45,
		[t2.ChromeSubMenu] = v46,
		[t2.ToolTipsContainer] = v47
	})
end

local function getDragBarOffsetForPanel(s1: string, vector2_12: Vector2?, b1: boolean?, n7: number?) -- line: 451
	-- upvalues: t5 (ref), vector2 (copy), t4 (copy), t8 (ref), v32 (copy), v15 (copy)
	if vector2_12 then
	else
		local spatialPanelProps = t5[s1].spatialPanelProps

		vector2_12 = if not spatialPanelProps then vector2 else spatialPanelProps.partSize
	end

	local PANEL_TO_DRAGBAR = t4.PANEL_TO_DRAGBAR

	if n7 then
		PANEL_TO_DRAGBAR += n7
	end

	local v119 = t8[s1]

	if b1 == true then
		v119 *= CFrame.Angles(0, -3.141592653589793, 0)
	end

	local new = CFrame.new
	local v121 = v32
	local v122 = PANEL_TO_DRAGBAR / v15
	local v123 = vector2_12.X * 0.5 + v121.X * 0.5 + v122
	local v124 = vector2_12.Y * 0.5 + v121.Y * 0.5 + v122

	return v119 * new(0, -1 * Vector2.new(v123, v124).Y, 0)
end

local t9 = {
	[t3.MainUIGroup] = CFrame.new(0, t8[t2.BottomBar].Y - 0.075 - 0.06666666666666667, 0)
}

if isInExperienceUIVREnabled then
	local assign = LuauPolyfill.Object.assign
	local t10 = {
		[t3.MainUIGroup] = getDragBarOffsetForPanel(t2.BottomBar, v30, true)
	}
	local ChatUIGroup = t3.ChatUIGroup
	local Chat = t2.Chat
	local spatialPanelProps = t5[Chat].spatialPanelProps
	local v64 = if not spatialPanelProps then vector2 else spatialPanelProps.partSize
	local PANEL_TO_DRAGBAR = t4.PANEL_TO_DRAGBAR
	local v66 = t8[Chat]
	local new = CFrame.new
	local v68 = PANEL_TO_DRAGBAR / v15
	local v69 = v64.X * 0.5 + v32.X * 0.5 + v68
	local v70 = v64.Y * 0.5 + v32.Y * 0.5 + v68

	t10[ChatUIGroup] = v66 * new(0, -1 * Vector2.new(v69, v70).Y, 0)

	local MenuUIGroup = t3.MenuUIGroup
	local MoreMenu = t2.MoreMenu
	local spatialPanelProps2 = t5[MoreMenu].spatialPanelProps
	local v74 = if not spatialPanelProps2 then vector2 else spatialPanelProps2.partSize
	local PANEL_TO_DRAGBAR2 = t4.PANEL_TO_DRAGBAR
	local v76 = t8[MoreMenu]
	local new2 = CFrame.new
	local v78 = PANEL_TO_DRAGBAR2 / v15
	local v79 = v74.X * 0.5 + v32.X * 0.5 + v78
	local v80 = v74.Y * 0.5 + v32.Y * 0.5 + v78

	t10[MenuUIGroup] = v76 * new2(0, -1 * Vector2.new(v79, v80).Y, 0)

	local ChromeSubMenuUIGroup = t3.ChromeSubMenuUIGroup
	local ChromeSubMenu = t2.ChromeSubMenu
	local spatialPanelProps3 = t5[ChromeSubMenu].spatialPanelProps
	local v84 = if not spatialPanelProps3 then vector2 else spatialPanelProps3.partSize
	local PANEL_TO_DRAGBAR3 = t4.PANEL_TO_DRAGBAR
	local v86 = t8[ChromeSubMenu] * CFrame.Angles(0, -3.141592653589793, 0)
	local new3 = CFrame.new
	local v88 = PANEL_TO_DRAGBAR3 / v15
	local v89 = v84.X * 0.5 + v32.X * 0.5 + v88
	local v90 = v84.Y * 0.5 + v32.Y * 0.5 + v88

	t10[ChromeSubMenuUIGroup] = v86 * new3(0, -1 * Vector2.new(v89, v90).Y, 0)
	t9 = assign(t9, t10)
end

return {
	BOTTOM_BAR_BASE_PART_SIZE = 0.15,
	SPATIAL_TOOLTIP_SPACING = 2,
	SpatialUIType = t1,
	SpatialUIGroupType = t3,
	PanelType = t2,
	DEFAULT_VR_PANEL_SIZE = Vector2.new(10, 10),
	VR_PANEL_RESOLUTION_MULTIPLIER = v15,
	COMPAT_PANEL_PROPS_MAP = t5,
	SPATIAL_PANEL_POSITION_PROPS_MAP = t6,
	ROACT_PANEL_UIGROUP_MAP = t7,
	ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP = t8,
	UIGROUP_DRAGBAR_OFFSET_MAP = t9,
	UIGROUP_INITITIAL_ROTATION_MAP = v33,
	DRAG_BAR_SIZE = v32,
	BOTTOM_BAR_SIZE = v30
}
