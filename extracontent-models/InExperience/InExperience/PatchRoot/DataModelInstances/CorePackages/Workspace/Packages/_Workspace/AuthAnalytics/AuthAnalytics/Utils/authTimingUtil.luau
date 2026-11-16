local HttpService = game:GetService("HttpService")

local guid = HttpService:GenerateGUID()
local landing_page_session = nil
local now = os.clock()
local function getLandingPageTiming() -- 1 equivalent call inferred from this helper
	local now2 = os.clock()

	if not landing_page_session then
		return nil
	end

	local duration = now2 - now
	return { app_session = guid, landing_page_session = landing_page_session, duration = duration }
end

local AuthTimingUtil = {}

function AuthTimingUtil.landingPageLoadStart()
	landing_page_session = HttpService:GenerateGUID()
	now = os.clock()
end

function AuthTimingUtil.landingPageLoadFinish()
	local landingPageTiming = getLandingPageTiming() -- inferred equivalent call
	landing_page_session = nil
	return landingPageTiming
end

return AuthTimingUtil
