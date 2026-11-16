local AdService = game:GetService("AdService")
local ExperienceService = game:GetService("ExperienceService")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/hUt")
local module2 = require("@luauforge/bundled/hTW")
local module3 = require("@luauforge/bundled/hUu")
local logger = require("@luauforge/bundled/hUv").Logger
local module4 = require("@luauforge/bundled/hUw")
local module5 = require("@luauforge/bundled/hTY")
local playWithRewardTelemetry = require("@luauforge/bundled/hUf").PlayWithRewardTelemetry

local usePlayButtonState = module3.usePlayButtonState
local playButtonStates = module3.PlayButtonStates
local useNavigationFocus = module.useNavigationFocus
local getSduiClientPageScope = module5.getSduiClientPageScope
local module6 = require("@luauforge/bundled/hUg")
local playWithRewardStateValue = module6.PlayWithRewardStateValue
local fFlagPlayWithRewardClearOnExperienceLeave = require("@luauforge/bundled/hTZ").FFlagPlayWithRewardClearOnExperienceLeave

local interface = module4.interface({ IsEligible = module4.boolean })

local function isPlayWithRewardEligible(AdService2, universeId): boolean
	if not AdService2 then
		logger:warning(`AdService is not available. Cannot determine Play with Reward eligibility for universe ID {universeId}.`)

		return false
	end

	local success, result = pcall(function()
		return AdService2:GetUniversalAppAdsEligibility()
	end)

	if not (success and result) then
		return false
	end

	local v5, v6 = interface(result)

	if v5 and result.IsEligible then
		return true
	end

	return false
end

local function isAdUsableForPlayWithReward(experimentVariantData): boolean
	if typeof(experimentVariantData) ~= "string" or experimentVariantData == "" then
		return true
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(experimentVariantData)
	end)

	if success and typeof(result) == "table" then
		return result.isAdUsableForPlayWithReward ~= false
	end

	return true
end

local function fetchSduiPlayWithRewardAvailability(AdService2, universeId, guid, productId, variantId)
	local lastTime = os.clock()
	playWithRewardTelemetry.logPlayWithRewardAdRequested(guid, universeId, variantId)

	local success, result = pcall(function()
		return AdService2:GetAdAvailabilityNowForUniverseAsync(
			Enum.AdFormat.RewardedVideo,
			tonumber(universeId),
			true
		)
	end)
	local sduiPlayWithRewardAvailability = success and result ~= nil
	local adAvailabilityResult = if sduiPlayWithRewardAvailability then result.AdAvailabilityResult else nil
	local experimentVariantData = if sduiPlayWithRewardAvailability then result.ExperimentVariantData else nil

	local logPlayWithRewardAdReceived = playWithRewardTelemetry.logPlayWithRewardAdReceived

	local v5 = if adAvailabilityResult then tostring(adAvailabilityResult) else nil
	logPlayWithRewardAdReceived(
		guid,
		universeId,
		sduiPlayWithRewardAvailability,
		v5,
		(os.clock() - lastTime) * 1000,
		productId,
		variantId
	)

	if sduiPlayWithRewardAvailability then
		if adAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable then
			sduiPlayWithRewardAvailability = isAdUsableForPlayWithReward(experimentVariantData)
		else
			sduiPlayWithRewardAvailability = false
		end
	end

	return sduiPlayWithRewardAvailability
end

local function SduiPlayWithReward(props)
	local configKey = props.sduiContext and props.sduiContext.configKey
	local networking = props.sduiContext
		and props.sduiContext.dependencies
		and props.sduiContext.dependencies.networking
	local v5 = usePlayButtonState(networking, props.universeId)
	local v6 = v5.playButtonState == playButtonStates.Playable
	local v7 = v5.playButtonState ~= playButtonStates.Loading
	local v8 = useNavigationFocus()
	local state, setState = module2.useState(false)

	local state2, setState2 = module2.useState(nil)
	local ref = module2.useRef(false)
	local ref2 = module2.useRef(0)
	local ref3 = module2.useRef(true)

	module2.useEffect(function()
		ref3.current = true
		return function()
			ref3.current = false
		end
	end, {})

	module2.useEffect(function()
		if v8 then
			setState(true)
			return
		end

		ref2.current += 1
		setState2(nil)
	end, { v8 })

	module2.useEffect(function()
		local connection

		if fFlagPlayWithRewardClearOnExperienceLeave then
			connection = ExperienceService:RegisterForExperienceLeave(function()
				ref.current = true
				setState2(nil)
			end)
		else
			connection = nil
		end

		return function()
			setState2(nil)

			if connection then
				connection:Disconnect()
			end
		end
	end, {})

	module2.useLayoutEffect(function()
		if not configKey then
			return
		end

		local sduiClientPageScope = getSduiClientPageScope(configKey)

		local v9 = (tonumber(props.productId) or 0) ~= 0

		if v7 and not v6 or not v9 then
			sduiClientPageScope.set(module6.FilterPlayWithReward, true)
			return
		end

		local v11

		if sduiClientPageScope.get(module6.FilterPlayWithReward) == true then
			v11 = false
		else
			v11 = fFlagPlayWithRewardClearOnExperienceLeave and ref.current
		end

		if state and v6 and v8 or v11 then
			if state2 and state2.universeId == props.universeId then
				return
			end

			if v11 then
				ref.current = false
			end

			setState(false)
			setState2({ universeId = props.universeId })

			local guid = HttpService:GenerateGUID(false)
			local playWithRewardEligible = isPlayWithRewardEligible(AdService, props.universeId)

			sduiClientPageScope.set(module6.PlayWithRewardFlowId, guid)
			local set = sduiClientPageScope.set
			local playWithRewardState = module6.PlayWithRewardState
			local v12 = if playWithRewardEligible then playWithRewardStateValue.Loading else nil
			set(playWithRewardState, v12)

			ref2.current += 1
			local current = ref2.current

			task.spawn(function()
				local v14 = fetchSduiPlayWithRewardAvailability(
					AdService,
					props.universeId,
					guid,
					props.productId,
					props.variantId
				)

				if ref2.current ~= current or not ref3.current then
					return
				end

				if v14 then
					sduiClientPageScope.set(module6.PlayWithRewardState, playWithRewardStateValue.Available)
				elseif playWithRewardEligible then
					sduiClientPageScope.set(
						module6.PlayWithRewardState,
						playWithRewardStateValue.Unavailable
					)
				else
					sduiClientPageScope.set(module6.FilterPlayWithReward, true)
				end
			end)
		else
			if state2 and state2.universeId == props.universeId then
				return
			end

			sduiClientPageScope.set(module6.PlayWithRewardState, nil)
		end
	end, {
		configKey,
		state,
		state2,
		v6,
		v7,
		props.universeId,
		props.productId,
		props.variantId,
		v8
	})

	return module2.createElement(module2.Fragment, nil, props.children)
end

return module2.memo(SduiPlayWithReward)
