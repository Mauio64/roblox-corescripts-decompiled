local module = require("@luauforge/deferred/gTR")
local module2 = require("@luauforge/deferred/gTT")
local useNavigation = require("@luauforge/deferred/gTX").useNavigation
local avatarScreen = require("@luauforge/deferred/gTY").Enums.AvatarScreen
local module3 = require("@luauforge/deferred/gTV")
local fFlagAXPhotoboothMomentsPage = module3.FFlagAXPhotoboothMomentsPage

local fFlagAXShowPhotoboothMomentsButtonFtuxTooltip = module3.FFlagAXShowPhotoboothMomentsButtonFtuxTooltip
local fFlagAXPhotoboothMomentsLogging = module3.FFlagAXPhotoboothMomentsLogging
local module4 = require("@luauforge/deferred/gTZ")

local useUnifiedEventTagging = module4.useUnifiedEventTagging
local unifiedEventLogEnums = module4.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = module4.Enums.UnifiedLoggingElementNameEnums

local iconName = module2.Enums.IconName
local iconSize = module2.Enums.IconSize

require("@luauforge/deferred/gTS")

local defineFastString = game:DefineFastString(
	"AXPhotoboothMomentsButtonFtuxTooltip",
	"AXPhotoboothMomentsButtonFtuxTooltip"
)
local frozen

if fFlagAXPhotoboothMomentsLogging then
	frozen = table.freeze({
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = unifiedLoggingElementNameEnums.PHOTOBOOTH_MOMENTS.AVATAR_PREVIEW_BUTTON
	})
else
	frozen = nil
end

local v5 = fFlagAXPhotoboothMomentsLogging
	and {
		hasDeferredActions = false,
		sessionTagName = module4.UnifiedEventLogConstants.L2_SESSION_TAG_NAME
	}
	or nil

local function usePhotoboothMomentsButtonViewModel(p2)
	local v6 = module2.Hooks.useTokens()
	local v7 = if fFlagAXPhotoboothMomentsPage then useNavigation() else nil

	local ref = if fFlagAXShowPhotoboothMomentsButtonFtuxTooltip then module.useRef(nil) else nil

	local ref2 = if fFlagAXPhotoboothMomentsLogging then module.useRef(nil) else nil

	if fFlagAXPhotoboothMomentsLogging then
		useUnifiedEventTagging({ ref = ref2, payload = frozen, options = v5 })
	end

	local function fn()
		if fFlagAXShowPhotoboothMomentsButtonFtuxTooltip and ref and ref.current then
			ref.current()
		end

		if fFlagAXPhotoboothMomentsPage then
			v7.navigate(avatarScreen.PhotoboothMomentsPage)
		end
	end

	local v10 = module.useCallback(fn, { if fFlagAXPhotoboothMomentsPage then v7 else nil })

	local v11 = {
		size = UDim2.fromOffset(v6.Size.Size_1100, v6.Size.Size_1100),
		backgroundStyle = v6.Color.Surface.Surface_100,
		iconName = iconName.FrameVideoCamera,
		iconSize = iconSize.Medium,
		iconStyle = v6.Color.Content.Emphasis,
		onActivated = v10,
		tooltipProps = fFlagAXShowPhotoboothMomentsButtonFtuxTooltip and {
			popoverSide = "Left",
			tooltipStorageKey = defineFastString,
			tooltipLocalizationKey = "Feature.Avatar.Label.ShareAvatarToMoments",
			showTooltip = true,
			dismissTooltipRef = ref
		} or nil,
		buttonRef = 0,
		LayoutOrder = 0
	}

	if not fFlagAXPhotoboothMomentsLogging then
		ref2 = nil
	end

	v11.buttonRef = ref2
	v11.LayoutOrder = p2.LayoutOrder
	return v11
end

return usePhotoboothMomentsButtonViewModel
