require(script.sponsoredAdViewabilityRegistry)

local useSponsoredAdViewabilityDetector = require(script.useSponsoredAdViewabilityDetector)
local useTagAsSponsoredAdViewabilityCandidate = require(script.useTagAsSponsoredAdViewabilityCandidate)

return {
	useSponsoredAdViewabilityDetector = useSponsoredAdViewabilityDetector,
	useTagAsSponsoredAdViewabilityCandidate = useTagAsSponsoredAdViewabilityCandidate,
	["jest.config"] = script["jest.config"]
}
