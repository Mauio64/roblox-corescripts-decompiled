local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local LoginStatus = require(CorePackages.Workspace.Packages.RobloxAppEnums).LoginStatus
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local CheckForVngAppUpsellForVnUsers = require(script.Parent.CheckForVngAppUpsellForVnUsers)

local function CheckForVngAppUpsell(_) -- line: 10
	-- upvalues: useSelector (copy), LoginStatus (copy), useAppPolicy (copy), React (copy), CheckForVngAppUpsellForVnUsers (copy)
	local v9 = useSelector(function(p2) -- line: 11
		-- upvalues: LoginStatus (copy)
		local CountryCode = p2.CountryCode

		return p2.AuthenticationStatus.status == LoginStatus.LOGGED_IN and CountryCode == "VN"
	end)
	local v10 = useAppPolicy(function(p3) -- line: 15
		return p3.getVngAppUpsell()
	end)

	if v9 and v10 then
		return React.createElement(CheckForVngAppUpsellForVnUsers)
	end

	return nil
end

return CheckForVngAppUpsell
