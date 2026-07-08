local MenuButtons = game:GetService("CoreGui"):WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("Settings"):WaitForChild("Components"):WaitForChild("MenuButtons")
local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local PeopleService = require(Parent.PeopleService)
local SignalsReact = require(Parent.SignalsReact)
local View = Foundation.View
local useSignalState = SignalsReact.useSignalState
local MenuButtons2 = require(MenuButtons:WaitForChild("MenuButtons"))

return function() -- line: 27
	-- upvalues: React (copy), PeopleService (copy), useSignalState (copy), View (copy), MenuButtons2 (copy)
	local v10 = React.useMemo(function() -- line: 28
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("SettingsHubService")
	end, {})
	local v11 = useSignalState(v10.showMenuButtonsContainer)
	local v12 = React.useMemo(function() -- line: 34
		-- upvalues: v10 (copy)
		local v13 = v10.hubRef()

		if v13 then
			return v13:GetExperienceControlStore()
		end

		return nil
	end, {})

	if not v12 or not v11 then
		return nil
	end

	return React.createElement(View, {
		LayoutOrder = -1,
		tag = "size-full-1000"
	}, {
		MenuButtonsContainer = React.createElement(MenuButtons2, {
			onLeaveGame = v12.onLeaveGame,
			onRespawn = v12.onRespawn,
			onResume = v12.onResume,
			setAddMenuKeyBindings = function() -- line: 54
			end,
			setRemoveMenuKeyBindings = function() -- line: 55
			end,
			getVisibility = function() -- line: 56
				return true
			end,
			getCanRespawn = v12.getCanRespawn
		})
	})
end
