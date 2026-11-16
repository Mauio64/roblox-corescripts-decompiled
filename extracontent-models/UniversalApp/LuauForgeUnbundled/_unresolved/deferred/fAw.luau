local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
require("@luauforge/bundled/dCp")
local module = require("@luauforge/bundled/fox")
local module2 = require("@luauforge/deferred/fAx")
local module3 = require("@luauforge/deferred/fAz")
local module4 = require("@luauforge/bundled/fys")
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local emptyState = UIBlox.App.Indicator.EmptyState

local extended = Roact.PureComponent:extend("TencentNoticeCenterPage")

extended.validateProps = t.strictInterface({
	formFactor = t.string,
	noticeList = t.optional(t.table)
})

function extended:init()
	function self.renderItem(p3, p4)
		return Roact.createElement(module3, { item = p3, layoutInfo = p4 })
	end
end

function extended.render(p2)
	return withStyle(function(p3)
		local backgroundDefault = p3.Theme.BackgroundDefault
		local v5 = p2.props.formFactor == formFactor.WIDE
		local noticeList = p2.props.noticeList
		local v6

		if noticeList == nil then
			v6 = Roact.createElement(
				"Frame",
				{
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = backgroundDefault.Color
				},
				{
					EmptySection = withLocalization({
						emptyText = "CommonUI.Features.Label.MoreEvents"
					})(function(p4)
						return Roact.createElement(emptyState, {
							text = p4.emptyText,
							size = UDim2.fromScale(1, 1)
						})
					end)
				}
			)
		else
			v6 = Roact.createElement(
				module4,
				{ Position = UDim2.fromScale(0, 0), Size = UDim2.fromScale(1, 1) },
				{
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v5 and 60 or 0),
						PaddingRight = UDim.new(0, v5 and 60 or 0),
						PaddingTop = UDim.new(0, v5 and 40 or 20),
						PaddingBottom = UDim.new(0, v5 and 40 or 20)
					}),
					TencentNoticeCenterList = noticeList and Roact.createElement(module2, {
						itemList = noticeList,
						renderItem = p2.renderItem
					})
				}
			)
		end

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = backgroundDefault.Color,
				BackgroundTransparency = backgroundDefault.Transparency
			},
			{
				TopBar = Roact.createElement(module.Container, {
					leftItem = module.BackButton,
					rightItems = { module.BuyRobuxButton, module.NotificationsButton }
				}),
				Content = Roact.createElement(module.PageContent, {}, {
					ContentFrame = v6
				})
			}
		)
	end)
end

local function mapStateToProps(p2)
	local noticeList = p2.Luobu.TencentNotice.noticeList
	return { formFactor = p2.FormFactor, noticeList = noticeList }
end

return RoactRodux.connect(mapStateToProps)(extended)
