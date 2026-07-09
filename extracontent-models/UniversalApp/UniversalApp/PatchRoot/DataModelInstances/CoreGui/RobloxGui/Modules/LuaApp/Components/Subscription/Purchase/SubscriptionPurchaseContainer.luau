local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux
local useDispatch = RoactRodux.useDispatch
local useSelector = RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagSduiSubscriptionCellPostPurchaseSync = SharedFlags.FFlagSduiSubscriptionCellPostPurchaseSync
local FFlagSubscriptionPurchaseModalLiveStatus = SharedFlags.FFlagSubscriptionPurchaseModalLiveStatus
local AppPage = require(Modules.LuaApp.AppPage)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local SetSubscriptionStatuses = require(Modules.LuaApp.Actions.Subscription.SetSubscriptionStatuses)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local PerformSubscriptionPurchase = require(Modules.LuaApp.Thunks.Subscription.PerformSubscriptionPurchase)
local SubscriptionPurchaseOverlay = require(script.Parent.SubscriptionPurchaseOverlay)

require(Modules.LuaApp.Models.SubscriptionApi.SubscriptionProductInfoModel)

local GetFFlagEnableDevSubsInRobux = require(Modules.LuaApp.Flags.GetFFlagEnableDevSubsInRobux)
local GetFFlagEnableVpcSettingsForInAppSubscriptionPurchase = require(Modules.LuaApp.Flags.GetFFlagEnableVpcSettingsForInAppSubscriptionPurchase)
local OpenCentralOverlayForUnifiedPurchasePrompt = require(Modules.LuaApp.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local ProductPurchaseSurface = require(CorePackages.Workspace.Packages.PurchasePromptLite).Enums.ProductPurchaseSurface
local Promise = require(Modules.LuaApp.Promise)

local function SubscriptionPurchaseContainer(t1: {[any]: any}) -- line: 51
	-- upvalues: useDispatch (copy), useNavigation (copy), useRoactService (copy), AppEventIngestService (copy), RoactNetworking (copy), GetFFlagEnableDevSubsInRobux (copy), FFlagSubscriptionPurchaseModalLiveStatus (copy), useSelector (copy), React (copy), SubscriptionPurchaseOverlay (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), CloseCentralOverlay (copy), SetSubscriptionStatuses (copy), FFlagSduiSubscriptionCellPostPurchaseSync (copy), ProductPurchaseSurface (copy), Promise (copy), GetFFlagEnableVpcSettingsForInAppSubscriptionPurchase (copy), NavigateDown (copy), AppPage (copy), UrlBuilder (copy), PerformSubscriptionPurchase (copy)
	local v28 = useDispatch()
	local v29 = useNavigation()
	local v30 = useRoactService(AppEventIngestService)

	useRoactService(RoactNetworking)

	local v31 = GetFFlagEnableDevSubsInRobux() and (t1.subscriptionPurchaseProductInfo.priceInRobux ~= nil and t1.subscriptionPurchaseProductInfo.priceInRobux > 0)
	local v32 = if not FFlagSubscriptionPurchaseModalLiveStatus then t1.isSubscribed else useSelector(function(p1) -- line: 61
		-- upvalues: t1 (copy)
		local subscriptionTargetKey = t1.subscriptionPurchaseProductInfo.subscriptionTargetKey
		local SubscriptionStatuses = p1.SubscriptionStatuses
		local v36 = SubscriptionStatuses and SubscriptionStatuses[subscriptionTargetKey]

		if v36 ~= nil and v36.isSubscribed ~= nil then
			return v36.isSubscribed
		end

		return t1.isSubscribed
	end)

	if GetFFlagEnableDevSubsInRobux() then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			SubscriptionPurchaseOverlay = React.createElement(SubscriptionPurchaseOverlay, {
				subscriptionPurchaseProductInfo = t1.subscriptionPurchaseProductInfo,
				thumbnailString = t1.thumbnailString,
				isSubscribed = v32,
				isRobuxSubscription = v31,
				shouldUseNewModalDesign = GetFFlagEnableDevSubsInRobux(),
				creatorName = t1.creatorName,
				creatorVerified = t1.creatorVerified,
				promptSubscriptionPurchase = function(_, _) -- line: 86
					-- upvalues: v28 (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), t1 (copy), v31 (copy), CloseCentralOverlay (copy), SetSubscriptionStatuses (copy), FFlagSduiSubscriptionCellPostPurchaseSync (copy), ProductPurchaseSurface (copy), Promise (copy)
					v28(OpenCentralOverlayForUnifiedPurchasePrompt({
						productPayload = {
							kind = "DeveloperSubscription",
							subscriptionId = t1.subscriptionPurchaseProductInfo.subscriptionTargetKey,
							name = t1.subscriptionPurchaseProductInfo.name,
							expectedPrice = t1.subscriptionPurchaseProductInfo.priceInRobux or 0,
							iconImageAssetId = t1.subscriptionPurchaseProductInfo.iconImageAssetId,
							isSubscriptionInRobux = v31,
							displayPrice = t1.subscriptionPurchaseProductInfo.displayPrice
						},
						purchaseCallbacks = {
							onFlowComplete = function() -- line: 98
								-- upvalues: v28 (copy), CloseCentralOverlay (copy)
								v28(CloseCentralOverlay())
							end,
							onPurchaseSuccess = function() -- line: 101
								-- upvalues: v28 (copy), SetSubscriptionStatuses (copy), t1 (copy), FFlagSduiSubscriptionCellPostPurchaseSync (copy)
								v28(SetSubscriptionStatuses({
									[t1.subscriptionPurchaseProductInfo.subscriptionTargetKey] = {
										isSubscribed = true,
										isRenewing = true
									}
								}))

								if FFlagSduiSubscriptionCellPostPurchaseSync and t1.onPurchaseSuccess then
									t1.onPurchaseSuccess()
								end
							end
						},
						purchaseAnalyticsMetadata = {
							surface = ProductPurchaseSurface.EDP,
							productUniverseId = t1.subscriptionPurchaseProductInfo.subscriptionProviderId
						}
					}))

					return Promise.new(function() -- line: 118
					end)
				end,
				endPurchase = function() -- line: 121
					-- upvalues: v29 (copy)
					v29.goBack()
				end,
				onPurchaseSuccess = function() -- line: 125
					-- upvalues: v28 (copy), SetSubscriptionStatuses (copy), t1 (copy), FFlagSduiSubscriptionCellPostPurchaseSync (copy), v29 (copy)
					v28(SetSubscriptionStatuses({
						[t1.subscriptionPurchaseProductInfo.subscriptionTargetKey] = {
							isSubscribed = true,
							isRenewing = true
						}
					}))

					if FFlagSduiSubscriptionCellPostPurchaseSync and t1.onPurchaseSuccess then
						t1.onPurchaseSuccess()
					end

					v29.goBack()
				end,
				openSettingsPage = if not GetFFlagEnableVpcSettingsForInAppSubscriptionPurchase() then nil else function() -- line: 139
					-- upvalues: v28 (copy), NavigateDown (copy), AppPage (copy), UrlBuilder (copy)
					v28(NavigateDown({
						name = AppPage.SettingsSubPage,
						detail = UrlBuilder.static.settings.billing(),
						extraProps = {
							titleKey = "Feature.AccountSettings.Heading.Tab.Spending"
						}
					}))
				end,
				onAnalyticEvent = function(s1: string, s2: string, t2: {[any]: any}) -- line: 150
					-- upvalues: v30 (copy)
					v30:sendEventDeferred(s1, s2, t2)
				end
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		SubscriptionPurchaseOverlay = React.createElement(SubscriptionPurchaseOverlay, {
			subscriptionPurchaseProductInfo = t1.subscriptionPurchaseProductInfo,
			thumbnailString = t1.thumbnailString,
			isSubscribed = v32,
			shouldUseNewModalDesign = GetFFlagEnableDevSubsInRobux(),
			creatorName = t1.creatorName,
			creatorVerified = t1.creatorVerified,
			promptSubscriptionPurchase = function(p4) -- line: 169
				-- upvalues: PerformSubscriptionPurchase (copy)
				return PerformSubscriptionPurchase(p4)
			end,
			endPurchase = function() -- line: 173
				-- upvalues: v29 (copy)
				v29.goBack()
			end,
			onPurchaseSuccess = function() -- line: 177
				-- upvalues: v28 (copy), SetSubscriptionStatuses (copy), t1 (copy), FFlagSduiSubscriptionCellPostPurchaseSync (copy), v29 (copy)
				v28(SetSubscriptionStatuses({
					[t1.subscriptionPurchaseProductInfo.subscriptionTargetKey] = {
						isSubscribed = true,
						isRenewing = true
					}
				}))

				if FFlagSduiSubscriptionCellPostPurchaseSync and t1.onPurchaseSuccess then
					t1.onPurchaseSuccess()
				end

				v29.goBack()
			end,
			openSettingsPage = if not GetFFlagEnableVpcSettingsForInAppSubscriptionPurchase() then nil else function() -- line: 191
				-- upvalues: v28 (copy), NavigateDown (copy), AppPage (copy), UrlBuilder (copy)
				v28(NavigateDown({
					name = AppPage.SettingsSubPage,
					detail = UrlBuilder.static.settings.billing(),
					extraProps = {
						titleKey = "Feature.AccountSettings.Heading.Tab.Spending"
					}
				}))
			end,
			onAnalyticEvent = function(s3: string, s4: string, t3: {[any]: any}) -- line: 202
				-- upvalues: v30 (copy)
				v30:sendEventDeferred(s3, s4, t3)
			end
		})
	})
end

return SubscriptionPurchaseContainer
