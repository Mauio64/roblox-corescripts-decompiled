local module = require("@luauforge/bundled/fzS")

local function reportSignUpClientError(p2, p3)
	local reportAuthClientError = p2.reportAuthClientError
	local singlePageSignUpScreen = module.Context.SinglePageSignUpScreen
	local v5 = if p3 == nil then module.State.Unknown else tostring(p3)
	reportAuthClientError(singlePageSignUpScreen, v5)
end

return reportSignUpClientError
