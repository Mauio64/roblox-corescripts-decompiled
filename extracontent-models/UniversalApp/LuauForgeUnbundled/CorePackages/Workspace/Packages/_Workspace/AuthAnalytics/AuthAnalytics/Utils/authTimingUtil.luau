local HttpService = game:GetService("HttpService")

local guid = HttpService:GenerateGUID()
local v5 = nil
local now = os.clock()
local function getLandingPageTiming()
	local now2 = os.clock()

	if not v5 then
		return nil
	end

	local v6 = now2 - now
	return { app_session = guid, landing_page_session = v5, duration = v6 }
end

return {
	landingPageLoadStart = function()
		v5 = HttpService:GenerateGUID()
		now = os.clock()
	end,
	landingPageLoadFinish = function()
		local now2 = os.clock()
		local v6

		if v5 then
			local v7 = now2 - now
			v6 = { app_session = guid, landing_page_session = v5, duration = v7 }
		end

		v5 = nil
		return v6
	end
}
