local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetTryOnManagerPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetTryOnManagerPeekViewState
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local FullView = AvatarExperienceCommon.Enums.FullView
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: Utils (copy), selectSearchKeyword (copy), CatalogUtils (copy), Constants (copy), PeekViewState (copy), FFlagAXMISEnableMultiShopping (copy), AvatarScreen (copy), SetFullView (copy), FullView (copy), SetTryOnManagerPeekViewState (copy)
	return function(p1) -- line: 35
		-- upvalues: t1 (copy), Utils (copy), selectSearchKeyword (copy), CatalogUtils (copy), Constants (copy), PeekViewState (copy), FFlagAXMISEnableMultiShopping (copy), AvatarScreen (copy), SetFullView (copy), FullView (copy), SetTryOnManagerPeekViewState (copy)
		local v17 = p1:getState()
		local name = t1.avatarRoute.opaque.name
		local v19 = Utils.getCurrentScreenIgnoreItemDetails(t1.avatarRoute)
		local v20 = selectSearchKeyword(v17)
		local v21, v22 = CatalogUtils.getCategoryAndSubcategory(v17)
		local Look = Constants.ItemType.Look

		t1.catalogAnalytics.openItemDetailsV2(t1.lookId, Look, t1.valueInRobux, v19, nil, v20, v21, v22, v17.AvatarExperience.AnalyticsMetadata)

		local Brief = PeekViewState.Brief

		if FFlagAXMISEnableMultiShopping and (t1.avatarRoute and t1.avatarRoute.opaque and t1.avatarRoute.opaque.name ~= AvatarScreen.MySharedAvatars) then
			Brief = PeekViewState.Full
		end

		p1:dispatch(SetFullView(t1.catalogAnalytics, name, FullView.None))
		p1:dispatch(SetTryOnManagerPeekViewState(Brief))
	end
end
