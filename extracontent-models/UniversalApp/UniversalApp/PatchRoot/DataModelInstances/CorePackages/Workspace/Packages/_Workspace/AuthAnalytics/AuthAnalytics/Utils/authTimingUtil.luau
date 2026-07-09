local HttpService = game:GetService("HttpService")
local guid = HttpService:GenerateGUID()
local guid2 = nil
local elapsed = os.clock()

local function getLandingPageTiming() -- line: 12
	-- upvalues: guid2 (ref), elapsed (ref), guid (copy)
	local elapsed2 = os.clock()

	if not guid2 then
		return nil
	end

	local v7 = elapsed2 - elapsed

	return {
		app_session = guid,
		landing_page_session = guid2,
		duration = v7
	}
end

return {
	landingPageLoadStart = function() -- line: 32
		-- upvalues: guid2 (ref), HttpService (copy), elapsed (ref)
		guid2 = HttpService:GenerateGUID()
		elapsed = os.clock()
	end,
	landingPageLoadFinish = function() -- line: 41
		-- upvalues: guid2 (ref), elapsed (ref), guid (copy)
		local elapsed3 = os.clock()
		local v9

		if not guid2 then
			v9 = nil
		else
			local v10 = elapsed3 - elapsed

			v9 = {
				app_session = guid,
				landing_page_session = guid2,
				duration = v10
			}
		end

		guid2 = nil

		return v9
	end
}
