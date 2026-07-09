local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

require(Parent.RobloxAppHooks)
require(Parent.Style)

local UiMode = require(Parent.RobloxAppEnums).UiMode
local SharedFlags = require(Parent.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local GetFFlagConsoleApplyTokenizationEdp = SharedFlags.GetFFlagConsoleApplyTokenizationEdp
local FFlagLuaAppUnifyPlayButtonNonMobileEdp = SharedFlags.FFlagLuaAppUnifyPlayButtonNonMobileEdp

local function makeExperienceDetailsTokenMapper(p1, p2) -- line: 17
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), UiMode (copy), GetFFlagConsoleApplyTokenizationEdp (copy), FFlagLuaAppUnifyPlayButtonNonMobileEdp (copy)
	local v10 = nil
	local n2 = nil
	local v12 = nil
	local v13 = nil
	local n4 = nil
	local n5 = nil
	local v16 = nil
	local n6 = nil
	local n3 = nil
	local v19 = nil
	local v20 = nil
	local vector2 = nil
	local t1 = nil
	local v23 = nil
	local vector2_2 = nil
	local n7 = nil
	local v26 = nil
	local v27 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Radius.Medium else p2.Radius.Medium
	local v28 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_200 else p2.Size.Size_400
	local n1 = 1
	local v30 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_300 else p2.Size.Size_600
	local v31

	if p1.uiMode == UiMode.TenFoot then
		if GetFFlagConsoleApplyTokenizationEdp() then
			v26 = ((if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_100 else p2.Size.Size_200)) * 49
			v10 = ((if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_100 else p2.Size.Size_200)) * 33
		else
			v10 = 400
		end

		n2 = 0
		n3 = 0
		n4 = 0
		n5 = 4
		v12 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_400 else p2.Size.Size_800
		v13 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_100 else p2.Size.Size_200
		v16 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.LineHeight_300 else p2.LineHeight.LineHeight_130
		n6 = 0
		v19 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_500 else p2.Size.Size_1000
		v20 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Color.BackgroundUi.Default else p2.Color.Surface.Surface_300
		vector2 = Vector2.new(if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_200 else p2.Size.Size_400, if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_100 else p2.Size.Size_200)
		t1 = {
			dampingRatio = 1,
			frequency = 3
		}
		v23 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_300 else p2.Size.Size_600
		vector2_2 = Vector2.new(if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_800 else p2.Size.Size_1600, if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_1200 else p2.Size.Size_2400)
		n7 = 3000
		n1 = 0.6
		v31 = if not FFlagLuaAppUnifyPlayButtonNonMobileEdp then nil else if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_500 else p2.Size.Size_1000
	else
		v31 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Size_600 else p2.Size.Size_1200
	end

	return {
		ThumbnailSize = v10,
		ThumbnailMargin = v12,
		SideMargin = n2,
		HeaderItemPadding = v13,
		HeaderDescriptionMaxRows = n5,
		HeaderDescriptionLineHeight = v16,
		ThumbnailShadowHeight = n6,
		HeaderGradientHeight = n3,
		HeaderBarBackgroundHeight = n4,
		HeaderBottomMargin = v19,
		ActionBarButtonBackgroundColor = v20,
		ActionBarTextButtonPadding = vector2,
		AnimationConfig = t1,
		ItemPadding = v23,
		SafeAreaSize = vector2_2,
		TrailingWhitespace = n7,
		PanelRadius = v27,
		PanelHeaderMargin = v28,
		PanelWidthScale = n1,
		PanelInnerPadding = v30,
		IconSize = if not FFlagRenameDeprecatedUIBloxTokens then p2.Semantic.Icon.Size.Medium else p2.Size.Size_900,
		ExpandableAreaHeightOffset = if not GetFFlagConsoleApplyTokenizationEdp() then nil else v26,
		actionBarHeight = v31
	}
end

return makeExperienceDetailsTokenMapper
