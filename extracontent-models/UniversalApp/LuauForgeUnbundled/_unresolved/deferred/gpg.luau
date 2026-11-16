local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dMx")
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local module2 = require("@luauforge/bundled/fpz")
local searchUuid = require("@luauforge/bundled/dOk").SearchUuid
local module3 = require("@luauforge/bundled/dTM")
local panel3D = UIBlox.Core.VR.Panel3D
local module4 = require("@luauforge/bundled/fsm")
local module5 = require("@luauforge/bundled/geL")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local headerBar = UIBlox.App.Bar.HeaderBar

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module6 = require("@luauforge/bundled/eeH")
local useStyle = UIBlox.Core.Style.useStyle
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local segmentedControl = UIBlox.App.Control.SegmentedControl
local module7 = require("@luauforge/bundled/dYU")
local vr = module.VR

local module8 = require("@luauforge/bundled/fpx")
local module9 = require("@luauforge/bundled/fpw")
local module10 = require("@luauforge/bundled/fpr")
local ROUNDED_CORNER_RADIUS = require("@luauforge/bundled/dwA").ROUNDED_CORNER_RADIUS

local searchViewExposureLogger = require("@luauforge/bundled/fpM").Components.SearchViewExposureLogger

local fFlagAXUnifiedAutocompleteExposureLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUnifiedAutocompleteExposureLogging

local iconsnavigationpushBack = images["icons/navigation/pushBack"]
local iconscommonsearch = images["icons/common/search"]
local iconsmenucustomize = images["icons/menu/customize"]
local iconsmenushop = images["icons/menu/shop"]

local v5 = { avatarScreen.AvatarEditor, avatarScreen.Catalog }

local v6 = {
	[avatarScreen.AvatarEditor] = 1,
	[avatarScreen.MySharedAvatars] = 1,
	[avatarScreen.CatalogSearch] = 2,
	[avatarScreen.Catalog] = 2
}

return function(p2)
	local state, setState = React.useState(false)
	local v7 = useDispatch()
	local v8 = module6(module7)
	local v9 = useStyle()
	local v10 = useLocalization({
		shop = "Feature.Avatar.Action.Shop",
		customize = "Feature.Catalog.Action.Customize",
		searchPlaceholder = "Search.GlobalSearch.Example.SearchCatalog"
	})

	local function fn(onActivated)
		return React.createElement(iconButton, {
			layoutOrder = 1,
			size = UDim2.fromOffset(58, 58),
			icon = iconsnavigationpushBack,
			iconSize = iconSize.Medium,
			iconColor3 = v9.Theme.SystemPrimaryDefault.Color,
			iconTransparency = v9.Theme.SystemPrimaryDefault.Transparency,
			backgroundColor = {
				Color = v9.Theme.BackgroundUIDefault.Color,
				Transparency = v9.Theme.BackgroundUIDefault.Transparency
			},
			showBackground = true,
			onActivated = onActivated
		})
	end

	local v11 = React.useCallback(function(p3, p4, p5)
		local v12 = searchUuid()
		local v13 = { searchKeyword = p3, isKeywordSuggestionEnabled = true }

		v7(module9(v12, searchTypes.Catalog))
		v7(module8(v12, v13))

		module10(v8, "catalog", p3, p4, avatarScreen.CatalogSearch, p5)

		module3.navigateToSearch(p2.navigation, v12, v13)
		setState(false)
	end)

	local v12 = nil
	local v13 = nil
	local v14 = nil
	local v15 = nil

	if state then
		v13 = React.createElement(module2, {
			Size = UDim2.new(1, 0, 1, -ROUNDED_CORNER_RADIUS),
			modernUI = true,
			cancelSearch = function()
				setState(false)
			end,
			confirmSearch = v11,
			onFocused = nil,
			onTextCleared = nil,
			isCompactView = false,
			placeholderText = v10.searchPlaceholder,
			searchType = searchTypes.Catalog,
			autocomplete = true,
			isSearching = state
		})
	elseif p2.currentPage == avatarScreen.LayeredClothingSort then
		v12 = fn(function()
			p2.navigation.navigate(avatarScreen.Catalog)
		end)
		v15 = "Feature.Avatar.Title.LCSortPage"
	else
		v13 = React.createElement(segmentedControl, {
			layoutOrder = 2,
			selectedTabIndex = v6[p2.currentPage] or 1,
			onTabActivated = function(p3)
				p2.navigation.navigate(v5[p3])
			end,
			tabs = {
				{ tabName = v10.customize, icon = iconsmenucustomize },
				{ tabName = v10.shop, icon = iconsmenushop }
			},
			width = UDim.new(0, 350),
			height = 58
		})

		if v6[p2.currentPage] == 2 then
			v14 = React.createElement(iconButton, {
				layoutOrder = 3,
				size = UDim2.fromOffset(58, 58),
				icon = iconscommonsearch,
				iconSize = iconSize.Medium,
				iconColor3 = v9.Theme.SystemPrimaryDefault.Color,
				iconTransparency = v9.Theme.SystemPrimaryDefault.Transparency,
				backgroundColor = {
					Color = v9.Theme.BackgroundUIDefault.Color,
					Transparency = v9.Theme.BackgroundUIDefault.Transparency
				},
				showBackground = true,
				onActivated = function()
					setState(true)
				end
			})
		else
			v14 = nil
		end
	end

	return React.createElement(module4.Consumer, {
		render = function(p3)
			return React.createElement(module5.Consumer, {
				render = function(p4)
					local createElement = React.createElement
					local v17 = {
						partSize = vr.AvatarEditorNavBarSize,
						offset = CFrame.lookAt(
							vr.AvatarEditorNavBarPosition,
							vr.AvatarEditorNavBarOrientation
						),
						virtualScreenSize = vr.AvatarEditorNavBarResolution,
						panelName = "AvatarNavBarVR",
						hidden = not p4 or p3 ~= avatarScreen.AvatarExperienceRoot
					}

					local createElement2 = React.createElement
					local v20 = {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 0,
						BackgroundColor3 = v9.Theme.BackgroundDefault.Color
					}
					local v21 = {
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, ROUNDED_CORNER_RADIUS)
						}),
						UIPadding = React.createElement("UIPadding", {
							PaddingRight = UDim.new(0, ROUNDED_CORNER_RADIUS),
							PaddingLeft = UDim.new(0, ROUNDED_CORNER_RADIUS)
						}),
						SearchViewExposureLogger = 0,
						HeaderBar = 0
					}

					local v22 = if fFlagAXUnifiedAutocompleteExposureLogging and state then React.createElement(searchViewExposureLogger) else nil
					v21.SearchViewExposureLogger = v22

					v21.HeaderBar = withLocalization({ title = v15 })(function(p5)
						return React.createElement(headerBar, {
							backgroundTransparency = 0,
							barHeight = vr.AvatarEditorNavBarResolution.Y,
							renderLeft = v12 and function()
								return v12
							end or nil,
							renderCenter = v13 and function()
								return v13
							end or nil,
							renderRight = v14 and function()
								return v14
							end or nil,
							title = v15 and p5.title or nil
						})
					end)
					return createElement(panel3D, v17, {
						RoundedFrame = createElement2("Frame", v20, v21)
					})
				end
			})
		end
	})
end
