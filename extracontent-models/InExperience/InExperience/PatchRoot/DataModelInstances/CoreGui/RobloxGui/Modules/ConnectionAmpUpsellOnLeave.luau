local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpFeatureName
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local FFlagConnectionUpsellAnalytics = SharedFlags.FFlagConnectionUpsellAnalytics
local FFlagPioneerLeaveOnInExpFaeDownAge = SharedFlags.FFlagPioneerLeaveOnInExpFaeDownAge
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url

local maybeLeavePioneerOnFaeDownAge = require(CorePackages.Workspace.Packages.PioneerUtils.maybeLeavePioneerOnFaeDownAge)

local placelaunchAgeVerificationRequired = nil
local placelaunchParentalApprovalRequired = nil
pcall(function()
	placelaunchAgeVerificationRequired = Enum.ConnectionError.PlacelaunchAgeVerificationRequired
	placelaunchParentalApprovalRequired = Enum.ConnectionError.PlacelaunchParentalApprovalRequired
end)

local function logTelemetry(p, selectedItem)
	TelemetryService:LogCounter(p, {
		customFields = { selectedItem = selectedItem }
	}, 1)
end

local function fetchUniverseIdFromPlaceIdYielding(p: number)
	local v = string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, p)
	local success, asyncFullUrl = pcall(HttpRbxApiService.GetAsyncFullUrl, HttpRbxApiService, v)

	if not success or type(asyncFullUrl) ~= "string" then
		return nil
	end

	local success2, result = pcall(HttpService.JSONDecode, HttpService, asyncFullUrl)

	if not success2 or type(result) ~= "table" then
		return nil
	end

	local universeId = result.universeId

	if type(universeId) == "number" and not (universeId <= 0) then
		return universeId
	end

	return nil
end

local v = FFlagConnectionUpsellAnalytics and {
	eventName = "unlockPlayIntent",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ConnectionAmpUnlockPlayIntentThrottleHundredthsPercent", 10000),
	lastUpdated = { 2026, 5, 11 },
	description = "Fired when a user clicks Continue on an AMP age check / parental approval upsell from a game-join flow."
} or nil

local v2 = FFlagConnectionUpsellAnalytics and {
	eventName = "gameJoinUpsellImpression",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ConnectionAmpGameJoinUpsellImpressionThrottleHundredthsPercent", 10000),
	lastUpdated = { 2026, 5, 11 },
	description = "Fired when an AMP age check / parental approval upsell is shown during a game-join flow."
} or nil

local standardizedFields = FFlagConnectionUpsellAnalytics and { "addSessionInfo", "addSessionId", "addOSInfo" } or nil

local v3 = FFlagConnectionUpsellAnalytics
	and {
		upsellName = "AgeCheckRequired",
		playabilityStatus = "ContextualPlayabilityAgeCheckRequired",
		missingPlaceIdItem = "AmpAgeCheckMissingPlaceId",
		universeIdLookupFailedItem = "AgeCheckImpressionUniverseIdLookupFailed"
	}
	or nil

local v4 = FFlagConnectionUpsellAnalytics
	and {
		upsellName = "ParentApprovalRequired",
		playabilityStatus = "ContextualPlayabilityRequireParentApproval",
		missingPlaceIdItem = "AmpParentApprovalMissingPlaceId",
		universeIdLookupFailedItem = "ParentApprovalImpressionUniverseIdLookupFailed"
	}
	or nil

local v5 = FFlagConnectionUpsellAnalytics and {} or nil

local fn = FFlagConnectionUpsellAnalytics and function(p, eventContext: string, p2, universeId: string)
	TelemetryService:LogEvent(p2, {
		eventContext = eventContext,
		standardizedFields = standardizedFields,
		customFields = {
			universeId = universeId,
			upsellName = p.upsellName,
			playabilityStatus = p.playabilityStatus
		}
	})
end or nil

local fn2 = FFlagConnectionUpsellAnalytics and function(p, p2: number, p3: string)
	local v6 = (p3 == "" or not p3) and (v5[p2] or "") or p3

	if p3 and p3 ~= "" then
		v5[p2] = p3
	end

	fn(p, "GameJoin", v, v6)
end or nil

local fn3 = FFlagConnectionUpsellAnalytics and function(p, data, p2: number)
	if not p2 or p2 == 0 then
		logTelemetry(p, data.missingPlaceIdItem)
		return
	end

	local v6 = v5[p2]

	if v6 then
		fn(data, data.upsellName, v2, v6)
	else
		task.spawn(function()
			local v7 = fetchUniverseIdFromPlaceIdYielding(p2)
			local v8 = not v7 and "" or tostring(v7)

			if v7 then
				v5[p2] = v8
			else
				logTelemetry(p, data.universeIdLookupFailedItem)
			end

			fn(data, data.upsellName, v2, v8)
		end)
	end
