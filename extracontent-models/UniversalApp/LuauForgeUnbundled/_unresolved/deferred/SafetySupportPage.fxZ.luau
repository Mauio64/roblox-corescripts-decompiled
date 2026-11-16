local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/dwA")
local module3 = require("@luauforge/deferred/fya")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module5 = require("@luauforge/bundled/fox")
local module6 = require("@luauforge/deferred/fym")
local module7 = require("@luauforge/deferred/fyn")
local module8 = require("@luauforge/bundled/fys")

local getFFlagEnableSupportCenter = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableSupportCenter
local module9 = require("@luauforge/deferred/fyk")

local v5 = if module9 then require("@luauforge/deferred/fyt") else nil

local function renderItem(p2, p3)
	return React.createElement(module7, { item = p2, layoutInfo = p3 })
end

local function SafetySupportPage()
	local v6 = not useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)
	local v7

	if getFFlagEnableSupportCenter() then
		v7 = useAppPolicy(function(p2)
			return p2.getSupportCenterEnabled()
		end)
	else
		v7 = false
	end

	local v8 = useSelector(function(p2)
		return p2.FormFactor
	end) == formFactor.WIDE

	local v9 = module2.MORE_PAGE_SECTION_PADDING
	local v10 = module2.MORE_PAGE_SECTION_PADDING
	local v11, v12

	if v8 then
		v11 = module2.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		v12 = module2.MORE_PAGE_WIDE_PADDING_HORIZONTAL
		v9 = module2.MORE_PAGE_WIDE_PADDING_VERTICAL
		v10 = module2.MORE_PAGE_WIDE_PADDING_VERTICAL
	else
		v11 = 0
		v12 = 0
	end

	local v13 = module2.MORE_PAGE_CONTENT_MAX_WIDTH + v11 + v12

	local backgroundDefault = useStyle().Theme.BackgroundDefault

	local useMemo = React.useMemo
	local function fn()
		local itemsInPage = module3.GetItemsInPage(
			module.SafetySupport,
			nil,
			nil,
			getFFlagEnableSupportCenter() and { isSupportCenterEnabled = v7 } or nil,
			nil,
			v6
		)

		return Cryo.List.map(itemsInPage, function(p2)
			return p2.contents
		end)
	end

	local v15 = if getFFlagEnableSupportCenter() then v7 else nil
	local v16 = useMemo(fn, { v6, v15 })

	local createElement = React.createElement
	local v18 = {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = backgroundDefault.Color,
		BackgroundTransparency = backgroundDefault.Transparency
	}
	local v19 = {
		TopBar = React.createElement(module5.Container, {
			leftItem = module5.BackButton,
			rightItems = { module5.BuyRobuxButton, module5.NotificationsButton }
		}),
		PageContent = 0
	}

	local createElement2 = React.createElement
	local pageContent = module5.PageContent
	local createElement3 = React.createElement
	local v23 = {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		maxWidth = v13
	}

	local v24 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, module2.MORE_PAGE_SECTION_PADDING)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v11),
			PaddingRight = UDim.new(0, v12),
			PaddingTop = UDim.new(0, v9),
			PaddingBottom = UDim.new(0, v10)
		}),
		ProfileHeader = 0,
		SafetySupportPageList = 0
	}

	local v25 = if v5 then React.createElement(v5, { LayoutOrder = 1 }) else nil
	v24.ProfileHeader = v25

	v24.SafetySupportPageList = React.createElement(module6, {
		LayoutOrder = module9 and 2 or 1,
		itemList = v16,
		renderItem = renderItem,
		rowHeight = module2.MORE_PAGE_ROW_HEIGHT
	})
	v19.PageContent = createElement2(pageContent, {}, {
		Scroller = createElement3(module8, v23, v24)
	})
	return createElement("Frame", v18, v19)
end

return SafetySupportPage
