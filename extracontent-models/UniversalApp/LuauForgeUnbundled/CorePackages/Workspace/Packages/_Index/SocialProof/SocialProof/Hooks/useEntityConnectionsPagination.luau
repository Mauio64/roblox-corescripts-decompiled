local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/React")
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Cryo")
local NetworkingSocialProof = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Networking/NetworkingSocialProof")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Common/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Common/Enums")

return function(data)
	local v5 = useDispatch()
	local entityId = data.entityId
	local entityType = data.entityType
	local connectionType = data.connectionType

	local state, setState = useState(false)
	local state2, setState2 = useState(true)
	local state3, setState3 = useState(nil)
	local state4, setState4 = useState("")
	local state5, setState5 = useState({})
	local v6 = useRef(true)
	local state6, setState6 = useState(0)

	local v7 = useSelector(function(p2)
		local connectionsByEntityId = p2[Constants.RODUX_KEY].ConnectionsByEntityId or {}
		return getDeepValue(
				connectionsByEntityId,
				(string.format("%s.%s.%s", connectionType, entityType, entityId))
			)
			or {}
	end)

	useEffect(function()
		if not v7.userIds then
			return
		end

		local userIds = v7.userIds

		local v8 = #state5 + #userIds
		local totalConnections = v7.totalConnections or 0
		local v9 = v8 < totalConnections
		setState6(totalConnections)
		setState2(v9)
		setState4((tostring(v8)))

		setState5(function(p2)
			return Cryo.List.join(p2, userIds)
		end)
	end, { v7.userIds, v7.totalConnections })

	local v8 = useCallback(function()
		if state or not state2 then
			return
		end

		setState(true)
		setState3(nil)

		v5(NetworkingSocialProof.GetConnectionsByEntityId.API({
			entityId = entityId,
			entityType = entityType,
			connectionType = connectionType,
			cursor = state4
		})):andThen(function()
			if v6.current then
				setState(false)
			end
		end):catch(function(p2)
			if v6.current then
				setState(false)
				setState3(p2)
			end
		end)
	end, { state4, state, state2, entityId, entityType, connectionType, v5 })

	local v9 = useCallback(function()
		setState5({})
		setState2(true)
		setState(false)
		setState3(nil)
	end, {})

	useEffect(function()
		if entityId and entityType and connectionType and not v7.userIds then
			v8()
		end
	end, { entityId, entityType, connectionType, v7.userIds })

	return {
		userIds = state5,
		isLoading = state,
		hasMore = state2,
		error = state3,
		fetchPage = v8,
		reset = v9,
		totalConnections = state6
	}
end
