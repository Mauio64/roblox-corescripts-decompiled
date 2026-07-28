local Parent = script:FindFirstAncestor("SplitPane").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local AppSplitView = require(Parent.AppSplitView)
local Constants = require(Parent.NavigationRodux).Constants
local SplitPaneContext = require(script.Parent.Parent.Context.SplitPaneContext)
local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)
local SupportPaneMode = AppSplitView.Enums.SupportPaneMode
local TempRnSwitchNavigatorName = Constants.TempRnSwitchNavigatorName

local function useSplitPaneRender(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, b1: boolean) -- line: 40
	-- upvalues: SplitPaneStore (copy), SignalsReact (copy), React (copy), SplitPaneContext (copy), TempRnSwitchNavigatorName (copy), SupportPaneMode (copy)
	local v15 = SplitPaneStore.getStore()
	local v16 = SignalsReact.useSignalState(v15.getSupportPaneMode)
	local v17 = SignalsReact.useSignalState(v15.getSupportWidth)
	local v18 = SignalsReact.useSignalState(v15.getIsBreakpointEnabled)
	local v19 = React.useContext(SplitPaneContext)
	local v20 = not b1 and 0 or #t3
	local v21 = table.clone(t2)
	local t4 = {}

	if b1 then
		for _, v24 in t3 do
			local key = t1[v24].descriptor.key
			local v26 = v21[key]

			if v26 ~= nil then
				v21[key] = nil
				t4[key] = v26
			end
		end
	end

	local v27 = t1[1] ~= nil and (t1[1].descriptor ~= nil and (t1[1].descriptor.state ~= nil and t1[1].descriptor.state.routeName == TempRnSwitchNavigatorName))
	local v28 = React.useRef(0)

	React.useEffect(function() -- line: 72
		-- upvalues: v28 (copy), v20 (copy), v27 (copy), v16 (copy), SupportPaneMode (copy), v15 (copy)
		local current = v28.current

		v28.current = v20

		if not v27 or v16 == SupportPaneMode.Normal then
			return
		end

		local v33 = current > 0 and v20 == 0
		local v34 = current == 0 and v20 > 0

		if v33 or v34 then
			v15.setSupportPaneMode(SupportPaneMode.Normal)
		end
	end, {
		v27,
		v20,
		v15,
		v16
	})

	local v29 = if not (v20 > 0) then nil else t3[v20]
	local v30 = if v29 == nil then {} else t1[v29].descriptor.options
	local t5 = {
		hostNavigation = if v29 == nil then nil else t1[v29].descriptor.navigation,
		hasDetailOnTop = v29 ~= nil,
		paneCount = v20,
		splitPaneExpandable = v30.splitPaneExpandable,
		splitPaneCollapsible = v30.splitPaneCollapsible
	}

	return {
		primarySlotChildren = v21,
		supportSlotChildren = t4,
		supportContentProps = t5,
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
