local Parent = script:FindFirstAncestor("SponsoredAdViewability").Parent
local React = require(Parent.React)
local useViewportBounds = require(Parent.ViewportUtils).useViewportBounds
local SponsoredAdViewabilityDetector = require(script.Parent.SponsoredAdViewabilityDetector)
local sponsoredAdViewabilityTelemetry = require(script.Parent.sponsoredAdViewabilityTelemetry)

local function useSponsoredAdViewabilityDetector(p1, s1: string?) -- line: 12
	-- upvalues: useViewportBounds (copy), React (copy), SponsoredAdViewabilityDetector (copy), sponsoredAdViewabilityTelemetry (copy)
	local v9 = useViewportBounds()
	local v10 = React.useRef(nil)

	if v10.current == nil then
		v10.current = SponsoredAdViewabilityDetector.new({
			onSessionStart = sponsoredAdViewabilityTelemetry.logSponsoredAdLoad,
			onMilestone = sponsoredAdViewabilityTelemetry.logSponsoredAdViewableImpression,
			onUnload = sponsoredAdViewabilityTelemetry.logSponsoredAdUnload
		})
	end

	React.useEffect(function() -- line: 25
		-- upvalues: v10 (copy), v9 (copy)
		local current = v10.current

		if current ~= nil then
			current:setViewportBounds(v9)
		end
	end, { v9 })
	React.useEffect(function() -- line: 35
		-- upvalues: v10 (copy), p1 (copy)
		local current = v10.current

		if current == nil then
			return
		end

		current:setSurfaceScope(p1)

		if p1 == nil then
			return
		end

		current:start()

		return function() -- line: 48
			-- upvalues: current (copy)
			current:reset()
		end
	end, { p1 })

	local v11 = React.useRef(s1)

	React.useEffect(function() -- line: 57
		-- upvalues: v10 (copy), v11 (copy), s1 (copy)
		local current = v10.current
		local current2 = v11.current

		v11.current = s1

		if current ~= nil and (current2 ~= nil and current2 ~= s1) then
			current:onFeedRefresh()
		end
	end, { s1 })
end

return useSponsoredAdViewabilityDetector
