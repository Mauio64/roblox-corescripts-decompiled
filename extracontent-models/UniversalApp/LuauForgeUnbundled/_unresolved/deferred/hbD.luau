local module = require("@luauforge/bundled/fCe")
local module2 = require("@luauforge/bundled/dVl")
local module3 = require("@luauforge/bundled/dPN")
local setTryOnManagerPeekViewState = require("@luauforge/bundled/dKU").Actions.SetTryOnManagerPeekViewState
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fullView = AvatarExperienceCommon.Enums.FullView
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local module5 = require("@luauforge/bundled/gSD")
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

return function(data)
	return function(object)
		local state = object:getState()
		local name = data.avatarRoute.opaque.name
		local currentScreenIgnoreItemDetails = module.getCurrentScreenIgnoreItemDetails(data.avatarRoute)
		local v5 = selectSearchKeyword(state)
		local categoryAndSubcategory, v6 = module2.getCategoryAndSubcategory(state)

		local look = module3.ItemType.Look

		data.catalogAnalytics.openItemDetailsV2(
			data.lookId,
			look,
			data.valueInRobux,
			currentScreenIgnoreItemDetails,
			nil,
			v5,
			categoryAndSubcategory,
			v6,
			state.AvatarExperience.AnalyticsMetadata
		)

		local v7 = peekViewState.Brief

		if
			data.avatarRoute
			and data.avatarRoute.opaque
			and data.avatarRoute.opaque.name ~= avatarScreen.MySharedAvatars
		then
			v7 = peekViewState.Full
		end

		object:dispatch(module5(data.catalogAnalytics, name, fullView.None))
		object:dispatch(setTryOnManagerPeekViewState(v7))
	end
end
