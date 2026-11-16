local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local module = require("@luauforge/bundled/dwA")
local module2 = require("@luauforge/deferred/fya")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor

local module3 = require("@luauforge/bundled/fox")
local module4 = require("@luauforge/deferred/fym")
local module5 = require("@luauforge/deferred/fyn")
local module6 = require("@luauforge/bundled/fys")

local React = require(CorePackages.Packages.React)
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local module9 = require("@luauforge/deferred/hHM")

local robloxVersion = RunService:GetRobloxVersion()

local clientGitHash = RunService.ClientGitHash
string.format("%s (%.6s)", robloxVersion, clientGitHash)

local extended = Roact.PureComponent:extend("AboutPage")

function extended:init()
	function self.renderItem(p3, p4)
		return Roact.createElement(module5, { item = p3, layoutInfo = p4 })
	end
end

function extended.render(p2)
	local v5 = p2.props.formFactor == formFactor.WIDE

	local v6 = module.MORE_PAGE_SECTION_PADDING
	local v7 = module.MORE_PAGE_SECTION_PADDING
	local v8, v9

	if v5 then
		v8 = module.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		v9 = module.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		v6 = module.MORE_PAGE_WIDE_PADDING_VERTICAL
		v7 = module.MORE_PAGE_WIDE_PADDING_VERTICAL
	else
		v8 = 0
		v9 = 0
	end

	local v10 = module.MORE_PAGE_CONTENT_MAX_WIDTH + v8 + v9

	local itemsInPage = module2.GetItemsInPage(
		p2.props.aboutPageType,
		nil,
		nil,
		nil,
		nil,
		p2.props.disableWebViewSupport
	)

	local mapped = Cryo.List.map(itemsInPage, function(p3)
		return p3.contents
	end)

	local function fn(backgroundDefault, joined)
		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = backgroundDefault.Color,
				BackgroundTransparency = backgroundDefault.Transparency
			},
			{
				TopBar = Roact.createElement(module3.Container, {
					leftItem = module3.BackButton,
					rightItems = { module3.BuyRobuxButton, module3.NotificationsButton }
				}),
				PageContent = Roact.createElement(module3.PageContent, {}, {
					Scroller = Roact.createElement(
						module6,
						{
							Position = UDim2.fromScale(0, 0),
							Size = UDim2.fromScale(1, 1),
							maxWidth = v10
						},
						{
							Layout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0, module.MORE_PAGE_SECTION_PADDING)
							}),
							UIPadding = Roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, v8),
								PaddingRight = UDim.new(0, v9),
								PaddingTop = UDim.new(0, v6),
								PaddingBottom = UDim.new(0, v7)
							}),
							AboutPageList = Roact.createElement(module4, {
								LayoutOrder = 1,
								itemList = mapped,
								renderItem = p2.renderItem,
								rowHeight = module.MORE_PAGE_ROW_HEIGHT
							})
						}
					)
				})
			}
		)
	end

	return withStyle(function(p3)
		local joined = Cryo.Dictionary.join(p3.Theme.TextDefault, {
			Font = p3.Font.Footer.Font,
			Size = p3.Font.BaseSize * p3.Font.Footer.RelativeSize
		})

		return fn(p3.Theme.BackgroundDefault, joined)
	end)
end

local v5 = roactAppPolicy.connect(function(p2, p3)
	local v6 = not p2.getWebViewSupport()
	return { aboutPageType = p2.getAboutPageType(), disableWebViewSupport = v6 }
end)(extended)

local v6 = RoactRodux.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end)(v5)

return function(p2)
	local v7 = RobloxAppHooks.useUiModeInfo().uiMode == uiMode.TenFoot

	local v8 = useAppPolicy(function(p3)
		return p3.getAboutPageType()
	end)

	if not v7 then
		return React.createElement(v6, p2)
	end

	local itemsInPage = module2.GetItemsInPage(v8)

	local mapped = Cryo.List.map(itemsInPage, function(p3)
		return p3.contents
	end)

	return React.createElement(module9, { itemList = mapped, topbarHeight = 0 })
end
