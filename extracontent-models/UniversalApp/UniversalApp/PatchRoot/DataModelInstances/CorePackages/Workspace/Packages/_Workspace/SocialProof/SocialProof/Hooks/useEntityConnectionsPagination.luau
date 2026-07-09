local SocialProof = script:FindFirstAncestor("SocialProof")
local SocialProofParent = SocialProof.Parent
local React = require(SocialProofParent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState
local RoactUtils = require(SocialProofParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getDeepValue = require(SocialProofParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local Cryo = require(SocialProofParent.Cryo)
local NetworkingSocialProof = require(SocialProof.Networking.NetworkingSocialProof)
local Constants = require(SocialProof.Common.Constants)

require(SocialProof.Common.Enums)

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useDispatch (copy), useState (copy), useRef (copy), useSelector (copy), Constants (copy), getDeepValue (copy), useEffect (copy), Cryo (copy), useCallback (copy), NetworkingSocialProof (copy)
	local v16 = useDispatch()
	local entityId = t1.entityId
	local entityType = t1.entityType
	local connectionType = t1.connectionType
	local v20, v21 = useState(false)
	local v22, v23 = useState(true)
	local v24, v25 = useState(nil)
	local v26, v27 = useState("")
	local v28, v29 = useState({})
	local v30 = useRef(true)
	local v31, v32 = useState(0)
	local v33 = useSelector(function(p1) -- line: 42
		-- upvalues: Constants (copy), connectionType (copy), entityType (copy), entityId (copy), getDeepValue (copy)
		local v37 = p1[Constants.RODUX_KEY].ConnectionsByEntityId or {}
		local v38 = string.format("%s.%s.%s", connectionType, entityType, entityId)

		return getDeepValue(v37, v38) or {}
	end)

	useEffect(function() -- line: 48
		-- upvalues: v33 (copy), v28 (copy), v32 (copy), v23 (copy), v27 (copy), v29 (copy), Cryo (copy)
		if not v33.userIds then
			return
		end

		local userIds = v33.userIds
		local v40 = #v28 + #userIds
		local v41 = v33.totalConnections or 0
		local v42 = v40 < v41

		v32(v41)
		v23(v42)
		v27((tostring(v40)))
		v29(function(p2) -- line: 65
			-- upvalues: Cryo (copy), userIds (copy)
			return Cryo.List.join(p2, userIds)
		end)
	end, {
		v33.userIds,
		v33.totalConnections
	})

	local v34 = useCallback(function() -- line: 70
		-- upvalues: v20 (copy), v22 (copy), v21 (copy), v25 (copy), entityId (copy), entityType (copy), connectionType (copy), v26 (copy), v16 (copy), NetworkingSocialProof (copy), v30 (copy)
		if v20 or not v22 then
			return
		end

		v21(true)
		v25(nil)

		local t2 = {
			entityId = entityId,
			entityType = entityType,
			connectionType = connectionType,
			cursor = v26
		}

		v16(NetworkingSocialProof.GetConnectionsByEntityId.API(t2)):andThen(function() -- line: 86
			-- upvalues: v30 (copy), v21 (copy)
			if v30.current then
				v21(false)
			end
		end):catch(function(p3) -- line: 91
			-- upvalues: v30 (copy), v21 (copy), v25 (copy)
			if v30.current then
				v21(false)
				v25(p3)
			end
		end)
	end, {
		v26,
		v20,
		v22,
		entityId,
		entityType,
		connectionType,
		v16
	})
	local v35 = useCallback(function() -- line: 99
		-- upvalues: v29 (copy), v23 (copy), v21 (copy), v25 (copy)
		v29({})
		v23(true)
		v21(false)
		v25(nil)
	end, {})

	useEffect(function() -- line: 107
		-- upvalues: entityId (copy), entityType (copy), connectionType (copy), v33 (copy), v34 (copy)
		if entityId and (entityType and connectionType and not v33.userIds) then
			v34()
		end
	end, {
		entityId,
		entityType,
		connectionType,
		v33.userIds
	})

	return {
		userIds = v28,
		isLoading = v20,
		hasMore = v22,
		error = v24,
		fetchPage = v34,
		reset = v35,
		totalConnections = v31
	}
end
