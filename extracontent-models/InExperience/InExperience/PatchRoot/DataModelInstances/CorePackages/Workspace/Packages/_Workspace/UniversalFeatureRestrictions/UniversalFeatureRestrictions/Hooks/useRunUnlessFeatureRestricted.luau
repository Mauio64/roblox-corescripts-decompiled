local UniversalFeatureRestrictions = script:FindFirstAncestor("UniversalFeatureRestrictions")
local parent = UniversalFeatureRestrictions.Parent

local React = require(parent.React)

require(UniversalFeatureRestrictions.Common.AbuseVector)
local runUnlessFeatureRestricted = require(UniversalFeatureRestrictions.Utils.runUnlessFeatureRestricted)
require(UniversalFeatureRestrictions.Utils.showFeatureRestrictionDirect)

local function useRunUnlessFeatureRestricted(p)
	local state, setState = React.useState("Settled")
	local ref = React.useRef(false)
	local ref2 = React.useRef(true)

	React.useEffect(function()
		ref2.current = true
		return function()
			ref2.current = false
		end
	end, {})

	return React.useCallback(function(data)
		if ref.current then
			return
		end

		ref.current = true

		local onRestricted = data.onRestricted
		runUnlessFeatureRestricted(p, {
			onProceed = function(p2)
				if ref2.current then
					data.onProceed(p2)
				end
			end,
			onRestricted = function(p2)
				if ref2.current and onRestricted then
					onRestricted(p2)
				end
			end,
			dialogOptions = data.dialogOptions,
			timeoutSeconds = data.timeoutSeconds,
			onPhaseChanged = function(p2)
				if p2 == "Settled" then
					ref.current = false
				end

				if ref2.current then
					setState(p2)
				end
			end
		})
	end, { p }), state == "Checking" or state == "Acknowledging"
end

return useRunUnlessFeatureRestricted
