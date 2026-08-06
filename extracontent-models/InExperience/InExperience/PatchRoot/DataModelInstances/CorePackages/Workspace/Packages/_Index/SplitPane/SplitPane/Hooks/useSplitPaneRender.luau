local Parent = script:FindFirstAncestor("SplitPane").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local AppSplitView = require(Parent.AppSplitView)
local Constants = require(Parent.NavigationRodux).Constants
local SplitPaneContext = require(script.Parent.Parent.Context.SplitPaneContext)
local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)
local SupportPaneMode = AppSplitView.Enums.SupportPaneMode
local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName

local function useSplitPaneRender(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, b1: boolean) -- line: 41
	-- upvalues: SplitPaneStore (copy), SignalsReact (copy), React (copy), SplitPaneContext (copy), TempRnSwitchNavigatorName (copy), SupportPaneMode (copy)
	local v15 = SplitPaneStore.getStore()
	local v16 = SignalsReact.useSignalState(v15.getSupportPaneMode)
	local v17 = SignalsReact.useSignalState(v15.getSupportWidth)
	local v18 = SignalsReact.useSignalState(v15.getIsBreakpointEnabled)
	local v19 = React.useContext(SplitPaneContext)
	local v20 = not b1 and 0 or #t3
	local v21 = table.clone(t2)
	local t4 = {}
	local t5 = {}

	if b1 then
		for _, v25 in t3 do
			local key = t1[v25].descriptor.key
			local v27 = v21[key]

			if v27 ~= nil then
				v21[key] = nil
				t4[key] = v27
			end
		end
	end

	if v18 then
		local n1 = 0

		for v29, v30 in t1 do
			local options = v30.descriptor.options

			if options ~= nil and options.splitPaneEligibility ~= nil then
				n1 = v29
			end
		end

		for v32, v33 in t1 do
			local options = v33.descriptor.options

			if options ~= nil and options.transparent and not options.overlayEnabled and options.splitPaneEligibility == nil then
				local key = v33.descriptor.key
				local v36 = v21[key]

				if v36 ~= nil then
					v21[key] = nil

					if n1 < v32 then
						t5[key] = v36
					end
				end
			end
		end
	end

	local v37 = t1[1] ~= nil and (t1[1].descriptor ~= nil and (t1[1].descriptor.state ~= nil and t1[1].descriptor.state.routeName == TempRnSwitchNavigatorName))
	local v38 = React.useRef(0)

	React.useEffect(function() -- line: 107
		-- upvalues: v38 (copy), v20 (copy), v37 (copy), v16 (copy), SupportPaneMode (copy), v15 (copy)
		local current = v38.current

		v38.current = v20

		if not v37 or v16 == SupportPaneMode.Normal then
			return
		end

		local v43 = current > 0 and v20 == 0
		local v44 = current == 0 and v20 > 0

		if v43 or v44 then
			v15.setSupportPaneMode(SupportPaneMode.Normal)
		end
	end, {
		v37,
		v20,
		v15,
		v16
	})

	local v39 = if not (v20 > 0) then nil else t3[v20]
	local v40 = if v39 == nil then {} else t1[v39].descriptor.options
	local t6 = {
		hostNavigation = if v39 == nil then nil else t1[v39].descriptor.navigation,
		hasDetailOnTop = v39 ~= nil,
		paneCount = v20,
		splitPaneExpandable = v40.splitPaneExpandable,
		splitPaneCollapsible = v40.splitPaneCollapsible
	}

	return {
		primarySlotChildren = v21,
		supportSlotChildren = t4,
		overlaySlotChildren = t5,
		supportContentProps = t6,
		supportWidth = v17,
		supportMinWidth = v15.getMinSupportWidth(),
		supportMaxWidth = v15.getMaxSupportWidth(),
		onSupportPaneWidthChanged = v15.setSupportWidth,
		supportPaneMode = v16,
		supportPaneResizable = v19.supportPaneResizable == true,
		isBreakpointEnabled = v18,
		renderSupportContent = v19.renderSupportContent,
		onContentRegionRectChanged = v19.onContentRegionRectChanged
	}
end

return useSplitPaneRender
