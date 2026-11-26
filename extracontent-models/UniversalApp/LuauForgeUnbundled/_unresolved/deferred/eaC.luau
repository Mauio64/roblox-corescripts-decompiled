local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module2 = require("@luauforge/deferred/dZm")
local module3 = require("@luauforge/deferred/eaD")
local module4 = require("@luauforge/deferred/eaE")

local module5 = require("@luauforge/deferred/eaj")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/LuaSocialLibrariesDeps")
local module7 = require("@luauforge/deferred/ear")

local module8 = require("@luauforge/deferred/dZw")

local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions

local loadableImage = module7.App.Loading.LoadableImage

local skeleton = module5.Skeleton
local text = module5.Text
local view = module5.View

local useSelector = module2.Hooks.RoactRodux.useSelector
local useStyle = module7.Core.Style.useStyle

local avatarHeadShot = module3.Utils.Constants.RbxthumbTypes.AvatarHeadShot

return function(p2)
	local v5 = useStyle()
	local v6

	if module8 then
		local v7 = module4.Hooks.useUserProfilesFetch({
			userIds = { (tostring(p2.creatorUserId)) },
			query = module4.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})

		if v7.data then
			v6 = module4.Selectors.getUsernameFromId(v7.data, p2.creatorUserId)
		end
	else
		v6 = useSelector(function(p3)
			return getDeepValue(p3, "Users.byUserId." .. tostring(p2.creatorUserId) .. ".username")
		end)
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = p2.layoutOrder,
		tag = "align-x-left align-y-center auto-y bg-action-subtle gap-small row size-full-0"
	}

	local v9 = {
		CreatorThumbnail = React.createElement(loadableImage, {
			BackgroundColor3 = v5.Theme.PlaceHolder.Color,
			BackgroundTransparency = v5.Theme.PlaceHolder.Transparency,
			cornerRadius = UDim.new(0, 30),
			Image = getRbxthumbWithTypeSizeAndOptions(tostring(p2.creatorUserId), avatarHeadShot, 150, true),
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(30, 30),
			useShimmerAnimationWhileLoading = true
		}),
		CreatorUsername = 0,
		ShimmerPanel = 0
	}

	local v10 = if v6 then React.createElement(text, {
		LayoutOrder = 2,
		tag = "auto-y content-action-emphasis grow text-align-x-left text-align-y-top text-title-large text-truncate-end",
		Text = v6,
		ZIndex = 2
	}) else nil
	v9.CreatorUsername = v10

	local v11 = if not v6 then React.createElement(skeleton, {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(160, 16)
	}) else nil
	v9.ShimmerPanel = v11
	return createElement(view, v8, v9)
end
