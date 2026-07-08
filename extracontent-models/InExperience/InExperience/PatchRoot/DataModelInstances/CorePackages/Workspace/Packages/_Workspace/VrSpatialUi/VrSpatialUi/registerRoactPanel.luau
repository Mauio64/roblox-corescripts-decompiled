local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local HttpService = game:GetService("HttpService")
local UIManager = require(VrSpatialUi.UIManager)
local Constants = require(VrSpatialUi.Constants)
local FFlagEnableSpatialUIBottomBarFixPlaceFilter = require(VrSpatialUi.Flags.FFlagEnableSpatialUIBottomBarFixPlaceFilter)

local function createInertDecoy(s1: string, p1) -- line: 17
	local Part = Instance.new("Part")

	Part.Name = s1
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.CastShadow = false
	Part.Transparency = 1
	Part.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
	Part:SetAttribute("_isProtectedSpatialUIPart", true)
	Part.Parent = p1
end
local function renameAndProtectPart(p2) -- line: 37
	-- upvalues: HttpService (copy)
	if p2:GetAttribute("_isProtectedSpatialUIPart") then
		return
	end

	local p2Name = p2.Name
	local p2Parent = p2.Parent

	p2:SetAttribute("_isProtectedSpatialUIPart", true)
	p2.Name = HttpService:GenerateGUID(false)

	local Part = Instance.new("Part")

	Part.Name = p2Name
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.CastShadow = false
	Part.Transparency = 1
	Part.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
	Part:SetAttribute("_isProtectedSpatialUIPart", true)
	Part.Parent = p2Parent
end
local function setupBottomBarRuntime(p3) -- line: 48
	-- upvalues: HttpService (copy)
	if p3 == nil then
		return
	end

	local p3Adornee = p3.Adornee

	if p3Adornee == nil then
		return
	end

	if p3Adornee:GetAttribute("_isProtectedSpatialUIPart") then
		return
	end

	local p3AdorneeName = p3Adornee.Name
	local p3AdorneeParent = p3Adornee.Parent

	p3Adornee:SetAttribute("_isProtectedSpatialUIPart", true)
	p3Adornee.Name = HttpService:GenerateGUID(false)

	local Part = Instance.new("Part")

	Part.Name = p3AdorneeName
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.CastShadow = false
	Part.Transparency = 1
	Part.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
	Part:SetAttribute("_isProtectedSpatialUIPart", true)
	Part.Parent = p3AdorneeParent
end

return function(t1: {[any]: any}, p4, p5) -- line: 61
	-- upvalues: Constants (copy), FFlagEnableSpatialUIBottomBarFixPlaceFilter (copy), HttpService (copy), UIManager (copy)
	local t2 = nil
	local v25 = Constants.ROACT_PANEL_UIGROUP_MAP[p4]

	if v25 then
		t2 = {
			uiGroupElementOffset = Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[p4]
		}
	end

	local t3 = {
		headScale = 1,
		panelObject = t1.current,
		uiType = Constants.SpatialUIType.SpatialUIRoact,
		panelType = p4,
		panelPositionProps = {
			uiGroup = v25,
			cameraFixedPanelProp = t2
		}
	}

	if FFlagEnableSpatialUIBottomBarFixPlaceFilter and p4 == Constants.PanelType.BottomBar then
		local current = t1.current

		if current ~= nil then
			local currentAdornee = current.Adornee

			if currentAdornee ~= nil and not currentAdornee:GetAttribute("_isProtectedSpatialUIPart") then
				local currentAdorneeName = currentAdornee.Name
				local currentAdorneeParent = currentAdornee.Parent

				currentAdornee:SetAttribute("_isProtectedSpatialUIPart", true)
				currentAdornee.Name = HttpService:GenerateGUID(false)

				local Part = Instance.new("Part")

				Part.Name = currentAdorneeName
				Part.Anchored = true
				Part.CanCollide = false
				Part.CanTouch = false
				Part.CanQuery = false
				Part.CastShadow = false
				Part.Transparency = 1
				Part.Size = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
				Part:SetAttribute("_isProtectedSpatialUIPart", true)
				Part.Parent = currentAdorneeParent
			end
		end
	end

	UIManager.getInstance():registerRoactPanel(p4, t3, p5)
end
