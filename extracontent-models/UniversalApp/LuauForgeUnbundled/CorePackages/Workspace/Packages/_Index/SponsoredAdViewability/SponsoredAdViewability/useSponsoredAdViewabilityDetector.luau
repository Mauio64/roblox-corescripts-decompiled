local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredAdViewability/React")
local useViewportBounds = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredAdViewability/ViewportUtils").useViewportBounds

local SponsoredAdViewabilityDetector = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/SponsoredAdViewabilityDetector")
local sponsoredAdViewabilityTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityTelemetry")

local function useSponsoredAdViewabilityDetector(p2, current, p3)
	local v5 = useViewportBounds()

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = SponsoredAdViewabilityDetector.new({
			onSessionStart = sponsoredAdViewabilityTelemetry.logSponsoredAdLoad,
			onMilestone = sponsoredAdViewabilityTelemetry.logSponsoredAdViewableImpression,
			onVideoProgress = sponsoredAdViewabilityTelemetry.logSponsoredAdVideoProgress,
			onUnload = sponsoredAdViewabilityTelemetry.logSponsoredAdUnload
		})
	end

	React.useEffect(function()
		local current2 = ref.current

		if current2 ~= nil then
			current2:setViewportBounds(v5)
		end
	end, { v5 })

	React.useEffect(function()
		local current2 = ref.current

		if current2 == nil then
			return
		end

		current2:setSurfaceScope(p2)

		if p2 == nil then
			return
		end

		current2:start()

		return function()
			current2:reset()
		end
	end, { p2 })

	React.useEffect(function()
		if p3 == nil then
			return
		end

		local current2 = ref.current

		if current2 == nil then
			return
		end

		local v6 = {
			p3.OnHide:Connect(function()
				current2:pause()
			end),
			p3.OnUnhide:Connect(function()
				current2:resume()
			end)
		}

		return function()
			for k, connection in v6 do
				connection:Disconnect()
			end
		end
	end, { p3 })

	local ref2 = React.useRef(current)
	React.useEffect(function()
		local current2 = ref.current
		local current3 = ref2.current
		ref2.current = current

		if current2 ~= nil and current3 ~= nil and current3 ~= current then
			current2:onFeedRefresh()
		end
	end, { current })
end

return useSponsoredAdViewabilityDetector