end or nil

local function loadAmpUpsell() -- 1 equivalent call inferred from this helper
	local success, ampUpsell = pcall(require, CorePackages.Workspace.Packages.AmpUpsell)
	return if success then ampUpsell else nil
end

local function loadCoreScriptsApolloClient() -- 1 equivalent call inferred from this helper
	local success, apolloClient = pcall(require, CoreGui.RobloxGui.Modules.ApolloClient)
	return if success then apolloClient else nil
end

local function openWizardThenReconnect(p, callback, p2, p3, p4, p5, p6, p7, selectedItem)
	logTelemetry(p, selectedItem)
	local ampUpsell = loadAmpUpsell() -- inferred equivalent call

	if not ampUpsell then
		logTelemetry(p, "AmpWizardLoadFailed")
		return
	end

	local apolloClient = loadCoreScriptsApolloClient() -- inferred equivalent call

	if not apolloClient then
		logTelemetry(p, "AmpWizardApolloLoadFailed")
	elseif not pcall(function()
		ampUpsell.InExpAmpWizardController.OpenAmpWizardContainerInExp(p3, function(p8, p9)
			local v6 = p8 == ampUpsell.AmpEnums.AccessResponseEnum.Granted

			if v6 then
				logTelemetry(p, "AmpWizardGrantedReconnect")

				if not FFlagPioneerLeaveOnInExpFaeDownAge then
					callback()
				end
			else
				logTelemetry(p, "AmpWizardNotGranted")
			end

			if FFlagPioneerLeaveOnInExpFaeDownAge then
				local ampEnums = ampUpsell.AmpEnums

				maybeLeavePioneerOnFaeDownAge(
					p9 ~= nil and p9[ampEnums.ActionTypeEnum.AgeEstimation] == ampEnums.ActionStatusEnum.Success,
					function()
						if v6 then
							callback()
						end
					end
				)
			end
		end, p6, p5, p7, p4, apolloClient, p2, true)
	end) then
		logTelemetry(p, "AmpWizardOpenError")
	end
end

local ConnectionAmpUpsellOnLeave = {}
ConnectionAmpUpsellOnLeave.PrimaryButtonText = "Continue"
ConnectionAmpUpsellOnLeave.PrimaryButtonLocalizationKey = "InGame.ConnectionError.Action.Continue"
ConnectionAmpUpsellOnLeave.AgeVerificationRequiredEnum = placelaunchAgeVerificationRequired
ConnectionAmpUpsellOnLeave.ParentalApprovalRequiredEnum = placelaunchParentalApprovalRequired

function ConnectionAmpUpsellOnLeave.createAgeCheckCallback(p, p2, p3: number)
	local v6 = p3 + 1
	return function()
		if FFlagConnectionUpsellAnalytics then
			fn2(v3, game.PlaceId, "")
		end

		openWizardThenReconnect(
			p,
			p2,
			v6,
			FStringLuaAppPlayButtonAgeCheckAmpFeatureName,
			FStringLuaAppPlayButtonAgeCheckAmpNameSpace,
			"gameJoinAgeCheckRequired",
			nil,
			nil,
			"AmpAgeCheckOpened"
		)
	end
end

function ConnectionAmpUpsellOnLeave.createParentalApprovalCallback(p, p2, p3: number)
	local v6 = p3 + 1
	return function()
		local placeId = game.PlaceId

		if placeId and placeId ~= 0 then
			task.spawn(function()
				local v7 = fetchUniverseIdFromPlaceIdYielding(placeId)

				if FFlagConnectionUpsellAnalytics then
					fn2(v4, placeId, not v7 and "" or tostring(v7))
				end

				if not v7 then
					logTelemetry(p, "AmpParentApprovalUniverseIdLookupFailed")
					return
				end

				openWizardThenReconnect(
					p,
					p2,
					v6,
					"CanApproveExperience",
					nil,
					"gameJoinContentMaturityLock",
					{ universeId = tostring(v7), experienceManagementAction = "Approve" },
					nil,
					"AmpParentApprovalOpened"
				)
			end)
		else
			logTelemetry(p, "AmpParentApprovalMissingPlaceId")
		end
	end
end

ConnectionAmpUpsellOnLeave.fireImpressionAgeCheck = FFlagConnectionUpsellAnalytics and function(p, p2: number)
	fn3(p, v3, p2)
end or nil

ConnectionAmpUpsellOnLeave.fireImpressionParentalApproval = FFlagConnectionUpsellAnalytics and function(p, p2: number)
	fn3(p, v4, p2)
end or nil
return ConnectionAmpUpsellOnLeave
