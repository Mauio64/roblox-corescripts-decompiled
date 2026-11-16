require("@luauforge/bundled/dsp")
require("@luauforge/bundled/dsj")
local uiMode = require("@luauforge/bundled/drn").UiMode

local module = require("@luauforge/bundled/dqB")

local getFFlagConsoleApplyTokenizationEdp = module.GetFFlagConsoleApplyTokenizationEdp
local fFlagLuaAppUnifyPlayButtonNonMobileEdp = module.FFlagLuaAppUnifyPlayButtonNonMobileEdp

local function makeExperienceDetailsTokenMapper(p2, data)
	local v5 = nil
	local v6 = nil
	local size_800 = nil
	local size_200 = nil
	local v7 = nil
	local v8 = nil
	local lineHeight_130 = nil
	local v9 = nil
	local v10 = nil
	local size_1000 = nil
	local surface_300 = nil
	local vector2 = nil
	local v11 = nil
	local size_600 = nil
	local vector2_2 = nil
	local v12 = nil
	local v13 = nil
	local medium = data.Radius.Medium
	local size_400 = data.Size.Size_400
	local v14 = 1
	local size_600_2 = data.Size.Size_600
	local v15

	if p2.uiMode == uiMode.TenFoot then
		if getFFlagConsoleApplyTokenizationEdp() then
			v13 = data.Size.Size_200 * 49
			v5 = data.Size.Size_200 * 33
		else
			v5 = 400
		end

		v6 = 0
		v10 = 0
		v7 = 0
		v8 = 4
		size_800 = data.Size.Size_800
		size_200 = data.Size.Size_200
		lineHeight_130 = data.LineHeight.LineHeight_130
		v9 = 0
		size_1000 = data.Size.Size_1000
		surface_300 = data.Color.Surface.Surface_300
		vector2 = Vector2.new(data.Size.Size_400, data.Size.Size_200)
		v11 = { dampingRatio = 1, frequency = 3 }

		size_600 = data.Size.Size_600
		vector2_2 = Vector2.new(data.Size.Size_1600, data.Size.Size_2400)
		v12 = 3000
		v14 = 0.6

		if fFlagLuaAppUnifyPlayButtonNonMobileEdp then
			v15 = data.Size.Size_1000
		end
	else
		v15 = data.Size.Size_1200
	end

	local experienceDetailsTokenMapper = {
		ThumbnailSize = v5,
		ThumbnailMargin = size_800,
		SideMargin = v6,
		HeaderItemPadding = size_200,
		HeaderDescriptionMaxRows = v8,
		HeaderDescriptionLineHeight = lineHeight_130,
		ThumbnailShadowHeight = v9,
		HeaderGradientHeight = v10,
		HeaderBarBackgroundHeight = v7,
		HeaderBottomMargin = size_1000,
		ActionBarButtonBackgroundColor = surface_300,
		ActionBarTextButtonPadding = vector2,
		AnimationConfig = v11,
		ItemPadding = size_600,
		SafeAreaSize = vector2_2,
		TrailingWhitespace = v12,
		PanelRadius = medium,
		PanelHeaderMargin = size_400,
		PanelWidthScale = v14,
		PanelInnerPadding = size_600_2,
		IconSize = data.Size.Size_900,
		ExpandableAreaHeightOffset = 0,
		actionBarHeight = 0
	}

	if not getFFlagConsoleApplyTokenizationEdp() then
		v13 = nil
	end

	experienceDetailsTokenMapper.ExpandableAreaHeightOffset = v13
	experienceDetailsTokenMapper.actionBarHeight = v15
	return experienceDetailsTokenMapper
end

return makeExperienceDetailsTokenMapper
