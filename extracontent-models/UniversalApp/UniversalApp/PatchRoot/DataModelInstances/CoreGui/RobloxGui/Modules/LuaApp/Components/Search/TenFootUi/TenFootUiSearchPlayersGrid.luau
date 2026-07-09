local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local PlayerSearch = require(Modules.LuaApp.Components.UserSearch.Players.PlayerSearch)
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes

local function TenFootUiSearchPlayersGrid(t1: {[any]: any}) -- line: 18
	-- upvalues: useDesignTokens (copy), SearchTypes (copy), React (copy), HttpService (copy), PlayerSearch (copy)
	local searchKeyword = t1.searchKeyword
	local layoutOrder = t1.layoutOrder
	local searchType = t1.searchType
	local SearchBoxAndTypeOffset = useDesignTokens().LuaApps.Search.SearchBoxAndTypeOffset

	if searchType ~= SearchTypes.Players then
		return React.createElement(React.Fragment, nil, {})
	end

	local v14 = React.useRef(HttpService:GenerateGUID(false))

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -SearchBoxAndTypeOffset),
		LayoutOrder = layoutOrder
	}, {
		["PlayerSearch_" .. searchKeyword] = React.createElement(PlayerSearch, {
			backgroundTransparency = 1,
			enableNewEmptySearchUI = false,
			searchParameters = {
				isKeywordSuggestionEnabled = true,
				searchKeyword = searchKeyword
			},
			searchUuid = v14.current
		})
	})
end

return TenFootUiSearchPlayersGrid
