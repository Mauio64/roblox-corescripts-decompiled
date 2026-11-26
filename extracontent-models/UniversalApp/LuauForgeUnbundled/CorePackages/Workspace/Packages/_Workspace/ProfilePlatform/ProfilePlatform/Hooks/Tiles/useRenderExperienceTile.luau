local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useDispatch

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation
local openGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameDetail").OpenGameDetails

local ExperienceTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/BaseComponents/Tiles/ExperienceTile")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")

local function useRenderExperienceTile(p2, value, callback, p3)
	local v5 = useDispatch()
	local v6 = useNavigation()

	local v7 = value or "ProfileExperienceTile_"
	local v8 = React.useCallback(function(p4, p5, p6)
		return function()
			if callback then
				callback(p4, p5, p6)
			end

			v5(openGameDetails(p4.experienceId, v6, {
				mountAsFullView = false,
				showBackButton = true
			}))
		end
	end, { callback, v5, v6 })

	return (React.useCallback(function(p4, p5, p6, p7)
		return React.createElement(ExperienceTile, {
			item = p4,
			index = p5,
			onActivated = v8(p4, p5, p7),
			impressionsTag = p2,
			showFooter = p3
		}), `{v7}{p4.experienceId}_`
	end, { p2, v8, v7 }))
end

return useRenderExperienceTile
