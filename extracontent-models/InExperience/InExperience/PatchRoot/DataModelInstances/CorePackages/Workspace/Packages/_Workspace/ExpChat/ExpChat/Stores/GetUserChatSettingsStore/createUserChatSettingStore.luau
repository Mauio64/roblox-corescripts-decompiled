local parent = script:FindFirstAncestor("ExpChat").Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local GetChatStatusStore = require(script.Parent.Parent.GetChatStatusStore)

return function(data)
	local signal, v = createSignal(false)
	local signal2, v2 = createSignal(false)
	local v3

	if data.requiresChatEnabled == nil then
		v3 = false
	else
		v3 = data.requiresChatEnabled
	end

	local chatStatusStore = GetChatStatusStore(false)

	local getIsSettingVisible = createComputed(function(p)
		if v3 then
			return signal(p) and chatStatusStore.getChatStatus(p) == "Enabled"
		end

		return signal(p)
	end)

	local getIsSettingEnabled = createComputed(function(p)
		if v3 then
			return signal2(p) and chatStatusStore.getChatStatus(p) == "Enabled"
		end

		return signal2(p)
	end)

	local fn = not data.buildFeatureValueHandler and function(_: string, _: string) end
		or data.buildFeatureValueHandler(v, v2)

	local cleanup = data.setupListener(v, v2)

	return {
		getIsSettingVisible = getIsSettingVisible,
		getIsSettingEnabled = getIsSettingEnabled,
		setIsSettingVisible = fn,
		setIsSettingEnabled = function(flag: boolean)
			data.onSetEnabled(flag, v2)
		end,
		initialize = data.onInitialize or function() end,
		cleanup = cleanup
	}
end
