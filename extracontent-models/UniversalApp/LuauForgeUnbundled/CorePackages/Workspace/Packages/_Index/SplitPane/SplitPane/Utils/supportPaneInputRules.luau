local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Responsive")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags")

local SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore")

local supportPaneMode = AppSplitView.Enums.SupportPaneMode

local fFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled

return {
	resolveOpenedMode = function(p2)
		if p2 == Responsive.Input.Directional or not fFlagLuaAppSduiEdpEnabled then
			return supportPaneMode.Expanded
		end

		return supportPaneMode.Normal
	end,
	resolveInputChangedMode = function(p2)
		if p2 == Responsive.Input.Directional then
			return supportPaneMode.Expanded
		end

		return SplitPaneStore.getStore().getSupportPaneMode()
	end,
	expandSupportPaneIfCollapsed = function()
		local store = SplitPaneStore.getStore()

		if store.getSupportPaneModeIfActive(false) == supportPaneMode.Collapsed then
			local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)
			local setTemporarySupportPaneMode = store.setTemporarySupportPaneMode
			local v5 = if preferredInputType == Responsive.Input.Directional or not fFlagLuaAppSduiEdpEnabled then supportPaneMode.Expanded else supportPaneMode.Normal

			setTemporarySupportPaneMode(v5)
		end
	end
}
