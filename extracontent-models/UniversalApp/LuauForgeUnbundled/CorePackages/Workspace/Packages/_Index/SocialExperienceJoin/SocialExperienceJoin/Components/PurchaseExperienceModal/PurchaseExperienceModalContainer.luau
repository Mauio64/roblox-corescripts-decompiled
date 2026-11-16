local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RoactUtils")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Navigation")
local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppNavigation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/RobloxAppHooks")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Promise")

local PurchaseExperienceModal = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Components/PurchaseExperienceModal/PurchaseExperienceModal")
local PurchaseProductById = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Networking/PurchaseProductById")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Common/Constants")

local initializeSocialExperienceJoinAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/initializeSocialExperienceJoinAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/EventNames")

local RODUX_KEY = Constants.RODUX_KEY
local useNavigation = Navigation.useNavigation

local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useScreenSize = RobloxAppHooks.useScreenSize

local PurchaseExperienceStatus = require("@game/CorePackages/Workspace/Packages/_Index/SocialExperienceJoin/SocialExperienceJoin/Analytics/PurchaseExperienceStatus")

return function()
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = useNavigationProps(function(p2, data)
		return {
			universeId = p2,
			userId = data.userId,
			openGameDetailsPeekView = data.openGameDetailsPeekView,
			analyticProps = data.analyticProps
		}
	end)

	local v8 = useScreenSize()

	local v9 = React.useMemo(function()
		return initializeSocialExperienceJoinAnalytics(v7.analyticProps)
	end, { v7.analyticProps })

	local v10 = useSelector(function(p2)
		return p2[RODUX_KEY].Games.productInfoByGameId[v7.universeId]
	end)

	local v11 = useSelector(function(p2)
		return p2[RODUX_KEY].Games.byGameId[v7.universeId]
	end)

	local v12 = React.useCallback(function()
		v5.pop()
	end, { v5 })

	local v13 = React.useCallback(function()
		v9.fireAnalyticsEvent(EventNames.CancelPurchaseExperience, {
			universeId = v7.universeId,
			profileUserId = v7.userId
		})

		v12()
	end, { v12, v9, v7.universeId })

	local v14 = React.useCallback(function()
		v9.fireAnalyticsEvent(EventNames.PurchaseExperience, {
			universeId = v7.universeId,
			profileUserId = v7.userId
		})

		v6(PurchaseProductById.API(v10.productId, {
			expectedCurrency = Constants.RobuxCurrency,
			expectedPrice = v10.price,
			expectedSellerId = v10.sellerId
		})):andThen(function(p2)
			local responseBody = p2.responseBody
			return type(responseBody) == "table" and responseBody or Promise.reject()
		end):andThen(function(p2)
			v12()

			if p2.purchased then
				v9.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
					status = PurchaseExperienceStatus.Success,
					universeId = v7.universeId,
					profileUserId = v7.userId
				})
			else
				v9.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
					status = PurchaseExperienceStatus.PurchaseError,
					universeId = v7.universeId,
					profileUserId = v7.userId
				})
			end
		end):catch(function(p2)
			v12()
			v9.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
				status = PurchaseExperienceStatus.NetworkError,
				universeId = v7.universeId,
				profileUserId = v7.userId
			})
		end)
	end, { v6, v10.productId, v10.price, v10.sellerId, v12 })

	return React.createElement(PurchaseExperienceModal, {
		cancelPurchase = v13,
		experienceName = v11.name,
		price = v10.price,
		purchaseExperience = v14,
		screenSize = v8
	})
end
