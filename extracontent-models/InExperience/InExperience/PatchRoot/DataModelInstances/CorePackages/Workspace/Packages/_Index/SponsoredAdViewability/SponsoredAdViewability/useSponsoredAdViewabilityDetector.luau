local Parent = script:FindFirstAncestor("SponsoredAdViewability").Parent
local React = require(Parent.React)
local useViewportBounds = require(Parent.ViewportUtils).useViewportBounds
local SponsoredAdViewabilityDetector = require(script.Parent.SponsoredAdViewabilityDetector)
local sponsoredAdViewabilityTelemetry = require(script.Parent.sponsoredAdViewabilityTelemetry)

local function useSponsoredAdViewabilityDetector(p1) -- line: 12
	-- upvalues: useViewportBounds (copy), React (copy), SponsoredAdViewabilityDetector (copy), sponsoredAdViewabilityTelemetry (copy)
	local v8 = useViewportBounds()
	local v9 = React.useRef(nil)

	if v9.current == nil then
		v9.current = SponsoredAdViewabilityDetector.new({
			onSessionStart = sponsoredAdViewabilityTelemetry.logSponsoredAdLoad,
			onMilestone = sponsoredAdViewabilityTelemetry.logSponsoredAdViewableImpression
		})
	end

	React.useEffect(function() -- line: 24
		-- upvalues: v9 (copy), v8 (copy)
		local current = v9.current

		if current ~= nil then
			current:setViewportBounds(v8)
		end
	end, { v8 })
	React.useEffect(function() -- line: 34
		-- upvalues: v9 (copy), p1 (copy)
		local current = v9.current

		if current == nil then
			return
		end

		current:setSurfaceScope(p1)

		if p1 == nil then
			return
		end

		current:start()

		return function() -- line: 47
			-- upvalues: current (copy)
			current:reset()
		end
	end, { p1 })
end

return useSponsoredAdViewabilityDetector
