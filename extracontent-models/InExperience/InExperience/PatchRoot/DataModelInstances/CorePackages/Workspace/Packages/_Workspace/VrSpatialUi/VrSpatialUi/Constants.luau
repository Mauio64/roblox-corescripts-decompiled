local parent = script:FindFirstAncestor("VrSpatialUi").Parent
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition.InExperienceUIVRIXP
local SharedExperimentDefinition2 = require(parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition2.isInExperienceUIVREnabled
local LuauPolyfill

if isInExperienceUIVREnabled then
	LuauPolyfill = require(parent.LuauPolyfill)
end

local vector2 = Vector2.new(0, 0)
local uiGroupElementOffset = CFrame.new(0, 0, 0)

local v = game:DefineFastInt("SpatialUIResolutionScale", 100) / 100
local defineFastInt = game:DefineFastInt("SpatialUIPanelDragBarDistance", 10)
local defineFastInt2 = game:DefineFastInt("SpatialUIPanelZOffset", 100)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix

local defineFastInt3 = game:DefineFastInt("SpatialUIChromeSubMenuHeight", 448)

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
	MoreMenu = "MoreMenu",
	ChromeSubMenu = "ChromeSubMenu",
	ToolTipsContainer = "ToolTipsContainer"
}

local spatialUIGroupType = {
	MainUIGroup = "MainUIGroup",
	MenuUIGroup = "MenuUIGroup",
	ChatUIGroup = "ChatUIGroup",
	ChromeSubMenuUIGroup = "ChromeSubMenuUIGroup",
	WristUIGroup = "WristUIGroup"
}

local v2 = 800 / v

local function pixelToScaledSize(p: number) -- 7 equivalent calls inferred from this helper
	return p / v2
end

local function getScaledResolutionForPart(p: number, p2: number) -- 5 equivalent calls inferred from this helper
	return Vector2.new(pixelToScaledSize(p), pixelToScaledSize(p2)) -- inferred equivalent call
end

local function panelDistanceWithSpacing(vector2_2: Vector2, vector2_3: Vector2, p: number) -- 7 equivalent calls inferred from this helper
	local v3 = pixelToScaledSize(p) -- inferred equivalent call
	local v4 = vector2_2.X * 0.5 + vector2_3.X * 0.5 + v3
	local v5 = vector2_2.Y * 0.5 + vector2_3.Y * 0.5 + v3
	return Vector2.new(v4, v5)
end

local function alignPanelLeftToAnchor(vector2_2: Vector2, vector2_3: Vector2) -- 1 equivalent call inferred from this helper
	return vector2_3.X * 0.5 - vector2_2.X * 0.5
end

local function alignPanelTopToAnchor(vector2_2: Vector2, vector2_3: Vector2)
	return vector2_2.Y * 0.5 - vector2_3.Y * 0.5
end

local function alignPanelBottomToAnchor(vector2_2: Vector2, vector2_3: Vector2)
	return vector2_3.Y * 0.5 - vector2_2.Y * 0.5
end

local function getAdditionalZOffsetIfNeeded() -- 4 equivalent calls inferred from this helper
	if InExperienceUIVRIXP:isMovePanelToCenter() then
		return defineFastInt2 / 1000
	end

	return 0
end

local v3 = {
	PANEL_TO_PANEL = 10,
	PANEL_TO_BOTTOMBAR = 10,
	PANEL_TO_DRAGBAR = defineFastInt,
	PANEL_TO_CHROME_BOTTOM_OFFSET = 24
}

local function getPanelAroundLeftOrRightEdgeRotation(vector2_2: Vector2, p: number)
	local v4 = vector2_2.X * 0.5 + pixelToScaledSize(v3.PANEL_TO_PANEL) * 0.5 -- inferred equivalent call
	local vector3

	if p > 0 then
		vector3 = Vector3.new(v4, 0, 0)
	else
		vector3 = Vector3.new(-1 * v4, 0, 0)
	end

	local cframe = CFrame.new(vector3)
	local cframe2 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(p)))
	local cframe3 = CFrame.new(-vector3)
	return cframe * cframe2 * cframe3
end

local partSize

if isInExperienceUIVREnabled then
	partSize = getScaledResolutionForPart(943, 640) -- inferred equivalent call
else
	partSize = Vector2.new(0.532, 0.3395) * (10 / 3)
end

local partSize2

if isInExperienceUIVREnabled then
	partSize2 = getScaledResolutionForPart(434, 264) -- inferred equivalent call
