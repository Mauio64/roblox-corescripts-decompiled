local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ResultsHeader = require(Modules.AvatarExperience.Catalog.Components.Search.ResultsHeader)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens

local function WidgetListResultsHeader(t1: {[any]: any}) -- line: 15
	-- upvalues: useTokens (copy), React (copy), ResultsHeader (copy)
	local v8 = useTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		UIListLayout = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v8.Size.Size_300),
			PaddingTop = if t1.pillBarVisible then nil else UDim.new(0, v8.Size.Size_500)
		}),
		ResultsHeader = if not t1.hideResultsHeader then React.createElement(ResultsHeader, {
			searchUuid = t1.searchUuid
		}) else nil
	})
end

return WidgetListResultsHeader
