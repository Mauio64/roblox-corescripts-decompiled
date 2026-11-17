local SocialProof = script:FindFirstAncestor("SocialProof")
local parent = SocialProof.Parent

local React = require(parent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local Cryo = require(parent.Cryo)
local NetworkingSocialProof = require(SocialProof.Networking.NetworkingSocialProof)
local Constants = require(SocialProof.Common.Constants)
require(SocialProof.Common.Enums)

return function(data)
	local v = useDispatch()
	local entityId = data.entityId
	local entityType = data.entityType
	local connectionType = data.connectionType

	local state, setState = useState(false)
	local state2, setState2 = useState(true)
	local state3, setState3 = useState(nil)
	local state4, setState4 = useState("")
	local state5, setState5 = useState({})
	local v2 = useRef(true)
	local state6, setState6 = useState(0)

	local v3 = useSelector(function(p)
		local connectionsByEntityId = p[Constants.RODUX_KEY].ConnectionsByEntityId or {}
		return getDeepValue(connectionsByEntityId, (string.format("%s.%s.%s", connectionType, entityType, entityId)))
			or {}
	end)

	useEffect(function()
		if not v3.userIds then
			return
		end

		local userIds = v3.userIds

		local v4 = #state5 + #userIds
		local totalConnections = v3.totalConnections or 0
		local v5 = v4 < totalConnections
		setState6(totalConnections)
		setState2(v5)
		setState4((tostring(v4)))

		setState5(function(p)
			return Cryo.List.join(p, userIds)
		end)
	end, { v3.userIds, v3.totalConnections })

	local fetchPage = useCallback(function()
		if state or not state2 then
			return
		end

		setState(true)
		setState3(nil)

		v(NetworkingSocialProof.GetConnectionsByEntityId.API({
			entityId = entityId,
			entityType = entityType,
			connectionType = connectionType,
			cursor = state4
		})):andThen(function()
			if v2.current then
				setState(false)
			end
		end):catch(function(p)
			if v2.current then
				setState(false)
				setState3(p)
			end
		end)
	end, { state4, state, state2, entityId, entityType, connectionType, v })

	local reset = useCallback(function()
		setState5({})
		setState2(true)
		setState(false)
		setState3(nil)
	end, {})

	useEffect(function()
		if entityId and entityType and connectionType and not v3.userIds then
			fetchPage()
		end
	end, { entityId, entityType, connectionType, v3.userIds })

	return {
		userIds = state5,
		isLoading = state,
		hasMore = state2,
		error = state3,
		fetchPage = fetchPage,
		reset = reset,
		totalConnections = state6
	}
end
