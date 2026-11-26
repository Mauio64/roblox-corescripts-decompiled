local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")

local StandardBreakpoints = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/CommonConfigs/StandardBreakpoints")

local InputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/InputMode")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/AppCommonLib").Signal
local FindFirstAncestorWithTag = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/FindFirstAncestorWithTag")

local object = setmetatable({}, { __mode = "k" })

local class = {}
class.__index = class

local rules = StandardBreakpoints.rules

local class2 = {}
class2.__index = class2

function class2.new(options)
	local v5 = false
	local v6 = false
	local v7 = {
		_hasSizeRules = false,
		_hasInputRules = false,
		_config = options or {},
		_currentRule = { Key = "Default" },
		_currentKey = "Default"
	}

	for k, option in options do
		v5 = v5
			or option.minWidth ~= nil
			or option.maxWidth ~= nil
			or option.minHeight ~= nil
			or option.maxHeight ~= nil
			or option.maxRatio ~= nil
			or option.minRatio ~= nil

		v6 = v6 or option.preferredInput ~= nil or option.lastInput ~= nil
	end

	v7._hasSizeRules = v5
	v7._hasInputRules = v6

	return (setmetatable(v7, class2))
end

function class2:hasSizeRules()
	return self._hasSizeRules
end

function class2:hasInputRules()
	return self._hasInputRules
end

function class2:currentRule()
	return self._currentRule
end

function class2:currentKey()
	return self._currentKey
end

function class2:resolve(p2, p3, p4, p5, p6): boolean
	local v5 = p2 / p3
	local v6 = "Default"
	local v7 = {}

	for k, v9 in self._config do
		local v10

		if
			(v9.minWidth == nil or v9.minWidth <= p2)
			and (v9.maxWidth == nil or p2 <= v9.maxWidth)
			and (v9.minHeight == nil or v9.minHeight <= p3)
			and (v9.maxHeight == nil or p3 <= v9.maxHeight)
			and (v9.minRatio == nil or v9.minRatio <= v5)
			and (v9.maxRatio == nil or v5 <= v9.maxRatio)
			and (v9.preferredInput == nil or p4 == v9.preferredInput)
			and (v9.lastInput == nil or p5 == v9.lastInput)
		then
			v10 = v9.spatial == nil or p6 == v9.spatial
		else
			v10 = false
		end

		if v10 then
			v6 = v9.Key
			v7 = v9
			break
		end
	end

	if v6 == self._currentKey then
		return false
	end

	self._currentKey = v6
	self._currentRule = v7
	return true
end

function class.new()
	local v5 = {
		_layerCollectorSizeConnection = nil,
		_inputModeConnection = nil,
		_vrEnabledConnection = nil,
		_vrEnabled = VRService.VREnabled,
		_changed = signal.new(),
		_absoluteSize = Vector2.zero,
		_hasInputRules = false,
		_hasSizeRules = false,
		_refCount = 1,
		_configResolvers = { default = {} }
	}

	local object2 = setmetatable(v5, class)

	v5._inputModeConnection = InputMode.connect(function()
		if v5._hasInputRules then
			object2:resolve()
		end
	end)

	v5._vrEnabledConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
		v5._vrEnabled = VRService.VREnabled
		object2:resolve()
	end)

	return object2
end

function class:incRef()
	self._refCount += 1
end

function class:destroy()
	if self._refCount > 1 then
		self._refCount -= 1
		return
	end

	if self._layerCollectorSizeConnection then
		self._layerCollectorSizeConnection:Disconnect()
		self._layerCollectorSizeConnection = nil
	end

	if self._inputModeConnection then
		self._inputModeConnection:disconnect()
		self._inputModeConnection = nil
	end

	if self._vrEnabledConnection then
		self._vrEnabledConnection:Disconnect()
		self._vrEnabledConnection = nil
	end

	self._changed = nil

	for k, v5 in object do
		if v5 == self then
			object[k] = nil
		end
	end
end

function class:connect(p3)
	if self._changed == nil then
		error("Connecting to dead signal!")
	end

	return self._changed:connect(p3)
end

function class:currentRule(value)
	return self._configResolvers[value or "default"]:currentRule()
end

function class:currentKey(value)
	return self._configResolvers[value or "default"]:currentKey()
end

function class:updateAbsoluteSize(layerCollector)
	local absoluteSize = layerCollector.AbsoluteSize

	if layerCollector:IsA("LayerCollector") then
		local success, result = pcall(function()
			return layerCollector.IgnoreGuiInset
		end)

		if success and result then
			local guiInset, v5 = GuiService:GetGuiInset()
			absoluteSize += guiInset
		end
	end

	if absoluteSize.X ~= self._absoluteSize.X or absoluteSize.Y ~= self._absoluteSize.Y then
		self._absoluteSize = absoluteSize

		if self._hasSizeRules then
			self:resolve()
		end
	end
end

function class:resolve()
	if not self._configResolvers then
		return
	end

	local x = self._absoluteSize.X or 1
	local y = self._absoluteSize.Y or 1
	local preferred = InputMode.preferred()
	local last = InputMode.last()
	local vrEnabled = self._vrEnabled
	local flag = false

	for k, configResolver in self._configResolvers do
		if configResolver:resolve(x, y, preferred, last, vrEnabled) then
			flag = true
		end
	end

	if flag then
		self._changed:fire()
	end
end

function LUAUFORGE_MODULE_GLOBALS_xL_is_array(list): boolean
	return type(list) == "table" and list[1] ~= nil
end

function class:setConfig(p2)
	local v5 = LUAUFORGE_MODULE_GLOBALS_xL_is_array(p2) and { default = p2 } or p2

	local v6 = false
	local v7 = false
	local v8 = {}

	if v5 then
		for k, v9 in v5 do
			v8[k] = class2.new(v9)
			v6 = v6 or v8[k]:hasSizeRules()
			v7 = v7 or v8[k]:hasInputRules()
		end
	end

	self._hasInputRules = v7
	self._hasSizeRules = v6
	self._configResolvers = v8
	self:resolve()
end

function class:setLocalInstance(instance, value)
	if typeof(instance) ~= "Instance" then
		error("setLocalInstance arg1 expects Instance")
		return
	end

	if typeof(value) == "string" then
		value = FindFirstAncestorWithTag(instance, value) or instance
	elseif typeof(value) ~= "Instance" then
		value = instance:FindFirstAncestorWhichIsA("LayerCollector")
	end

	if value == nil then
		value = instance
	end

	if self._layerCollectorSizeConnection then
		self._layerCollectorSizeConnection:Disconnect()
		self._layerCollectorSizeConnection = nil
	end

	if value then
		self._layerCollectorSizeConnection = value:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			self:updateAbsoluteSize(value)
		end)
		self:updateAbsoluteSize(value)
	end
end

return {
	DefaultKey = "Default",
	bindContainer = function(p2, p3)
		local v5 = object[p2]
		local v6 = p3 == nil

		if v6 and v5 then
			v5:incRef()
			return v5
		end

		local v7 = class.new()
		v7:setLocalInstance(p2, p2)
		v7:setConfig(p3 or rules)

		if v6 then
			object[p2] = v7
		end

		return v7
	end
}
