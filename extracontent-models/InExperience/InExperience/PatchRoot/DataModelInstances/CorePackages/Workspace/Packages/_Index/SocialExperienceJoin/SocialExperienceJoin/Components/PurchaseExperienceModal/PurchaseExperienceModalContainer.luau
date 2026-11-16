local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local parent = SocialExperienceJoin.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Navigation = require(parent.Navigation)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local Promise = require(parent.Promise)

local PurchaseExperienceModal = require(script.Parent.PurchaseExperienceModal)
local PurchaseProductById = require(SocialExperienceJoin.Networking.PurchaseProductById)
local Constants = require(SocialExperienceJoin.Common.Constants)

local initializeSocialExperienceJoinAnalytics = require(SocialExperienceJoin.Analytics.initializeSocialExperienceJoinAnalytics)
local EventNames = require(SocialExperienceJoin.Analytics.EventNames)

local RODUX_KEY = Constants.RODUX_KEY
local useNavigation = Navigation.useNavigation

local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useScreenSize = RobloxAppHooks.useScreenSize

local PurchaseExperienceStatus = require(SocialExperienceJoin.Analytics.PurchaseExperienceStatus)

return function()
	local v = useNavigation()
	local v2 = useDispatch()
	local v3 = useNavigationProps(function(universeId: string, data)
		return {
			universeId = universeId,
			userId = data.userId,
			openGameDetailsPeekView = data.openGameDetailsPeekView,
			analyticProps = data.analyticProps
		}
	end)

	local screenSize = useScreenSize()

	local v4 = React.useMemo(function()
		return initializeSocialExperienceJoinAnalytics(v3.analyticProps)
	end, { v3.analyticProps })

	local v5 = useSelector(function(p)
		return p[RODUX_KEY].Games.productInfoByGameId[v3.universeId]
	end)

	local v6 = useSelector(function(p)
		return p[RODUX_KEY].Games.byGameId[v3.universeId]
	end)

	local v7 = React.useCallback(function()
		v.pop()
	end, { v })

	local cancelPurchase = React.useCallback(function()
		v4.fireAnalyticsEvent(EventNames.CancelPurchaseExperience, {
			universeId = v3.universeId,
			profileUserId = v3.userId
		})

		v7()
	end, { v7, v4, v3.universeId })

	local function fn() -- 1 equivalent call inferred from this helper
		v4.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
			status = PurchaseExperienceStatus.Success,
			universeId = v3.universeId,
			profileUserId = v3.userId
		})
	end

	local function fn2(_) -- 1 equivalent call inferred from this helper
		v4.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
			status = PurchaseExperienceStatus.PurchaseError,
			universeId = v3.universeId,
			profileUserId = v3.userId
		})
	end

	local function fn3(_) -- 1 equivalent call inferred from this helper
		v4.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
			status = PurchaseExperienceStatus.NetworkError,
			universeId = v3.universeId,
			profileUserId = v3.userId
		})
	end

	local purchaseExperience = React.useCallback(function()
		v4.fireAnalyticsEvent(EventNames.PurchaseExperience, {
			universeId = v3.universeId,
			profileUserId = v3.userId
		})

		local function fn4() -- 1 equivalent call inferred from this helper
			return v2(PurchaseProductById.API(v5.productId, {
				expectedCurrency = Constants.RobuxCurrency,
				expectedPrice = v5.price,
				expectedSellerId = v5.sellerId
			}))
		end

		fn4():andThen(function(p) -- inferred equivalent call
			local responseBody = p.responseBody
			return type(responseBody) == "table" and responseBody or Promise.reject()
		end):andThen(function(p)
			v7()

			if p.purchased then
				fn() -- inferred equivalent call
			else
				fn2() -- inferred equivalent call
			end
		end):catch(function(_)
			v7()
			fn3() -- inferred equivalent call
		end)
	end, { v2, v5.productId, v5.price, v5.sellerId, v7 })

	return React.createElement(PurchaseExperienceModal, {
		cancelPurchase = cancelPurchase,
		experienceName = v6.name,
		price = v5.price,
		purchaseExperience = purchaseExperience,
		screenSize = screenSize
	})
end
