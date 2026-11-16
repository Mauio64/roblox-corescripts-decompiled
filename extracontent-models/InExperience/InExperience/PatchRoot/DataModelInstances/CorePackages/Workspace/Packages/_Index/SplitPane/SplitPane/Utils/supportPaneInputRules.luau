local parent = script:FindFirstAncestor("SplitPane").Parent

local AppSplitView = require(parent.AppSplitView)
local Responsive = require(parent.Responsive)
local SharedFlags = require(parent.SharedFlags)

local SplitPaneStore = require(script.Parent.Parent.Stores.SplitPaneStore)

local SupportPaneMode = AppSplitView.Enums.SupportPaneMode

local FFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled

local function resolveOpenedMode(preferredInputType) -- 1 equivalent call inferred from this helper
	if preferredInputType == Responsive.Input.Directional or not FFlagLuaAppSduiEdpEnabled then
		return SupportPaneMode.Expanded
	end

	return SupportPaneMode.Normal
end

local SupportPaneInputRules = {}
SupportPaneInputRules.resolveOpenedMode = resolveOpenedMode

function SupportPaneInputRules.resolveInputChangedMode(p)
	if p == Responsive.Input.Directional then
		return SupportPaneMode.Expanded
	end

	return SplitPaneStore.getStore().getSupportPaneMode()
end

function SupportPaneInputRules.expandSupportPaneIfCollapsed()
	local store = SplitPaneStore.getStore()

	if store.getSupportPaneModeIfActive(false) == SupportPaneMode.Collapsed then
		local preferredInputType = Responsive.GetInputModeStore(false).getPreferredInputType(false)
		store.setTemporarySupportPaneMode(resolveOpenedMode(preferredInputType)) -- inferred equivalent call
	end
end

return SupportPaneInputRules
