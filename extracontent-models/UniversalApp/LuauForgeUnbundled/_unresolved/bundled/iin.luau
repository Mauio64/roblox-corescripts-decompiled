local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local omniFeedProps = require("@luauforge/bundled/dpZ").Modules.Personalization.OmniFeed.OmniFeedProps
local usePageSideMargin = require("@luauforge/bundled/edJ").usePageSideMargin
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local view = Foundation.View

local promptsHandler = require("@luauforge/bundled/ftU").PromptsHandler

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagHomepagePromptsPaddingFix = SharedFlags.FFlagHomepagePromptsPaddingFix

return function(data)
	local v5 = fFlagLuaAppCompositionAlways and true or data[omniFeedProps.key].appCompositionEnabled

	local ref = React.useRef(nil)

	local v6 = if not fFlagLuaAppCompositionAlways then usePageSideMargin(ref.current) else nil

	local udim = if not v5 then UDim.new(0, v6) else nil
	local topPadding, bottomPadding

	if fFlagHomepagePromptsPaddingFix then
		local layoutPadding = useDesignTokens().LuaApps.HomeOmniFeed.getLayoutSpacing(false).layoutPadding
		topPadding = data.topPadding or layoutPadding
		bottomPadding = data.bottomPadding or layoutPadding
	end

	local createElement = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = { left = udim, right = udim, top = UDim.new(0, 1) },
		ref = ref
	}

	local createElement2 = React.createElement
	local v11 = {
		entryPoint = data.entryPoint,
		promptStyle = data.promptStyle,
		topPadding = 0,
		bottomPadding = 0
	}

	if not fFlagHomepagePromptsPaddingFix then
		topPadding = nil
	end

	v11.topPadding = topPadding

	if not fFlagHomepagePromptsPaddingFix then
		bottomPadding = nil
	end

	v11.bottomPadding = bottomPadding
	return createElement(view, v8, {
		PromptsHandler = createElement2(promptsHandler, v11)
	})
end
