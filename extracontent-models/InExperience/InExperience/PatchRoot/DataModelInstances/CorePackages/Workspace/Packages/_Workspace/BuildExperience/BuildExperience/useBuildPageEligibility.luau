local parent = script:FindFirstAncestor("BuildExperience").Parent

local AmpUpsell = require(parent.AmpUpsell)
local Navigation = require(parent.Navigation)
local NavigationRodux = require(parent.NavigationRodux)
local React = require(parent.React)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local SharedFlags = require(parent.SharedFlags)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigationFocus = Navigation.useNavigationFocus

local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local ActionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local NavigationCommands = RobloxAppNavigation.NavigationCommands

local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature = SharedFlags.FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature
local FStringCoreContentAmpNameSpace = SharedFlags.FStringCoreContentAmpNameSpace
local defineFastInt = game:DefineFastInt("BuildPolicyRefreshTimeoutMs", 4000)

local frozen = table.freeze({
	Prompting = "Prompting",
	Refreshing = "Refreshing",
	Ineligible = "Ineligible",
	Error = "Error",
	Leaving = "Leaving"
})

local function wasCancelled(items): boolean -- 1 equivalent call inferred from this helper
	if items == nil then
		return false
	end

	for _, item in items do
		if item == ActionStatusEnum.Cancelled then
			return true
		end
	end

	return false
end

return {
	Status = frozen,
	useBuildPageEligibility = function(flag: boolean)
		local v, v2 = UniversalAppPolicy.useAppPolicy(function(p)
			if flag then
				return p.getCanViewBuild(), p.getCanUseBuild()
			end

			return true, true
		end)

		local v3 = useDispatch()
		local current2 = useNavigationFocus()
		local ref = React.useRef(false)
		local ref2 = React.useRef(current2)
		local ref3 = React.useRef(0)
		local state, setState = React.useState(false)
		local state2, setState2 = React.useState(frozen.Prompting)

		local onDialogDismiss = React.useCallback(function()
			ref.current = false
			ref3.current += 1
			setState(false)
			setState2(frozen.Leaving)

			if FFlagSignalsNavP3Dispatch then
				NavigationCommands.back(true)
			else
				v3(NavigateBack(true))
			end
		end, { v3 })

		local v4 = React.useCallback(function()
			setState(false)
			setState2(frozen.Refreshing)
			ref3.current += 1
			local current = ref3.current

			task.delay(defineFastInt / 1000, function()
				if ref3.current ~= current then
					return
				end

				local appFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies()
				local canViewBuild = appFeaturePolicies.getCanViewBuild()

				if appFeaturePolicies.getCanUseBuild() then
					setState(true)
				elseif canViewBuild then
					setState2(frozen.Error)
				else
					setState2(frozen.Ineligible)
				end
			end)
		end, {})

		local v5 = React.useCallback(function(p, items)
			if p == AccessResponseEnum.Granted then
				v4()
			elseif wasCancelled(items) then -- inferred equivalent call
				onDialogDismiss()
			else
				setState2(frozen.Error)
			end
		end, { v4, onDialogDismiss })

		React.useEffect(function()
			local current = ref2.current
			ref2.current = current2

			if current2 and not current and state2 == frozen.Prompting then
				ref.current = false
			elseif current2 and not current and state2 == frozen.Leaving then
				ref.current = false
				setState2(frozen.Prompting)
			end
		end, { current2, state2 })

		React.useEffect(function()
			if not flag then
				return
			end

			if v2 then
				ref3.current += 1
				ref.current = false
				setState(false)
				setState2(frozen.Prompting)
			elseif not v then
				ref3.current += 1
				setState(false)
				setState2(frozen.Ineligible)
			end
		end, { v, v2, flag })

		React.useEffect(function()
			if not flag or not current2 or state2 ~= frozen.Prompting or v2 or not v or ref.current then
				return
			end

			ref.current = true
			v3(OpenAmpWizardContainer(
				FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature,
				v5,
				nil,
				"BuildPage",
				nil,
				FStringCoreContentAmpNameSpace
			))
		end, { v, v2, v3, flag, v5, current2, state2 })

		React.useEffect(function()
			return function()
				ref3.current += 1
			end
		end, {})
		local canEnterBuild = not flag or v2 or state
		local status

		if canEnterBuild or v then
			status = state2
		else
			status = frozen.Ineligible
		end

		return { canEnterBuild = canEnterBuild, status = status, onDialogDismiss = onDialogDismiss }
	end
}
