local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")

local parent = script:FindFirstAncestor("Responsive").Parent

local StandardBreakpoints = require(script.Parent.CommonConfigs.StandardBreakpoints)

local InputMode = require(script.Parent.InputMode)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local FindFirstAncestorWithTag = require(script.Parent.FindFirstAncestorWithTag)

local object = setmetatable({}, { __mode = "k" })

local class = {}
class.__index = class

local rules = StandardBreakpoints.rules

local class2 = {}
class2.__index = class2

function class2.new(options)
	local hasSizeRules = false
	local hasInputRules = false
	local v = {
		_hasSizeRules = false,
		_hasInputRules = false,
		_config = options or {},
		_currentRule = { Key = "Default" },
		_currentKey = "Default"
	}

	for _, option in options do
		hasSizeRules = hasSizeRules
			or option.minWidth ~= nil
			or option.maxWidth ~= nil
			or option.minHeight ~= nil
			or option.maxHeight ~= nil
			or option.maxRatio ~= nil
			or option.minRatio ~= nil

		hasInputRules = hasInputRules or option.preferredInput ~= nil or option.lastInput ~= nil
	end

	v._hasSizeRules = hasSizeRules
	v._hasInputRules = hasInputRules

	return (setmetatable(v, class2))
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

function class2:resolve(p: number, p2: number, p3: string, p4: string, flag: boolean): boolean
	local v = p / p2
	local currentKey = "Default"
	local currentRule = {}

	for _, v2 in self._config do
		local v3

		if
			(v2.minWidth == nil or v2.minWidth <= p)
			and (v2.maxWidth == nil or p <= v2.maxWidth)
			and (v2.minHeight == nil or v2.minHeight <= p2)
			and (v2.maxHeight == nil or p2 <= v2.maxHeight)
			and (v2.minRatio == nil or v2.minRatio <= v)
			and (v2.maxRatio == nil or v <= v2.maxRatio)
			and (v2.preferredInput == nil or p3 == v2.preferredInput)
			and (v2.lastInput == nil or p4 == v2.lastInput)
		then
			v3 = v2.spatial == nil or flag == v2.spatial
		else
			v3 = false
		end

		if v3 then
			currentKey = v2.Key
			currentRule = v2
			break
		end
	end

	if currentKey == self._currentKey then
		return false
	end

	self._currentKey = currentKey
	self._currentRule = currentRule
	return true
end

function class.new()
	local v = {
		_layerCollectorSizeConnection = nil,
		_inputModeConnection = nil,
		_vrEnabledConnection = nil,
		_vrEnabled = VRService.VREnabled,
		_changed = Signal.new(),
		_absoluteSize = Vector2.zero,
		_hasInputRules = false,
		_hasSizeRules = false,
		_refCount = 1,
		_configResolvers = { default = {} }
	}

	local object2 = setmetatable(v, class)

	v._inputModeConnection = InputMode.connect(function()
		if v._hasInputRules then
			object2:resolve()
		end
	end)

	v._vrEnabledConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
		v._vrEnabled = VRService.VREnabled
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

	for k, v in object do
		if v == self then
			object[k] = nil
		end
	end
end

function class:connect(p)
	if self._changed == nil then
		error("Connecting to dead signal!")
	end

	return self._changed:connect(p)
end

function class:currentRule(value: string?)
	return self._configResolvers[value or "default"]:currentRule()
end

function class:currentKey(value: string?)
	return self._configResolvers[value or "default"]:currentKey()
end

function class:updateAbsoluteSize(layerCollector)
	local absoluteSize = layerCollector.AbsoluteSize

	if layerCollector:IsA("LayerCollector") then
		local success, result = pcall(function()
			return layerCollector.IgnoreGuiInset
		end)

		if success and result then
			local guiInset, _ = GuiService:GetGuiInset()
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

	for _, configResolver in self._configResolvers do
		if configResolver:resolve(x, y, preferred, last, vrEnabled) then
			flag = true
		end
	end

	if flag then
		self._changed:fire()
	end
end

function is_array(list): boolean
	return type(list) == "table" and list[1] ~= nil
end

function class:setConfig(default)
	local v = is_array(default) and { default = default } or default

	local hasSizeRules = false
	local hasInputRules = false
	local configResolvers = {}

	if v then
		for k, v2 in v do
			configResolvers[k] = class2.new(v2)
			hasSizeRules = hasSizeRules or configResolvers[k]:hasSizeRules()
			hasInputRules = hasInputRules or configResolvers[k]:hasInputRules()
		end
	end

	self._hasInputRules = hasInputRules
	self._hasSizeRules = hasSizeRules
	self._configResolvers = configResolvers
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
	bindContainer = function(p, p2)
		local v = object[p]
		local v2 = p2 == nil

		if v2 and v then
			v:incRef()
			return v
		end

		local v3 = class.new()
		v3:setLocalInstance(p, p)
		v3:setConfig(p2 or rules)

		if v2 then
			object[p] = v3
		end

		return v3
	end
}
