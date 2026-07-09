local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local SearchBar = require(Modules.LuaApp.Components.SearchBar)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Panel3D = UIBlox.Core.VR.Panel3D
local CurrentTabContext = require(Modules.LuaApp.Navigation.CurrentTabContext)
local SwitchNavigatorVisibleContext = require(Modules.LuaApp.Navigation.SwitchNavigatorVisibleContext)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local HeaderBar = UIBlox.App.Bar.HeaderBar
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useStyle = UIBlox.Core.Style.useStyle
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local SegmentedControl = UIBlox.App.Control.SegmentedControl
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local VR = Constants.VR
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)
local catalogSearchEvent = require(Modules.LuaApp.Analytics.Events.catalogSearchEvent)
local ROUNDED_CORNER_RADIUS = require(Modules.LuaApp.Constants).ROUNDED_CORNER_RADIUS
local v31 = Images["icons/navigation/pushBack"]
local v32 = Images["icons/common/search"]
local v33 = Images["icons/menu/customize"]
local v34 = Images["icons/menu/shop"]
local t1 = {
	AvatarScreen.AvatarEditor,
	AvatarScreen.Catalog
}
local t2 = {
	[AvatarScreen.AvatarEditor] = 1,
	[AvatarScreen.MySharedAvatars] = 1,
	[AvatarScreen.CatalogSearch] = 2,
	[AvatarScreen.Catalog] = 2
}

