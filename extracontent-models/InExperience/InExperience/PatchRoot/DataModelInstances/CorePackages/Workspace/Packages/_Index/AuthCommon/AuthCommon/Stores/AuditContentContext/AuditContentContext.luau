local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local React = require(parent.React)

local Cryo = require(parent.Cryo)

local GetFFlagEnableAuditSystem = require(AuthCommon.Flags.GetFFlagEnableAuditSystem)

local useState = React.useState
local useMemo = React.useMemo
local useContext = React.useContext
local useCallback = React.useCallback
local useEffect = React.useEffect

local context = React.createContext({
	capturedAuditContent = {},
	additionalAuditContent = {},
	setCapturedAuditContentItem = function() end,
	removeCapturedAuditContentItem = function() end,
	setAdditionalAuditContentItem = function() end,
	removeAdditionalAuditContentItem = function() end
})

local function AuditContentProvider(p)
	local state, setState = useState({})
	local state2, setState2 = useState({})

	local setCapturedAuditContentItem = useCallback(function(p2: string, p3)
		setState(function(p4)
			return (Cryo.Dictionary.join(p4, { [p2] = p3 }))
		end)
	end, { setState })

	local removeCapturedAuditContentItem = useCallback(function(p2: string)
		setState(function(p3)
			return (Cryo.Dictionary.join(p3, { [p2] = Cryo.None }))
		end)
	end, { setState })

	local setAdditionalAuditContentItem = useCallback(function(p2: string, p3: string)
		setState2(function(p4)
			return Cryo.Dictionary.join(p4, { [p2] = p3 })
		end)
	end, { setState2 })

	local removeAdditionalAuditContentItem = useCallback(function(p2: string)
		setState2(function(p3)
			return Cryo.Dictionary.join(p3, { [p2] = Cryo.None })
		end)
	end, { setState2 })

	local v = useMemo(function()
		return {
			capturedAuditContent = state,
			additionalAuditContent = state2,
			setCapturedAuditContentItem = setCapturedAuditContentItem,
			removeCapturedAuditContentItem = removeCapturedAuditContentItem,
			setAdditionalAuditContentItem = setAdditionalAuditContentItem,
			removeAdditionalAuditContentItem = removeAdditionalAuditContentItem
		}
	end, { state, state2 })

	return React.createElement(context.Provider, { value = v }, p.children)
end

local AuditContentContext = {}
AuditContentContext.Context = context
AuditContentContext.Provider = AuditContentProvider

function AuditContentContext.useCapturedAuditContent(p: string?, p2)
	local v = useContext(context)

	useEffect(function()
		if not GetFFlagEnableAuditSystem() then
			return
		end

		if p and p2 then
			v.setCapturedAuditContentItem(p, p2)
		end
	end, { p, p2 })

	useEffect(function()
		return function()
			if not GetFFlagEnableAuditSystem() then
				return
			end

			if p then
				v.removeCapturedAuditContentItem(p)
			end
		end
	end, { p })
end

function AuditContentContext.useAdditionalAuditContent(p: string?, p2: string?)
	local v = useContext(context)

	useEffect(function()
		if not GetFFlagEnableAuditSystem() then
			return
		end

		if p and p2 then
			v.setAdditionalAuditContentItem(p, p2)
		end
	end, { p, p2 })

	useEffect(function()
		return function()
			if not GetFFlagEnableAuditSystem() then
				return
			end

			if p then
				v.removeAdditionalAuditContentItem(p)
			end
		end
	end, { p })
end

function AuditContentContext.useAuditContentContext()
	local v = useContext(context)

	return {
		capturedAuditContent = v.capturedAuditContent,
		additionalAuditContent = v.additionalAuditContent,
		setCapturedAuditContentItem = v.setCapturedAuditContentItem,
		removeCapturedAuditContentItem = v.removeCapturedAuditContentItem,
		setAdditionalAuditContentItem = v.setAdditionalAuditContentItem,
		removeAdditionalAuditContentItem = v.removeAdditionalAuditContentItem
	}
end

return AuditContentContext
