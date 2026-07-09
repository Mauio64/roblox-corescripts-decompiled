local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Workspace.Packages
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local OmniFeedProps = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.OmniFeedProps
local usePageSideMargin = require(CorePackages.Workspace.Packages.CollectionViews).usePageSideMargin
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local View = Foundation.View
local PromptsHandler = require(Packages.ServerTriggeredModals).PromptsHandler
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: FFlagLuaAppCompositionAlways (copy), OmniFeedProps (copy), React (copy), usePageSideMargin (copy), FFlagHomepagePromptsPaddingFix (copy), useDesignTokens (copy), View (copy), PromptsHandler (copy)
	local v14 = not not FFlagLuaAppCompositionAlways or t1[OmniFeedProps.key].appCompositionEnabled
	local v15 = React.useRef(nil)
	local v16 = nil

	if not FFlagLuaAppCompositionAlways then
		v16 = usePageSideMargin(v15.current)
	end

	local v17 = if not v14 then UDim.new(0, v16) else nil
	local v18 = nil
	local v19 = nil

	if FFlagHomepagePromptsPaddingFix then
		local layoutPadding = useDesignTokens().LuaApps.HomeOmniFeed.getLayoutSpacing(false).layoutPadding

		v18 = t1.topPadding or layoutPadding
		v19 = t1.bottomPadding or layoutPadding
	end

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = {
			left = v17,
			right = v17,
			top = UDim.new(0, 1)
		},
		ref = v15
	}, {
		PromptsHandler = React.createElement(PromptsHandler, {
			entryPoint = t1.entryPoint,
			promptStyle = t1.promptStyle,
			topPadding = if not FFlagHomepagePromptsPaddingFix then nil else v18,
			bottomPadding = if not FFlagHomepagePromptsPaddingFix then nil else v19
		})
	})
end
