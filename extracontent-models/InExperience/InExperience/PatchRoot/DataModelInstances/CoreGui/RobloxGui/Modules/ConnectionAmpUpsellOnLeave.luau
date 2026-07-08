local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringLuaAppPlayButtonAgeCheckAmpFeatureName = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpFeatureName
local FStringLuaAppPlayButtonAgeCheckAmpNameSpace = SharedFlags.FStringLuaAppPlayButtonAgeCheckAmpNameSpace
local FFlagConnectionUpsellAnalytics = SharedFlags.FFlagConnectionUpsellAnalytics
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local PlacelaunchAgeVerificationRequired = nil
local PlacelaunchParentalApprovalRequired = nil

pcall(function() -- line: 32
	-- upvalues: PlacelaunchAgeVerificationRequired (ref), PlacelaunchParentalApprovalRequired (ref)
	PlacelaunchAgeVerificationRequired = Enum.ConnectionError.PlacelaunchAgeVerificationRequired
	PlacelaunchParentalApprovalRequired = Enum.ConnectionError.PlacelaunchParentalApprovalRequired
end)

local function logTelemetry(p1, p2) -- line: 37
	-- upvalues: TelemetryService (copy)
	TelemetryService:LogCounter(p1, {
		customFields = {
			selectedItem = p2
		}
	}, 1)
end
local function fetchUniverseIdFromPlaceIdYielding(n1: number) -- line: 44
	-- upvalues: Url (copy), HttpRbxApiService (copy), HttpService (copy)
	local v30 = string.format("%suniverses/v1/places/%d/universe", Url.APIS_URL, n1)
	local ok, result = pcall(HttpRbxApiService.GetAsyncFullUrl, HttpRbxApiService, v30)

	if not ok or type(result) ~= "string" then
		return nil
	end

	local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, result)

	if not ok2 or type(result2) ~= "table" then
		return nil
	end

	local universeId = result2.universeId

	if type(universeId) ~= "number" or universeId <= 0 then
		return nil
	end

	return universeId
end

local v15 = if not FFlagConnectionUpsellAnalytics then nil else {
	eventName = "unlockPlayIntent",
	description = "Fired when a user clicks Continue on an AMP age check / parental approval upsell from a game-join flow.",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ConnectionAmpUnlockPlayIntentThrottleHundredthsPercent", 10000),
	lastUpdated = {
		2026,
		5,
		11
	}
}
local v16 = if not FFlagConnectionUpsellAnalytics then nil else {
	eventName = "gameJoinUpsellImpression",
	description = "Fired when an AMP age check / parental approval upsell is shown during a game-join flow.",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ConnectionAmpGameJoinUpsellImpressionThrottleHundredthsPercent", 10000),
	lastUpdated = {
		2026,
		5,
		11
	}
}
local v17 = if not FFlagConnectionUpsellAnalytics then nil else {
	"addSessionInfo",
	"addSessionId",
	"addOSInfo"
}
local v18 = if not FFlagConnectionUpsellAnalytics then nil else {
	upsellName = "AgeCheckRequired",
	playabilityStatus = "ContextualPlayabilityAgeCheckRequired",
	missingPlaceIdItem = "AmpAgeCheckMissingPlaceId",
	universeIdLookupFailedItem = "AgeCheckImpressionUniverseIdLookupFailed"
}
local v19 = if not FFlagConnectionUpsellAnalytics then nil else {
	upsellName = "ParentApprovalRequired",
	playabilityStatus = "ContextualPlayabilityRequireParentApproval",
	missingPlaceIdItem = "AmpParentApprovalMissingPlaceId",
	universeIdLookupFailedItem = "ParentApprovalImpressionUniverseIdLookupFailed"
}
local v20 = if not FFlagConnectionUpsellAnalytics then nil else {}
local v21 = if not FFlagConnectionUpsellAnalytics then nil else function(t1: {[any]: any}, s1: string, p3, s2: string) -- line: 120
	-- upvalues: TelemetryService (copy), v17 (copy)
	TelemetryService:LogEvent(p3, {
		eventContext = s1,
		standardizedFields = v17,
		customFields = {
			universeId = s2,
			upsellName = t1.upsellName,
			playabilityStatus = t1.playabilityStatus
		}
	})
