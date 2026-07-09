local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local AppPage = require(Modules.LuaApp.AppPage)
local Constants = require(Modules.LuaApp.Constants)
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local MoreList = require(Modules.LuaApp.Components.More.MoreList)
local MoreItemContainer = require(Modules.LuaApp.Components.More.MoreItemContainer)
local MorePageScrollingFrame = require(Modules.LuaApp.Components.More.MorePageScrollingFrame)
local GetFFlagEnableSupportCenter = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableSupportCenter
local FFlagEnableSafetyDashboard = require(Modules.LuaApp.Flags.FFlagEnableSafetyDashboard)
local v18 = if not FFlagEnableSafetyDashboard then nil else require(Modules.LuaApp.Components.More.SafetySupportProfileHeader)

local function renderItem(p1, p2) -- line: 50
	-- upvalues: React (copy), MoreItemContainer (copy)
	return React.createElement(MoreItemContainer, {
		item = p1,
		layoutInfo = p2
	})
end
local function SafetySupportPage() -- line: 57
	-- upvalues: useAppPolicy (copy), GetFFlagEnableSupportCenter (copy), useSelector (copy), FormFactor (copy), Constants (copy), useStyle (copy), React (copy), MorePageSettings (copy), AppPage (copy), Cryo (copy), TopBar (copy), MorePageScrollingFrame (copy), v18 (copy), MoreList (copy), FFlagEnableSafetyDashboard (copy), renderItem (copy)
	local v23 = not useAppPolicy(function(p3) -- line: 58
		return p3.getWebViewSupport()
	end)
	local v24 = not not GetFFlagEnableSupportCenter() and useAppPolicy(function(p4) -- line: 62
		return p4.getSupportCenterEnabled()
	end)
	local v25 = useSelector(function(p5) -- line: 66
		return p5.FormFactor
	end) == FormFactor.WIDE
	local n1 = 0
	local n2 = 0
	local MORE_PAGE_SECTION_PADDING = Constants.MORE_PAGE_SECTION_PADDING
	local MORE_PAGE_SECTION_PADDING2 = Constants.MORE_PAGE_SECTION_PADDING

	if v25 then
		n1 = Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		n2 = Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		MORE_PAGE_SECTION_PADDING = Constants.MORE_PAGE_WIDE_PADDING_VERTICAL
		MORE_PAGE_SECTION_PADDING2 = Constants.MORE_PAGE_WIDE_PADDING_VERTICAL
	end

	local v30 = Constants.MORE_PAGE_CONTENT_MAX_WIDTH + n1 + n2
	local BackgroundDefault = useStyle().Theme.BackgroundDefault
	local v32 = React.useMemo(function() -- line: 87
		-- upvalues: MorePageSettings (copy), AppPage (copy), GetFFlagEnableSupportCenter (copy), v24 (copy), v23 (copy), Cryo (copy)
		local v36 = MorePageSettings.GetItemsInPage(AppPage.SafetySupport, nil, nil, if not GetFFlagEnableSupportCenter() then nil else {
			isSupportCenterEnabled = v24
		}, nil, v23)

		return Cryo.List.map(v36, function(p6) -- line: 101
			return p6.contents
		end)
	end, {
		v23,
		if not GetFFlagEnableSupportCenter() then nil else v24
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = BackgroundDefault.Color,
		BackgroundTransparency = BackgroundDefault.Transparency
	}, {
		TopBar = React.createElement(TopBar.Container, {
			leftItem = TopBar.BackButton,
			rightItems = {
				TopBar.BuyRobuxButton,
				TopBar.NotificationsButton
			}
		}),
		PageContent = React.createElement(TopBar.PageContent, {}, {
			Scroller = React.createElement(MorePageScrollingFrame, {
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 1),
				maxWidth = v30
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, Constants.MORE_PAGE_SECTION_PADDING)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, n1),
					PaddingRight = UDim.new(0, n2),
					PaddingTop = UDim.new(0, MORE_PAGE_SECTION_PADDING),
					PaddingBottom = UDim.new(0, MORE_PAGE_SECTION_PADDING2)
				}),
				ProfileHeader = if not v18 then nil else React.createElement(v18, {
					LayoutOrder = 1
				}),
				SafetySupportPageList = React.createElement(MoreList, {
					LayoutOrder = not FFlagEnableSafetyDashboard and 1 or 2,
					itemList = v32,
					renderItem = renderItem,
					rowHeight = Constants.MORE_PAGE_ROW_HEIGHT
				})
			})
		})
	})
end

return SafetySupportPage
