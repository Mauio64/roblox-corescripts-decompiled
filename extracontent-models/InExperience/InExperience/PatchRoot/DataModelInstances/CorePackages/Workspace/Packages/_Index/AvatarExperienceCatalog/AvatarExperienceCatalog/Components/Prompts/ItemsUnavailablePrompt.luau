local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local Constants = require(AvatarExperienceCatalog.Constants)

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local withMappedNavigationParams = AvatarExperienceNavigation.withMappedNavigationParams
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local UIBlox = require(parent.UIBlox)
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport

local function fn(p)
	return p.ScreenSize
end

local v = {
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
	PartiallyExpiredItems = FFlagAXInventoryDurablesSupport and {
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

	if FFlagAXInventoryDurablesSupport then
		if props.items then
			for _, item in props.items do
				if item.categoryLoc then
					categoryLocsByCategoryLoc[item.categoryLoc] = item.categoryLoc
				end
			end
		end
	else
		for _, item in props.items do
			if item.categoryLoc then
				categoryLocsByCategoryLoc[item.categoryLoc] = item.categoryLoc
			end
		end
	end

	local v2 = useLocalization(categoryLocsByCategoryLoc)

	local function localizeCategory(p) -- 3 equivalent calls inferred from this helper
		if p.categoryLoc and v2[p.categoryLoc] then
			return v2[p.categoryLoc]
		end

		return p.category or ""
	end

	local function createItemListString(items)
		local itemListString = ""

		for _, item in items do
			itemListString ..= "• " .. localizeCategory(item) .. " \"" .. item.itemName .. "\"" .. (item == items[#items] and "" or "\n") -- inferred equivalent call
		end

		return itemListString
	end

	local bodyText

	if FFlagAXInventoryDurablesSupport then
		if props.items and #props.items > 0 then
			if v[props.messageType].BodyTextMultiple and #props.items > 1 then
				bodyText = {
					v[props.messageType].BodyTextMultiple,
					items = createItemListString(props.items),
					lineBreak = "\n\n"
				}
			else
				bodyText = {
					[1] = nil,
					[1] = nil,
					v[props.messageType].BodyText,
					item = props.items[1].itemName
				}
				bodyText.category = localizeCategory(props.items[1]) -- inferred equivalent call
				bodyText.lineBreak = "\n\n"
			end
		else
			bodyText = v[props.messageType].BodyText
		end
	elseif v[props.messageType].BodyTextMultiple and #props.items > 1 then
		bodyText = {
			v[props.messageType].BodyTextMultiple,
			items = createItemListString(props.items),
			lineBreak = "\n\n"
		}
	else
		bodyText = {
			[1] = nil,
			[1] = nil,
			v[props.messageType].BodyText,
			item = props.items[1].itemName
		}
		bodyText.category = localizeCategory(props.items[1]) -- inferred equivalent call
		bodyText.lineBreak = "\n\n"
	end

	local v3 = useLocalization({
		ConfirmText = "Feature.Avatar.UnavailableItems.ConfirmText",
		TitleText = v[props.messageType].TitleText,
		BodyText = bodyText,
		ViewInbox = "Feature.Avatar.RevokedItems.ViewInbox"
	})

	local screenSize = useSelector(fn)

	local v4 = React.useCallback(function()
		props.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { props.navigation })

	local onActivated = React.useCallback(function()
		v4()

		if props.onConfirm then
			props.onConfirm()
		end
	end, { props.onConfirm, v4 })

	local onActivated2 = React.useCallback(function()
		v4()

		if props.navigateDown then
			props.navigateDown()
		end
	end, { props.navigateDown, v4 })

	local function fn2()
		return React.createElement(
			View,
			{ tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top" },
			{
				PromptBodyTitle = React.createElement(Text, {
					tag = "auto-xy text-align-x-left text-truncate-end text-heading-small text-wrap",
					Text = v3.TitleText,
					LayoutOrder = 1,
					padding = { bottom = UDim.new(0, 8) }
				}),
				PromptBodyText = React.createElement(Text, {
					tag = "auto-xy text-align-x-left text-body-large text-wrap",
					Text = v3.BodyText,
					LayoutOrder = 2
				})
			}
		)
	end

	local function fn3()
		local createElement = React.createElement

		local v5 = {
			Buttons = React.createElement(Button, {
				tag = "size-full-0 auto-y",
				onActivated = onActivated,
				text = v3.ConfirmText,
				variant = ButtonVariant.Emphasis,
				width = UDim.new(1, 0),
				fillBehavior = FillBehavior.Fill,
				size = InputSize.Medium,
				LayoutOrder = 3
			}),
			ViewDetailButton = 0
		}
		local viewDetailButton

		if props.messageType == "RevokedItems" then
			viewDetailButton = React.createElement(Button, {
				tag = "size-full-0 auto-y",
				onActivated = onActivated2,
				text = v3.ViewInbox,
				variant = ButtonVariant.Standard,
				width = UDim.new(1, 0),
				LayoutOrder = 4
			})
		end

		v5.ViewDetailButton = viewDetailButton
		return createElement(View, { tag = "col gap-medium auto-y size-full-0 fill-x" }, v5)
	end

	return React.createElement(ModalWindow, { screenSize = screenSize, isFullHeight = false }, {
		ViewFrame = React.createElement(
			View,
			{ tag = "auto-y size-full-0 padding-xxlarge col align-x-left align-y-top" },
			{ ContentContainer = fn2(), ButtonContainer = fn3() }
		)
	})
end

return (withMappedNavigationParams(ItemsUnavailablePrompt))
