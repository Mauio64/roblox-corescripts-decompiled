local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local IconTabGroup = UIBlox.App.Navigation.PrimaryNavBar.IconTabGroup
local Images = UIBlox.App.ImageSet.Images
local FFlagLuaAppSearchStandardizeAssetCategorization = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSearchStandardizeAssetCategorization

local function TenFootUiSearchTypeSelector(t1: {[any]: any}) -- line: 23
	-- upvalues: useDesignTokens (copy), useLocalization (copy), FFlagLuaAppSearchStandardizeAssetCategorization (copy), React (copy), IconTabGroup (copy), Images (copy), SearchTypes (copy)
	local layoutOrder = t1.layoutOrder
	local searchType = t1.searchType
	local onSearchTypeSelected = t1.onSearchTypeSelected
	local v16 = useDesignTokens()
	local v17 = useLocalization({
		players = "CommonUI.Features.Label.Players",
		games = not FFlagLuaAppSearchStandardizeAssetCategorization and "CommonUI.Features.Label.Game" or "CommonUI.Features.Label.Games"
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(v16.LuaApps.Search.SearchHeadingScale, 0, 0, 0),
		Position = UDim2.fromScale(1 - v16.LuaApps.Search.SearchHeadingScale, 0),
		LayoutOrder = layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v16.LuaApps.Search.SearchTypePaddingVertical),
			PaddingBottom = UDim.new(0, v16.LuaApps.Search.SearchTypePaddingVertical)
		}),
		SearchTypeSelector = React.createElement(IconTabGroup, {
			items = {
				{
					title = v17.games,
					icon = Images["icons/common/play"],
					onActivated = function() -- line: 52
						-- upvalues: onSearchTypeSelected (copy), SearchTypes (copy)
						onSearchTypeSelected(SearchTypes.Games)
					end,
					showRoundedBackground = searchType == SearchTypes.Games
				},
				{
					title = v17.players,
					icon = Images["icons/menu/profile"],
					onActivated = function() -- line: 60
						-- upvalues: onSearchTypeSelected (copy), SearchTypes (copy)
						onSearchTypeSelected(SearchTypes.Players)
					end,
					showRoundedBackground = searchType == SearchTypes.Players
				}
			}
		})
	})
end

return TenFootUiSearchTypeSelector
