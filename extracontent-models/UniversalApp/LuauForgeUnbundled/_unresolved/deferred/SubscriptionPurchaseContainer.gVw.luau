local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local roactRodux = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux
local useDispatch = roactRodux.useDispatch
local useSelector = roactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSduiSubscriptionCellPostPurchaseSync = SharedFlags.FFlagSduiSubscriptionCellPostPurchaseSync
local fFlagSubscriptionPurchaseModalLiveStatus = SharedFlags.FFlagSubscriptionPurchaseModalLiveStatus
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module2 = require("@luauforge/bundled/dFu")
local module3 = require("@luauforge/bundled/fzK")
local module4 = require("@luauforge/bundled/ehB")

local module5 = require("@luauforge/bundled/dBD")
local module6 = require("@luauforge/bundled/eie")
local module7 = require("@luauforge/bundled/ecr")
local module8 = require("@luauforge/bundled/egx")
local module9 = require("@luauforge/deferred/gVx")

local module10 = require("@luauforge/deferred/gVy")

require("@luauforge/bundled/gCI")

local module11 = require("@luauforge/deferred/gFz")

local module12 = require("@luauforge/deferred/gVC")

local module13 = require("@luauforge/deferred/fCN")
local module14 = require("@luauforge/bundled/fCM")
local productPurchaseSurface = require("@luauforge/deferred/fCQ").Enums.ProductPurchaseSurface
local module15 = require("@luauforge/bundled/egs")

local function SubscriptionPurchaseContainer(props)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = module6(module7)
	module6(module8)
	local v8 = module11()

	if v8 then
		if props.subscriptionPurchaseProductInfo.priceInRobux == nil then
			v8 = false
		else
			v8 = props.subscriptionPurchaseProductInfo.priceInRobux > 0
		end
	end

	local v9

	if fFlagSubscriptionPurchaseModalLiveStatus then
		v9 = useSelector(function(p2)
			local subscriptionTargetKey = props.subscriptionPurchaseProductInfo.subscriptionTargetKey
			local subscriptionStatuses = p2.SubscriptionStatuses
			local v10 = subscriptionStatuses and subscriptionStatuses[subscriptionTargetKey]

			if v10 == nil or v10.isSubscribed == nil then
				return props.isSubscribed
			end

			return v10.isSubscribed
		end)
	else
		v9 = props.isSubscribed
	end

	if module11() then
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			SubscriptionPurchaseOverlay = React.createElement(module10, {
				subscriptionPurchaseProductInfo = props.subscriptionPurchaseProductInfo,
				thumbnailString = props.thumbnailString,
				isSubscribed = v9,
				isRobuxSubscription = v8,
				shouldUseNewModalDesign = module11(),
				creatorName = props.creatorName,
				creatorVerified = props.creatorVerified,
				promptSubscriptionPurchase = function(p2, p3)
					v5(module13({
						productPayload = {
							kind = "DeveloperSubscription",
							subscriptionId = props.subscriptionPurchaseProductInfo.subscriptionTargetKey,
							name = props.subscriptionPurchaseProductInfo.name,
							expectedPrice = props.subscriptionPurchaseProductInfo.priceInRobux or 0,
							iconImageAssetId = props.subscriptionPurchaseProductInfo.iconImageAssetId,
							isSubscriptionInRobux = v8,
							displayPrice = props.subscriptionPurchaseProductInfo.displayPrice
						},
						purchaseCallbacks = {
							onFlowComplete = function()
								v5(module14())
							end,
							onPurchaseSuccess = function()
								v5(module5({
									[props.subscriptionPurchaseProductInfo.subscriptionTargetKey] = {
										isSubscribed = true,
										isRenewing = true
									}
								}))

								if
									fFlagSduiSubscriptionCellPostPurchaseSync
									and props.onPurchaseSuccess
								then
									props.onPurchaseSuccess()
								end
							end
						},
						purchaseAnalyticsMetadata = {
							surface = productPurchaseSurface.EDP,
							productUniverseId = props.subscriptionPurchaseProductInfo.subscriptionProviderId
						}
					}))

					return module15.new(function() end)
				end,
				endPurchase = function()
					v6.goBack()
				end,
				onPurchaseSuccess = function()
					v5(module5({
						[props.subscriptionPurchaseProductInfo.subscriptionTargetKey] = {
							isSubscribed = true,
							isRenewing = true
						}
					}))

					if fFlagSduiSubscriptionCellPostPurchaseSync and props.onPurchaseSuccess then
						props.onPurchaseSuccess()
					end

					v6.goBack()
				end,
				openSettingsPage = module12() and function()
					local v10 = {
						name = module2.SettingsSubPage,
						detail = module3.static.settings.billing(),
						extraProps = {
							titleKey = "Feature.AccountSettings.Heading.Tab.Spending"
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v10))
					else
						v5(module4(v10))
					end
				end or nil,
				onAnalyticEvent = function(p2, p3, p4)
					v7:sendEventDeferred(p2, p3, p4)
				end
			})
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	}, {
		SubscriptionPurchaseOverlay = React.createElement(module10, {
			subscriptionPurchaseProductInfo = props.subscriptionPurchaseProductInfo,
			thumbnailString = props.thumbnailString,
			isSubscribed = v9,
			shouldUseNewModalDesign = module11(),
			creatorName = props.creatorName,
			creatorVerified = props.creatorVerified,
			promptSubscriptionPurchase = function(p2)
				return module9(p2)
			end,
			endPurchase = function()
				v6.goBack()
			end,
			onPurchaseSuccess = function()
				v5(module5({
					[props.subscriptionPurchaseProductInfo.subscriptionTargetKey] = {
						isSubscribed = true,
						isRenewing = true
					}
				}))

				if fFlagSduiSubscriptionCellPostPurchaseSync and props.onPurchaseSuccess then
					props.onPurchaseSuccess()
				end

				v6.goBack()
			end,
			openSettingsPage = module12() and function()
				local v10 = {
					name = module2.SettingsSubPage,
					detail = module3.static.settings.billing(),
					extraProps = {
						titleKey = "Feature.AccountSettings.Heading.Tab.Spending"
					}
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v10))
				else
					v5(module4(v10))
				end
			end or nil,
			onAnalyticEvent = function(p2, p3, p4)
				v7:sendEventDeferred(p2, p3, p4)
			end
		})
	})
end

return SubscriptionPurchaseContainer
