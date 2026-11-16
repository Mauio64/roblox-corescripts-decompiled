require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local GetAgentRollbackRequestStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentRollbackRequestStore")

local function useAgentRollbackRequest(data)
	local v5 = GetAgentRollbackRequestStore(false)
	local ref = React.useRef({})
	local ref2 = React.useRef(nil)
	local v6 = React.useCallback(function(p2): boolean
		local current = ref2.current

		if current == nil then
			return false
		end

		ref2.current = nil
		p2.stop()
		current.rejectStartup()
		return true
	end, {})

	local v7 = React.useCallback(function(p2, callback, callback2): boolean
		if data.session == nil or data.activeTurnHandleRef.current ~= nil then
			return false
		end

		ref2.current = { requestId = p2.id, rejectStartup = callback2 }

		data.startRollbackTurn(p2, function()
			local current = ref2.current

			if current == nil or current.requestId ~= p2.id then
				return
			end

			ref2.current = nil
			callback()
		end, function()
			local current = ref2.current

			if current == nil or current.requestId ~= p2.id then
				return
			end

			ref2.current = nil
			callback2()
		end)
		return true
	end, { data.session, data.activeTurnHandleRef, data.startRollbackTurn })

	React.useLayoutEffect(function()
		if data.session == nil or data.placeId == nil then
			v5.unregisterTurnStarter(ref.current)
		else
			v5.registerTurnStarter(
				{ universeId = data.universeId, placeId = data.placeId },
				ref.current,
				v7
			)
		end
	end, { data.universeId, data.placeId, data.session, v7, v5 })

	React.useLayoutEffect(function()
		local current = ref.current
		return function()
			v5.unregisterTurnStarter(current)
		end
	end, { v5 })

	React.useEffect(function()
		return function()
			local current = data.activeTurnHandleRef.current

			if current ~= nil then
				v6(current)
			end
		end
	end, { data.activeTurnHandleRef, v6 })

	return {
		stopRequestBeforeReceipt = v6,
		cancelRequestBeforeTurnStarts = React.useCallback(function()
			return ref2.current == nil and data.placeId ~= nil and v5.cancelRequestForPlaceId(data.placeId)
		end, { data.placeId, v5 })
	}
end

return useAgentRollbackRequest
