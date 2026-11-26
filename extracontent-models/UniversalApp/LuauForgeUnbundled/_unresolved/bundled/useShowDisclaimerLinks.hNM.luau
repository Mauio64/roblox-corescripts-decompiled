local module = require("@luauforge/bundled/hNw")
local useAppPolicy = require("@luauforge/bundled/hNN").useAppPolicy
local module2 = require("@luauforge/bundled/hMJ")
local payloadKey = module2.Enums.PayloadKey
local userActivationSignupPageState = module2.Enums.UserActivationSignupPageState
local fullPageActivationFrameworkContext = module2.Context.FullPageActivationFrameworkContext

local function useShowDisclaimerLinks()
	local v5 = useAppPolicy(function(p2)
		return p2
	end)

	local showDisclaimerLinkForUnderageSignupsOnAllSignupPages = v5.getShowDisclaimerLinkForUnderageSignupsOnAllSignupPages()
	local ageCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages = v5.getAgeCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages()
	local v6 = module.useContext(fullPageActivationFrameworkContext)

	return module.useMemo(function(): boolean
		local activationFrameworkState = v6.activationFrameworkState
		local v7 = (tonumber(activationFrameworkState.payloadTable[payloadKey.SignupAge]) or -1) < ageCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages

		if
			activationFrameworkState.currentState == userActivationSignupPageState.EnterBirthday
			or v7 and showDisclaimerLinkForUnderageSignupsOnAllSignupPages
		then
			return true
		end

		return false
	end, { v6, showDisclaimerLinkForUnderageSignupsOnAllSignupPages })
end

return useShowDisclaimerLinks
