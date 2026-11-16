local HttpService = game:GetService("HttpService")
local UIManager = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/UIManager")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Constants")

local FFlagEnableSpatialUIBottomBarFixPlaceFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Flags/FFlagEnableSpatialUIBottomBarFixPlaceFilter")

local function createInertDecoy(name, parent)
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

local function renameAndProtectPart(instance)
	if instance:GetAttribute("_isProtectedSpatialUIPart") then
		return
	end

	local name = instance.Name
	local parent = instance.Parent
	instance:SetAttribute("_isProtectedSpatialUIPart", true)
	instance.Name = HttpService:GenerateGUID(false)
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

local function setupBottomBarRuntime(p2)
	if p2 == nil then
		return
	end

	local adornee = p2.Adornee

	if adornee == nil or adornee:GetAttribute("_isProtectedSpatialUIPart") then
		return
	end

	local name = adornee.Name
	local parent = adornee.Parent
	adornee:SetAttribute("_isProtectedSpatialUIPart", true)
	adornee.Name = HttpService:GenerateGUID(false)
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

return function(p2, p3, p4, p5)
	local v5 = Constants.ROACT_PANEL_UIGROUP_MAP[p3]

	local v6 = v5 and {
		uiGroupElementOffset = Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[p3]
	} or nil

	local v7 = {
		keepVisibleWhenTopBarHidden = p5,
		panelObject = p2.current,
		uiType = Constants.SpatialUIType.SpatialUIRoact,
		panelType = p3,
		headScale = 1,
		panelPositionProps = { uiGroup = v5, cameraFixedPanelProp = v6 }
	}

	if FFlagEnableSpatialUIBottomBarFixPlaceFilter and p3 == Constants.PanelType.BottomBar then
		local current = p2.current

		if current ~= nil then
			local adornee = current.Adornee

			if adornee ~= nil and not adornee:GetAttribute("_isProtectedSpatialUIPart") then
				local name = adornee.Name
				local parent = adornee.Parent
				adornee:SetAttribute("_isProtectedSpatialUIPart", true)
				adornee.Name = HttpService:GenerateGUID(false)
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
		end
	end

	UIManager.getInstance():registerRoactPanel(p3, v7, p4)
end
