local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local addUnifiedEventLogging = require(script.Parent.addUnifiedEventLogging)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)

local function useUnifiedEventTagging(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), Cryo (copy), UnifiedEventLogConstants (copy), addUnifiedEventLogging (copy)
	local v8 = React.useMemo(function() -- line: 29
		-- upvalues: Cryo (copy), UnifiedEventLogConstants (copy), t1 (copy)
		return Cryo.Dictionary.join({
			hasDeferredActions = true,
			sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
		}, t1.options or {})
	end, { t1.options })

	React.useEffect(function() -- line: 36
		-- upvalues: t1 (copy), addUnifiedEventLogging (copy), v8 (copy)
		if t1.isReady == false then
			return
		end

		addUnifiedEventLogging(t1.ref, t1.payload, v8)
	end, {
		t1.ref,
		t1.payload,
		t1.isReady,
		v8
	})
end

return useUnifiedEventTagging
