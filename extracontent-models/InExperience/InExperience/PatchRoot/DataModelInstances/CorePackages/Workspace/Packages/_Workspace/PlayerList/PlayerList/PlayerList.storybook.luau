local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local ReactRoblox = require(parent2.ReactRoblox)
local Foundation = require(parent2.Foundation)

local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local FFlagPlayerListContrastingTeamText = require(parent.Flags.FFlagPlayerListContrastingTeamText)

local v = { Default = ColorMode.Dark, Light = ColorMode.Light, Dark = ColorMode.Dark }

return {
	name = "PlayerList",
	storyRoots = { parent },
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			local settings = p2.settings

			if not FFlagPlayerListContrastingTeamText then
				local UserGameSettings = UserSettings():GetService("UserGameSettings")
				local preferredTransparency

				if settings then
					preferredTransparency = settings.preferredTransparency
				else
					preferredTransparency = nil
				end

				React.useEffect(function()
					local preferredTransparency2 = UserGameSettings.PreferredTransparency
					return function()
						UserGameSettings.PreferredTransparency = preferredTransparency2
					end
				end, {})

				React.useEffect(function()
					if preferredTransparency == nil then
						return
					end

					UserGameSettings.PreferredTransparency = preferredTransparency
				end, { preferredTransparency })
			end

			local createElement = React.createElement
			local v2 = {
				colorMode = v[p2.theme] or ColorMode.Dark,
				preferences = settings,
				scale = 0
			}
			local scale

			if settings then
				scale = settings.scale
			end

			v2.scale = scale
			return createElement(FoundationProvider, v2, { Child = React.createElement(p, p2) })
		end
	end
}
