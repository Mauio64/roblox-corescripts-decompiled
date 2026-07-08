local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local React = require(AuthCommonParent.React)
local Cryo = require(AuthCommonParent.Cryo)
local GetFFlagEnableAuditSystem = require(AuthCommon.Flags.GetFFlagEnableAuditSystem)
local useState = React.useState
local useMemo = React.useMemo
local useContext = React.useContext
local useCallback = React.useCallback
local useEffect = React.useEffect
local v11 = React.createContext({
	capturedAuditContent = {},
	additionalAuditContent = {},
	setCapturedAuditContentItem = function() -- line: 49
	end,
	removeCapturedAuditContentItem = function() -- line: 50
	end,
	setAdditionalAuditContentItem = function() -- line: 51
	end,
	removeAdditionalAuditContentItem = function() -- line: 52
	end
})

local function AuditContentProvider(t1: {[any]: any}) -- line: 58
	-- upvalues: useState (copy), useCallback (copy), Cryo (copy), useMemo (copy), React (copy), v11 (copy)
	local v14, v15 = useState({})
	local v16, v17 = useState({})
	local v18 = useCallback(function(s1: string, t2: {[any]: any}) -- line: 62
		-- upvalues: v15 (copy), Cryo (copy)
		v15(function(p1) -- line: 63
			-- upvalues: Cryo (copy), s1 (copy), t2 (copy)
			return (Cryo.Dictionary.join(p1, {
				[s1] = t2
			}))
		end)
	end, { v15 })
	local v19 = useCallback(function(s2: string) -- line: 71
		-- upvalues: v15 (copy), Cryo (copy)
		v15(function(p2) -- line: 72
			-- upvalues: Cryo (copy), s2 (copy)
			return (Cryo.Dictionary.join(p2, {
				[s2] = Cryo.None
			}))
		end)
	end, { v15 })
	local v20 = useCallback(function(s3: string, s4: string) -- line: 80
		-- upvalues: v17 (copy), Cryo (copy)
		v17(function(p3) -- line: 81
			-- upvalues: Cryo (copy), s3 (copy), s4 (copy)
			return Cryo.Dictionary.join(p3, {
				[s3] = s4
			})
		end)
	end, { v17 })
	local v21 = useCallback(function(s5: string) -- line: 88
		-- upvalues: v17 (copy), Cryo (copy)
		v17(function(p4) -- line: 89
			-- upvalues: Cryo (copy), s5 (copy)
			return Cryo.Dictionary.join(p4, {
				[s5] = Cryo.None
			})
		end)
	end, { v17 })
	local v22 = useMemo(function() -- line: 96
		-- upvalues: v14 (copy), v16 (copy), v18 (copy), v19 (copy), v20 (copy), v21 (copy)
		return {
			capturedAuditContent = v14,
			additionalAuditContent = v16,
			setCapturedAuditContentItem = v18,
			removeCapturedAuditContentItem = v19,
			setAdditionalAuditContentItem = v20,
			removeAdditionalAuditContentItem = v21
		}
	end, {
		v14,
		v16
	})

	return React.createElement(v11.Provider, {
		value = v22
	}, t1.children)
end

return {
	Context = v11,
	Provider = AuditContentProvider,
	useCapturedAuditContent = function(s6: string?, t3: {[any]: any}?) -- line: 119
		-- upvalues: useContext (copy), v11 (copy), useEffect (copy), GetFFlagEnableAuditSystem (copy)
		local v25 = useContext(v11)

		useEffect(function() -- line: 123
			-- upvalues: GetFFlagEnableAuditSystem (copy), s6 (copy), t3 (copy), v25 (copy)
			if not GetFFlagEnableAuditSystem() then
				return
			end

			if not s6 or not t3 then
				return
			end

			v25.setCapturedAuditContentItem(s6, t3)
		end, {
			s6,
			t3
		})
		useEffect(function() -- line: 136
			-- upvalues: GetFFlagEnableAuditSystem (copy), s6 (copy), v25 (copy)
			return function() -- line: 137
				-- upvalues: GetFFlagEnableAuditSystem (copy), s6 (copy), v25 (copy)
				if not GetFFlagEnableAuditSystem() then
					return
				end

				if s6 then
					v25.removeCapturedAuditContentItem(s6)
				end
			end
		end, { s6 })
	end,
	useAdditionalAuditContent = function(s7: string?, s8: string?) -- line: 156
		-- upvalues: useContext (copy), v11 (copy), useEffect (copy), GetFFlagEnableAuditSystem (copy)
		local v28 = useContext(v11)

		useEffect(function() -- line: 160
			-- upvalues: GetFFlagEnableAuditSystem (copy), s7 (copy), s8 (copy), v28 (copy)
			if not GetFFlagEnableAuditSystem() then
				return
			end

			if not s7 or not s8 then
				return
			end

			v28.setAdditionalAuditContentItem(s7, s8)
		end, {
			s7,
			s8
		})
		useEffect(function() -- line: 173
			-- upvalues: GetFFlagEnableAuditSystem (copy), s7 (copy), v28 (copy)
			return function() -- line: 174
				-- upvalues: GetFFlagEnableAuditSystem (copy), s7 (copy), v28 (copy)
				if not GetFFlagEnableAuditSystem() then
					return
				end

				if s7 then
					v28.removeAdditionalAuditContentItem(s7)
				end
			end
		end, { s7 })
	end,
	useAuditContentContext = function() -- line: 189
		-- upvalues: useContext (copy), v11 (copy)
		local v29 = useContext(v11)

		return {
			capturedAuditContent = v29.capturedAuditContent,
			additionalAuditContent = v29.additionalAuditContent,
			setCapturedAuditContentItem = v29.setCapturedAuditContentItem,
			removeCapturedAuditContentItem = v29.removeCapturedAuditContentItem,
			setAdditionalAuditContentItem = v29.setAdditionalAuditContentItem,
			removeAdditionalAuditContentItem = v29.removeAdditionalAuditContentItem
		}
	end
}
