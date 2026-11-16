local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local GameDetail = require(parent.GameDetail)
local OpenGameDetails = GameDetail.OpenGameDetails

local ExperienceTile = require(ProfilePlatform.BaseComponents.Tiles.ExperienceTile)

require(ProfilePlatform.Common.Types)

local function useRenderExperienceTile(impressionsTag: string, value: string?, callback, showFooter: boolean?)
	local v = useDispatch()
	local v2 = useNavigation()

	local v3 = value or "ProfileExperienceTile_"
	local v4 = React.useCallback(function(p, p2, p3)
		return function()
			if callback then
				callback(p, p2, p3)
			end

			v(OpenGameDetails(p.experienceId, v2, { mountAsFullView = false, showBackButton = true }))
		end
	end, { callback, v, v2 })

	return (React.useCallback(function(p, p2: number, _, p3: number?)
		return React.createElement(ExperienceTile, {
			item = p,
			index = p2,
			onActivated = v4(p, p2, p3),
			impressionsTag = impressionsTag,
			showFooter = showFooter
		}), `{v3}{p.experienceId}_`
	end, { impressionsTag, v4, v3 }))
end

return useRenderExperienceTile