end
local v22 = if not FFlagConnectionUpsellAnalytics then nil else function(t2: {[any]: any}, n2: number, s3: string) -- line: 139
	-- upvalues: v20 (copy), v21 (copy), v15 (copy)
	local v43 = s3 ~= "" and s3 or (v20[n2] or "")

	if s3 and s3 ~= "" then
		v20[n2] = s3
	end

	v21(t2, "GameJoin", v15, v43)
end
local v23 = if not FFlagConnectionUpsellAnalytics then nil else function(p4, t3: {[any]: any}, n3: number) -- line: 150
	-- upvalues: logTelemetry (copy), v20 (copy), v21 (copy), v16 (copy), fetchUniverseIdFromPlaceIdYielding (copy)
	if not n3 or n3 == 0 then
		logTelemetry(p4, t3.missingPlaceIdItem)

		return
	end

	local v47 = v20[n3]

	if v47 then
		v21(t3, t3.upsellName, v16, v47)

		return
	end

	task.spawn(function() -- line: 160
		-- upvalues: fetchUniverseIdFromPlaceIdYielding (copy), n3 (copy), v20 (copy), logTelemetry (copy), p4 (copy), t3 (copy), v21 (copy), v16 (copy)
		local v79 = fetchUniverseIdFromPlaceIdYielding(n3)
		local v80 = not v79 and "" or tostring(v79)

		if v79 then
			v20[n3] = v80
		else
			logTelemetry(p4, t3.universeIdLookupFailedItem)
		end

		v21(t3, t3.upsellName, v16, v80)
	end)
end

local function loadAmpUpsell() -- line: 186
	-- upvalues: CorePackages (copy)
	local ok, result = pcall(require, CorePackages.Workspace.Packages.AmpUpsell)

	if ok then
		return result
	end

	return nil
end
local function loadCoreScriptsApolloClient() -- line: 193
	-- upvalues: CoreGui (copy)
	local ok, result = pcall(require, CoreGui.RobloxGui.Modules.ApolloClient)

	if ok then
		return result
	end

	return nil
end
local function openWizardThenReconnect(p5, p6, p7, p8, p9, p10, p11, p12, p13) -- line: 198
	-- upvalues: logTelemetry (copy), CorePackages (copy), CoreGui (copy)
	logTelemetry(p5, p13)

	local ok, result = pcall(require, CorePackages.Workspace.Packages.AmpUpsell)
	local v67 = if not ok then nil else result

	if not v67 then
		logTelemetry(p5, "AmpWizardLoadFailed")

		return
	end

	local ok3, result3 = pcall(require, CoreGui.RobloxGui.Modules.ApolloClient)
	local v70 = if not ok3 then nil else result3

	if not v70 then
		logTelemetry(p5, "AmpWizardApolloLoadFailed")

		return
	end

	if not pcall(function() -- line: 224
		-- upvalues: v67 (copy), p8 (copy), logTelemetry (copy), p5 (copy), p6 (copy), p11 (copy), p10 (copy), p12 (copy), p9 (copy), v70 (copy), p7 (copy)
		v67.InExpAmpWizardController.OpenAmpWizardContainerInExp(p8, function(p14) -- line: 225
			-- upvalues: v67 (copy), logTelemetry (copy), p5 (copy), p6 (copy)
			if p14 == v67.AmpEnums.AccessResponseEnum.Granted then
				logTelemetry(p5, "AmpWizardGrantedReconnect")
				p6()

				return
			end

			logTelemetry(p5, "AmpWizardNotGranted")
		end, p11, p10, p12, p9, v70, p7, true)
	end) then
		logTelemetry(p5, "AmpWizardOpenError")
	end
