local Parent = script:FindFirstAncestor("EngagementScreen").Parent
local React = require(Parent.React)
local AppStartup = require(Parent.AppStartup)
local useNavigation = require(Parent.Navigation).useNavigation
local navigateWithPlatformAccount = AppStartup.navigateWithPlatformAccount
local AppLogging = require(Parent.RoactServiceTags).AppLogging
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local Responsive = require(Parent.Responsive)
local BackgroundFill = require(Parent.AuthCommon).Components.BackgroundFill
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function useEngagementScreenProps(t1: {[any]: any}) -- line: 20
	-- upvalues: useNavigation (copy), useRoactService (copy), AppLogging (copy), React (copy), ThirdPartyUserService (copy), Responsive (copy), BackgroundFill (copy), navigateWithPlatformAccount (copy)
	local useSingleSignOn = t1.useSingleSignOn
	local allowPlatformAccountSwitching = t1.allowPlatformAccountSwitching
	local v15 = useNavigation()
	local v16 = useRoactService(AppLogging)
	local v17, v18 = React.useState(false)
	local v19 = nil

	if allowPlatformAccountSwitching then
		function v19() -- line: 29
			-- upvalues: ThirdPartyUserService (copy)
			if ThirdPartyUserService then
				ThirdPartyUserService:ShowAccountPicker()
			end
		end
	end

	local v20 = React.useCallback(function() -- line: 36
		-- upvalues: v18 (copy)
		v18(true)
	end, {})
	local v21 = Responsive.usePreferredInput()
	local v22 = React.useCallback(function() -- line: 41
		-- upvalues: React (copy), BackgroundFill (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Background = React.createElement(BackgroundFill, {
				Image = "rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg"
			})
		})
	end, {})
	local v23 = if v21 ~= Responsive.Input.Directional then v22 else nil

	React.useEffect(function() -- line: 56
		-- upvalues: v17 (copy), v16 (copy), ThirdPartyUserService (copy), navigateWithPlatformAccount (copy), useSingleSignOn (copy), v15 (copy), v18 (copy)
		if v17 then
			v16:logEventOnce("engagement_screen_did_continue")

			if ThirdPartyUserService then
				ThirdPartyUserService:RegisterActiveUser(Enum.UserInputType.Gamepad1)
			end

			navigateWithPlatformAccount(useSingleSignOn, v15.replace)
			v18(false)
		end
	end, {
		v17,
		v16,
		useSingleSignOn,
		v15.replace
	})

	return {
		onContinue = v20,
		onSwitchAccounts = v19,
		renderBackground = v23
	}
end

return useEngagementScreenProps
