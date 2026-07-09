local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)

require(Parent.UnifiedLogging)

local SduiCollectionAnalyticsBuilder = require(Parent.SduiCoreSystem).SduiCollectionAnalyticsBuilder
local t1 = {}

local function useCollectionAnalyticsContext(p1, p2, n1: number, n2: number, p3, n3: number?, b1: boolean?) -- line: 20
	-- upvalues: React (copy), SduiCollectionAnalyticsBuilder (copy), Cryo (copy), t1 (copy)
	local v14 = React.useRef(nil)

	v14.current = React.useMemo(function() -- line: 36
		-- upvalues: p2 (copy), SduiCollectionAnalyticsBuilder (copy), p3 (copy), p1 (copy), n1 (copy), n2 (copy), n3 (copy)
		local v15 = p2

		return SduiCollectionAnalyticsBuilder.buildAndValidateCollectionAnalyticsData(p3, p1.ancestorAnalyticsData, p1.analyticsData, p2, n1, n2, nil, v15, n3)
	end, {
		p3,
		p1,
		n1,
		n2,
		p2,
		n3
	})

	return React.useMemo(function() -- line: 62
		-- upvalues: v14 (copy), p1 (copy), b1 (copy), Cryo (copy), t1 (copy)
		local function v16() -- line: 63
			-- upvalues: v14 (copy)
			return v14.current
		end

		if p1 and b1 then
			p1.getCollectionData = v16
		end

		return Cryo.Dictionary.join(p1 or t1, {
			getCollectionData = v16
		})
	end, {
		v14,
		p1,
		b1
	}), v14
end

return useCollectionAnalyticsContext
