local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local GenericChallengesParent = GenericChallenges.Parent
local Players = game:GetService("Players")
local React = require(GenericChallengesParent.React)
local useDispatch = require(GenericChallengesParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(GenericChallengesParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(GenericChallengesParent.Localization).Hooks.useLocalization
local Foundation = require(GenericChallengesParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local FullscreenPageWithSafeArea = require(GenericChallengesParent.AppBlox).FullscreenPageWithSafeArea
local FocusNavigationUtils = require(GenericChallengesParent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local PersonaLivenessContainer = require(script.Parent.PersonaLivenessContainer)
local PersonaLivenessServiceWrapper = require(script.Parent.PersonaLivenessServiceWrapper)
local QRDeepLinkDialog = require(GenericChallengesParent.IdentityVerification).QRDeepLinkDialog
local BiometricTypeEnum = require(script.Parent.Parent.Common.Enums).BiometricTypeEnum
local TelemetryReasons = require(script.Parent.Parent.Common.TelemetryReasons)
local useRoactService = require(GenericChallengesParent.RobloxAppHooks).useRoactService
local AppLogging = require(GenericChallengesParent.RoactServiceTags).AppLogging
local RoactNetworking = require(GenericChallengesParent.RoactServiceTags).RoactNetworking
local BiometricChallengeEvent = require(script.Parent.Parent.Common.BiometricChallengeEvent)
local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)
local GetFFlagEnhancedPersonaLivenessEvents = require(GenericChallengesParent.SharedFlags).GetFFlagEnhancedPersonaLivenessEvents
local v26 = game:DefineFastInt("PersonaLivenessV2QrPollDelaySec", 6)
local v27 = game:DefineFastInt("PersonaLivenessV2QrPollMaxRetries", 60)

local function defaultGetLocalUserId() -- line: 66
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		return nil
	end

	return LocalPlayer.UserId
end
local function buildDeeplink(n1: number) -- line: 76
	return "https://ro.blox.com/Ebh5" .. "?pid=QR_code&c=liveness_onelink" .. "&is_retargeting=false" .. "&af_dp=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(n1) .. "&deep_link_value=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(n1)
end
local function PersonaLivenessQRFlow(t1: {[any]: any}) -- line: 88
	-- upvalues: useDispatch (copy), useRoactService (copy), AppLogging (copy), RoactNetworking (copy), useSelector (copy), defaultGetLocalUserId (copy), useLocalization (copy), React (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), BiometricTypeEnum (copy), TelemetryReasons (copy), v27 (copy), v26 (copy), Loading (copy), IconSize (copy), FullscreenPageWithSafeArea (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), QRDeepLinkDialog (copy)
	local v35 = useDispatch()
	local v36 = useRoactService(AppLogging)
	local v37 = useRoactService(RoactNetworking)
	local v38 = useSelector(function(p1) -- line: 93
		return p1.UserAccess and p1.UserAccess.restrictionDetail
	end)
	local v39 = (t1.getLocalUserId or defaultGetLocalUserId)()
	local v40 = if not v39 or not (v39 > 0) then nil else "https://ro.blox.com/Ebh5" .. "?pid=QR_code&c=liveness_onelink" .. "&is_retargeting=false" .. "&af_dp=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(v39) .. "&deep_link_value=" .. "roblox%3A%2F%2Fnavigation%2Faccount_unlock%3Fuser_id=" .. tostring(v39)
	local v41 = useLocalization({
		prompt = "Feature.BiometricChallenge.Content.QRHelpPrompt"
	})
	local v42 = useLocalization({
		title = "Feature.BiometricChallenge.Title.QRHandoff",
		description = "Feature.BiometricChallenge.Content.ScanQR",
		footer = {
			"Feature.BiometricChallenge.Content.QRHelpFull",
			prompt = "<b>" .. v41.prompt .. "</b>"
		}
	})
	local v43 = React.useRef(false)
	local v44 = React.useCallback(function(p2) -- line: 119
		-- upvalues: v43 (copy), t1 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v36 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), BiometricTypeEnum (copy)
		if v43.current then
			return
		end

		v43.current = true
		t1.onChallengeAbandoned("")

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v36:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
				challengeId = t1.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = p2
			})

			return
		end

		v36:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeAbandoned,
			challengeId = t1.challengeId,
			biometricType = BiometricTypeEnum.PersonaLiveness
		})
	end, {
		v36,
		t1.challengeId,
		t1.onChallengeAbandoned
	})
	local v45 = React.useCallback(function(s1: string, p3) -- line: 142
		-- upvalues: v43 (copy), t1 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v36 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), BiometricTypeEnum (copy)
		if v43.current then
			return
		end

		v43.current = true
		t1.onChallengeFailed(s1)

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v36:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
				challengeId = t1.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = p3
			})

			return
		end

		v36:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
			context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeInvalidated,
			challengeId = t1.challengeId,
			biometricType = BiometricTypeEnum.PersonaLiveness
		})
	end, {})

	React.useEffect(function() -- line: 165
		-- upvalues: v40 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v45 (copy), TelemetryReasons (copy)
		if not v40 then
			if GetFFlagEnhancedPersonaLivenessEvents() then
				v45("MissingLocalUserId", TelemetryReasons.NullUserId)

				return
			end

			v45("MissingLocalUserId")
		end
	end, {
		v40,
		v45
	})
	React.useEffect(function() -- line: 177
		-- upvalues: v40 (copy), v38 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v43 (copy), v36 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), t1 (copy), BiometricTypeEnum (copy), TelemetryReasons (copy), v44 (copy)
		if not v40 or v38 ~= nil then
			return
		end

		if GetFFlagEnhancedPersonaLivenessEvents() then
			if v43.current then
				return
			end

			v43.current = true
			v36:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeCompleted,
				challengeId = t1.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = TelemetryReasons.QRCompleted
			})
			t1.onChallengeAbandoned("")

			return
		end

		v44()
	end, {
		v38,
		v40,
		v44,
		v36,
		t1.challengeId,
		t1.onChallengeAbandoned
	})
	React.useEffect(function() -- line: 208
		-- upvalues: v40 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v36 (copy), BiometricChallengeEvent (copy), ChallengeEventConstants (copy), t1 (copy), BiometricTypeEnum (copy), TelemetryReasons (copy), v27 (copy), v26 (copy), v35 (copy), v37 (copy), v45 (copy)
		if not v40 then
			return
		end

		if GetFFlagEnhancedPersonaLivenessEvents() then
			v36:logRobloxTelemetryEvent(BiometricChallengeEvent, {}, {
				context = ChallengeEventConstants.ChallengeLifecycleEventConstants.ChallengeDisplayed,
				challengeId = t1.challengeId,
				biometricType = BiometricTypeEnum.PersonaLiveness,
				reason = TelemetryReasons.QRDisplayed
			})
		end

		local u51 = false

		task.spawn(function() -- line: 223
			-- upvalues: v27 (copy), v26 (copy), u51 (ref), t1 (copy), v35 (copy), v37 (copy), GetFFlagEnhancedPersonaLivenessEvents (copy), v45 (copy), TelemetryReasons (copy)
			for _ = 1, v27 do
				task.wait(v26)

				if u51 then
					return
				end

				if t1.ApiFetchAccessStatus then
					v35(t1.ApiFetchAccessStatus(v37))
				end
			end

			if not u51 then
				if GetFFlagEnhancedPersonaLivenessEvents() then
					v45("Timeout", TelemetryReasons.QRPollingTimeout)

					return
				end

				v45("Timeout")
			end
		end)

		return function() -- line: 244
			-- upvalues: u51 (ref)
			u51 = true
		end
	end, {})

	if not v40 then
		return React.createElement(Loading, {
			size = IconSize.Medium,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})
	end

	return React.createElement("ScreenGui", {
		DisplayOrder = 200,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Overlay = React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = false,
			useFullScalePage = true
		}, {
			FocusNavigableSurface = React.createElement(FocusNavigableSurfaceWrapper, {
				isIsolated = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ModerationOverlay
			}, {
				Dialog = React.createElement(QRDeepLinkDialog, {
					deeplink = v40,
					title = v42.title,
					description = v42.description,
					footer = v42.footer,
					onClose = if not GetFFlagEnhancedPersonaLivenessEvents() then v44 else function() -- line: 282
						-- upvalues: v44 (copy), TelemetryReasons (copy)
						v44(TelemetryReasons.QRUserAbandon)
					end
				})
			})
		})
	})
end
local function PersonaLivenessContainerV2(t2: {[any]: any}) -- line: 292
	-- upvalues: PersonaLivenessServiceWrapper (copy), React (copy), PersonaLivenessContainer (copy), PersonaLivenessQRFlow (copy)
	if PersonaLivenessServiceWrapper.isAvailable() then
		return React.createElement(PersonaLivenessContainer, {
			challengeId = t2.challengeId,
			onChallengeCompleted = t2.onChallengeCompleted,
			onChallengeAbandoned = t2.onChallengeAbandoned,
			onChallengeFailed = t2.onChallengeFailed
		})
	end

	return React.createElement(PersonaLivenessQRFlow, t2)
end

return PersonaLivenessContainerV2
