local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/gTW")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local fFlagAXFixEmptyCatalogSearchChrome = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixEmptyCatalogSearchChrome

local function WidgetListResultsHeader(props)
	local v5 = useTokens()

	local udim = if not props.pillBarVisible then UDim.new(0, v5.Size.Size_500) else nil

	if fFlagAXFixEmptyCatalogSearchChrome then
		udim = if not props.pillBarVisible then UDim.new(0, v5.Size.Size_300) else nil
	end

	local createElement = React.createElement
	local v7 = { AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 }

	local v8 = {
		UIListLayout = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v5.Size.Size_300),
			PaddingTop = udim
		}),
		ResultsHeader = 0
	}

	local v9 = if not props.hideResultsHeader then React.createElement(module, {
		searchUuid = props.searchUuid
	}) else nil
	v8.ResultsHeader = v9
	return createElement("Frame", v7, v8)
end

return WidgetListResultsHeader
