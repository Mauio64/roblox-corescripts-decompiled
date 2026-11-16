local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")

local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require(parent.SignalsReact)
local AvatarExperienceSlotBasedEditor = require(parent.AvatarExperienceSlotBasedEditor)
local InventoryItemAvailability = AvatarExperienceSlotBasedEditor.Enums.InventoryItemAvailability

local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
local SwitchAvatarButton = require(AvatarSwitcher.Components.SwitchAvatarButton)
local AvatarPreview = require(AvatarSwitcher.Components.AvatarPreview)
local AvatarCompatibilityWarning = require(AvatarSwitcher.Components.AvatarCompatibilityWarning)
local OutfitViewportUtils = require(AvatarSwitcher.Components.OutfitViewport.OutfitViewportUtils)
local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherAccurateAvatarWarning = AvatarExperienceFlags.FFlagAvatarSwitcherAccurateAvatarWarning
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherWarningLayoutFix = AvatarExperienceFlags2.FFlagAvatarSwitcherWarningLayoutFix

local AvatarExperienceFlags3 = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherExpiredItemsWarning = AvatarExperienceFlags3.FFlagAvatarSwitcherExpiredItemsWarning

local function PreviewPanel(p)
	local v = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local outfitId = SignalsReact.useSignalState(v.getSelectedOutfitId)
	local v2 = SignalsReact.useSignalState(v.getSelectedOutfitDetails)
	local v3 = SignalsReact.useSignalState(v.getExperienceAvatarSupportType)
	local v4 = SignalsReact.useSignalState(v.getExperienceAvatarType)
	local v5 = useTokens()

	local onActivated = React.useCallback(function()
		v.toggleRespawnPrompt(true)
	end, {})

	local state = nil
	local v6 = nil
	local onAvatarPreviewLoaded

	if FFlagAvatarSwitcherAccurateAvatarWarning then
		local setState
		state, setState = React.useState(false)
		v6 = setState
		onAvatarPreviewLoaded = React.useCallback(function(p2, p3)
			local v7 = not (v2 and v2.assetIds) and {} or v2.assetIds

			local missingAssetsInDescription = OutfitViewportUtils.hasMissingAssetsInDescription(p3, v7)

			local missingAccessoriesInHumanoid = OutfitViewportUtils.hasMissingAccessoriesInHumanoid(p2, p3)
			v6(missingAssetsInDescription or missingAccessoriesInHumanoid)
		end, { v2 })
		React.useEffect(function()
			v6(false)
		end, { outfitId })
	end

	local rigType

	if v4 == Enum.HumanoidRigType.R6 then
		rigType = Enum.HumanoidRigType.R6
	elseif v2 then
		rigType = v2.rigType
	end

	local v7

	if v2 == nil then
		v7 = false
	else
		v7 = v2.rigType ~= rigType or FFlagAvatarSwitcherAccurateAvatarWarning and state
	end

	local message

	if FFlagAvatarSwitcherExpiredItemsWarning then
		local v8 = v2 and v2.availabilityStatus == InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
		message = v7 and "Feature.AvatarSwitcher.Message.PartiallyUnsupported"
			or v8 and "Feature.AvatarSwitcher.Message.ExpiredItems"
			or nil
	end

	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local createElement3 = React.createElement
	local imageScaleType

	if p.compactLayout then
		imageScaleType = Enum.ScaleType.Fit
	else
		imageScaleType = Enum.ScaleType.Crop
	end

	local v8 = {
		outfitId = outfitId,
		rigType = rigType,
		imageScaleType = imageScaleType,
		showAvatarSupportWarning = v3 == ExperienceAvatarSupportType.UnknownSupport,
		showAvatarTypeCompatibilityWarning = 0,
		messageBottomPadding = 0,
		onAvatarPreviewLoaded = 0
	}
	local showAvatarTypeCompatibilityWarning

	if not FFlagAvatarSwitcherWarningLayoutFix then
		showAvatarTypeCompatibilityWarning = v7
	end

	v8.showAvatarTypeCompatibilityWarning = showAvatarTypeCompatibilityWarning
	local messageBottomPadding

	if p.compactLayout then
		messageBottomPadding = v5.Size.Size_800 + v5.Gap.Medium
	else
		messageBottomPadding = v5.Gap.Medium
	end

	v8.messageBottomPadding = messageBottomPadding

	if not FFlagAvatarSwitcherAccurateAvatarWarning then
		onAvatarPreviewLoaded = nil
	end

	v8.onAvatarPreviewLoaded = onAvatarPreviewLoaded
	local v9 = {
		AvatarPreview = createElement3(AvatarPreview, v8),
		FloatingButtonContainer = not FFlagAvatarSwitcherWarningLayoutFix and p.compactLayout and React.createElement(
			Foundation.View,
			{ tag = "auto-xy position-bottom-right anchor-bottom-right", LayoutOrder = 2 },
			{
				SizeConstraint = React.createElement("UISizeConstraint", {
					MinSize = Vector2.new(100, 0)
				}),
				SwitchButton = React.createElement(SwitchAvatarButton, { onActivated = onActivated })
			}
		),
		FloatingBottomContainer = 0
	}

	local floatingBottomContainer = FFlagAvatarSwitcherWarningLayoutFix and p.compactLayout

	if floatingBottomContainer then
		local createElement4 = React.createElement
		local view3 = Foundation.View
		local avatarCompatibilityWarningContainer

		if FFlagAvatarSwitcherExpiredItemsWarning then
			avatarCompatibilityWarningContainer = message
		else
			avatarCompatibilityWarningContainer = v7
		end

		if avatarCompatibilityWarningContainer then
			local createElement5 = React.createElement
			local view4 = Foundation.View

			local createElement6 = React.createElement
			local message2

			if FFlagAvatarSwitcherExpiredItemsWarning then
				message2 = message
			end

			avatarCompatibilityWarningContainer = createElement5(view4, {
				tag = "grow auto-y",
				LayoutOrder = 1
			}, {
				AvatarCompatibilityWarning = createElement6(AvatarCompatibilityWarning, {
					message = message2
				})
			})
		end

		floatingBottomContainer = createElement4(
			view3,
			{
				tag = "size-full-0 auto-y position-bottom-left anchor-bottom-left row gap-small align-x-right align-y-bottom"
			},
			{
				AvatarCompatibilityWarningContainer = avatarCompatibilityWarningContainer,
				FloatingButtonContainer = React.createElement(
					Foundation.View,
					{ tag = "auto-xy position-bottom-right anchor-bottom-right", LayoutOrder = 2 },
					{
						SizeConstraint = React.createElement("UISizeConstraint", {
							MinSize = Vector2.new(100, 0)
						}),
						SwitchButton = React.createElement(SwitchAvatarButton, {
							onActivated = onActivated
						})
					}
				)
			}
		)
	end

	v9.FloatingBottomContainer = floatingBottomContainer
	local v10 = {
		Content = createElement2(view2, { tag = "size-full-0 fill", LayoutOrder = 1 }, v9),
		AvatarCompatibilityWarning = 0,
		BottomButtonContainer = 0
	}

	local avatarCompatibilityWarning = FFlagAvatarSwitcherWarningLayoutFix and not p.compactLayout

	if avatarCompatibilityWarning then
		if FFlagAvatarSwitcherExpiredItemsWarning then
			avatarCompatibilityWarning = message
		else
			avatarCompatibilityWarning = v7
		end

		if avatarCompatibilityWarning then
			local createElement4 = React.createElement

			if not FFlagAvatarSwitcherExpiredItemsWarning then
				message = nil
			end

			avatarCompatibilityWarning = createElement4(AvatarCompatibilityWarning, {
				LayoutOrder = 2,
				message = message
			})
		end
	end

	v10.AvatarCompatibilityWarning = avatarCompatibilityWarning

	v10.BottomButtonContainer = not p.compactLayout and React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = FFlagAvatarSwitcherWarningLayoutFix and 3 or 2
	}, {
		SwitchButton = React.createElement(SwitchAvatarButton, { onActivated = onActivated })
	})
	return (createElement(view, {
		tag = FFlagAvatarSwitcherWarningLayoutFix and "size-full-full padding-x-xlarge padding-y-medium col gap-small" or "size-full-full padding-x-xlarge padding-y-medium col"
	}, v10))
end

return PreviewPanel
