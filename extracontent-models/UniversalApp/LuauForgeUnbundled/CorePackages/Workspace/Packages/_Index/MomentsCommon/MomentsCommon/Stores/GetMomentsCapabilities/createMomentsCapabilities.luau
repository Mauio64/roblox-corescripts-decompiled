local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags")
local fFlagMomentsAutoplayAmpPolicy = SharedFlags.FFlagMomentsAutoplayAmpPolicy
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled
local fFlagMomentsReactFeatureGate = SharedFlags.FFlagMomentsReactFeatureGate
local fFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local FFlagMomentsEngagementMetricsFeature = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsEngagementMetricsFeature")
local FFlagDebugForceEnableMoments = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagDebugForceEnableMoments")
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

	if fFlagMomentsAutoplayAmpPolicy then
		local v11 = "auto_play"
		v10 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v11) ~= nil
		end)
	end

	local v11

	if FFlagMomentsEngagementMetricsFeature then
		local v12 = "engagement_metrics"
		v11 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v12) ~= nil
		end)
	end

	local v12

	if fFlagMomentsReactFeatureGate then
		local v13 = "moments_react"
		v12 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v13) ~= nil
		end)
	end

	local v13 = fFlagMomentsComments or fFlagMomentsCommentsIxpEnabled
	local v14

	if v13 then
		local v15 = "comments_read"
		v14 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v15) ~= nil
		end)
	end

	local v15

	if v13 then
		local v16 = "comments_write"
		v15 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v16) ~= nil
		end)
	end

	local v16

	if v13 then
		local v17 = "comments_react"
		v16 = createComputed(function(p2): boolean
			if FFlagDebugForceEnableMoments then
				return true
			end

			local appPolicy = getAppPolicyStore(false).getAppPolicy(p2)
			return table.find(appPolicy.getMomentsFeatureList(), v17) ~= nil
		end)
	end

	return {
		getHasMomentsAccess = computed,
		getIsInfluencerContentEnabled = computed2,
		getCanCreateMoments = v9,
		getIsAutoPlayEnabled = v10,
		getIsEngagementMetricsEnabled = v11,
		getCanReactToMoments = v12,
		getCanReadComments = v14,
		getCanWriteComments = v15,
		getCanReactToComments = v16,
		getIsInfiniteScrollEnabled = createComputed(function(p2): boolean
			if not v5 or FFlagDebugForceEnableMoments then
				return true
			end

			local momentsFeatureList = getAppPolicyStore(false).getAppPolicy(p2).getMomentsFeatureList()

			if next(momentsFeatureList) == nil then
				return true
			end

			return table.find(momentsFeatureList, "infinite_scroll") ~= nil
		end),
		getMaxMomentsBeforeEndState = createComputed(function(p2)
			return v6
		end)
	}
end

return createMomentsCapabilities
