local module = require("@luauforge/deferred/gTR")
local module2 = require("@luauforge/deferred/gTT")
local useLocalization = require("@luauforge/deferred/gUd").Hooks.useLocalization
local useNavigation = require("@luauforge/deferred/gTX").useNavigation
local avatarScreen = require("@luauforge/deferred/gTY").Enums.AvatarScreen
local fFlagAXPhotoboothMomentsPage = require("@luauforge/deferred/gTV").FFlagAXPhotoboothMomentsPage
local fFlagAXPhotoboothMomentsLogging = require("@luauforge/deferred/gTV").FFlagAXPhotoboothMomentsLogging
local module3 = require("@luauforge/deferred/gTZ")

local useUnifiedEventTagging = module3.useUnifiedEventTagging
local unifiedEventLogEnums = module3.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = module3.Enums.UnifiedLoggingElementNameEnums

local iconName = module2.Enums.IconName
local iconSize = module2.Enums.IconSize

require("@luauforge/deferred/gUb")
local frozen

if fFlagAXPhotoboothMomentsLogging then
	frozen = table.freeze({
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = unifiedLoggingElementNameEnums.PHOTOBOOTH_MOMENTS.FULL_VIEW_BUTTON
	})
else
	frozen = nil
end

local v5 = fFlagAXPhotoboothMomentsLogging
	and {
		hasDeferredActions = false,
		sessionTagName = module3.UnifiedEventLogConstants.L2_SESSION_TAG_NAME
	}
	or nil

local function usePhotoboothMomentsFullViewButtonViewModel(p2)
	local v6 = module2.Hooks.useTokens()
	local v7 = useLocalization({ text = "Feature.Catalog.Label.ShareToMoments" })

	local v8 = if fFlagAXPhotoboothMomentsPage then useNavigation() else nil

	local function fn()
		if fFlagAXPhotoboothMomentsPage then
			v8.navigate(avatarScreen.PhotoboothMomentsPage)
		end
	end

	local v11 = module.useCallback(fn, { if fFlagAXPhotoboothMomentsPage then v8 else nil })

	local ref = if fFlagAXPhotoboothMomentsLogging then module.useRef(nil) else nil

	if fFlagAXPhotoboothMomentsLogging then
		useUnifiedEventTagging({ ref = ref, payload = frozen, options = v5 })
	end

	local v12 = {
		text = v7.text,
		backgroundStyle = v6.Color.ActionEmphasis.Background,
		contentStyle = v6.Color.ActionEmphasis.Foreground,
		iconName = iconName.FrameVideoCamera,
		iconSize = iconSize.Small,
		onActivated = v11,
		buttonRef = 0,
		LayoutOrder = 0
	}

	if not fFlagAXPhotoboothMomentsLogging then
		ref = nil
	end

	v12.buttonRef = ref
	v12.LayoutOrder = p2.LayoutOrder
	return v12
end

return usePhotoboothMomentsFullViewButtonViewModel
