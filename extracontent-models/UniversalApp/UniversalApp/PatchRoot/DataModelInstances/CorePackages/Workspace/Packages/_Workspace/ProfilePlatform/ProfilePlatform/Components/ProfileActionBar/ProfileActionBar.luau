local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Foundation = require(ProfilePlatformParent.Foundation)
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local IconSize = Foundation.Enums.IconSize
local ActionMenuButton = require(ProfilePlatform.Components.ProfileActionBar.ActionMenuButton)
local ProfileMoreButton = require(ProfilePlatform.Components.ProfileActionBar.ProfileMoreButton)
local useDisabledReasonText = require(ProfilePlatform.Components.ProfileActionBar.useDisabledReasonText)
local PlusMoreMenuTooltip = require(ProfilePlatform.Components.ProfileActionBar.PlusMoreMenuTooltip)
local useIsMeTab = require(ProfilePlatform.Hooks.useIsMeTab)
local FFlagEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagEnableCommunityVerificationModal)
local FFlagEnableProfilePlatformDisabledReasonText = require(ProfilePlatform.Flags.FFlagEnableProfilePlatformDisabledReasonText)
local FFlagPortEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagPortEnableCommunityVerificationModal)
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEnableTransferTooltip = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTransferTooltip)

require(ProfilePlatform.Types.UpsellTooltipProps)

local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab

