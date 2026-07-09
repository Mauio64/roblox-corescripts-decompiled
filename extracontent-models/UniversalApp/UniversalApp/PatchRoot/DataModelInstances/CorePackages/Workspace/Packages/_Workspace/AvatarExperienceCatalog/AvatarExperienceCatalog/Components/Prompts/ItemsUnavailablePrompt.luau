local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local RoactNavigation = require(AvatarExperienceCatalogParent.RoactNavigation)
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local sendAXCounterV2 = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(AvatarExperienceCatalog.Constants)
local useSelector = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useSelector
local withMappedNavigationParams = require(AvatarExperienceCatalogParent.AvatarExperienceNavigation).withMappedNavigationParams
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization
local Foundation = require(AvatarExperienceCatalogParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ModalWindow = require(AvatarExperienceCatalogParent.UIBlox).App.Dialog.Modal.ModalWindow
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXLogItemsUnavailablePromptShown = AvatarExperienceFlags.FFlagAXLogItemsUnavailablePromptShown

local function v21(p1) -- line: 41
	return p1.ScreenSize
end

local t1 = {
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
	PartiallyExpiredItems = if not FFlagAXInventoryDurablesSupport then nil else {
		TitleText = "Feature.Durables.PartiallyExpiredItems.TitleText",
		BodyText = "Feature.Durables.PartiallyExpiredItems.BodyText"
	}
}

local function ItemsUnavailablePrompt(t2: {[any]: any}) -- line: 96
	-- upvalues: FFlagAXLogItemsUnavailablePromptShown (copy), React (copy), sendAXCounterV2 (copy), Constants (copy), FFlagAXInventoryDurablesSupport (copy), useLocalization (copy), t1 (copy), useSelector (copy), v21 (copy), RoactNavigation (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy), InputSize (copy), ModalWindow (copy)
	if FFlagAXLogItemsUnavailablePromptShown then
		React.useEffect(function() -- line: 98
			-- upvalues: sendAXCounterV2 (copy), Constants (copy), t2 (copy)
			sendAXCounterV2(Constants.COUNTERS.ItemsUnavailablePromptShown, {
				messageType = t2.messageType
			})
		end, {})
	end

	local t3 = {}

	if FFlagAXInventoryDurablesSupport then
		if t2.items then
			for _, v28 in t2.items do
				if v28.categoryLoc then
					t3[v28.categoryLoc] = v28.categoryLoc
				end
			end
		end
	else
		for _, v30 in t2.items do
			if v30.categoryLoc then
				t3[v30.categoryLoc] = v30.categoryLoc
			end
		end
	end

	local v31 = useLocalization(t3)

	local function localizeCategory(t4: {[any]: any}) -- line: 124
		-- upvalues: v31 (copy)
		if t4.categoryLoc and v31[t4.categoryLoc] then
			return v31[t4.categoryLoc]
		end

		return t4.category or ""
	end
	local function createItemListString(t5: {[any]: any}) -- line: 131
		-- upvalues: v31 (copy)
		local s1 = ""

		for _, v46 in t5 do
			s1 ..= "• " .. ((if not v46.categoryLoc or not v31[v46.categoryLoc] then v46.category or "" else v31[v46.categoryLoc])) .. " \"" .. v46.itemName .. "\"" .. (v46 == t5[#t5] and "" or "\n")
		end

		return s1
	end

	local t6

	if FFlagAXInventoryDurablesSupport then
		if t2.items and #t2.items > 0 then
			if t1[t2.messageType].BodyTextMultiple and #t2.items > 1 then
				t6 = {
					t1[t2.messageType].BodyTextMultiple,
					items = createItemListString(t2.items),
					lineBreak = "\n\n"
				}
			else
				t6 = {
					t1[t2.messageType].BodyText,
					item = t2.items[1].itemName
				}

				local v35 = t2.items[1]

				t6.category = if not v35.categoryLoc or not v31[v35.categoryLoc] then v35.category or "" else v31[v35.categoryLoc]
				t6.lineBreak = "\n\n"
			end
		else
			t6 = t1[t2.messageType].BodyText
		end
	elseif t1[t2.messageType].BodyTextMultiple and #t2.items > 1 then
		t6 = {
			t1[t2.messageType].BodyTextMultiple,
			items = createItemListString(t2.items),
			lineBreak = "\n\n"
		}
	else
		t6 = {
			t1[t2.messageType].BodyText,
			item = t2.items[1].itemName
		}

		local v36 = t2.items[1]

		t6.category = if not v36.categoryLoc or not v31[v36.categoryLoc] then v36.category or "" else v31[v36.categoryLoc]
		t6.lineBreak = "\n\n"
	end

	local v37 = useLocalization({
		ConfirmText = "Feature.Avatar.UnavailableItems.ConfirmText",
		ViewInbox = "Feature.Avatar.RevokedItems.ViewInbox",
		TitleText = t1[t2.messageType].TitleText,
		BodyText = t6
	})
	local v38 = useSelector(v21)
	local v39 = React.useCallback(function() -- line: 190
		-- upvalues: t2 (copy), RoactNavigation (copy)
		t2.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { t2.navigation })
	local v40 = React.useCallback(function() -- line: 194
		-- upvalues: v39 (copy), t2 (copy)
		v39()

		if t2.onConfirm then
			t2.onConfirm()
		end
	end, {
		t2.onConfirm,
		v39
	})
	local v41 = React.useCallback(function() -- line: 201
		-- upvalues: v39 (copy), t2 (copy)
		v39()

		if t2.navigateDown then
			t2.navigateDown()
		end
	end, {
		t2.navigateDown,
		v39
	})

	return React.createElement(ModalWindow, {
		isFullHeight = false,
		screenSize = v38
	}, {
		ViewFrame = React.createElement(View, {
			tag = "auto-y size-full-0 padding-xxlarge col align-x-left align-y-top"
		}, {
			ContentContainer = (function() -- line: 210
				-- upvalues: React (copy), View (copy), FoundationText (copy), v37 (copy)
				return React.createElement(View, {
					tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
				}, {
					PromptBodyTitle = React.createElement(FoundationText, {
						tag = "auto-xy text-align-x-left text-truncate-end text-heading-small text-wrap",
						LayoutOrder = 1,
						Text = v37.TitleText,
						padding = {
							bottom = UDim.new(0, 8)
						}
					}),
					PromptBodyText = React.createElement(FoundationText, {
						tag = "auto-xy text-align-x-left text-body-large text-wrap",
						LayoutOrder = 2,
						Text = v37.BodyText
					})
				})
			end)(),
			ButtonContainer = (function() -- line: 230
				-- upvalues: React (copy), View (copy), Button (copy), v40 (copy), v37 (copy), ButtonVariant (copy), FillBehavior (copy), InputSize (copy), t2 (copy), v41 (copy)
				return React.createElement(View, {
					tag = "col gap-medium auto-y size-full-0 fill-x"
				}, {
					Buttons = React.createElement(Button, {
						tag = "size-full-0 auto-y",
						LayoutOrder = 3,
						onActivated = v40,
						text = v37.ConfirmText,
						variant = ButtonVariant.Emphasis,
						width = UDim.new(1, 0),
						fillBehavior = FillBehavior.Fill,
						size = InputSize.Medium
					}),
					ViewDetailButton = if t2.messageType ~= "RevokedItems" then nil else React.createElement(Button, {
						tag = "size-full-0 auto-y",
						LayoutOrder = 4,
						onActivated = v41,
						text = v37.ViewInbox,
						variant = ButtonVariant.Standard,
						width = UDim.new(1, 0)
					})
				})
			end)()
		})
	})
end

return (withMappedNavigationParams(ItemsUnavailablePrompt))
