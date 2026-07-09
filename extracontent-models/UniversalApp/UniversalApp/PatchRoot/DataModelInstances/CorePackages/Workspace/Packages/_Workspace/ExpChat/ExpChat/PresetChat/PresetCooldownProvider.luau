local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local PresetCooldownContext = require(script.Parent.PresetCooldownContext)

local function PresetCooldownProvider(t1: {[any]: any}) -- line: 13
	-- upvalues: GetPresetChatStore (copy), SignalsReact (copy), React (copy), PresetCooldownContext (copy)
	local v9 = GetPresetChatStore(false)
	local v10 = SignalsReact.useSignalState(v9.getPresetCooldownEndsAt)
	local v11 = v10 ~= nil and v10 > os.clock()

	React.useEffect(function() -- line: 18
		-- upvalues: v10 (copy), v9 (copy)
		if v10 == nil then
			return
		end

		local v13 = v10 - os.clock()

		if v13 <= 0 then
			v9.setPresetCooldownEndsAt(nil)

			return
		end

		local u14 = false

		task.delay(v13, function() -- line: 28
			-- upvalues: u14 (ref), v9 (copy), v10 (copy)
			if u14 then
				return
			end

			if v9.getPresetCooldownEndsAt(false) == v10 then
				v9.setPresetCooldownEndsAt(nil)
			end
		end)

		return function() -- line: 36
			-- upvalues: u14 (ref)
			u14 = true
		end
	end, {
		v10,
		v9.setPresetCooldownEndsAt,
		v9.getPresetCooldownEndsAt
	})

	local v12 = React.useMemo(function() -- line: 41
		-- upvalues: v10 (copy), v11 (copy)
		return {
			endsAt = v10,
			isCooldownActive = v11
		}
	end, {
		v10,
		v11
	})

	return React.createElement(PresetCooldownContext.Provider, {
		value = v12
	}, t1.children)
end

return PresetCooldownProvider