else
	partSize2 = Vector2.new(0.1365, 0.1995) * (10 / 3)
end

local partSize3

if isInExperienceUIVREnabled then
	partSize3 = getScaledResolutionForPart(800, 640) -- inferred equivalent call
else
	partSize3 = Vector2.new(0.532, 0.3395) * (10 / 3)
end

local partSize4

if isInExperienceUIVREnabled then
	partSize4 = Vector2.new(
		pixelToScaledSize(317), -- inferred equivalent call
		pixelToScaledSize(not FFlagEnableInExperienceUIPCVRFix and 292 or defineFastInt3) -- inferred equivalent call
	)
else
	partSize4 = vector2
end

local v4

if isInExperienceUIVREnabled then
	v4 = getScaledResolutionForPart(943, 64) -- inferred equivalent call
else
	v4 = vector2
end

local partSize5

if isInExperienceUIVREnabled then
	partSize5 = Vector2.new(v4.X, pixelToScaledSize(120)) -- inferred equivalent call
else
	partSize5 = vector2
end

local v5

if isInExperienceUIVREnabled then
	v5 = getScaledResolutionForPart(296, 40) -- inferred equivalent call
else
	v5 = vector2
end

local v6

if isInExperienceUIVREnabled then
	v6 = {}
	v6[spatialUIGroupType.MenuUIGroup] = getPanelAroundLeftOrRightEdgeRotation(
		partSize3,
		InExperienceUIVRIXP:isMovePanelToCenter() and 0 or 15
	)

	v6[spatialUIGroupType.ChatUIGroup] = getPanelAroundLeftOrRightEdgeRotation(
		partSize2,
		InExperienceUIVRIXP:isMovePanelToCenter() and 0 or -15
	)
else
	v6 = {}
end

local uiGroupElementOffset2

if isInExperienceUIVREnabled then
	local v7

	if InExperienceUIVRIXP:isMovePanelToCenter() then
		v7 = 0
	else
		v7 = -1 * panelDistanceWithSpacing(partSize, partSize3, v3.PANEL_TO_PANEL).X -- inferred equivalent call
	end

	uiGroupElementOffset2 = CFrame.new(v7, partSize.Y * 0.5 - partSize3.Y * 0.5, getAdditionalZOffsetIfNeeded()) * v6[spatialUIGroupType.MenuUIGroup] -- inferred equivalent call
else
	uiGroupElementOffset2 = CFrame.new(0.4, -0.36, 0) * CFrame.Angles(0, 3.141592653589793, 0)
end

local uiGroupElementOffset3

if isInExperienceUIVREnabled then
	local v7

	if InExperienceUIVRIXP:isMovePanelToCenter() then
		v7 = alignPanelLeftToAnchor(partSize, partSize2) -- inferred equivalent call
	else
		v7 = panelDistanceWithSpacing(partSize, partSize2, v3.PANEL_TO_PANEL).X -- inferred equivalent call
	end

	uiGroupElementOffset3 = CFrame.new(v7, partSize.Y * 0.5 - partSize2.Y * 0.5, getAdditionalZOffsetIfNeeded()) * v6[spatialUIGroupType.ChatUIGroup] -- inferred equivalent call
else
	uiGroupElementOffset3 = CFrame.new(partSize.X * 0.5 + partSize2.X * 0.5 + 1 / 15, (partSize.Y - partSize2.Y) / 2, 0)
end

local uiGroupElementOffset4

if isInExperienceUIVREnabled then
	uiGroupElementOffset4 = CFrame.new(
		0,
		partSize4.Y * 0.5 - partSize.Y * 0.5 + v3.PANEL_TO_CHROME_BOTTOM_OFFSET / v2,
		getAdditionalZOffsetIfNeeded() -- inferred equivalent call
	) * CFrame.Angles(0, 3.141592653589793, 0)
else
	uiGroupElementOffset4 = uiGroupElementOffset
end

if isInExperienceUIVREnabled then
	uiGroupElementOffset = CFrame.new(
		0,
		partSize5.Y * 0.5 - partSize.Y * 0.5 - v3.PANEL_TO_BOTTOMBAR / v2,
		getAdditionalZOffsetIfNeeded() -- inferred equivalent call
	) * CFrame.Angles(0, 3.141592653589793, 0)
end

local v7 = {}
v7[panelType.Chat] = {
	type = spatialUIType.SpatialUI,
	spatialPanelProps = {
		name = "ExperienceChat",
		faceCamera = true,
		lerp = true,
		partSize = partSize2,
		virtualScreenSize = partSize2 * v2
	}
}