local function ProfileActionBar(t1: {[any]: any}) -- line: 53
	-- upvalues: FFlagEnableProfilePlatformDisabledReasonText (copy), useTokens (copy), FFlagAXEnableProfileTab (copy), useIsMeTab (copy), ButtonVariant (copy), React (copy), useDisabledReasonText (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), ActionMenuButton (copy), Button (copy), FillBehavior (copy), InputSize (copy), FFlagPortEnableCommunityVerificationModal (copy), FFlagEnableCommunityVerificationModal (copy), IconButton (copy), IconSize (copy), FFlagProfilePlatformEnableTransferTooltip (copy), ProfileMoreButton (copy), PlusMoreMenuTooltip (copy), View (copy), FoundationText (copy), HorizontalPageMargin (copy)
	local v29 = if not FFlagEnableProfilePlatformDisabledReasonText then nil else useTokens()
	local v30 = if not FFlagAXEnableProfileTab then nil else useIsMeTab()
	local profileActions = t1.profileActions
	local Standard = ButtonVariant.Standard
	local v33 = if not FFlagEnableProfilePlatformDisabledReasonText then nil else React.useMemo(function() -- line: 64
		-- upvalues: profileActions (copy)
		if profileActions.primary then
			for _, v in ipairs(profileActions.primary) do
				if v.disabledReason then
					return v.disabledReason
				end
			end
		end

		return nil
	end, { profileActions.primary })
	local v34 = if not FFlagEnableProfilePlatformDisabledReasonText then nil else useDisabledReasonText(v33)
	local v35 = React.useMemo(function() -- line: 83
		-- upvalues: profileActions (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), React (copy), ActionMenuButton (copy), t1 (copy), Standard (copy), ButtonVariant (copy), Button (copy), FillBehavior (copy), InputSize (copy), FFlagPortEnableCommunityVerificationModal (copy), FFlagEnableCommunityVerificationModal (copy), IconButton (copy), IconSize (copy), FFlagProfilePlatformEnableTransferTooltip (copy), ProfileMoreButton (copy), PlusMoreMenuTooltip (copy)
		local t2 = {}

		if profileActions.primary then
			for i, v in ipairs(profileActions.primary) do
				if FFlagProfilePlatformEnableEditAppearanceMenu and v.menuItems then
					t2[i] = React.createElement(ActionMenuButton, {
						text = v.text,
						variant = v.variant,
						menuItems = v.menuItems,
						buttonRef = if i ~= 1 then nil else t1.primaryButtonRef,
						onMenuOpened = v.onActivated,
						LayoutOrder = i
					})
				else
					local v42 = if not v.variant then Standard else v.variant

					if #profileActions.primary >= 2 and i > 1 then
						v42 = ButtonVariant.Standard
					end

					t2[i] = React.createElement(Button, {
						onActivated = v.onActivated,
						text = v.text,
						isDisabled = v.isDisabled,
						isLoading = v.isLoading,
						variant = v42,
						width = UDim.new(1, 0),
						fillBehavior = FillBehavior.Fill,
						size = InputSize.Medium,
						ref = if i ~= 1 then nil else t1.primaryButtonRef,
						icon = if not FFlagPortEnableCommunityVerificationModal or not FFlagEnableCommunityVerificationModal then nil else v.icon,
						LayoutOrder = i
					})
				end
			end
		end

		if profileActions.secondary then
			for i, v in ipairs(profileActions.secondary) do
				t2[#(profileActions.primary or {}) + i] = React.createElement(IconButton, {
					onActivated = v.onActivated,
					icon = v.icon,
					size = IconSize.Medium,
					isDisabled = v.isDisabled,
					variant = ButtonVariant.Standard,
					LayoutOrder = #(profileActions.primary or {}) + i
				})
			end
		end

		if t1.openContextualMenu then
			local v45 = #(profileActions.primary or {}) + #(profileActions.secondary or {}) + 1
			local upsellTooltipProps = t1.upsellTooltipProps

			if FFlagProfilePlatformEnableTransferTooltip and t1.showPlusMoreMenuTooltip and upsellTooltipProps and upsellTooltipProps.plusMoreMenuTooltipBody and upsellTooltipProps.plusMoreMenuTooltipBody ~= "" then
				t2[v45] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					ClipsDescendants = false,
					ZIndex = 10,
					Size = UDim2.fromOffset(40, 40),
					LayoutOrder = v45
				}, {
					Button = React.createElement(ProfileMoreButton, {
						layoutOrder = 1,
						onActivated = t1.openContextualMenu,
						isSelected = t1.isContextualMenuOpen,
						buttonRef = t1.moreButtonRef
					}),
					PlusMoreMenuTooltip = React.createElement(PlusMoreMenuTooltip, {
						anchorRef = t1.moreButtonRef,
						isOpen = t1.showPlusMoreMenuTooltip == true,
						text = upsellTooltipProps.plusMoreMenuTooltipBody,
						title = upsellTooltipProps.plusMoreMenuTooltipTitle,
						onClose = upsellTooltipProps.onPlusMoreMenuTooltipClose,
						onPressedOutside = upsellTooltipProps.onPlusMoreMenuTooltipDismiss
					})
				})

				return t2
			end

			t2[v45] = React.createElement(ProfileMoreButton, {
				layoutOrder = v45,
				onActivated = t1.openContextualMenu,
				isSelected = t1.isContextualMenuOpen,
				buttonRef = t1.moreButtonRef
			})
		end

		return t2
	end, {
		profileActions.primary,
		profileActions.secondary,
		t1.openContextualMenu,
		t1.isContextualMenuOpen,
		t1.showPlusMoreMenuTooltip,
		t1.upsellTooltipProps,
		t1.moreButtonRef
	})
	local t3 = {
		UIListLayout = if not FFlagEnableProfilePlatformDisabledReasonText then nil else React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8)
		}),
		ActionBar = React.createElement(View, {
			tag = "size-full-0 auto-y row align-y-center gap-small",
			LayoutOrder = 0
		}, v35),
		DisabledReasonText = if not FFlagEnableProfilePlatformDisabledReasonText or (not v34 or not v29) then nil else React.createElement(FoundationText, {
			LayoutOrder = 1,
			TextWrapped = true,
			tag = "text-align-y-bottom text-align-x-left auto-y size-full-0",
			Text = v34,
			fontStyle = v29.Typography.CaptionMedium,
			colorStyle = v29.Color.Content.Emphasis
		})
	}

	if FFlagAXEnableProfileTab and v30 then
		return React.createElement(View, {
			tag = "auto-y size-full-0",
			LayoutOrder = t1.layoutOrder
		}, t3)
	end

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		size = UDim2.fromScale(1, 0),
		layoutOrder = t1.layoutOrder
	}, t3)
end

return ProfileActionBar
