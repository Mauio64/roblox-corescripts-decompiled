local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local React = require(parent.React)
local fetchInternal = require(AvatarExperienceProfilePictureEditor.Api.fetchInternal)
local getEmoteRecommendations = require(AvatarExperienceProfilePictureEditor.Shared.getEmoteRecommendations)
local Enums = require(AvatarExperienceProfilePictureEditor.Common.Enums)

local function useRecommendedEmotes()
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(false)

	React.useEffect(function()
		local flag = false
		fetchInternal(getEmoteRecommendations.getEmoteRecommendationsUrl(), Enums.RequestMethods.GET):andThen(function(p)
			if flag then
				return
			end

			setState(getEmoteRecommendations.parseEmoteRecommendationsResponse(p.responseBody))
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
