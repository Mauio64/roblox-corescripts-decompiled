local parent = script:FindFirstAncestor("SponsoredAdViewability").Parent

local React = require(parent.React)
local ViewportUtils = require(parent.ViewportUtils)
local useViewportBounds = ViewportUtils.useViewportBounds

local SponsoredAdViewabilityDetector = require(script.Parent.SponsoredAdViewabilityDetector)
local sponsoredAdViewabilityTelemetry = require(script.Parent.sponsoredAdViewabilityTelemetry)

local function useSponsoredAdViewabilityDetector(p, current: string?, p2)
	local v = useViewportBounds()

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
			current2:setViewportBounds(v)
		end
	end, { v })

	React.useEffect(function()
		local current2 = ref.current

		if current2 == nil then
			return
		end

		current2:setSurfaceScope(p)

		if p == nil then
			return
		end

		current2:start()

		return function()
			current2:reset()
		end
	end, { p })

	React.useEffect(function()
		if p2 == nil then
			return
		end

		local current2 = ref.current

		if current2 == nil then
			return
		end

		local v2 = {
			p2.OnHide:Connect(function()
				current2:pause()
			end),
			p2.OnUnhide:Connect(function()
				current2:resume()
			end)
		}

		return function()
			for _, connection in v2 do
				connection:Disconnect()
			end
		end
	end, { p2 })

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
