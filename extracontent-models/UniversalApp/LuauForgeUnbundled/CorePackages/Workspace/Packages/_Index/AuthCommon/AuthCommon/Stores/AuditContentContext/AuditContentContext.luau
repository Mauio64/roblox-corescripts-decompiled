local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")

local GetFFlagEnableAuditSystem = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/GetFFlagEnableAuditSystem")

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

local function AuditContentProvider(p2)
	local state, setState = useState({})
	local state2, setState2 = useState({})

	local v5 = useCallback(function(p3, p4)
		setState(function(p5)
			return (Cryo.Dictionary.join(p5, { [p3] = p4 }))
		end)
	end, { setState })

	local v6 = useCallback(function(p3)
		setState(function(p4)
			return (Cryo.Dictionary.join(p4, { [p3] = Cryo.None }))
		end)
	end, { setState })

	local v7 = useCallback(function(p3, p4)
		setState2(function(p5)
			return Cryo.Dictionary.join(p5, { [p3] = p4 })
		end)
	end, { setState2 })

	local v8 = useCallback(function(p3)
		setState2(function(p4)
			return Cryo.Dictionary.join(p4, { [p3] = Cryo.None })
		end)
	end, { setState2 })

	local v9 = useMemo(function()
		return {
			capturedAuditContent = state,
			additionalAuditContent = state2,
			setCapturedAuditContentItem = v5,
			removeCapturedAuditContentItem = v6,
			setAdditionalAuditContentItem = v7,
			removeAdditionalAuditContentItem = v8
		}
	end, { state, state2 })

	return React.createElement(context.Provider, { value = v9 }, p2.children)
end

return {
	Context = context,
	Provider = AuditContentProvider,
	useCapturedAuditContent = function(p2, p3)
		local v5 = useContext(context)

		useEffect(function()
			if not GetFFlagEnableAuditSystem() then
				return
			end

			if p2 and p3 then
				v5.setCapturedAuditContentItem(p2, p3)
			end
		end, { p2, p3 })

		useEffect(function()
			return function()
				if not GetFFlagEnableAuditSystem() then
					return
				end

				if p2 then
					v5.removeCapturedAuditContentItem(p2)
				end
			end
		end, { p2 })
	end,
	useAdditionalAuditContent = function(p2, p3)
		local v5 = useContext(context)

		useEffect(function()
			if not GetFFlagEnableAuditSystem() then
				return
			end

			if p2 and p3 then
				v5.setAdditionalAuditContentItem(p2, p3)
			end
		end, { p2, p3 })

		useEffect(function()
			return function()
				if not GetFFlagEnableAuditSystem() then
					return
				end

				if p2 then
					v5.removeAdditionalAuditContentItem(p2)
				end
			end
		end, { p2 })
	end,
	useAuditContentContext = function()
		local v5 = useContext(context)

		return {
			capturedAuditContent = v5.capturedAuditContent,
			additionalAuditContent = v5.additionalAuditContent,
			setCapturedAuditContentItem = v5.setCapturedAuditContentItem,
			removeCapturedAuditContentItem = v5.removeCapturedAuditContentItem,
			setAdditionalAuditContentItem = v5.setAdditionalAuditContentItem,
			removeAdditionalAuditContentItem = v5.removeAdditionalAuditContentItem
		}
	end
}
