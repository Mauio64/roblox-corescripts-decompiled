local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local Parent = script:FindFirstAncestor("Responsive").Parent
local StandardBreakpoints = require(script.Parent.CommonConfigs.StandardBreakpoints)
local InputMode = require(script.Parent.InputMode)
local Signal = require(Parent.AppCommonLib).Signal
local FindFirstAncestorWithTag = require(script.Parent.FindFirstAncestorWithTag)
local self = setmetatable({}, {
	__mode = "k"
})
local t1 = {}

t1.__index = t1

local rules = StandardBreakpoints.rules
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}) -- line: 62
	-- upvalues: t2 (copy)
	local t4 = {
		_hasSizeRules = false,
		_hasInputRules = false,
		_currentKey = "Default",
		_config = t3 or {},
		_currentRule = {
			Key = "Default"
		}
	}
	local v14 = false
	local v15 = false

	for _, v17 in t3 do
		v14 = v14 or (v17.minWidth ~= nil or (v17.maxWidth ~= nil or (v17.minHeight ~= nil or (v17.maxHeight ~= nil or (v17.maxRatio ~= nil or v17.minRatio ~= nil)))))
		v15 = v15 or (v17.preferredInput ~= nil or v17.lastInput ~= nil)
	end

	t4._hasSizeRules = v14
	t4._hasInputRules = v15

	return (setmetatable(t4, t2))
end
function t2.hasSizeRules(p1) -- line: 98
	return p1._hasSizeRules
end
function t2.hasInputRules(p2) -- line: 101
	return p2._hasInputRules
end
function t2.currentRule(p3) -- line: 105
	return p3._currentRule
end
function t2.currentKey(p4) -- line: 108
	return p4._currentKey
end
function t2.resolve(t5: {[any]: any}, n1: number, n2: number, s1: string, s2: string, b1: boolean) -- line: 114
	local s3 = "Default"
	local t6 = {}
	local v30 = n1 / n2

	for _, v32 in t5._config do
		if (v32.minWidth == nil or n1 >= v32.minWidth) and ((v32.maxWidth == nil or n1 <= v32.maxWidth) and ((v32.minHeight == nil or n2 >= v32.minHeight) and ((v32.maxHeight == nil or n2 <= v32.maxHeight) and ((v32.minRatio == nil or v30 >= v32.minRatio) and ((v32.maxRatio == nil or v30 <= v32.maxRatio) and ((v32.preferredInput == nil or s1 == v32.preferredInput) and ((v32.lastInput == nil or s2 == v32.lastInput) and (v32.spatial == nil or b1 == v32.spatial)))))))) then
			t6 = v32
			s3 = v32.Key

			break
		end
	end

	if s3 ~= t5._currentKey then
		t5._currentKey = s3
		t5._currentRule = t6

		return true
	end

	return false
end
function t1.new() -- line: 154
	-- upvalues: VRService (copy), Signal (copy), t1 (copy), InputMode (copy)
	local t7 = {
		_layerCollectorSizeConnection = nil,
		_inputModeConnection = nil,
		_vrEnabledConnection = nil,
		_hasInputRules = false,
		_hasSizeRules = false,
		_refCount = 1,
		_vrEnabled = VRService.VREnabled,
		_changed = Signal.new(),
		_absoluteSize = Vector2.zero,
		_configResolvers = {
			default = {}
		}
	}
	local v34 = setmetatable(t7, t1)

	t7._inputModeConnection = InputMode.connect(function() -- line: 182
		-- upvalues: t7 (copy), v34 (copy)
		if t7._hasInputRules then
			v34:resolve()
		end
	end)
	t7._vrEnabledConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 188
		-- upvalues: t7 (copy), VRService (copy), v34 (copy)
		t7._vrEnabled = VRService.VREnabled
		v34:resolve()
	end)

	return v34
end
function t1.incRef(p5) -- line: 196
	p5._refCount = p5._refCount + 1
end
function t1.destroy(p6) -- line: 201
	-- upvalues: self (copy)
	if p6._refCount > 1 then
		p6._refCount = p6._refCount - 1

		return
	end

	if p6._layerCollectorSizeConnection then
		p6._layerCollectorSizeConnection:Disconnect()
		p6._layerCollectorSizeConnection = nil
	end

	if p6._inputModeConnection then
		p6._inputModeConnection:disconnect()
		p6._inputModeConnection = nil
	end

	if p6._vrEnabledConnection then
		p6._vrEnabledConnection:Disconnect()
		p6._vrEnabledConnection = nil
	end

	p6._changed = nil

	for v37, v38 in self do
		if v38 == p6 then
			self[v37] = nil
		end
	end
