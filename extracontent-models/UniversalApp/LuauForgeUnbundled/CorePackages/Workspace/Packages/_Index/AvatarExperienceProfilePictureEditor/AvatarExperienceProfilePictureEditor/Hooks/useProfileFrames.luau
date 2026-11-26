local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")

local fetchInternal = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Api/fetchInternal")
local EditProfileImageAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Analytics/EditProfileImageAnalytics")
local profileFramesWidgetsApi = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Api/profileFramesWidgetsApi")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/mapWidgetContentToFrameItems")

local function useProfileFrames()
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(false)

	local v5 = React.useCallback(function()
		profileFramesWidgetsApi.fetchProfileFramesWidgets(fetchInternal):andThen(function(p2)
			local v6 = not (p2 and p2.widgetContent) and {} or p2.widgetContent
			local v7 = if p2 then p2.hydrateResponseBody else nil

			local mapWidgetContentToFrameItems = module5.mapWidgetContentToFrameItems(v6, v7)

			setState3(false)
			setState(mapWidgetContentToFrameItems)
			setState2(false)
		end):catch(function(p2)
			EditProfileImageAnalytics.logFetchFailure({ assetType = "frames" })

			setState3(true)
			setState({})
			setState2(false)
		end)
	end, {})

	local v6 = React.useCallback(function()
		setState2(true)
		setState3(false)
		v5()
	end, { v5 })

	React.useEffect(function()
		v5()
	end, { v5 })

	return { frameItems = state, isLoading = state2, hasError = state3, refetch = v6 }
end

return useProfileFrames
