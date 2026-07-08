local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require(AvatarSwitcherParent.SignalsReact)
local InventoryItemAvailability = require(AvatarSwitcherParent.AvatarExperienceSlotBasedEditor).Enums.InventoryItemAvailability
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
local SwitchAvatarButton = require(AvatarSwitcher.Components.SwitchAvatarButton)
local AvatarPreview = require(AvatarSwitcher.Components.AvatarPreview)
local AvatarCompatibilityWarning = require(AvatarSwitcher.Components.AvatarCompatibilityWarning)
local OutfitViewportUtils = require(AvatarSwitcher.Components.OutfitViewport.OutfitViewportUtils)
local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)
local FFlagAvatarSwitcherAccurateAvatarWarning = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherAccurateAvatarWarning
local FFlagAvatarSwitcherWarningLayoutFix = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherWarningLayoutFix
local FFlagAvatarSwitcherExpiredItemsWarning = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherExpiredItemsWarning

local function PreviewPanel(t1: {[any]: any}) -- line: 33
	-- upvalues: SignalsReact (copy), getAvatarSwitcherStore (copy), useTokens (copy), React (copy), FFlagAvatarSwitcherAccurateAvatarWarning (copy), OutfitViewportUtils (copy), FFlagAvatarSwitcherExpiredItemsWarning (copy), InventoryItemAvailability (copy), Foundation (copy), FFlagAvatarSwitcherWarningLayoutFix (copy), AvatarPreview (copy), ExperienceAvatarSupportType (copy), SwitchAvatarButton (copy), AvatarCompatibilityWarning (copy)
	local v19 = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local v20 = SignalsReact.useSignalState(v19.getSelectedOutfitId)
	local v21 = SignalsReact.useSignalState(v19.getSelectedOutfitDetails)
	local v22 = SignalsReact.useSignalState(v19.getExperienceAvatarSupportType)
	local v23 = SignalsReact.useSignalState(v19.getExperienceAvatarType)
	local v24 = useTokens()
	local v25 = React.useCallback(function() -- line: 41
		-- upvalues: v19 (copy)
		v19.toggleRespawnPrompt(true)
	end, {})
	local v26 = nil
	local u27 = nil
	local v28 = nil

	if FFlagAvatarSwitcherAccurateAvatarWarning then
		local v29

		v26, v29 = React.useState(false)
		u27 = v29
		v28 = React.useCallback(function(p1, p2) -- line: 48
			-- upvalues: v21 (copy), OutfitViewportUtils (copy), u27 (ref)
			local v36 = if not v21 or not v21.assetIds then {} else v21.assetIds
			local v37 = OutfitViewportUtils.hasMissingAssetsInDescription(p2, v36)
			local v38 = OutfitViewportUtils.hasMissingAccessoriesInHumanoid(p1, p2)

			u27(v37 or v38)
		end, { v21 })
		React.useEffect(function() -- line: 60
			-- upvalues: u27 (ref)
			u27(false)
		end, { v20 })
	end

	local v30 = if v23 ~= Enum.HumanoidRigType.R6 then if not v21 then nil else v21.rigType else Enum.HumanoidRigType.R6
	local v31 = v21 ~= nil and (v30 ~= v21.rigType or FFlagAvatarSwitcherAccurateAvatarWarning and v26)
	local v32 = nil

	if FFlagAvatarSwitcherExpiredItemsWarning then
		local v33 = v21 and v21.availabilityStatus == InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems

		v32 = if not v31 then if not v33 then nil else "Feature.AvatarSwitcher.Message.ExpiredItems" else "Feature.AvatarSwitcher.Message.PartiallyUnsupported"
	end

	return (React.createElement(Foundation.View, {
		tag = not FFlagAvatarSwitcherWarningLayoutFix and "size-full-full padding-x-xlarge padding-y-medium col" or "size-full-full padding-x-xlarge padding-y-medium col gap-small"
	}, {
		Content = React.createElement(Foundation.View, {
			tag = "size-full-0 fill",
			LayoutOrder = 1
		}, {
			AvatarPreview = React.createElement(AvatarPreview, {
				outfitId = v20,
				rigType = v30,
				imageScaleType = if not t1.compactLayout then Enum.ScaleType.Crop else Enum.ScaleType.Fit,
				showAvatarSupportWarning = v22 == ExperienceAvatarSupportType.UnknownSupport,
				showAvatarTypeCompatibilityWarning = if FFlagAvatarSwitcherWarningLayoutFix then nil else v31,
				messageBottomPadding = if not t1.compactLayout then v24.Gap.Medium else v24.Size.Size_800 + v24.Gap.Medium,
				onAvatarPreviewLoaded = if not FFlagAvatarSwitcherAccurateAvatarWarning then nil else v28
			}),
			FloatingButtonContainer = not FFlagAvatarSwitcherWarningLayoutFix and (t1.compactLayout and React.createElement(Foundation.View, {
				tag = "auto-xy position-bottom-right anchor-bottom-right",
				LayoutOrder = 2
			}, {
				SizeConstraint = React.createElement("UISizeConstraint", {
					MinSize = Vector2.new(100, 0)
				}),
				SwitchButton = React.createElement(SwitchAvatarButton, {
					onActivated = v25
				})
			})),
			FloatingBottomContainer = FFlagAvatarSwitcherWarningLayoutFix and (t1.compactLayout and React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y position-bottom-left anchor-bottom-left row gap-small align-x-right align-y-bottom"
			}, {
				AvatarCompatibilityWarningContainer = ((if not FFlagAvatarSwitcherExpiredItemsWarning then v31 else v32)) and React.createElement(Foundation.View, {
					tag = "grow auto-y",
					LayoutOrder = 1
				}, {
					AvatarCompatibilityWarning = React.createElement(AvatarCompatibilityWarning, {
						message = if not FFlagAvatarSwitcherExpiredItemsWarning then nil else v32
					})
				}),
				FloatingButtonContainer = React.createElement(Foundation.View, {
					tag = "auto-xy position-bottom-right anchor-bottom-right",
					LayoutOrder = 2
				}, {
					SizeConstraint = React.createElement("UISizeConstraint", {
						MinSize = Vector2.new(100, 0)
					}),
					SwitchButton = React.createElement(SwitchAvatarButton, {
						onActivated = v25
					})
				})
			}))
		}),
		AvatarCompatibilityWarning = FFlagAvatarSwitcherWarningLayoutFix and (not t1.compactLayout and (((if not FFlagAvatarSwitcherExpiredItemsWarning then v31 else v32)) and React.createElement(AvatarCompatibilityWarning, {
			LayoutOrder = 2,
			message = if not FFlagAvatarSwitcherExpiredItemsWarning then nil else v32
		}))),
		BottomButtonContainer = not t1.compactLayout and React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = not FFlagAvatarSwitcherWarningLayoutFix and 2 or 3
		}, {
			SwitchButton = React.createElement(SwitchAvatarButton, {
				onActivated = v25
			})
		})
	}))
end

return PreviewPanel
