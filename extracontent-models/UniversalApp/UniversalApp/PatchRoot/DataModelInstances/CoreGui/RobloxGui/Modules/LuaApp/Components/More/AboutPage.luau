local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AppPage = require(Modules.LuaApp.AppPage)
local Constants = require(Modules.LuaApp.Constants)
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local MoreList = require(Modules.LuaApp.Components.More.MoreList)
local MoreItemContainer = require(Modules.LuaApp.Components.More.MoreItemContainer)
local MorePageScrollingFrame = require(Modules.LuaApp.Components.More.MorePageScrollingFrame)
local React = require(CorePackages.Packages.React)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local Constants2 = require(CorePackages.Workspace.Packages.TenFootUiShell).Constants
local MoreSectionList = require(Modules.LuaApp.Components.More.MoreSectionList)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local RobloxVersion = RunService:GetRobloxVersion()
local ClientGitHash = RunService.ClientGitHash

string.format("%s (%.6s)", RobloxVersion, ClientGitHash)

local v26 = Roact.PureComponent:extend("AboutPage")

function v26.init(p1) -- line: 57
	-- upvalues: Roact (copy), MoreItemContainer (copy)
	function p1.renderItem(p2, p3) -- line: 58
		-- upvalues: Roact (copy), MoreItemContainer (copy)
		return Roact.createElement(MoreItemContainer, {
			item = p2,
			layoutInfo = p3
		})
	end
end
function v26.render(p4) -- line: 66
	-- upvalues: FormFactor (copy), Constants (copy), MorePageSettings (copy), Cryo (copy), Roact (copy), TopBar (copy), MorePageScrollingFrame (copy), MoreList (copy), withStyle (copy)
	local v31 = p4.props.formFactor == FormFactor.WIDE
	local n1 = 0
	local n2 = 0
	local MORE_PAGE_SECTION_PADDING = Constants.MORE_PAGE_SECTION_PADDING
	local MORE_PAGE_SECTION_PADDING2 = Constants.MORE_PAGE_SECTION_PADDING

	if v31 then
		n1 = Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		n2 = Constants.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		MORE_PAGE_SECTION_PADDING = Constants.MORE_PAGE_WIDE_PADDING_VERTICAL
		MORE_PAGE_SECTION_PADDING2 = Constants.MORE_PAGE_WIDE_PADDING_VERTICAL
	end

	local v36 = Constants.MORE_PAGE_CONTENT_MAX_WIDTH + n1 + n2
	local v37 = MorePageSettings.GetItemsInPage(p4.props.aboutPageType, nil, nil, nil, nil, p4.props.disableWebViewSupport)
	local u38 = Cryo.List.map(v37, function(p5) -- line: 92
		return p5.contents
	end)

	local function v39(p6, _) -- line: 96
		-- upvalues: Roact (copy), TopBar (copy), MorePageScrollingFrame (copy), v36 (copy), Constants (copy), n1 (ref), n2 (ref), MORE_PAGE_SECTION_PADDING (ref), MORE_PAGE_SECTION_PADDING2 (ref), MoreList (copy), u38 (ref), p4 (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p6.Color,
			BackgroundTransparency = p6.Transparency
		}, {
			TopBar = Roact.createElement(TopBar.Container, {
				leftItem = TopBar.BackButton,
				rightItems = {
					TopBar.BuyRobuxButton,
					TopBar.NotificationsButton
				}
			}),
			PageContent = Roact.createElement(TopBar.PageContent, {}, {
				Scroller = Roact.createElement(MorePageScrollingFrame, {
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromScale(1, 1),
					maxWidth = v36
				}, {
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, Constants.MORE_PAGE_SECTION_PADDING)
					}),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, n1),
						PaddingRight = UDim.new(0, n2),
						PaddingTop = UDim.new(0, MORE_PAGE_SECTION_PADDING),
						PaddingBottom = UDim.new(0, MORE_PAGE_SECTION_PADDING2)
					}),
					AboutPageList = Roact.createElement(MoreList, {
						LayoutOrder = 1,
						itemList = u38,
						renderItem = p4.renderItem,
						rowHeight = Constants.MORE_PAGE_ROW_HEIGHT
					})
				})
			})
		})
	end

	return withStyle(function(p8) -- line: 137
		-- upvalues: Cryo (copy), v39 (copy)
		local v57 = Cryo.Dictionary.join(p8.Theme.TextDefault, {
			Font = p8.Font.Footer.Font,
			Size = p8.Font.BaseSize * p8.Font.Footer.RelativeSize
		})

		return v39(p8.Theme.BackgroundDefault, v57)
	end)
end

local v27 = RoactAppPolicy.connect(function(p9, _) -- line: 146
	local v42 = p9.getWebViewSupport()

	return {
		aboutPageType = p9.getAboutPageType(),
		disableWebViewSupport = not v42
	}
end)(v26)
local u28 = RoactRodux.connect(function(p11, _) -- line: 154
	return {
		formFactor = p11.FormFactor
	}
end)(v27)

return function(p13) -- line: 160
	-- upvalues: RobloxAppHooks (copy), UiMode (copy), useAppPolicy (copy), MorePageSettings (copy), Cryo (copy), FFlagEnableLeftNavOnConsole (copy), AppPage (copy), Constants2 (copy), React (copy), MoreSectionList (copy), u28 (ref)
	local v46 = RobloxAppHooks.useUiModeInfo().uiMode == UiMode.TenFoot
	local v47 = useAppPolicy(function(p14) -- line: 164
		return p14.getAboutPageType()
	end)

	if v46 then
		local v48 = MorePageSettings.GetItemsInPage(v47)
		local v49 = Cryo.List.map(v48, function(p15) -- line: 171
			return p15.contents
		end)
		local v50 = if not FFlagEnableLeftNavOnConsole then v47 ~= AppPage.TenFootAbout and 0 or Constants2.TOP_BAR_CANVAS_SIZE.Y else 0

		return React.createElement(MoreSectionList, {
			itemList = v49,
			topbarHeight = v50
		})
	end

	return React.createElement(u28, p13)
end
