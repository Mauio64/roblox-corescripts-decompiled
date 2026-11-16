local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactNavigation")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").sendAXCounterV2

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useSelector
local withMappedNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").withMappedNavigationParams
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local modalWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/UIBlox").App.Dialog.Modal.ModalWindow
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport

local function fn(p2)
	return p2.ScreenSize
end

local v5 = {
	UnavailableItems = {
		TitleText = "Feature.Avatar.UnavailableItems.TitleText",
		BodyText = "Feature.Avatar.UnavailableItems.BodyText",
		BodyTextMultiple = "Feature.Avatar.UnavailableItems.BodyTextMultiple"
	},
	ItemsRemovedFromAvatar = {
		TitleText = "Feature.Avatar.ItemsRemovedFromAvatar.TitleText",
		BodyText = "Feature.Avatar.UnavailableItems.BodyText",
		BodyTextMultiple = "Feature.Avatar.UnavailableItems.BodyTextMultiple"
	},
	RevokedItems = {
		TitleText = "Feature.Avatar.ItemsRemovedFromAvatar.TitleText",
		BodyText = "Feature.Avatar.RevokedItems.BodyText",
		BodyTextMultiple = "Feature.Avatar.RevokedItems.BodyTextMultiple"
	},
	ItemDidNotMeetRobloxCommunityStandards = {
		TitleText = "Feature.Avatar.ItemDidNotMeetRobloxCommunityStandards.TitleText",
		BodyText = "Feature.Avatar.ItemDidNotMeetRobloxCommunityStandards.BodyText"
	},
	PartiallyExpiredItems = fFlagAXInventoryDurablesSupport and {
		TitleText = "Feature.Durables.PartiallyExpiredItems.TitleText",
		BodyText = "Feature.Durables.PartiallyExpiredItems.BodyText"
	} or nil
}

local function ItemsUnavailablePrompt(props)
	React.useEffect(function()
		sendAXCounterV2(Constants.COUNTERS.ItemsUnavailablePromptShown, {
			messageType = props.messageType
		})
	end, {})

	local categoryLocsByCategoryLoc = {}

	if fFlagAXInventoryDurablesSupport then
		if props.items then
			for k, item in props.items do
				if item.categoryLoc then
					categoryLocsByCategoryLoc[item.categoryLoc] = item.categoryLoc
				end
			end
		end
	else
		for k, item in props.items do
			if item.categoryLoc then
				categoryLocsByCategoryLoc[item.categoryLoc] = item.categoryLoc
			end
		end
	end

	local v6 = useLocalization(categoryLocsByCategoryLoc)

	local function localizeCategory(p2)
		if p2.categoryLoc and v6[p2.categoryLoc] then
			return v6[p2.categoryLoc]
		end

		return p2.category or ""
	end

	local function createItemListString(items)
		local itemListString = ""

		for k, item in items do
			local v8 = if item.categoryLoc and v6[item.categoryLoc] then v6[item.categoryLoc] else item.category or ""

			itemListString ..= "• " .. v8 .. " \"" .. item.itemName .. "\"" .. (item == items[#items] and "" or "\n")
		end

		return itemListString
	end

	local v7

	if fFlagAXInventoryDurablesSupport then
		if props.items and #props.items > 0 then
			if v5[props.messageType].BodyTextMultiple and #props.items > 1 then
				v7 = {
					v5[props.messageType].BodyTextMultiple,
					items = createItemListString(props.items),
					lineBreak = "\n\n"
				}
			else
				v7 = {
					[1] = nil,
					[1] = nil,
					v5[props.messageType].BodyText,
					item = props.items[1].itemName
				}
				local item = props.items[1]
				local v8 = if item.categoryLoc and v6[item.categoryLoc] then v6[item.categoryLoc] else item.category or ""

				v7.category = v8
				v7.lineBreak = "\n\n"
			end
		else
			v7 = v5[props.messageType].BodyText
		end
	elseif v5[props.messageType].BodyTextMultiple and #props.items > 1 then
		v7 = {
			v5[props.messageType].BodyTextMultiple,
			items = createItemListString(props.items),
			lineBreak = "\n\n"
		}
	else
		v7 = {
			[1] = nil,
			[1] = nil,
			v5[props.messageType].BodyText,
			item = props.items[1].itemName
		}
		local item = props.items[1]
		local v8 = if item.categoryLoc and v6[item.categoryLoc] then v6[item.categoryLoc] else item.category or ""

		v7.category = v8
		v7.lineBreak = "\n\n"
	end

	local v8 = useLocalization({
		ConfirmText = "Feature.Avatar.UnavailableItems.ConfirmText",
		TitleText = v5[props.messageType].TitleText,
		BodyText = v7,
		ViewInbox = "Feature.Avatar.RevokedItems.ViewInbox"
	})

	local v9 = useSelector(fn)

	local v10 = React.useCallback(function()
		props.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { props.navigation })

	local v11 = React.useCallback(function()
		v10()

		if props.onConfirm then
			props.onConfirm()
		end
	end, { props.onConfirm, v10 })

	local v12 = React.useCallback(function()
		v10()

		if props.navigateDown then
			props.navigateDown()
		end
	end, { props.navigateDown, v10 })

	local function fn2()
		return React.createElement(
			view,
			{
				tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
			},
			{
				PromptBodyTitle = React.createElement(text, {
					tag = "auto-xy text-align-x-left text-truncate-end text-heading-small text-wrap",
					Text = v8.TitleText,
					LayoutOrder = 1,
					padding = { bottom = UDim.new(0, 8) }
				}),
				PromptBodyText = React.createElement(text, {
					tag = "auto-xy text-align-x-left text-body-large text-wrap",
					Text = v8.BodyText,
					LayoutOrder = 2
				})
			}
		)
	end

	local function fn3()
		local createElement = React.createElement

		local v15 = {
			Buttons = React.createElement(button, {
				tag = "size-full-0 auto-y",
				onActivated = v11,
				text = v8.ConfirmText,
				variant = buttonVariant.Emphasis,
				width = UDim.new(1, 0),
				fillBehavior = fillBehavior.Fill,
				size = inputSize.Medium,
				LayoutOrder = 3
			}),
			ViewDetailButton = 0
		}

		local v16 = if props.messageType == "RevokedItems" then React.createElement(button, {
			tag = "size-full-0 auto-y",
			onActivated = v12,
			text = v8.ViewInbox,
			variant = buttonVariant.Standard,
			width = UDim.new(1, 0),
			LayoutOrder = 4
		}) else nil
		v15.ViewDetailButton = v16
		return createElement(view, { tag = "col gap-medium auto-y size-full-0 fill-x" }, v15)
	end

	return React.createElement(modalWindow, { screenSize = v9, isFullHeight = false }, {
		ViewFrame = React.createElement(
			view,
			{ tag = "auto-y size-full-0 padding-xxlarge col align-x-left align-y-top" },
			{ ContentContainer = fn2(), ButtonContainer = fn3() }
		)
	})
end

return (withMappedNavigationParams(ItemsUnavailablePrompt))
