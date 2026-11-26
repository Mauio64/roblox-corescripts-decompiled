local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags")
local fFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled
local fFlagMomentsReactFeatureGate = SharedFlags.FFlagMomentsReactFeatureGate
local fFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local fFlagAXAvatarMomentsCreation = SharedFlags.FFlagAXAvatarMomentsCreation
local FFlagMomentsEngagementMetricsFeature = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsEngagementMetricsFeature")
local FFlagDebugForceEnableMoments = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagDebugForceEnableMoments")
local FFlagMomentsParentTimeLimit = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsParentTimeLimit")
local GetFFlagMomentsNonInfiniteScroll = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsNonInfiniteScroll")
local GetFIntMomentsNonInfiniteScrollLimit = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFIntMomentsNonInfiniteScrollLimit")

local createComputed = Signals.createComputed

local getAppPolicyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/UniversalAppPolicy").GetAppPolicyStore

local function createMomentsCapabilities()
	local v5 = GetFFlagMomentsNonInfiniteScroll()

	local v6 = math.max(1, GetFIntMomentsNonInfiniteScrollLimit())

	local function policyCapability(p2)
		return createComputed(function(p3): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p3)
			return table.find(appPolicy.getMomentsFeatureList(), p2) ~= nil
		end)
	end
	local v7 = "moments_access"
	local computed = createComputed(function(p2): boolean
		if FFlagDebugForceEnableMoments then
			return true
		end

		local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
		return table.find(appPolicy.getMomentsFeatureList(), v7) ~= nil
	end)
	local v8 = "influencer_content"
	local computed2 = createComputed(function(p2): boolean
		if FFlagDebugForceEnableMoments then
			return true
		end

		local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
		return table.find(appPolicy.getMomentsFeatureList(), v8) ~= nil
	end)
	local v9

	if fFlagMomentsCreationFeatureGate then
		local v10 = "moments_creation"
		v9 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v10) ~= nil
		end)
	end

	local v10

	if fFlagAXAvatarMomentsCreation then
		local v11 = "avatar_creation"
		v10 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v11) ~= nil
		end)
	end

	local v11

	if fFlagMomentsAutoplayAmpPolicy then
		local v12 = "auto_play"
		v11 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v12) ~= nil
		end)
	end

	local v12

	if FFlagMomentsEngagementMetricsFeature then
		local v13 = "engagement_metrics"
		v12 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v13) ~= nil
		end)
	end

	local v13

	if fFlagMomentsReactFeatureGate then
		local v14 = "moments_react"
		v13 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v14) ~= nil
		end)
	end

	local v14 = fFlagMomentsComments or fFlagMomentsCommentsIxpEnabled
	local v15

	if v14 then
		local v16 = "comments_read"
		v15 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v16) ~= nil
		end)
	end

	local v16

	if v14 then
		local v17 = "comments_write"
		v16 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v17) ~= nil
		end)
	end

	local v17

	if v14 then
		local v18 = "comments_react"
		v17 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v18) ~= nil
		end)
	end

	local computed3 = createComputed(function(p2)
		return getAppPolicyStore(false).getAppPolicy(p2).getShowInContextPersonalizedRecommendationsMomentsFeed()
	end)

	local computed4 = createComputed(function(p2): boolean
		if not v5 or FFlagDebugForceEnableMoments then
			return true
		end

		local momentsFeatureList = getAppPolicyStore(false).getAppPolicy(p2).getMomentsFeatureList()

		if next(momentsFeatureList) == nil then
			return true
		end

		return table.find(momentsFeatureList, "infinite_scroll") ~= nil
	end)

	local computed5 = createComputed(function(p2)
		return v6
	end)
	local v18

	if FFlagMomentsParentTimeLimit then
		v18 = createComputed(function(p2): boolean
			if require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagDebugForceMomentsDailyLimit") then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), "moments_daily_limit") ~= nil
		end)
	end

	return {
		getHasMomentsAccess = computed,
		getIsInfluencerContentEnabled = computed2,
		getCanCreateMoments = v9,
		getCanCreateAvatarMoments = v10,
		getIsAutoPlayEnabled = v11,
		getIsEngagementMetricsEnabled = v12,
		getCanReactToMoments = v13,
		getCanReadComments = v15,
		getCanWriteComments = v16,
		getCanReactToComments = v17,
		getCanShowPersonalizedRecommendationsEntryPoint = computed3,
		getIsInfiniteScrollEnabled = computed4,
		getMaxMomentsBeforeEndState = computed5,
		getHasDailyLimit = v18
	}
end

return createMomentsCapabilities
