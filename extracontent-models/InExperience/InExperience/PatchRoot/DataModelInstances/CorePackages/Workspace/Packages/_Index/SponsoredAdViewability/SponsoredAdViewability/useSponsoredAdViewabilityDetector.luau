local Parent = script:FindFirstAncestor("SponsoredAdViewability").Parent
local React = require(Parent.React)
local useViewportBounds = require(Parent.ViewportUtils).useViewportBounds
local SponsoredAdViewabilityDetector = require(script.Parent.SponsoredAdViewabilityDetector)
local sponsoredAdViewabilityTelemetry = require(script.Parent.sponsoredAdViewabilityTelemetry)

local function useSponsoredAdViewabilityDetector(p1, s1: string?, t1: {[any]: any}?) -- line: 16
	-- upvalues: useViewportBounds (copy), React (copy), SponsoredAdViewabilityDetector (copy), sponsoredAdViewabilityTelemetry (copy)
	local v10 = useViewportBounds()
	local v11 = React.useRef(nil)

	if v11.current == nil then
		v11.current = SponsoredAdViewabilityDetector.new({
			onSessionStart = sponsoredAdViewabilityTelemetry.logSponsoredAdLoad,
			onMilestone = sponsoredAdViewabilityTelemetry.logSponsoredAdViewableImpression,
			onUnload = sponsoredAdViewabilityTelemetry.logSponsoredAdUnload
		})
	end

	React.useEffect(function() -- line: 33
		-- upvalues: v11 (copy), v10 (copy)
		local current = v11.current

		if current ~= nil then
			current:setViewportBounds(v10)
		end
	end, { v10 })
	React.useEffect(function() -- line: 43
		-- upvalues: v11 (copy), p1 (copy)
		local current = v11.current

		if current == nil then
			return
		end

		current:setSurfaceScope(p1)

		if p1 == nil then
			return
		end

		current:start()

		return function() -- line: 56
			-- upvalues: current (copy)
			current:reset()
		end
	end, { p1 })
	React.useEffect(function() -- line: 61
		-- upvalues: t1 (copy), v11 (copy)
		if t1 == nil then
			return
		end

		local v15 = assert(v11.current, "detector must exist before effects run")
		local t2 = {
			t1.OnHide:Connect(function() -- line: 68
				-- upvalues: v15 (copy)
				v15:pause()
			end),
			t1.OnUnhide:Connect(function() -- line: 71
				-- upvalues: v15 (copy)
				v15:resume()
			end)
		}

		return function() -- line: 75
			-- upvalues: t2 (copy)
			for _, v20 in t2 do
				v20:Disconnect()
			end
		end
	end, { t1 })

	local v12 = React.useRef(s1)

	React.useEffect(function() -- line: 86
		-- upvalues: v11 (copy), v12 (copy), s1 (copy)
		local current = v11.current
		local current2 = v12.current

		v12.current = s1

		if current ~= nil and (current2 ~= nil and current2 ~= s1) then
			current:onFeedRefresh()
		end
	end, { s1 })
end

return useSponsoredAdViewabilityDetector
