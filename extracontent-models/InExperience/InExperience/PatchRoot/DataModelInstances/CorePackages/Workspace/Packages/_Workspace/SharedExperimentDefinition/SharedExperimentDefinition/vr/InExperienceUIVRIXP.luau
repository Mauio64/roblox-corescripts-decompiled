local parent = script:FindFirstAncestor("SharedExperimentDefinition").Parent
local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("LuaAppIECVRLayerName", "PlatformExcellence.VR.SpatialUI")
local defineFastString2 = game:DefineFastString("LuaAppIECVRVariantKey", "spatial_ui_type")
local defineFastInt = game:DefineFastInt("LuaAppIECVRVariantNoSpatialUI", 0)
local defineFastInt2 = game:DefineFastInt("LuaAppIECVRVariantSpatialUIWithDragging", 1)
local defineFastInt3 = game:DefineFastInt("LuaAppIECVRVariantSpatialUIWithoutDragging", 2)

local defineFastInt4 = game:DefineFastInt("LuaAppIECVRVariantSpatialUIMovePanelToCenter", 3)

local defineFastFlag = game:DefineFastFlag("LuaAppIECVRIxpEnabled8", false)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableUIManagerPackgify = SharedFlags.FFlagEnableUIManagerPackgify

local defineFastFlag2 = game:DefineFastFlag("EnableSpatialUIScalingFix", false)
local defineFastFlag3 = game:DefineFastFlag("EnableSpatialUICameraTypeFix8", false)

local defineFastFlag4 = game:DefineFastFlag("LuaAppIECVREnabled8", false)
local defineFastFlag5 = game:DefineFastFlag("SpatialUIEnableDrag8", false)
local defineFastFlag6 = game:DefineFastFlag("SpatialUIEnableMovePanelToCenter8", false)
local defineFastFlag7 = game:DefineFastFlag("EnableSpatialUIPlaceFilter", false)

local class = {}

class.__index = class

function class.new()
	local v = { _layer_data = nil }

	setmetatable(v, class)
	return v
end

function class:getIXPVariant()
	if self._layer_data == nil then
		self._layer_data = experimentCacheManager.default:getLayerVariables(defineFastString) or {}
	end

	local v = self._layer_data[defineFastString2] or nil

	if v == nil then
		return defineFastInt
	end

	return (tonumber(v))
end

function class.isDependencyFlagsEnabled()
	return FFlagEnableUIManagerPackgify and not defineFastFlag7
end

function class:isInExperienceUIVREnabled(): boolean
	if not self:isDependencyFlagsEnabled() then
		return false
	end

	if defineFastFlag4 then
		return true
	end

	if defineFastFlag then
		return self:getIXPVariant() ~= defineFastInt
	end

	return false
end

function class:isDraggingAllowed()
	if not self:isInExperienceUIVREnabled() then
		return false
	end

	if defineFastFlag5 then
		return not defineFastFlag6
	end

	if defineFastFlag6 then
		return false
	end

	local ixpVariant = self:getIXPVariant()

	if ixpVariant == defineFastInt2 then
		return true
	end

	return ixpVariant ~= defineFastInt3 and ixpVariant ~= defineFastInt4 and defineFastFlag5
end

function class:isMovePanelToCenter(): boolean
	if not self:isInExperienceUIVREnabled() then
		return false
	end

	if defineFastFlag6 then
		return true
	end

	return self:getIXPVariant() == defineFastInt4
end

function class.isSpatialUICameraTypeFixEnabled(_)
	return defineFastFlag3
end

function class.isSpatialUIScalingFixEnabled(_)
	return defineFastFlag2
end

return (class.new())
