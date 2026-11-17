local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled
local FFlagMomentsReactFeatureGate = SharedFlags.FFlagMomentsReactFeatureGate
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local FFlagAXAvatarMomentsCreation = SharedFlags.FFlagAXAvatarMomentsCreation
local FFlagMomentsEngagementMetricsFeature = require(MomentsCommon.Flags.FFlagMomentsEngagementMetricsFeature)
local FFlagDebugForceEnableMoments = require(MomentsCommon.Flags.FFlagDebugForceEnableMoments)
local FFlagMomentsParentTimeLimit = require(MomentsCommon.Flags.FFlagMomentsParentTimeLimit)
local GetFFlagMomentsNonInfiniteScroll = require(MomentsCommon.Flags.GetFFlagMomentsNonInfiniteScroll)
local GetFIntMomentsNonInfiniteScrollLimit = require(MomentsCommon.Flags.GetFIntMomentsNonInfiniteScrollLimit)

local createComputed = Signals.createComputed

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local GetAppPolicyStore = UniversalAppPolicy.GetAppPolicyStore

local function createMomentsCapabilities()
	local fFlagMomentsNonInfiniteScroll = GetFFlagMomentsNonInfiniteScroll()

	local v = math.max(1, GetFIntMomentsNonInfiniteScrollLimit())

	local function policyCapability(p: string) -- 10 equivalent calls inferred from this helper
		return createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = GetAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), p) ~= nil
		end)
	end

	local getHasMomentsAccess = policyCapability("moments_access") -- inferred equivalent call
	local getIsInfluencerContentEnabled = policyCapability("influencer_content") -- inferred equivalent call
	local getCanCreateMoments

	if FFlagMomentsCreationFeatureGate then
		getCanCreateMoments = policyCapability("moments_creation") -- inferred equivalent call
	end

	local getCanCreateAvatarMoments

	if FFlagAXAvatarMomentsCreation then
		getCanCreateAvatarMoments = policyCapability("avatar_creation") -- inferred equivalent call
	end

	local getIsAutoPlayEnabled

	if FFlagMomentsAutoplayAmpPolicy then
		getIsAutoPlayEnabled = policyCapability("auto_play") -- inferred equivalent call
	end

	local getIsEngagementMetricsEnabled

	if FFlagMomentsEngagementMetricsFeature then
		getIsEngagementMetricsEnabled = policyCapability("engagement_metrics") -- inferred equivalent call
	end

	local getCanReactToMoments

	if FFlagMomentsReactFeatureGate then
		getCanReactToMoments = policyCapability("moments_react") -- inferred equivalent call
	end

	local v2 = FFlagMomentsComments or FFlagMomentsCommentsIxpEnabled
	local getCanReadComments

	if v2 then
		getCanReadComments = policyCapability("comments_read") -- inferred equivalent call
	end

	local getCanWriteComments

	if v2 then
		getCanWriteComments = policyCapability("comments_write") -- inferred equivalent call
	end

	local getCanReactToComments

	if v2 then
		getCanReactToComments = policyCapability("comments_react") -- inferred equivalent call
	end

	local getCanShowPersonalizedRecommendationsEntryPoint = createComputed(function(p)
		return GetAppPolicyStore(false).getAppPolicy(p).getShowInContextPersonalizedRecommendationsMomentsFeed()
	end)

	local getIsInfiniteScrollEnabled = createComputed(function(p): boolean
		if not fFlagMomentsNonInfiniteScroll or FFlagDebugForceEnableMoments then
			return true
		end

		local momentsFeatureList = GetAppPolicyStore(false).getAppPolicy(p).getMomentsFeatureList()

		return next(momentsFeatureList) == nil or table.find(momentsFeatureList, "infinite_scroll") ~= nil
	end)

	local getMaxMomentsBeforeEndState = createComputed(function(_)
		return v
	end)
	local getHasDailyLimit

	if FFlagMomentsParentTimeLimit then
		getHasDailyLimit = createComputed(function(p): boolean
			local FFlagDebugForceMomentsDailyLimit = require(MomentsCommon.Flags.FFlagDebugForceMomentsDailyLimit)

			if FFlagDebugForceMomentsDailyLimit then
				return true
			end

			local appPolicy = GetAppPolicyStore(false).getAppPolicy(p)
			return table.find(appPolicy.getMomentsFeatureList(), "moments_daily_limit") ~= nil
		end)
	end

	return {
		getHasMomentsAccess = getHasMomentsAccess,
		getIsInfluencerContentEnabled = getIsInfluencerContentEnabled,
		getCanCreateMoments = getCanCreateMoments,
		getCanCreateAvatarMoments = getCanCreateAvatarMoments,
		getIsAutoPlayEnabled = getIsAutoPlayEnabled,
		getIsEngagementMetricsEnabled = getIsEngagementMetricsEnabled,
		getCanReactToMoments = getCanReactToMoments,
		getCanReadComments = getCanReadComments,
		getCanWriteComments = getCanWriteComments,
		getCanReactToComments = getCanReactToComments,
		getCanShowPersonalizedRecommendationsEntryPoint = getCanShowPersonalizedRecommendationsEntryPoint,
		getIsInfiniteScrollEnabled = getIsInfiniteScrollEnabled,
		getMaxMomentsBeforeEndState = getMaxMomentsBeforeEndState,
		getHasDailyLimit = getHasDailyLimit
	}
end

return createMomentsCapabilities
