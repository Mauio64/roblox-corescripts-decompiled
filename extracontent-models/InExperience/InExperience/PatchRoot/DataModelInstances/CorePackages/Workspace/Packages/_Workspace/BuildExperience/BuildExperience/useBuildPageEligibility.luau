local Parent = script:FindFirstAncestor("BuildExperience").Parent
local AmpUpsell = require(Parent.AmpUpsell)
local Navigation = require(Parent.Navigation)
local NavigationRodux = require(Parent.NavigationRodux)
local React = require(Parent.React)
local RobloxAppNavigation = require(Parent.RobloxAppNavigation)
local SharedFlags = require(Parent.SharedFlags)
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigationFocus = Navigation.useNavigationFocus
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local ActionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local NavigationCommands = RobloxAppNavigation.NavigationCommands
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature = SharedFlags.FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature
local FStringCoreContentAmpNameSpace = SharedFlags.FStringCoreContentAmpNameSpace
local v19 = game:DefineFastInt("BuildPolicyRefreshTimeoutMs", 4000)
local v20 = table.freeze({
	Prompting = "Prompting",
	Refreshing = "Refreshing",
	Ineligible = "Ineligible",
	Error = "Error",
	Leaving = "Leaving"
})

local function wasCancelled(t1: {[any]: any}?) -- line: 44
	-- upvalues: ActionStatusEnum (copy)
	if t1 == nil then
		return false
	end

	for _, v24 in t1 do
		if v24 == ActionStatusEnum.Cancelled then
			return true
		end
	end

	return false
end

return {
	Status = v20,
	useBuildPageEligibility = function(b1: boolean) -- line: 58
		-- upvalues: UniversalAppPolicy (copy), useDispatch (copy), useNavigationFocus (copy), React (copy), v20 (copy), FFlagSignalsNavP3Dispatch (copy), NavigationCommands (copy), NavigateBack (copy), v19 (copy), AccessResponseEnum (copy), ActionStatusEnum (copy), OpenAmpWizardContainer (copy), FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature (copy), FStringCoreContentAmpNameSpace (copy)
		local v26, v27 = UniversalAppPolicy.useAppPolicy(function(p1) -- line: 59
			-- upvalues: b1 (copy)
			if not b1 then
				return true, true
			end

			return p1.getCanViewBuild(), p1.getCanUseBuild()
		end)
		local v28 = useDispatch()
		local v29 = useNavigationFocus()
		local v30 = React.useRef(false)
		local v31 = React.useRef(v29)
		local v32 = React.useRef(0)
		local v33, v34 = React.useState(false)
		local v35, v36 = React.useState(v20.Prompting)
		local v37 = React.useCallback(function() -- line: 73
			-- upvalues: v30 (copy), v32 (copy), v34 (copy), v36 (copy), v20 (copy), FFlagSignalsNavP3Dispatch (copy), NavigationCommands (copy), v28 (copy), NavigateBack (copy)
			v30.current = false

			local v43 = v32

			v43.current = v43.current + 1
			v34(false)
			v36(v20.Leaving)

			if FFlagSignalsNavP3Dispatch then
				NavigationCommands.back(true)

				return
			end

			v28(NavigateBack(true))
		end, { v28 })
		local v38 = React.useCallback(function() -- line: 85
			-- upvalues: v34 (copy), v36 (copy), v20 (copy), v32 (copy), v19 (copy), UniversalAppPolicy (copy)
			v34(false)
			v36(v20.Refreshing)

			local v44 = v32

			v44.current = v44.current + 1

			local current = v32.current

			task.delay(v19 / 1000, function() -- line: 91
				-- upvalues: v32 (copy), current (copy), UniversalAppPolicy (copy), v34 (copy), v36 (copy), v20 (copy)
				if v32.current ~= current then
					return
				end

				local v55 = UniversalAppPolicy.getAppFeaturePolicies()
				local v56 = v55.getCanViewBuild()

				if v55.getCanUseBuild() then
					v34(true)

					return
				end

				if not v56 then
					v36(v20.Ineligible)

					return
				end

				v36(v20.Error)
			end)
		end, {})
		local v39 = React.useCallback(function(p2, p3) -- line: 110
			-- upvalues: AccessResponseEnum (copy), v38 (copy), ActionStatusEnum (copy), v37 (copy), v36 (copy), v20 (copy)
			if p2 == AccessResponseEnum.Granted then
				v38()

				return
			end

			local v48, g51

			if p3 == nil then
				v48 = false
			else
				g51 = nil
				v48 = nil

				for _, v50 in p3 do
					if v50 == ActionStatusEnum.Cancelled then
						v48 = true
						g51 = true
					end

					if g51 then
						break
					end
				end

				if not g51 then
					v48 = false
				end
			end

			g51 = false

			if v48 then
				v37()

				return
			end

			v36(v20.Error)
		end, {
			v38,
			v37
		})

		React.useEffect(function() -- line: 120
			-- upvalues: v31 (copy), v29 (copy), v35 (copy), v20 (copy), v30 (copy), v36 (copy)
			local current = v31.current

			v31.current = v29

			if v29 and (not current and v35 == v20.Prompting) then
				v30.current = false

				return
			end

			if v29 and not current and v35 == v20.Leaving then
				v30.current = false
				v36(v20.Prompting)
			end
		end, {
			v29,
			v35
		})
		React.useEffect(function() -- line: 132
			-- upvalues: b1 (copy), v27 (copy), v32 (copy), v30 (copy), v34 (copy), v36 (copy), v20 (copy), v26 (copy)
			if not b1 then
				return
			end

			if v27 then
				local v53 = v32

				v53.current = v53.current + 1
				v30.current = false
				v34(false)
				v36(v20.Prompting)

				return
			end

			if not v26 then
				local v54 = v32

				v54.current = v54.current + 1
				v34(false)
				v36(v20.Ineligible)
			end
		end, {
			v26,
			v27,
			b1
		})
		React.useEffect(function() -- line: 150
			-- upvalues: b1 (copy), v29 (copy), v35 (copy), v20 (copy), v27 (copy), v26 (copy), v30 (copy), v28 (copy), OpenAmpWizardContainer (copy), FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature (copy), v39 (copy), FStringCoreContentAmpNameSpace (copy)
			if not b1 or (not v29 or v35 ~= v20.Prompting or v27 or not v26 or v30.current) then
				return
			end

			v30.current = true
			v28(OpenAmpWizardContainer(FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature, v39, nil, "BuildPage", nil, FStringCoreContentAmpNameSpace))
		end, {
			v26,
			v27,
			v28,
			b1,
			v39,
			v29,
			v35
		})
		React.useEffect(function() -- line: 185
			-- upvalues: v32 (copy)
			return function() -- line: 186
				-- upvalues: v32 (copy)
				local v57 = v32

				v57.current = v57.current + 1
			end
		end, {})

		local v40 = not b1 or (v27 or v33)
		local v41 = if v40 or v26 then v35 else v20.Ineligible

		return {
			canEnterBuild = v40,
			status = v41,
			onDialogDismiss = v37
		}
	end
}
