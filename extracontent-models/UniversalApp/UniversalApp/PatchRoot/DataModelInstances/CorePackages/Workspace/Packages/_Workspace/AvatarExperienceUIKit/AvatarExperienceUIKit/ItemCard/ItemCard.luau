local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local UIBlox = require(AvatarExperienceUIKitParent.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local FFlagAXMigrateAXToGlobalAutofocus = require(AvatarExperienceUIKitParent.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

require(AvatarExperienceUIKit.BackgroundLayers.BackgroundLayers)

local ItemCardBackgroundsWrapper = require(script.Parent.ItemCardBackgroundsWrapper)
local AvatarExperienceFlags = require(AvatarExperienceUIKitParent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXLookAndFeelBackgrounds = AvatarExperienceFlags.FFlagAXLookAndFeelBackgrounds
local FFlagAXSelectedBorderWrapsBackground = AvatarExperienceFlags.FFlagAXSelectedBorderWrapsBackground

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 33
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), useSelectionCursor (copy), CursorKind (copy), useTokens (copy), React (copy), FFlagAXMISEnableMultiShopping (copy), FFlagAXLookAndFeelBackgrounds (copy), ItemCardBackgroundsWrapper (copy), FFlagAXSelectedBorderWrapsBackground (copy), View (copy)
	local v18 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useSelectionCursor(CursorKind.RoundedRect)
	local v19 = useTokens()

	return React.createElement("TextButton", {
		Selectable = if not FFlagAXMISEnableMultiShopping then nil else t1.Selectable,
		SelectionImageObject = v18,
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Event.Activated] = if not t1.isDisabled then t1.onActivated else nil,
		ref = p1,
		Size = t1.Size,
		AutomaticSize = t1.AutomaticSize,
		LayoutOrder = t1.LayoutOrder,
		SelectionGroup = true,
		[React.Tag] = t1.tag
	}, if not FFlagAXLookAndFeelBackgrounds or (t1.backgroundLayers == nil or not (#t1.backgroundLayers > 0)) then {
		ItemCardListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v19.Gap.Small)
		}),
		ItemCardHeaderSlot = t1.headerSlot,
		ItemCardFooterSlot = t1.footerSlot
	} else {
		BackgroundsWrapper = React.createElement(ItemCardBackgroundsWrapper, {
			backgroundLayers = t1.backgroundLayers,
			imageScaleType = t1.imageScaleType,
			headerSlot = t1.headerSlot,
			footerSlot = t1.footerSlot
		}),
		SelectedBorder = if not FFlagAXSelectedBorderWrapsBackground or not t1.showSelectionBorderWithBackground then nil else React.createElement(View, {
			tag = "size-full stroke-standard stroke-system-contrast radius-medium",
			testId = "card-selection-stroke",
			ZIndex = 2
		})
	})
end))
