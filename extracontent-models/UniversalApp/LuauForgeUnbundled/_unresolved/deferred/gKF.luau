local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/dPU")
local module3 = require("@luauforge/deferred/gJI")
local module4 = require("@luauforge/bundled/fCe")

local module5 = require("@luauforge/deferred/gJH")
local module6 = require("@luauforge/bundled/dXh")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local module7 = require("@luauforge/deferred/gKG")

local module8 = require("@luauforge/deferred/gKH")

local extended = Roact.PureComponent:extend("RemoveCurrentlySellingItemPrompt")

function extended:init()
	function self.removeSoldItem()
		if self.props.fetchingState == retrievalStatus.Fetching then
			return
		end

		local itemId = self.props.itemId
		local collectibleItemId = self.props.collectibleItemId
		local userAssetId = self.props.userAssetId
		local networking = self.props.networking
		local localUserId = self.props.localUserId

		if collectibleItemId then
			self.props.removeCurrentlySellingCollectible(networking, collectibleItemId, userAssetId)
		else
			self.props.removeCurrentlySellingAsset(networking, itemId, userAssetId, localUserId)
		end
	end

	function self.closePrompt()
		module6.closeOverlay(self.props.navigation)
	end
end

function extended.willUpdate(p2, p3, p4)
	if module4.isFetchingDoneOrFailed(p2.props.fetchingState, p3.fetchingState) then
		p2.closePrompt()
	end
end

function extended:renderAlertLocalized(props2)
	return Roact.createElement(interactiveAlert, {
		title = props2.titleText,
		bodyText = props2.messageText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = self.closePrompt,
						text = props2.cancelButtonText
					},
					isDefaultChild = true
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						isLoading = self.props.fetchingState == retrievalStatus.Fetching,
						onActivated = self.removeSoldItem,
						text = props2.confirmButtonText
					}
				}
			}
		},
		screenSize = self.props.screenSize,
		defaultChildRef = self.props.defaultChildRef
	})
end

function extended:render()
	return withLocalization({
		titleText = "Feature.Catalog.Heading.TakeOffSale",
		messageText = "Feature.Catalog.Label.TakeOffResaleConfirmation",
		confirmButtonText = "Feature.Catalog.Heading.TakeOffSale",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	local userAssetId = p3.userAssetId
	local v6

	if p3.collectibleItemId then
		v6 = module2.UpdateCollectibleInstanceResaleStateKey
	else
		v6 = module2.RemoveCurrentlySellingAssetKey
	end

	return {
		localUserId = p2.LocalUserId,
		fetchingState = performFetch.GetStatus(p2, v6 .. tostring(userAssetId)),
		screenSize = p2.ScreenSize
	}
end, function(callback)
	return {
		removeCurrentlySellingAsset = function(p2, p3, p4, p5)
			return callback(module7(p2, p3, p4, p5))
		end,
		removeCurrentlySellingCollectible = function(p2, p3, p4)
			return callback(module8(p2, p3, p4, false, nil))
		end
	}
end)(extended)

return (module5((module3((roactServices.connect({ networking = module })(v5))))))
