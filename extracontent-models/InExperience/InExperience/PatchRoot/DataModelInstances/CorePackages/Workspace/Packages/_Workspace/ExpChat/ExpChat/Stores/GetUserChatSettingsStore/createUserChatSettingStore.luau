local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local GetChatStatusStore = require(script.Parent.Parent.GetChatStatusStore)

return function(t1: {[any]: any}) -- line: 49
	-- upvalues: createSignal (copy), GetChatStatusStore (copy), createComputed (copy)
	local v7, v8 = createSignal(false)
	local v9, v10 = createSignal(false)
	local v11 = t1.requiresChatEnabled ~= nil and t1.requiresChatEnabled
	local v12 = GetChatStatusStore(false)
	local v13 = createComputed(function(p1) -- line: 58
		-- upvalues: v11 (copy), v7 (copy), v12 (copy)
		if v11 then
			return v7(p1) and v12.getChatStatus(p1) == "Enabled"
		end

		return v7(p1)
	end)
	local v14 = createComputed(function(p2) -- line: 65
		-- upvalues: v11 (copy), v9 (copy), v12 (copy)
		if v11 then
			return v9(p2) and v12.getChatStatus(p2) == "Enabled"
		end

		return v9(p2)
	end)
	local v15 = not t1.buildFeatureValueHandler and function(_: string, _: string) -- line: 74
	end or t1.buildFeatureValueHandler(v8, v10)
	local v16 = t1.setupListener(v8, v10)

	return {
		getIsSettingVisible = v13,
		getIsSettingEnabled = v14,
		setIsSettingVisible = v15,
		setIsSettingEnabled = function(b1: boolean) -- line: 82
			-- upvalues: t1 (copy), v10 (copy)
			t1.onSetEnabled(b1, v10)
		end,
		initialize = t1.onInitialize or function() -- line: 85
		end,
		cleanup = v16
	}
end