end

return {
	PrimaryButtonText = "Continue",
	PrimaryButtonLocalizationKey = "InGame.ConnectionError.Action.Continue",
	AgeVerificationRequiredEnum = PlacelaunchAgeVerificationRequired,
	ParentalApprovalRequiredEnum = PlacelaunchParentalApprovalRequired,
	createAgeCheckCallback = function(p15, p16, n4: number) -- line: 240
		-- upvalues: FFlagConnectionUpsellAnalytics (copy), v22 (copy), v18 (copy), openWizardThenReconnect (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy)
		local v74 = n4 + 1

		return function() -- line: 242
			-- upvalues: FFlagConnectionUpsellAnalytics (copy), v22 (copy), v18 (copy), openWizardThenReconnect (copy), p15 (copy), p16 (copy), v74 (copy), FStringLuaAppPlayButtonAgeCheckAmpFeatureName (copy), FStringLuaAppPlayButtonAgeCheckAmpNameSpace (copy)
			if FFlagConnectionUpsellAnalytics then
				v22(v18, game.PlaceId, "")
			end

			openWizardThenReconnect(p15, p16, v74, FStringLuaAppPlayButtonAgeCheckAmpFeatureName, FStringLuaAppPlayButtonAgeCheckAmpNameSpace, "gameJoinAgeCheckRequired", nil, nil, "AmpAgeCheckOpened")
		end
	end,
	createParentalApprovalCallback = function(p17, p18, n5: number) -- line: 260
		-- upvalues: logTelemetry (copy), fetchUniverseIdFromPlaceIdYielding (copy), FFlagConnectionUpsellAnalytics (copy), v22 (copy), v19 (copy), openWizardThenReconnect (copy)
		local v78 = n5 + 1

		return function() -- line: 262
			-- upvalues: logTelemetry (copy), p17 (copy), fetchUniverseIdFromPlaceIdYielding (copy), FFlagConnectionUpsellAnalytics (copy), v22 (copy), v19 (copy), openWizardThenReconnect (copy), p18 (copy), v78 (copy)
			local PlaceId = game.PlaceId

			if not PlaceId or PlaceId == 0 then
				logTelemetry(p17, "AmpParentApprovalMissingPlaceId")

				return
			end

			task.spawn(function() -- line: 270
				-- upvalues: fetchUniverseIdFromPlaceIdYielding (copy), PlaceId (copy), FFlagConnectionUpsellAnalytics (copy), v22 (copy), v19 (copy), logTelemetry (copy), p17 (copy), openWizardThenReconnect (copy), p18 (copy), v78 (copy)
				local v83 = fetchUniverseIdFromPlaceIdYielding(PlaceId)

				if FFlagConnectionUpsellAnalytics then
					local v84 = not v83 and "" or tostring(v83)

					v22(v19, PlaceId, v84)
				end

				if not v83 then
					logTelemetry(p17, "AmpParentApprovalUniverseIdLookupFailed")

					return
				end

				local str = tostring(v83)

				openWizardThenReconnect(p17, p18, v78, "CanApproveExperience", nil, "gameJoinContentMaturityLock", {
					experienceManagementAction = "Approve",
					universeId = str
				}, nil, "AmpParentApprovalOpened")
			end)
		end
	end,
	fireImpressionAgeCheck = if not FFlagConnectionUpsellAnalytics then nil else function(p19, n6: number) -- line: 174
		-- upvalues: v23 (copy), v18 (copy)
		v23(p19, v18, n6)
	end,
	fireImpressionParentalApproval = if not FFlagConnectionUpsellAnalytics then nil else function(p20, n7: number) -- line: 180
		-- upvalues: v23 (copy), v19 (copy)
		v23(p20, v19, n7)
	end
}