v7[panelType.RobloxGui] = {
	type = spatialUIType.SpatialUIPartOnly,
	spatialPanelProps = {
		name = "RobloxGuiPanel-PartOnly",
		faceCamera = true,
		lerp = true,
		partSize = partSize,
		transparency = 0.5
	}
}

if isInExperienceUIVREnabled then
	v7 = LuauPolyfill.Object.assign(v7, {
		[panelType.MoreMenu] = {
			type = spatialUIType.SpatialUI,
			spatialPanelProps = {
				name = "MoreMenu",
				faceCamera = true,
				lerp = true,
				partSize = partSize3,
				virtualScreenSize = partSize3 * v2
			}
		},
		[panelType.ChromeSubMenu] = {
			type = spatialUIType.SpatialUI,
			spatialPanelProps = {
				name = "ChromeSubMenu",
				faceCamera = true,
				lerp = true,
				partSize = partSize4,
				virtualScreenSize = partSize4 * v2
			}
		},
		[panelType.ToolTipsContainer] = {
			type = spatialUIType.SpatialUI,
			spatialPanelProps = {
				name = "ToolTipsContainer",
				faceCamera = true,
				lerp = true,
				partSize = partSize5,
				virtualScreenSize = partSize5 * v2
			}
		}
	})
end

local chat = panelType.Chat
local uiGroup

if isInExperienceUIVREnabled then
	uiGroup = spatialUIGroupType.ChatUIGroup
else
	uiGroup = spatialUIGroupType.MainUIGroup
end

local v8 = {
	[chat] = {
		uiGroup = uiGroup,
		cameraFixedPanelProp = { uiGroupElementOffset = uiGroupElementOffset3 }
	},
	[panelType.RobloxGui] = {
		uiGroup = spatialUIGroupType.MainUIGroup,
		cameraFixedPanelProp = { uiGroupElementOffset = CFrame.new(0, 0, 0) }
	}
}

if isInExperienceUIVREnabled then
	v8 = LuauPolyfill.Object.assign(v8, {
		[panelType.MoreMenu] = {
			uiGroup = spatialUIGroupType.MenuUIGroup,
			cameraFixedPanelProp = { uiGroupElementOffset = uiGroupElementOffset2 }
		},
		[panelType.ChromeSubMenu] = {
			uiGroup = spatialUIGroupType.ChromeSubMenuUIGroup,
			cameraFixedPanelProp = { uiGroupElementOffset = uiGroupElementOffset4 }
		},
		[panelType.ToolTipsContainer] = {
			uiGroup = spatialUIGroupType.MainUIGroup,
			cameraFixedPanelProp = { uiGroupElementOffset = uiGroupElementOffset }
		}
	})
end

local v9

if isInExperienceUIVREnabled then
	v9 = CFrame.new(0, -1 * panelDistanceWithSpacing(partSize, v4, v3.PANEL_TO_BOTTOMBAR).Y, 0) * CFrame.Angles(0, 3.141592653589793, 0) -- inferred equivalent call
else
	v9 = CFrame.new(0, -partSize.Y * 0.5 - 0.075 - 1 / 30, 0) * CFrame.Angles(0, 3.141592653589793, 0)
end

local v10 = { [panelType.BottomBar] = spatialUIGroupType.MainUIGroup }
local moreMenu = panelType.MoreMenu
local v11

if isInExperienceUIVREnabled then
	v11 = spatialUIGroupType.MenuUIGroup
else
	v11 = spatialUIGroupType.MainUIGroup
end

v10[moreMenu] = v11

if isInExperienceUIVREnabled then
	v10 = LuauPolyfill.Object.assign(v10, {
		[panelType.Chat] = spatialUIGroupType.ChatUIGroup,
		[panelType.ChromeSubMenu] = spatialUIGroupType.ChromeSubMenuUIGroup,
		[panelType.ToolTipsContainer] = spatialUIGroupType.MainUIGroup
	})
end

local v12 = {}
v12[panelType.BottomBar] = v9
v12[panelType.MoreMenu] = uiGroupElementOffset2

if isInExperienceUIVREnabled then
	v12 = LuauPolyfill.Object.assign(v12, {
		[panelType.Chat] = uiGroupElementOffset3,
		[panelType.ChromeSubMenu] = uiGroupElementOffset4,
		[panelType.ToolTipsContainer] = uiGroupElementOffset
	})
