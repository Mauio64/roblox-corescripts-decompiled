local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AmpUpsell")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Navigation")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/NavigationRodux")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RobloxAppNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UniversalAppPolicy")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigationFocus = Navigation.useNavigationFocus

local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local actionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local openAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local navigateBack = NavigationRodux.Thunks.NavigateBack
local navigationCommands = RobloxAppNavigation.NavigationCommands

local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fStringTriggerAgeCheckUpsellIncludingVPCAmpFeature = SharedFlags.FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature
local fStringCoreContentAmpNameSpace = SharedFlags.FStringCoreContentAmpNameSpace
local defineFastInt = game:DefineFastInt("BuildPolicyRefreshTimeoutMs", 4000)

local frozen = table.freeze({
	Prompting = "Prompting",
	Refreshing = "Refreshing",
	Ineligible = "Ineligible",
	Error = "Error",
	Leaving = "Leaving"
})

local function wasCancelled(items): boolean
	if items == nil then
		return false
	end

	for k, item in items do
		if item == actionStatusEnum.Cancelled then
			return true
		end
	end

	return false
end

return {
	Status = frozen,
	useBuildPageEligibility = function(p2)
		local v5, v6 = UniversalAppPolicy.useAppPolicy(function(p3)
			if p2 then
				return p3.getCanViewBuild(), p3.getCanUseBuild()
			end

			return true, true
		end)

		local v7 = useDispatch()
		local v8 = useNavigationFocus()
		local ref = React.useRef(false)
		local ref2 = React.useRef(v8)
		local ref3 = React.useRef(0)
		local state, setState = React.useState(false)
		local state2, setState2 = React.useState(frozen.Prompting)

		local v9 = React.useCallback(function()
			ref.current = false
			ref3.current += 1
			setState(false)
			setState2(frozen.Leaving)

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back(true)
			else
				v7(navigateBack(true))
			end
		end, { v7 })

		local v10 = React.useCallback(function()
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

		local v11 = React.useCallback(function(p3, items)
			if p3 == accessResponseEnum.Granted then
				v10()
				return
			end

			local flag

			if items == nil then
				flag = false
			else
				local flag2 = true

				for k, item in items do
					if item == actionStatusEnum.Cancelled then
						flag = true
						flag2 = false
						break
					end
				end

				if flag2 then
					flag = false
				end
			end

			if flag then
				v9()
			else
				setState2(frozen.Error)
			end
		end, { v10, v9 })

		React.useEffect(function()
			local current = ref2.current
			ref2.current = v8

			if v8 and not current and state2 == frozen.Prompting then
				ref.current = false
			elseif v8 and not current and state2 == frozen.Leaving then
				ref.current = false
				setState2(frozen.Prompting)
			end
		end, { v8, state2 })

		React.useEffect(function()
			if not p2 then
				return
			end

			if v6 then
				ref3.current += 1
				ref.current = false
				setState(false)
				setState2(frozen.Prompting)
			elseif not v5 then
				ref3.current += 1
				setState(false)
				setState2(frozen.Ineligible)
			end
		end, { v5, v6, p2 })

		React.useEffect(function()
			if not p2 or not v8 or state2 ~= frozen.Prompting or v6 or not v5 or ref.current then
				return
			end

			ref.current = true
			v7(openAmpWizardContainer(
				fStringTriggerAgeCheckUpsellIncludingVPCAmpFeature,
				v11,
				nil,
				"BuildPage",
				nil,
				fStringCoreContentAmpNameSpace
			))
		end, { v5, v6, v7, p2, v11, v8, state2 })

		React.useEffect(function()
			return function()
				ref3.current += 1
			end
		end, {})
		local v12 = not p2 or v6 or state
		local v13 = if v12 or v5 then state2 else frozen.Ineligible

		return { canEnterBuild = v12, status = v13, onDialogDismiss = v9 }
	end
}
