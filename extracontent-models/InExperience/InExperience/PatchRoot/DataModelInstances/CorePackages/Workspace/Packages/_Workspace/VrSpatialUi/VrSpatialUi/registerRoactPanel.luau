local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local HttpService = game:GetService("HttpService")
local UIManager = require(VrSpatialUi.UIManager)
local Constants = require(VrSpatialUi.Constants)

local FFlagEnableSpatialUIBottomBarFixPlaceFilter = require(VrSpatialUi.Flags.FFlagEnableSpatialUIBottomBarFixPlaceFilter)

local function createInertDecoy(name: string, parent) -- 1 equivalent call inferred from this helper
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Transparency = 1
	part.Size = Vector3.new(0.05, 0.05, 0.05)
	part:SetAttribute("_isProtectedSpatialUIPart", true)
	part.Parent = parent
end

local function renameAndProtectPart(adornee) -- 1 equivalent call inferred from this helper
	if adornee:GetAttribute("_isProtectedSpatialUIPart") then
		return
	end

	local name = adornee.Name
	local parent = adornee.Parent
	adornee:SetAttribute("_isProtectedSpatialUIPart", true)
	adornee.Name = HttpService:GenerateGUID(false)
	createInertDecoy(name, parent) -- inferred equivalent call
end

local function setupBottomBarRuntime(current) -- 1 equivalent call inferred from this helper
	if current == nil then
		return
	end

	local adornee = current.Adornee

	if adornee == nil then
		return
	end

	renameAndProtectPart(adornee) -- inferred equivalent call
end

return function(p, panelType, p2, keepVisibleWhenTopBarHidden: boolean?)
	local uiGroup = Constants.ROACT_PANEL_UIGROUP_MAP[panelType]

	local cameraFixedPanelProp = uiGroup
		and { uiGroupElementOffset = Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[panelType] }
		or nil

	local v = {
		keepVisibleWhenTopBarHidden = keepVisibleWhenTopBarHidden,
		panelObject = p.current,
		uiType = Constants.SpatialUIType.SpatialUIRoact,
		panelType = panelType,
		headScale = 1,
		panelPositionProps = { uiGroup = uiGroup, cameraFixedPanelProp = cameraFixedPanelProp }
	}

	if FFlagEnableSpatialUIBottomBarFixPlaceFilter and panelType == Constants.PanelType.BottomBar then
		setupBottomBarRuntime(p.current) -- inferred equivalent call
	end

	UIManager.getInstance():registerRoactPanel(panelType, v, p2)
end