return function(t3: {[any]: any}) -- line: 68
	-- upvalues: React (copy), useDispatch (copy), useRoactService (copy), AppEventIngestService (copy), useStyle (copy), useLocalization (copy), IconButton (copy), v31 (copy), IconSize (copy), SearchUuid (copy), SetSearchType (copy), SearchTypes (copy), SetSearchParameters (copy), AvatarScreen (copy), catalogSearchEvent (copy), NavigationUtils (copy), SearchBar (copy), ROUNDED_CORNER_RADIUS (copy), SegmentedControl (copy), t2 (copy), t1 (copy), v33 (copy), v34 (copy), v32 (copy), CurrentTabContext (copy), SwitchNavigatorVisibleContext (copy), Panel3D (copy), VR (copy), withLocalization (copy), HeaderBar (copy)
	local v38, v39 = React.useState(false)
	local v40 = useDispatch()
	local v41 = useRoactService(AppEventIngestService)
	local v42 = useStyle()
	local v43 = useLocalization({
		shop = "Feature.Avatar.Action.Shop",
		customize = "Feature.Catalog.Action.Customize",
		searchPlaceholder = "Search.GlobalSearch.Example.SearchCatalog"
	})
	local v44 = React.useCallback(function(p1, p2, p3) -- line: 97
		-- upvalues: SearchUuid (copy), v40 (copy), SetSearchType (copy), SearchTypes (copy), SetSearchParameters (copy), AvatarScreen (copy), catalogSearchEvent (copy), v41 (copy), NavigationUtils (copy), t3 (copy), v39 (copy)
		local v53 = SearchUuid()
		local t4 = {
			isKeywordSuggestionEnabled = true,
			searchKeyword = p1
		}

		v40(SetSearchType(v53, SearchTypes.Catalog))
		v40(SetSearchParameters(v53, t4))

		local CatalogSearch = AvatarScreen.CatalogSearch

		catalogSearchEvent(v41, "catalog", p1, p2, CatalogSearch, p3)
		NavigationUtils.navigateToSearch(t3.navigation, v53, t4)
		v39(false)
	end)
	local u45 = nil
	local u46 = nil
	local u47 = nil
	local s1 = nil

	if v38 then
		u46 = React.createElement(SearchBar, {
			modernUI = true,
			onFocused = nil,
			onTextCleared = nil,
			isCompactView = false,
			autocomplete = true,
			Size = UDim2.new(1, 0, 1, -ROUNDED_CORNER_RADIUS),
			cancelSearch = function() -- line: 131
				-- upvalues: v39 (copy)
				v39(false)
			end,
			confirmSearch = v44,
			placeholderText = v43.searchPlaceholder,
			searchType = SearchTypes.Catalog,
			isSearching = v38
		})
	elseif t3.currentPage == AvatarScreen.LayeredClothingSort then
		u45 = (function(p4: ((...any) -> ...any)) -- line: 79
			-- upvalues: React (copy), IconButton (copy), v31 (copy), IconSize (copy), v42 (copy)
			return React.createElement(IconButton, {
				layoutOrder = 1,
				showBackground = true,
				size = UDim2.fromOffset(58, 58),
				icon = v31,
				iconSize = IconSize.Medium,
				iconColor3 = v42.Theme.SystemPrimaryDefault.Color,
				iconTransparency = v42.Theme.SystemPrimaryDefault.Transparency,
				backgroundColor = {
					Color = v42.Theme.BackgroundUIDefault.Color,
					Transparency = v42.Theme.BackgroundUIDefault.Transparency
				},
				onActivated = p4
			})
		end)(function() -- line: 144
			-- upvalues: t3 (copy), AvatarScreen (copy)
			t3.navigation.navigate(AvatarScreen.Catalog)
		end)
		s1 = "Feature.Avatar.Title.LCSortPage"
	else
		u46 = React.createElement(SegmentedControl, {
			layoutOrder = 2,
			height = 58,
			selectedTabIndex = t2[t3.currentPage] or 1,
			onTabActivated = function(p5) -- line: 152
				-- upvalues: t3 (copy), t1 (copy)
				t3.navigation.navigate(t1[p5])
			end,
			tabs = {
				{
					tabName = v43.customize,
					icon = v33
				},
				{
					tabName = v43.shop,
					icon = v34
				}
			},
			width = UDim.new(0, 350)
		})
		u47 = if t2[t3.currentPage] ~= 2 then nil else React.createElement(IconButton, {
			layoutOrder = 3,
			showBackground = true,
			size = UDim2.fromOffset(58, 58),
			icon = v32,
			iconSize = IconSize.Medium,
			iconColor3 = v42.Theme.SystemPrimaryDefault.Color,
			iconTransparency = v42.Theme.SystemPrimaryDefault.Transparency,
			backgroundColor = {
				Color = v42.Theme.BackgroundUIDefault.Color,
				Transparency = v42.Theme.BackgroundUIDefault.Transparency
			},
			onActivated = function() -- line: 182
				-- upvalues: v39 (copy)
				v39(true)
			end
		})
	end

	return React.createElement(CurrentTabContext.Consumer, {
		render = function(p6) -- line: 190
			-- upvalues: React (copy), SwitchNavigatorVisibleContext (copy), Panel3D (copy), VR (copy), AvatarScreen (copy), v42 (copy), ROUNDED_CORNER_RADIUS (copy), withLocalization (copy), s1 (ref), HeaderBar (copy), u45 (ref), u46 (ref), u47 (ref)
			return React.createElement(SwitchNavigatorVisibleContext.Consumer, {
				render = function(p7) -- line: 192
					-- upvalues: React (copy), Panel3D (copy), VR (copy), p6 (copy), AvatarScreen (copy), v42 (copy), ROUNDED_CORNER_RADIUS (copy), withLocalization (copy), s1 (ref), HeaderBar (copy), u45 (ref), u46 (ref), u47 (ref)
					return React.createElement(Panel3D, {
						panelName = "AvatarNavBarVR",
						partSize = VR.AvatarEditorNavBarSize,
						offset = CFrame.lookAt(VR.AvatarEditorNavBarPosition, VR.AvatarEditorNavBarOrientation),
						virtualScreenSize = VR.AvatarEditorNavBarResolution,
						hidden = not p7 or p6 ~= AvatarScreen.AvatarExperienceRoot
					}, {
						RoundedFrame = React.createElement("Frame", {
							BackgroundTransparency = 0,
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundColor3 = v42.Theme.BackgroundDefault.Color
						}, {
							UICorner = React.createElement("UICorner", {
								CornerRadius = UDim.new(0, ROUNDED_CORNER_RADIUS)
							}),
							UIPadding = React.createElement("UIPadding", {
								PaddingRight = UDim.new(0, ROUNDED_CORNER_RADIUS),
								PaddingLeft = UDim.new(0, ROUNDED_CORNER_RADIUS)
							}),
							HeaderBar = withLocalization({
								title = s1
							})(function(p8) -- line: 217
								-- upvalues: React (copy), HeaderBar (copy), VR (copy), u45 (ref), u46 (ref), u47 (ref), s1 (ref)
								return React.createElement(HeaderBar, {
									backgroundTransparency = 0,
									barHeight = VR.AvatarEditorNavBarResolution.Y,
									renderLeft = if not u45 then nil else function() -- line: 222
										-- upvalues: u45 (ref)
										return u45
									end,
									renderCenter = u46 and function() -- line: 226
										-- upvalues: u46 (ref)
										return u46
									end or nil,
									renderRight = u47 and function() -- line: 229
										-- upvalues: u47 (ref)
										return u47
									end or nil,
									title = s1 and p8.title or nil
								})
							end)
						})
					})
				end
			})
		end
	})
end
