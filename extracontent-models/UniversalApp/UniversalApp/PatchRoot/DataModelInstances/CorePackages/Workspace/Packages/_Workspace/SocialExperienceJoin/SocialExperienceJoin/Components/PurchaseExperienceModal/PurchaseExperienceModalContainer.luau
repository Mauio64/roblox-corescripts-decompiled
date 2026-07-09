local SocialExperienceJoin = script:FindFirstAncestor("SocialExperienceJoin")
local SocialExperienceJoinParent = SocialExperienceJoin.Parent
local React = require(SocialExperienceJoinParent.React)
local RoactUtils = require(SocialExperienceJoinParent.RoactUtils)
local Navigation = require(SocialExperienceJoinParent.Navigation)
local RobloxAppNavigation = require(SocialExperienceJoinParent.RobloxAppNavigation)
local RobloxAppHooks = require(SocialExperienceJoinParent.RobloxAppHooks)
local Promise = require(SocialExperienceJoinParent.Promise)
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

return function() -- line: 38
	-- upvalues: useNavigation (copy), useDispatch (copy), useNavigationProps (copy), useScreenSize (copy), React (copy), initializeSocialExperienceJoinAnalytics (copy), useSelector (copy), RODUX_KEY (copy), EventNames (copy), PurchaseExperienceStatus (copy), PurchaseProductById (copy), Constants (copy), Promise (copy), PurchaseExperienceModal (copy)
	local v21 = useNavigation()
	local v22 = useDispatch()
	local v23 = useNavigationProps(function(s1: string, t1: {[any]: any}) -- line: 41
		return {
			universeId = s1,
			userId = t1.userId,
			openGameDetailsPeekView = t1.openGameDetailsPeekView,
			analyticProps = t1.analyticProps
		}
	end)
	local v24 = useScreenSize()
	local v25 = React.useMemo(function() -- line: 51
		-- upvalues: initializeSocialExperienceJoinAnalytics (copy), v23 (copy)
		return initializeSocialExperienceJoinAnalytics(v23.analyticProps)
	end, { v23.analyticProps })
	local v26 = useSelector(function(p1) -- line: 56
		-- upvalues: RODUX_KEY (copy), v23 (copy)
		return p1[RODUX_KEY].Games.productInfoByGameId[v23.universeId]
	end)
	local v27 = useSelector(function(p2) -- line: 59
		-- upvalues: RODUX_KEY (copy), v23 (copy)
		return p2[RODUX_KEY].Games.byGameId[v23.universeId]
	end)
	local v28 = React.useCallback(function() -- line: 90
		-- upvalues: v21 (copy)
		v21.pop()
	end, { v21 })
	local v29 = React.useCallback(function() -- line: 94
		-- upvalues: v25 (copy), EventNames (copy), v23 (copy), v28 (copy)
		v25.fireAnalyticsEvent(EventNames.CancelPurchaseExperience, {
			universeId = v23.universeId,
			profileUserId = v23.userId
		})
		v28()
	end, {
		v28,
		v25,
		v23.universeId
	})
	local v30 = React.useCallback(function() -- line: 103
		-- upvalues: v25 (copy), EventNames (copy), v23 (copy), v22 (copy), PurchaseProductById (copy), v26 (copy), Constants (copy), Promise (copy), v28 (copy), PurchaseExperienceStatus (copy)
		v25.fireAnalyticsEvent(EventNames.PurchaseExperience, {
			universeId = v23.universeId,
			profileUserId = v23.userId
		})
		v22(PurchaseProductById.API(v26.productId, {
			expectedCurrency = Constants.RobuxCurrency,
			expectedPrice = v26.price,
			expectedSellerId = v26.sellerId
		})):andThen(function(p3) -- line: 118
			-- upvalues: Promise (copy)
			local responseBody = p3.responseBody

			return type(responseBody) == "table" and responseBody or Promise.reject()
		end):andThen(function(p4) -- line: 122
			-- upvalues: v28 (copy), v25 (copy), EventNames (copy), PurchaseExperienceStatus (copy), v23 (copy)
			v28()

			if p4.purchased then
				v25.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
					status = PurchaseExperienceStatus.Success,
					universeId = v23.universeId,
					profileUserId = v23.userId
				})

				return
			end

			v25.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
				status = PurchaseExperienceStatus.PurchaseError,
				universeId = v23.universeId,
				profileUserId = v23.userId
			})
		end):catch(function(_) -- line: 131
			-- upvalues: v28 (copy), v25 (copy), EventNames (copy), PurchaseExperienceStatus (copy), v23 (copy)
			v28()
			v25.fireAnalyticsEvent(EventNames.PurchaseExperienceAttempt, {
				status = PurchaseExperienceStatus.NetworkError,
				universeId = v23.universeId,
				profileUserId = v23.userId
			})
		end)
	end, {
		v22,
		v26.productId,
		v26.price,
		v26.sellerId,
		v28
	})

	return React.createElement(PurchaseExperienceModal, {
		cancelPurchase = v29,
		experienceName = v27.name,
		price = v26.price,
		purchaseExperience = v30,
		screenSize = v24
	})
end
