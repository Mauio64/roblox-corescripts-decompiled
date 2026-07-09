local Songbird = script:FindFirstAncestor("Songbird")
local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local useState = React.useState
local useCallback = React.useCallback
local v6 = React.createContext(nil)

local function noOp() -- line: 32
end

local t1 = {
	value = {
		assetId = nil,
		isVisible = false,
		hasThumbnail = false,
		setVisibility = noOp,
		setAssetId = noOp,
		setHasThumbnail = noOp
	}
}

return {
	Context = v6,
	Provider = function(t2: {[any]: any}) -- line: 47
		-- upvalues: Cryo (copy), t1 (copy), useState (copy), useCallback (copy), React (copy), v6 (copy)
		local v10 = Cryo.Dictionary.join(t1, t2)
		local isVisible = v10.value.isVisible
		local v12, v13 = useState(isVisible)
		local v14 = useCallback(function(b1: boolean) -- line: 53
			-- upvalues: v13 (copy)
			v13(function(p1) -- line: 54
				-- upvalues: b1 (copy)
				if p1 ~= b1 then
					return b1
				end

				return p1
			end)
		end, {})
		local v15, v16 = useState(nil)
		local v17 = useCallback(function(n1: number?) -- line: 63
			-- upvalues: v16 (copy)
			v16(function(p2) -- line: 64
				-- upvalues: n1 (copy)
				if p2 ~= n1 then
					return n1
				end

				return p2
			end)
		end, {})
		local v18, v19 = useState(v10.value.hasThumbnail or false)
		local v20 = useCallback(function(b2: boolean) -- line: 73
			-- upvalues: v19 (copy)
			v19(function(p3) -- line: 74
				-- upvalues: b2 (copy)
				if p3 ~= b2 then
					return b2
				end

				return p3
			end)
		end, {})

		return React.createElement(v6.Provider, {
			value = {
				isVisible = v12,
				setVisibility = v14,
				assetId = v15,
				setAssetId = v17,
				hasThumbnail = v18,
				setHasThumbnail = v20
			}
		}, v10.children)
	end,
	use = function() -- line: 94
		-- upvalues: React (copy), v6 (copy)
		local v21 = React.useContext(v6)

		if v21 then
			return v21
		end

		error("attempt to use ReportAudioPopupContext with no provider. Add `ReportAudioPopupContext.Provider` to the React tree and try again")
	end
}
