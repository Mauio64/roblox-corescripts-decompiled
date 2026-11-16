local CoreGui = game:GetService("CoreGui")
local menuButtons = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("Settings"):WaitForChild("Components"):WaitForChild("MenuButtons")

local parent = script:FindFirstAncestor("PeopleReactView").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local PeopleService = require(parent.PeopleService)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View

local useSignalState = SignalsReact.useSignalState

local MenuButtons = require(menuButtons:WaitForChild("MenuButtons"))

return function()
	local v = React.useMemo(function()
		return PeopleService.getService("SettingsHubService")
	end, {})

	local v2 = useSignalState(v.showMenuButtonsContainer)

	local v3 = React.useMemo(function()
		local hubRef = v.hubRef()

		if hubRef then
			return hubRef:GetExperienceControlStore()
		end

		return nil
	end, {})

	if v3 and v2 then
		return React.createElement(View, { LayoutOrder = -1, tag = "size-full-1000" }, {
			MenuButtonsContainer = React.createElement(MenuButtons, {
				onLeaveGame = v3.onLeaveGame,
				onRespawn = v3.onRespawn,
				onResume = v3.onResume,
				setAddMenuKeyBindings = function() end,
				setRemoveMenuKeyBindings = function() end,
				getVisibility = function(): boolean
					return true
				end,
				getCanRespawn = v3.getCanRespawn
			})
		})
	end

	return nil
end
