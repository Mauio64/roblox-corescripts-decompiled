local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/deferred/gko")
local module2 = require("@luauforge/bundled/fve")

local v5 = { avatarScreen.SendGiftRecipientPicker, avatarScreen.SendGiftReview }

local function withGiftSendFlowAppRouterNavigation(p2)
	return function(p3)
		local navigation = p3.navigation
		local v6 = useDispatch()

		local v7 = React.useMemo(function()
			return {
				closeSendFlow = function()
					v6(module2(navigation, v5))
				end,
				goBack = function()
					v6(module(navigation))
				end
			}
		end, { v6, navigation })

		return React.createElement(p2, Cryo.Dictionary.join(p3, {
			navigationOverrides = v7
		}))
	end
end

return withGiftSendFlowAppRouterNavigation
