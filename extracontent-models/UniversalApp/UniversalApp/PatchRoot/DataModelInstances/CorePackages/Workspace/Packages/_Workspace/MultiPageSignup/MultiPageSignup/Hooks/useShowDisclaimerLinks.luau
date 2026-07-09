local Parent = script:FindFirstAncestor("MultiPageSignup").Parent
local React = require(Parent.React)
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local UserActivationFramework = require(Parent.UserActivationFramework)
local PayloadKey = UserActivationFramework.Enums.PayloadKey
local UserActivationSignupPageState = UserActivationFramework.Enums.UserActivationSignupPageState
local FullPageActivationFrameworkContext = UserActivationFramework.Context.FullPageActivationFrameworkContext

local function useShowDisclaimerLinks() -- line: 10
	-- upvalues: useAppPolicy (copy), React (copy), FullPageActivationFrameworkContext (copy), PayloadKey (copy), UserActivationSignupPageState (copy)
	local v9 = useAppPolicy(function(p1) -- line: 11
		return p1
	end)
	local v10 = v9.getShowDisclaimerLinkForUnderageSignupsOnAllSignupPages()
	local v11 = v9.getAgeCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages()
	local v12 = React.useContext(FullPageActivationFrameworkContext)

	return React.useMemo(function() -- line: 20
		-- upvalues: v12 (copy), PayloadKey (copy), v11 (copy), UserActivationSignupPageState (copy), v10 (copy)
		local activationFrameworkState = v12.activationFrameworkState
		local v15 = (tonumber(activationFrameworkState.payloadTable[PayloadKey.SignupAge]) or -1) < v11

		if activationFrameworkState.currentState == UserActivationSignupPageState.EnterBirthday then
			return true
		end

		if v15 and v10 then
			return true
		end

		return false
	end, {
		v12,
		v10
	})
end

return useShowDisclaimerLinks
