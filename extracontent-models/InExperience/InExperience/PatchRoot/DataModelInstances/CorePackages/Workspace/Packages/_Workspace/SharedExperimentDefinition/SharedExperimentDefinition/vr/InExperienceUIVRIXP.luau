local Parent = script:FindFirstAncestor("SharedExperimentDefinition").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("LuaAppIECVRLayerName", "PlatformExcellence.VR.SpatialUI")
local v4 = game:DefineFastString("LuaAppIECVRVariantKey", "spatial_ui_type")
local v5 = game:DefineFastInt("LuaAppIECVRVariantNoSpatialUI", 0)
local v6 = game:DefineFastInt("LuaAppIECVRVariantSpatialUIWithDragging", 1)
local v7 = game:DefineFastInt("LuaAppIECVRVariantSpatialUIWithoutDragging", 2)
local v8 = game:DefineFastInt("LuaAppIECVRVariantSpatialUIMovePanelToCenter", 3)
local v9 = game:DefineFastFlag("LuaAppIECVRIxpEnabled8", false)
local FFlagEnableUIManagerPackgify = require(Parent.SharedFlags).FFlagEnableUIManagerPackgify
local v11 = game:DefineFastFlag("EnableSpatialUIScalingFix", false)
local v12 = game:DefineFastFlag("EnableSpatialUICameraTypeFix8", false)
local v13 = game:DefineFastFlag("LuaAppIECVREnabled8", false)
local v14 = game:DefineFastFlag("SpatialUIEnableDrag8", false)
local v15 = game:DefineFastFlag("SpatialUIEnableMovePanelToCenter8", false)
local v16 = game:DefineFastFlag("EnableSpatialUIPlaceFilter", false)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 40
	-- upvalues: t1 (copy)
	local t2 = {
		_layer_data = nil
	}

	setmetatable(t2, t1)

	return t2
end
function t1.getIXPVariant(p1) -- line: 48
	-- upvalues: ExperimentCacheManager (copy), v3 (copy), v4 (copy), v5 (copy)
	if p1._layer_data == nil then
		p1._layer_data = ExperimentCacheManager.default:getLayerVariables(v3) or {}
	end

	local v20 = p1._layer_data[v4] or nil

	if v20 == nil then
		return v5
	end

	return (tonumber(v20))
end
function t1.isDependencyFlagsEnabled() -- line: 60
	-- upvalues: FFlagEnableUIManagerPackgify (copy), v16 (copy)
	return FFlagEnableUIManagerPackgify and not v16
end
function t1.isInExperienceUIVREnabled(p2) -- line: 64
	-- upvalues: v13 (copy), v9 (copy), v5 (copy)
	if not p2:isDependencyFlagsEnabled() then
		return false
	end

	if v13 then
		return true
	end

	if not v9 then
		return false
	end

	return p2:getIXPVariant() ~= v5
end
function t1.isDraggingAllowed(p3) -- line: 78
	-- upvalues: v14 (copy), v15 (copy), v6 (copy), v7 (copy), v8 (copy)
	if not p3:isInExperienceUIVREnabled() then
		return false
	end

	if v14 then
		return not v15
	end

	if v15 then
		return false
	end

	local v23 = p3:getIXPVariant()

	if v23 == v6 then
		return true
	end

	if v23 == v7 then
		return false
	end

	if v23 == v8 then
		return false
	end

	return v14
end
function t1.isMovePanelToCenter(p4) -- line: 101
	-- upvalues: v15 (copy), v8 (copy)
	if not p4:isInExperienceUIVREnabled() then
		return false
	end

	if v15 then
		return true
	end

	return p4:getIXPVariant() == v8
end
function t1.isSpatialUICameraTypeFixEnabled(_) -- line: 112
	-- upvalues: v12 (copy)
	return v12
end
function t1.isSpatialUIScalingFixEnabled(_) -- line: 116
	-- upvalues: v11 (copy)
	return v11
end

return (t1.new())
