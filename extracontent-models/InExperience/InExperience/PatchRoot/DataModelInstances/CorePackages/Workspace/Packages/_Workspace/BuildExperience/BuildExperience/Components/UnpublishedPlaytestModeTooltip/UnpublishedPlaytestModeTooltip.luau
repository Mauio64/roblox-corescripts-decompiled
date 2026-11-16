local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local BuildAppStorage = require(BuildExperience.Storage.BuildAppStorage)
local BuildModeLaunch = require(parent.BuildExperiencePlaytestLaunch.BuildModeLaunch)

local EducationalTooltip = Foundation.EducationalTooltip
local OverlayProvider = Foundation.OverlayProvider
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local FIntUnpublishedPlaytestModeTooltipDisplayLimit = SharedFlags.FIntUnpublishedPlaytestModeTooltipDisplayLimit

local function getCanShow(anchorRef) -- 2 equivalent calls inferred from this helper
	local canShow

	if FIntUnpublishedPlaytestModeTooltipDisplayLimit > 0 then
		canShow = BuildModeLaunch:hasBuildMode()

		if canShow then
			if
				BuildAppStorage.getUnpublishedPlaytestModeTooltipDisplayCount() < FIntUnpublishedPlaytestModeTooltipDisplayLimit
				and anchorRef ~= nil
			then
				canShow = anchorRef.current ~= nil
			else
				canShow = false
			end
		end
	else
		canShow = false
	end

	return canShow
end

local function UnpublishedPlaytestModeTooltip(p)
	local v = useLocalization({
		description = LocalizationStrings.UNPUBLISHED_PLAYTEST_MODE_TOOLTIP_DESCRIPTION,
		title = LocalizationStrings.UNPUBLISHED_PLAYTEST_MODE_TOOLTIP_TITLE
	})

	local state, setState = React.useState(getCanShow(p.anchorRef)) -- inferred equivalent call
	local ref = React.useRef(false)

	local v2 = React.useCallback(function()
		setState(false)
	end, {})

	React.useEffect(function()
		setState(getCanShow(p.anchorRef)) -- inferred equivalent call
	end, { p.anchorRef })

	React.useEffect(function()
		if state and not ref.current then
			ref.current = true
			BuildAppStorage.incrementUnpublishedPlaytestModeTooltipDisplayCount()
		end
	end, { state })

	if state then
		return React.createElement(OverlayProvider, nil, {
			Tooltip = React.createElement(EducationalTooltip, {
				anchorRef = p.anchorRef,
				title = v.title,
				text = v.description,
				side = PopoverSide.Bottom,
				align = PopoverAlign.Start,
				isOpen = state,
				onClose = v2,
				onPressedOutside = v2,
				testId = "unpublished-playtest-mode-tooltip",
				Visible = p.isVisible
			})
		})
	end

	return nil
end

return React.memo(UnpublishedPlaytestModeTooltip)
