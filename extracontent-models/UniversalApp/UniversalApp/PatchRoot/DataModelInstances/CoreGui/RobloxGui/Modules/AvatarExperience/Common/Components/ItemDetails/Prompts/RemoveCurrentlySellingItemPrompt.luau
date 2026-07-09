local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local RemoveCurrentlySellingAsset = require(Modules.AvatarExperience.Catalog.Thunks.RemoveCurrentlySellingAsset)
local UpdateCollectibleInstanceResaleState = require(Modules.AvatarExperience.Catalog.Thunks.UpdateCollectibleInstanceResaleState)
local v20 = Roact.PureComponent:extend("RemoveCurrentlySellingItemPrompt")

function v20.init(p1) -- line: 37
	-- upvalues: RetrievalStatus (copy), NavigationUtils (copy)
	function p1.removeSoldItem() -- line: 38
		-- upvalues: p1 (copy), RetrievalStatus (copy)
		if p1.props.fetchingState == RetrievalStatus.Fetching then
			return
		end

		local itemId = p1.props.itemId
		local collectibleItemId = p1.props.collectibleItemId
		local userAssetId = p1.props.userAssetId
		local networking = p1.props.networking
		local localUserId = p1.props.localUserId

		if collectibleItemId then
			p1.props.removeCurrentlySellingCollectible(networking, collectibleItemId, userAssetId)

			return
		end

		p1.props.removeCurrentlySellingAsset(networking, itemId, userAssetId, localUserId)
	end
	function p1.closePrompt() -- line: 57
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v20.willUpdate(p2, p3, _) -- line: 62
	-- upvalues: Utils (copy)
	if Utils.isFetchingDoneOrFailed(p2.props.fetchingState, p3.fetchingState) then
		p2.closePrompt()
	end
end
function v20.renderAlertLocalized(p5, p6) -- line: 68
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy), RetrievalStatus (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p6.titleText,
		bodyText = p6.messageText,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p5.closePrompt,
						text = p6.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isLoading = p5.props.fetchingState == RetrievalStatus.Fetching,
						onActivated = p5.removeSoldItem,
						text = p6.confirmButtonText
					}
				}
			}
		},
		screenSize = p5.props.screenSize,
		defaultChildRef = p5.props.defaultChildRef
	})
end
function v20.render(p7) -- line: 97
	-- upvalues: withLocalization (copy)
	return withLocalization({
		titleText = "Feature.Catalog.Heading.TakeOffSale",
		messageText = "Feature.Catalog.Label.TakeOffResaleConfirmation",
		confirmButtonText = "Feature.Catalog.Heading.TakeOffSale",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p8) -- line: 103
		-- upvalues: p7 (copy)
		return p7:renderAlertLocalized(p8)
	end)
end

local v21 = RoactRodux.connect(function(p9, p10) -- line: 108
	-- upvalues: CatalogConstants (copy), PerformFetch (copy)
	local userAssetId = p10.userAssetId
	local v32 = if not p10.collectibleItemId then CatalogConstants.RemoveCurrentlySellingAssetKey else CatalogConstants.UpdateCollectibleInstanceResaleStateKey

	return {
		localUserId = p9.LocalUserId,
		fetchingState = PerformFetch.GetStatus(p9, v32 .. tostring(userAssetId)),
		screenSize = p9.ScreenSize
	}
end, function(p11) -- line: 120
	-- upvalues: RemoveCurrentlySellingAsset (copy), UpdateCollectibleInstanceResaleState (copy)
	return {
		removeCurrentlySellingAsset = function(p12, p13, p14, p15) -- line: 122
			-- upvalues: p11 (copy), RemoveCurrentlySellingAsset (copy)
			return p11(RemoveCurrentlySellingAsset(p12, p13, p14, p15))
		end,
		removeCurrentlySellingCollectible = function(p16, p17, p18) -- line: 125
			-- upvalues: p11 (copy), UpdateCollectibleInstanceResaleState (copy)
			return p11(UpdateCollectibleInstanceResaleState(p16, p17, p18, false, nil))
		end
	}
end)(v20)

return (withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	networking = RoactNetworking
})(v21))))))
