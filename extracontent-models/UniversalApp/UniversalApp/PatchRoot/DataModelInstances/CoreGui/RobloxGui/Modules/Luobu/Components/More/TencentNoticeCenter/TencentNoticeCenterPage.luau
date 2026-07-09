local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor

require(Modules.LuaApp.AppPage)

local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local TencentNoticeList = require(Modules.Luobu.Components.More.TencentNoticeCenter.TencentNoticeList)
local TencentNoticeItemContainer = require(Modules.Luobu.Components.More.TencentNoticeCenter.TencentNoticeItemContainer)
local MorePageScrollingFrame = require(Modules.LuaApp.Components.More.MorePageScrollingFrame)
local t = require(CorePackages.Packages.t)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local EmptyState = UIBlox.App.Indicator.EmptyState
local v15 = Roact.PureComponent:extend("TencentNoticeCenterPage")

v15.validateProps = t.strictInterface({
	formFactor = t.string,
	noticeList = t.optional(t.table)
})

function v15.init(p1) -- line: 29
	-- upvalues: Roact (copy), TencentNoticeItemContainer (copy)
	function p1.renderItem(p2, p3) -- line: 30
		-- upvalues: Roact (copy), TencentNoticeItemContainer (copy)
		return Roact.createElement(TencentNoticeItemContainer, {
			item = p2,
			layoutInfo = p3
		})
	end
end
function v15.render(p4) -- line: 38
	-- upvalues: withStyle (copy), FormFactor (copy), Roact (copy), withLocalization (copy), EmptyState (copy), MorePageScrollingFrame (copy), TencentNoticeList (copy), TopBar (copy)
	return withStyle(function(p5) -- line: 39
		-- upvalues: p4 (copy), FormFactor (copy), Roact (copy), withLocalization (copy), EmptyState (copy), MorePageScrollingFrame (copy), TencentNoticeList (copy), TopBar (copy)
		local BackgroundDefault = p5.Theme.BackgroundDefault
		local v25 = p4.props.formFactor == FormFactor.WIDE
		local noticeList = p4.props.noticeList
		local v27 = if noticeList ~= nil then Roact.createElement(MorePageScrollingFrame, {
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, not v25 and 0 or 60),
				PaddingRight = UDim.new(0, not v25 and 0 or 60),
				PaddingTop = UDim.new(0, not v25 and 20 or 40),
				PaddingBottom = UDim.new(0, not v25 and 20 or 40)
			}),
			TencentNoticeCenterList = noticeList and Roact.createElement(TencentNoticeList, {
				itemList = noticeList,
				renderItem = p4.renderItem
			})
		}) else Roact.createElement("Frame", {
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = BackgroundDefault.Color
		}, {
			EmptySection = withLocalization({
				emptyText = "CommonUI.Features.Label.MoreEvents"
			})(function(p6) -- line: 53
				-- upvalues: Roact (copy), EmptyState (copy)
				return Roact.createElement(EmptyState, {
					text = p6.emptyText,
					size = UDim2.fromScale(1, 1)
				})
			end)
		})

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = BackgroundDefault.Color,
			BackgroundTransparency = BackgroundDefault.Transparency
		}, {
			TopBar = Roact.createElement(TopBar.Container, {
				leftItem = TopBar.BackButton,
				rightItems = {
					TopBar.BuyRobuxButton,
					TopBar.NotificationsButton
				}
			}),
			Content = Roact.createElement(TopBar.PageContent, {}, {
				ContentFrame = v27
			})
		})
	end)
end

local function mapStateToProps(p7) -- line: 107
	local noticeList = p7.Luobu.TencentNotice.noticeList

	return {
		formFactor = p7.FormFactor,
		noticeList = noticeList
	}
end

return RoactRodux.connect(mapStateToProps)(v15)
