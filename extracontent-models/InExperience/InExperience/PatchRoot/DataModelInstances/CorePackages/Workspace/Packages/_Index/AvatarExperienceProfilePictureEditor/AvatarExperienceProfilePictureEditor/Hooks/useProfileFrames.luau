local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)

local fetchInternal = require(AvatarExperienceProfilePictureEditor.Api.fetchInternal)
local EditProfileImageAnalytics = require(AvatarExperienceProfilePictureEditor.Analytics.EditProfileImageAnalytics)
local profileFramesWidgetsApi = require(AvatarExperienceProfilePictureEditor.Api.profileFramesWidgetsApi)
local mapWidgetContentToFrameItems = require(AvatarExperienceProfilePictureEditor.Utils.mapWidgetContentToFrameItems)

local function useProfileFrames()
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(false)

	local v = React.useCallback(function()
		profileFramesWidgetsApi.fetchProfileFramesWidgets(fetchInternal):andThen(function(p)
			local v = not (p and p.widgetContent) and {} or p.widgetContent
			local v2

			if p then
				v2 = p.hydrateResponseBody
			end

			local mapWidgetContentToFrameItems2 = mapWidgetContentToFrameItems.mapWidgetContentToFrameItems(v, v2)

			setState3(false)
			setState(mapWidgetContentToFrameItems2)
			setState2(false)
		end):catch(function(_)
			EditProfileImageAnalytics.logFetchFailure({ assetType = "frames" })

			setState3(true)
			setState({})
			setState2(false)
		end)
	end, {})

	local refetch = React.useCallback(function()
		setState2(true)
		setState3(false)
		v()
	end, { v })

	React.useEffect(function()
		v()
	end, { v })

	return { frameItems = state, isLoading = state2, hasError = state3, refetch = refetch }
end

return useProfileFrames
