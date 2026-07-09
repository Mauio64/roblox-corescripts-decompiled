local StarterGui = game:GetService("StarterGui")
local Lifecycle = require(script.Parent.Lifecycle)
local FeatureName = require(script.Parent.FeatureName)
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}?) -- line: 27
	-- upvalues: t1 (copy), StarterGui (copy), Lifecycle (copy)
	local self = setmetatable({}, t1)
	local t3 = nil
	local coreGuiType = nil

	if t2 then
		coreGuiType = t2.coreGuiType

		local v10 = t2.defaultEnabled or false

		if coreGuiType then
			v10 = StarterGui:GetCoreGuiEnabled(coreGuiType)
		end

		t3 = {
			defaultVisible = t2.defaultVisible or false,
			defaultEnabled = v10
		}
	end

	local v11 = Lifecycle.new(t3)

	self.lifecycle = v11

	if coreGuiType then
		self._coreGuiConnection = StarterGui.CoreGuiChangedSignal:Connect(function(p1, p2) -- line: 51
			-- upvalues: coreGuiType (ref), v11 (copy)
			if p1 == coreGuiType or p1 == Enum.CoreGuiType.All then
				v11.setEnabled(p2)
			end
		end)
	end

	return self
end
function t1.dispose(p3) -- line: 61
	if p3._coreGuiConnection then
		p3._coreGuiConnection:Disconnect()
		p3._coreGuiConnection = nil
	end

	p3.lifecycle:dispose()
end

local t4 = {}

return {
	FeatureName = FeatureName,
	registerLifecycle = function(p4, t5: {[any]: any}?) -- line: 75
		-- upvalues: t4 (copy), t1 (copy)
		assert(not t4[p4], `Feature "{ p4 }" already has a registered lifecycle`)

		local v15 = t1.new(t5)

		t4[p4] = v15

		return v15
	end,
	getFeature = function(p5) -- line: 83
		-- upvalues: t4 (copy)
		return t4[p5]
	end,
	getVisibility = function(p6) -- line: 87
		-- upvalues: t4 (copy)
		local v18 = t4[p6]

		if v18 then
			return v18.lifecycle.getVisible(false)
		end

		return false
	end,
	setVisibility = function(p7, b1: boolean) -- line: 95
		-- upvalues: t4 (copy)
		local v21 = t4[p7]

		if v21 then
			v21.lifecycle.setVisible(b1)
		end
	end,
	toggleVisibility = function(p8) -- line: 102
		-- upvalues: t4 (copy)
		local v23 = t4[p8]

		if v23 then
			v23.lifecycle.setVisible(not v23.lifecycle.getVisible(false))
		end
	end,
	setEnabled = function(p9, b2: boolean) -- line: 109
		-- upvalues: t4 (copy)
		local v26 = t4[p9]

		if v26 then
			v26.lifecycle.setEnabled(b2)
		end
	end,
	onVisibilityChanged = function(p10, p11: ((...any) -> ...any)) -- line: 116
		-- upvalues: t4 (copy)
		local v29 = t4[p10]

		if v29 then
			return v29.lifecycle:onVisibilityChanged(p11)
		end

		return function() -- line: 121
		end
	end,
	onEnabledChanged = function(p12, p13: ((...any) -> ...any)) -- line: 124
		-- upvalues: t4 (copy)
		local v32 = t4[p12]

		if v32 then
			return v32.lifecycle:onEnabledChanged(p13)
		end

		return function() -- line: 129
		end
	end
}
