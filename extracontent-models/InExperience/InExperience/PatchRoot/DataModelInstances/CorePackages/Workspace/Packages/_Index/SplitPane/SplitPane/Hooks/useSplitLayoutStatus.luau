local Parent = script:FindFirstAncestor("SplitPane").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local SignalsReact = require(Parent.SignalsReact)
local AppSplitView = require(Parent.AppSplitView)
local ViewState = require(Parent.Navigation).ViewState
local Constants = require(Parent.NavigationRodux).Constants
local SplitPaneContext = require(script.Parent.Parent.Context.SplitPaneContext)
local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)
local computeSplitEligibility = require(script.Parent.Parent.Utils.computeSplitEligibility)
local SupportPaneMode = AppSplitView.Enums.SupportPaneMode
local SplitPaneSlot = AppSplitView.Enums.SplitPaneSlot
local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName

local function useSplitLayoutStatus(t1: {[any]: any}, n1: number) -- line: 26
	-- upvalues: SplitPaneStore (copy), SignalsReact (copy), computeSplitEligibility (copy), React (copy), SplitPaneContext (copy), TempRnSwitchNavigatorName (copy), SplitPaneSlot (copy), ViewState (copy), RoactNavigation (copy), SupportPaneMode (copy)
	local v17 = SplitPaneStore.getStore()
	local v18 = SignalsReact.useSignalState(v17.getIsBreakpointEnabled)
	local v19 = computeSplitEligibility(t1)
	local v20 = v18 and v19
	local v21 = React.useContext(SplitPaneContext).renderSupportContent ~= nil
	local v22 = t1[1] ~= nil and (t1[1].descriptor ~= nil and (t1[1].descriptor.state ~= nil and t1[1].descriptor.state.routeName == TempRnSwitchNavigatorName))
	local t2 = {}
	local v24 = nil
	local v25 = false

	if v20 then
		for i = #t1, 1, -1 do
			if t1[i].descriptor.options.splitPaneEligibility ~= SplitPaneSlot.Support then
				if not (#t2 > 0) then
					continue
				end

				v24 = i

				break
			end

			table.insert(t2, 1, i)
		end
	elseif not v18 then
		for _, v28 in t1 do
			if v28.descriptor.options.splitPaneEligibility == SplitPaneSlot.Support and v28.viewState ~= ViewState.Closing then
				v25 = true

				break
			end
		end
	end

	local v29 = #t2
	local v30 = v24 ~= nil and v29 > 0
	local v31 = n1 >= 1
	local v32 = v25 or (v30 or v20 and (v21 and v31))

	React.useEffect(function() -- line: 72
		-- upvalues: v22 (copy), v17 (copy), v19 (copy), t1 (copy), SplitPaneSlot (copy), RoactNavigation (copy)
		if not v22 then
			return
		end

		local v33 = v17.getIsSplitEligible(false)

		v17.setIsSplitEligible(v19)

		if not v33 or v19 then
			return
		end

		local descriptor = t1[1].descriptor

		if descriptor == nil or descriptor.navigation == nil then
			return
		end

		local navigation = descriptor.navigation

		for i = #t1, 2, -1 do
			local descriptor2 = t1[i].descriptor

			if descriptor2 ~= nil then
				local splitPaneEligibility = descriptor2.options.splitPaneEligibility

				if splitPaneEligibility ~= nil and splitPaneEligibility ~= SplitPaneSlot.Content then
					local v39 = descriptor2.state ~= nil and descriptor2.state.key or nil

					if v39 ~= nil then
						navigation.dispatch(RoactNavigation.StackActions.pop({
							prune = false,
							immediate = true,
							key = v39
						}))
					end
				end
			end
		end
	end, {
		v22,
		v19,
		t1,
		v17
	})
	React.useEffect(function() -- line: 109
		-- upvalues: v32 (copy), v22 (copy), v17 (copy), SupportPaneMode (copy), t1 (copy), ViewState (copy), SplitPaneSlot (copy)
		if v32 then
			return
		end

		if v22 and v17.getSupportPaneMode(false) ~= SupportPaneMode.Normal then
			v17.setSupportPaneMode(SupportPaneMode.Normal)
		end

		for _, v41 in t1 do
			if v41.viewState == ViewState.Closing and v41.descriptor.options.splitPaneEligibility == SplitPaneSlot.Support then
				v41.setClosed()
			end
		end
	end, {
		v22,
		v32,
		t1,
		v17
	})

	return {
		isSplitLayoutEnabled = v32,
		isRouteActiveOnPane = v30,
		paneIndices = t2
	}
end

return useSplitLayoutStatus
