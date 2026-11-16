local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local ItemInfoRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/ItemDetails/ItemInfoRow")
local module2 = require("@luauforge/bundled/dME")
local module3 = require("@luauforge/bundled/dMx")

local module4 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module5 = require("@luauforge/bundled/fsq")
local module6 = require("@luauforge/bundled/dCp")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
require("@luauforge/bundled/dMc")

local module8 = require("@luauforge/deferred/gol")

return (React.forwardRef(function(props, p2)
	local curator = if props.lookDetails and props.lookDetails.curator then props.lookDetails.curator else nil

	local id = curator and curator.id
	local kind = curator and curator.type
	local v5 = curator and curator.name and curator.name:lower() ~= module3.RobloxCreatorName:lower()

	local totalValue = props.lookDetails and props.lookDetails.totalValue or ""

	local v6 = useAppPolicy(function(p3)
		return p3.getWebViewSupport()
	end)

	local v7 = useNavigation()

	local isTryOn = props.isTryOn
	local v8 = useDispatch()

	local v9 = React.useCallback(function()
		if id then
			local v10

			if kind == module2.CreatorType.Group then
				v10 = module5.user.group({ groupId = id })
			else
				v10 = module5.user.profile({ userId = id })
			end

			if isTryOn then
				local v11 = {
					name = module6.GenericWebPage,
					detail = v10,
					extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v11))
				else
					v8(module4(v11))
				end
			else
				v7.navigate(module6.GenericWebPage, {
					detail = v10,
					extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
				})
			end
		end
	end, { id, kind, isTryOn, v8 })

	local createElement = React.createElement
	local frame = focusable.Frame
	local v10 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder
	}
	local v11 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = 0,
		Curator = 0,
		TotalValue = 0
	}

	local v12 = if module8() then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, props.innerPadding),
		PaddingRight = UDim.new(0, props.innerPadding)
	}) else nil
	v11.Padding = v12
	local v13

	if v5 then
		local createElement2 = React.createElement
		local v15 = {
			infoName = "Feature.Avatar.Label.By",
			infoData = curator.name,
			onActivate = 0,
			hasVerifiedBadge = 0,
			LayoutOrder = 2
		}

		if not v6 or props.disableInteractions then
			v9 = nil
		end

		v15.onActivate = v9
		local v16 = if curator then curator.hasVerifiedBadge else false
		v15.hasVerifiedBadge = v16
		v13 = createElement2(ItemInfoRow, v15)
	end

	v11.Curator = v13

	v11.TotalValue = React.createElement(ItemInfoRow, {
		infoName = "Feature.Catalog.Label.Filter.TotalValue",
		infoData = module2.RobloxEmoji.Robux .. totalValue,
		LayoutOrder = 3
	})
	return createElement(frame, v10, v11)
end))