end
function t1.connect(p7, p8) -- line: 228
	if p7._changed == nil then
		error("Connecting to dead signal!")
	end

	return p7._changed:connect(p8)
end
function t1.currentRule(t8: {[any]: any}, s4: string?) -- line: 236
	local v43 = s4 or "default"

	return t8._configResolvers[v43]:currentRule()
end
function t1.currentKey(t9: {[any]: any}, s5: string?) -- line: 241
	local v46 = s5 or "default"

	return t9._configResolvers[v46]:currentKey()
end
function t1.updateAbsoluteSize(p9, p10) -- line: 247
	-- upvalues: GuiService (copy)
	local AbsoluteSize = p10.AbsoluteSize

	if p10:IsA("LayerCollector") then
		local ok, result = pcall(function() -- line: 251
			-- upvalues: p10 (copy)
			return p10.IgnoreGuiInset
		end)

		if ok and result then
			local v52, _ = GuiService:GetGuiInset()

			AbsoluteSize += v52
		end
	end

	if AbsoluteSize.X ~= p9._absoluteSize.X or AbsoluteSize.Y ~= p9._absoluteSize.Y then
		p9._absoluteSize = AbsoluteSize

		if p9._hasSizeRules then
			p9:resolve()
		end
	end
end
function t1.resolve(p11) -- line: 270
	-- upvalues: InputMode (copy)
	if not p11._configResolvers then
		return
	end

	local v55 = p11._absoluteSize.X or 1
	local v56 = p11._absoluteSize.Y or 1
	local v57 = InputMode.preferred()
	local v58 = InputMode.last()
	local _vrEnabled = p11._vrEnabled
	local v60 = false

	for _, v62 in p11._configResolvers do
		if v62:resolve(v55, v56, v57, v58, _vrEnabled) then
			v60 = true
		end
	end

	if v60 then
		p11._changed:fire()
	end
end
function is_array(p12) -- line: 293
	return type(p12) == "table" and p12[1] ~= nil
end
function t1.setConfig(p13, p14) -- line: 300
	-- upvalues: t2 (copy)
	if is_array(p14) then
		p14 = {
			default = p14
		}
	end

	local v66 = false
	local v67 = false
	local t10 = {}

	if p14 then
		for v69, v70 in p14 do
			t10[v69] = t2.new(v70)
			v66 = v66 or t10[v69]:hasSizeRules()
			v67 = v67 or t10[v69]:hasInputRules()
		end
	end

	p13._hasInputRules = v67
	p13._hasSizeRules = v66
	p13._configResolvers = t10
	p13:resolve()
end
function t1.setLocalInstance(t11: {[any]: any}, p15, p16) -- line: 328
	-- upvalues: FindFirstAncestorWithTag (copy)
	if typeof(p15) ~= "Instance" then
		error("setLocalInstance arg1 expects Instance")

		return
	end

	local u74 = if typeof(p16) ~= "string" then if typeof(p16) ~= "Instance" then p15:FindFirstAncestorWhichIsA("LayerCollector") else p16 else FindFirstAncestorWithTag(p15, p16) or p15

	if u74 == nil then
		u74 = p15
	end

	if t11._layerCollectorSizeConnection then
		t11._layerCollectorSizeConnection:Disconnect()
		t11._layerCollectorSizeConnection = nil
	end

	if u74 then
		t11._layerCollectorSizeConnection = u74:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 354
			-- upvalues: t11 (copy), u74 (ref)
			t11:updateAbsoluteSize(u74)
		end)
		t11:updateAbsoluteSize(u74)
	end
end

return {
	DefaultKey = "Default",
	bindContainer = function(p17, p18) -- line: 363
		-- upvalues: self (copy), t1 (copy), rules (copy)
		local v77 = self[p17]
		local v78 = p18 == nil

		if v78 and v77 then
			v77:incRef()

			return v77
		end

		local v79 = t1.new()

		v79:setLocalInstance(p17, p17)
		v79:setConfig(p18 or rules)

		if v78 then
			self[p17] = v79
		end

		return v79
	end
}
