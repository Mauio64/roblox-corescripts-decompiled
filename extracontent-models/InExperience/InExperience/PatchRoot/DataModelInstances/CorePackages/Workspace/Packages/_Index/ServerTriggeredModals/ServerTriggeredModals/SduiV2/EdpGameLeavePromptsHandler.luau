local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local React = require(Parent.React)
local MessageBus = require(Parent.MessageBus).MessageBus
local t = require(Parent.t)
local PromptsHandler = require(script.Parent.PromptsHandler).PromptsHandler
local PromptsEntryPoint = require(script.Parent.PromptsEntryPoint)
local isPinShortcutAvailable = require(script.Parent.isPinShortcutAvailable)

local function EdpGameLeavePromptsHandler(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), isPinShortcutAvailable (copy), MessageBus (copy), t (copy), PromptsHandler (copy), PromptsEntryPoint (copy)
	local v10, v11 = React.useState(0)
	local v12 = React.useMemo(isPinShortcutAvailable, {})
	local v13 = React.useMemo(function() -- line: 20
		-- upvalues: t1 (copy)
		if t1.universeId == nil then
			return nil
		end

		return {
			universeId = t1.universeId
		}
	end, { t1.universeId })

	React.useEffect(function() -- line: 29
		-- upvalues: v12 (copy), t1 (copy), MessageBus (copy), t (copy), v11 (copy)
		if not v12 or t1.universeId == nil then
			return
		end

		local v14 = MessageBus.Subscriber.new()
		local v15 = MessageBus.getMessageId("Game", "onGameLeave")

		v14:subscribe({
			mid = v15,
			validateParams = t.table
		}, function() -- line: 39
			-- upvalues: v11 (copy)
			v11(function(n1: number) -- line: 40
				return n1 + 1
			end)
		end)

		return function() -- line: 45
			-- upvalues: v14 (copy), v15 (copy)
			v14:unsubscribeWithMsgId(v15)
		end
	end, {
		v12,
		t1.universeId
	})

	if not v12 or (v10 == 0 or v13 == nil) then
		return nil
	end

	return React.createElement(PromptsHandler, {
		key = "EdpPrompts" .. tostring(v10),
		entryPoint = PromptsEntryPoint.ExperienceDetailsPageSessionEnd,
		clientAttributes = v13
	})
end

return EdpGameLeavePromptsHandler