end

local function getDragBarOffsetForPanel(bottomBar: string, vector2_2: Vector2?, flag: boolean?, p: number?)
	if not vector2_2 then
		local spatialPanelProps = v7[bottomBar].spatialPanelProps

		if spatialPanelProps then
			vector2_2 = spatialPanelProps.partSize
		else
			vector2_2 = vector2
		end
	end

	local PANEL_TO_DRAGBAR = v3.PANEL_TO_DRAGBAR

	if p then
		PANEL_TO_DRAGBAR += p
	end

	local v13 = v12[bottomBar]

	if flag == true then
		v13 *= CFrame.Angles(0, -3.141592653589793, 0)
	end

	return v13 * CFrame.new(0, -1 * panelDistanceWithSpacing(vector2_2, v5, PANEL_TO_DRAGBAR).Y, 0) -- inferred equivalent call
end

local cframesByMainUIGroup = {
	[spatialUIGroupType.MainUIGroup] = CFrame.new(0, v12[panelType.BottomBar].Y - 0.075 - 1 / 15, 0)
}

if isInExperienceUIVREnabled then
	local assign = LuauPolyfill.Object.assign
	local v13 = {
		[spatialUIGroupType.MainUIGroup] = getDragBarOffsetForPanel(panelType.BottomBar, v4, true)
	}
	local chatUIGroup = spatialUIGroupType.ChatUIGroup
	local chat2 = panelType.Chat
	local spatialPanelProps = v7[chat2].spatialPanelProps
	local v14

	if spatialPanelProps then
		v14 = spatialPanelProps.partSize
	else
		v14 = vector2
	end

	local PANEL_TO_DRAGBAR = v3.PANEL_TO_DRAGBAR

	v13[chatUIGroup] = v12[chat2] * CFrame.new(0, -1 * panelDistanceWithSpacing(v14, v5, PANEL_TO_DRAGBAR).Y, 0) -- inferred equivalent call
	local menuUIGroup = spatialUIGroupType.MenuUIGroup
	local moreMenu2 = panelType.MoreMenu
	local spatialPanelProps2 = v7[moreMenu2].spatialPanelProps
	local v15

	if spatialPanelProps2 then
		v15 = spatialPanelProps2.partSize
	else
		v15 = vector2
	end

	local PANEL_TO_DRAGBAR2 = v3.PANEL_TO_DRAGBAR

	v13[menuUIGroup] = v12[moreMenu2] * CFrame.new(0, -1 * panelDistanceWithSpacing(v15, v5, PANEL_TO_DRAGBAR2).Y, 0) -- inferred equivalent call
	local chromeSubMenuUIGroup = spatialUIGroupType.ChromeSubMenuUIGroup
	local chromeSubMenu = panelType.ChromeSubMenu
	local spatialPanelProps3 = v7[chromeSubMenu].spatialPanelProps
	local v16

	if spatialPanelProps3 then
		v16 = spatialPanelProps3.partSize
	else
		v16 = vector2
	end

	local PANEL_TO_DRAGBAR3 = v3.PANEL_TO_DRAGBAR

	v13[chromeSubMenuUIGroup] = v12[chromeSubMenu] * CFrame.Angles(0, -3.141592653589793, 0) * CFrame.new(
		0,
		-1 * panelDistanceWithSpacing(v16, v5, PANEL_TO_DRAGBAR3).Y, -- inferred equivalent call
		0
	)
	cframesByMainUIGroup = assign(cframesByMainUIGroup, v13)
end

return {
	SpatialUIType = spatialUIType,
	SpatialUIGroupType = spatialUIGroupType,
	PanelType = panelType,
	DEFAULT_VR_PANEL_SIZE = Vector2.new(10, 10),
	VR_PANEL_RESOLUTION_MULTIPLIER = v2,
	BOTTOM_BAR_BASE_PART_SIZE = 0.15,
	COMPAT_PANEL_PROPS_MAP = v7,
	SPATIAL_PANEL_POSITION_PROPS_MAP = v8,
	ROACT_PANEL_UIGROUP_MAP = v10,
	ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP = v12,
	UIGROUP_DRAGBAR_OFFSET_MAP = cframesByMainUIGroup,
	UIGROUP_INITITIAL_ROTATION_MAP = v6,
	DRAG_BAR_SIZE = v5,
	BOTTOM_BAR_SIZE = v4,
	SPATIAL_TOOLTIP_SPACING = 2
}
