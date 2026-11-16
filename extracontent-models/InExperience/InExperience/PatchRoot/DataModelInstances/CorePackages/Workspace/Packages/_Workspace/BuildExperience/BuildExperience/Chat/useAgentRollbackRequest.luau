local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.CreatorAgentChat)
local React = require(parent.React)

require(script.Parent.chatTypes)
local GetAgentRollbackRequestStore = require(BuildExperience.Stores.GetAgentRollbackRequestStore)

local function useAgentRollbackRequest(data)
	local agentRollbackRequestStore = GetAgentRollbackRequestStore(false)
	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	local stopRequestBeforeReceipt = React.useCallback(function(p): boolean
		local current = ref2.current

		if current == nil then
			return false
		end

		ref2.current = nil
		p.stop()
		current.rejectStartup()
		return true
	end, {})

	local v = React.useCallback(function(p, callback, callback2): boolean
		if data.session == nil or data.activeTurnHandleRef.current ~= nil then
			return false
		end

		ref2.current = { requestId = p.id, rejectStartup = callback2 }

		data.startRollbackTurn(p, function()
			local current = ref2.current

			if current == nil or current.requestId ~= p.id then
				return
			end

			ref2.current = nil
			callback()
		end, function()
			local current = ref2.current

			if current == nil or current.requestId ~= p.id then
				return
			end

			ref2.current = nil
			callback2()
		end)
		return true
	end, { data.session, data.activeTurnHandleRef, data.startRollbackTurn })

	React.useLayoutEffect(function()
		if data.session == nil or data.placeId == nil then
			agentRollbackRequestStore.unregisterTurnStarter(ref.current)
		else
			agentRollbackRequestStore.registerTurnStarter(
				{ universeId = data.universeId, placeId = data.placeId },
				ref.current,
				v
			)
		end
	end, { data.universeId, data.placeId, data.session, v, agentRollbackRequestStore })

	React.useLayoutEffect(function()
		local current = ref.current
		return function()
			agentRollbackRequestStore.unregisterTurnStarter(current)
		end
	end, { agentRollbackRequestStore })

	React.useEffect(function()
		return function()
			local current = data.activeTurnHandleRef.current

			if current ~= nil then
				stopRequestBeforeReceipt(current)
			end
		end
	end, { data.activeTurnHandleRef, stopRequestBeforeReceipt })

	return {
		stopRequestBeforeReceipt = stopRequestBeforeReceipt,
		cancelRequestBeforeTurnStarts = React.useCallback(function()
			return ref2.current == nil
				and data.placeId ~= nil
				and agentRollbackRequestStore.cancelRequestForPlaceId(data.placeId)
		end, { data.placeId, agentRollbackRequestStore })
	}
end

return useAgentRollbackRequest
