local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local fetchInternal = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Api/fetchInternal")
local getEmoteRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/getEmoteRecommendations")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")

local function useRecommendedEmotes()
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(false)

	React.useEffect(function()
		local flag = false
		fetchInternal(getEmoteRecommendations.getEmoteRecommendationsUrl(), Enums.RequestMethods.GET):andThen(function(p2)
			if flag then
				return
			end

			setState(getEmoteRecommendations.parseEmoteRecommendationsResponse(p2.responseBody))
			setState2(false)
		end):catch(function()
			if flag then
				return
			end

			setState3(true)
			setState2(false)
		end)

		return function()
			flag = true
		end
	end, {})

	return { recommendedEmotes = state, isLoading = state2, hasError = state3 }
end

return useRecommendedEmotes
