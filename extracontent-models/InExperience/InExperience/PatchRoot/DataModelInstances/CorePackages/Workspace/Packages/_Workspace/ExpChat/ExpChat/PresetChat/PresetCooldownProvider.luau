local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local PresetCooldownContext = require(script.Parent.PresetCooldownContext)

local function PresetCooldownProvider(p)
	local presetChatStore = GetPresetChatStore(false)
	local endsAt = SignalsReact.useSignalState(presetChatStore.getPresetCooldownEndsAt)
	local isCooldownActive

	if endsAt == nil then
		isCooldownActive = false
	else
		isCooldownActive = os.clock() < endsAt
	end

	React.useEffect(function()
		if endsAt == nil then
			return
		end

		local v = endsAt - os.clock()

		if v <= 0 then
			presetChatStore.setPresetCooldownEndsAt(nil)
			return
		end

		local flag = false
		task.delay(v, function()
			if flag then
				return
			end

			if presetChatStore.getPresetCooldownEndsAt(false) == endsAt then
				presetChatStore.setPresetCooldownEndsAt(nil)
			end
		end)
		return function()
			flag = true
		end
	end, { endsAt, presetChatStore.setPresetCooldownEndsAt, presetChatStore.getPresetCooldownEndsAt })

	local v = React.useMemo(function()
		return { endsAt = endsAt, isCooldownActive = isCooldownActive }
	end, { endsAt, isCooldownActive })

	return React.createElement(PresetCooldownContext.Provider, { value = v }, p.children)
end

return PresetCooldownProvider
