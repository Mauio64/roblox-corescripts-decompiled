local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local useNineDotActivityIndicator = require(Chrome.ChromeShared.Hooks.useNineDotActivityIndicator)

local submitFreeTrialBlueDot = require(CorePackages.Workspace.Packages.InExperienceShop.submitFreeTrialBlueDot)

local function useFreeTrialNineDotActivityIndicator()
	local v = SignalsReact.useSignalState(submitFreeTrialBlueDot.isHamburgerBlueDotShowing)

	useNineDotActivityIndicator("free_trial_blue_dot", v == true)

	React.useEffect(function()
		if v ~= true then
			return
		end

		submitFreeTrialBlueDot.reportMounted()
		submitFreeTrialBlueDot.reportViewed()
	end, { v })
end

return useFreeTrialNineDotActivityIndicator
