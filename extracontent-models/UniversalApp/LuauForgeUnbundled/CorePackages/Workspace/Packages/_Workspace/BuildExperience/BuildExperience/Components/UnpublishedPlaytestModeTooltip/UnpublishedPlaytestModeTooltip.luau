local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local BuildAppStorage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/BuildAppStorage")
local BuildModeLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/BuildModeLaunch")

local educationalTooltip = Foundation.EducationalTooltip
local overlayProvider = Foundation.OverlayProvider
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign

local fIntUnpublishedPlaytestModeTooltipDisplayLimit = SharedFlags.FIntUnpublishedPlaytestModeTooltipDisplayLimit

local function getCanShow(p2)
	local canShow

	if fIntUnpublishedPlaytestModeTooltipDisplayLimit > 0 then
		canShow = BuildModeLaunch:hasBuildMode()

		if canShow then
			if
				BuildAppStorage.getUnpublishedPlaytestModeTooltipDisplayCount() < fIntUnpublishedPlaytestModeTooltipDisplayLimit
				and p2 ~= nil
			then
				canShow = p2.current ~= nil
			else
				canShow = false
			end
		end
	else
		canShow = false
	end

	return canShow
end

local function UnpublishedPlaytestModeTooltip(p2)
	local v5 = useLocalization({
		description = LocalizationStrings.UNPUBLISHED_PLAYTEST_MODE_TOOLTIP_DESCRIPTION,
		title = LocalizationStrings.UNPUBLISHED_PLAYTEST_MODE_TOOLTIP_TITLE
	})

	local useState = React.useState
	local anchorRef = p2.anchorRef
	local v6

	if fIntUnpublishedPlaytestModeTooltipDisplayLimit > 0 then
		v6 = BuildModeLaunch:hasBuildMode()

		if v6 then
			if
				BuildAppStorage.getUnpublishedPlaytestModeTooltipDisplayCount() < fIntUnpublishedPlaytestModeTooltipDisplayLimit
				and anchorRef ~= nil
			then
				v6 = anchorRef.current ~= nil
			else
				v6 = false
			end
		end
	else
		v6 = false
	end

	local state, setState = useState(v6)
	local ref = React.useRef(false)

	local v7 = React.useCallback(function()
		setState(false)
	end, {})

	React.useEffect(function()
		local anchorRef2 = p2.anchorRef
		local v9

		if fIntUnpublishedPlaytestModeTooltipDisplayLimit > 0 then
			v9 = BuildModeLaunch:hasBuildMode()

			if v9 then
				if
					BuildAppStorage.getUnpublishedPlaytestModeTooltipDisplayCount() < fIntUnpublishedPlaytestModeTooltipDisplayLimit
					and anchorRef2 ~= nil
				then
					v9 = anchorRef2.current ~= nil
				else
					v9 = false
				end
			end
		else
			v9 = false
		end

		setState(v9)
	end, { p2.anchorRef })

	React.useEffect(function()
		if state and not ref.current then
			ref.current = true
			BuildAppStorage.incrementUnpublishedPlaytestModeTooltipDisplayCount()
		end
	end, { state })

	if state then
		return React.createElement(overlayProvider, nil, {
			Tooltip = React.createElement(educationalTooltip, {
				anchorRef = p2.anchorRef,
				title = v5.title,
				text = v5.description,
				side = popoverSide.Bottom,
				align = popoverAlign.Start,
				isOpen = state,
				onClose = v7,
				onPressedOutside = v7,
				testId = "unpublished-playtest-mode-tooltip",
				Visible = p2.isVisible
			})
		})
	end

	return nil
end

return React.memo(UnpublishedPlaytestModeTooltip)
