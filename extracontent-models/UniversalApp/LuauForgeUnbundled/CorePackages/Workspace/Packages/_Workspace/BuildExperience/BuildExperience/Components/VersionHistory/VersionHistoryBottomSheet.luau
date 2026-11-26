local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local FIntBuildExperienceVersionHistoryLoadMoreViewportPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FIntBuildExperienceVersionHistoryLoadMoreViewportPercent")
local LatestVersionCardView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/LatestVersionCard/LatestVersionCardView")
local LiveVersionCardView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/LiveVersionCard/LiveVersionCardView")
local RestoreVersionDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/RestoreVersionDialog")
local VersionHistoryCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryCard")
local VersionHistorySection = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistorySection")
local useScrollEndReached = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/useScrollEndReached")
local useScrollPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useScrollPerformanceTracker")

local checkbox = Foundation.Checkbox
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue

local VERSION_HISTORY_VERSIONS_TITLE = LocalizationStrings.VERSION_HISTORY_VERSIONS_TITLE

local function VersionHistoryContent(props)
	useScrollPerformanceTracker("LuaApp_Build_VersionHistory_Scroll", props.scrollingFrameRef)
	useScrollEndReached(props.scrollingFrameRef, FIntBuildExperienceVersionHistoryLoadMoreViewportPercent / 100, props.onEndReached)

	return React.createElement(
		sheet.Content,
		{ scrollingFrameRef = props.scrollingFrameRef },
		props.children
	)
end

local function VersionHistoryBottomSheet(props)
	local testId = props.testId or "version-history-bottom-sheet"
	local ref = React.useRef(nil)
	local scrollingFrameRef = props.scrollingFrameRef or ref
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(true)
	local v5 = useLocalization({
		allVersions = LocalizationStrings.VERSION_HISTORY_ALL_VERSIONS,
		hideAutosaved = LocalizationStrings.VERSION_HISTORY_HIDE_AUTOSAVED,
		published = LocalizationStrings.VERSION_HISTORY_PUBLISHED,
		title = VERSION_HISTORY_VERSIONS_TITLE
	})

	local hideAutosaved = v5.hideAutosaved
	local title = v5.title
	local v6 = React.useCallback(function()
		setState(nil)
		props.onClose()
	end, { props.onClose })

	local v7 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local v8 = React.useCallback(function()
		if state2 then
			return
		end

		setState(nil)
	end, { state2 })

	local v9 = React.useCallback(function()
		if state == nil or (props.isRestoreDisabled or state2) then
			return
		end

		setState2(true)
		local v10 = props.onRestore(state)

		if v10 == nil then
			setState2(false)
		else
			v10:andThen(function()
				setState2(false)
				setState(nil)

				if props.onRestoreStarted ~= nil then
					props.onRestoreStarted()
				end
			end):catch(function()
				setState2(false)
			end)
		end
	end, {
		state,
		props.isRestoreDisabled,
		props.onRestore,
		props.onRestoreStarted,
		state2
	})

	local v10 = React.useMemo(function()
		local children = {}

		local v11 = props.latestVersion ~= nil

		if v11 then
			children.LatestVersionCard = React.createElement(LatestVersionCardView, props.latestVersion)
		end

		for k, entry in props.entries do
			if not (not v11 or k ~= 1) or state3 and entry.isAutosaved then
				continue
			end

			local formatted = `{testId}-card-{entry.id}`
			children[entry.id] = React.createElement(VersionHistoryCard, {
				layoutOrder = k,
				versionLabel = entry.versionLabel,
				title = entry.title,
				description = entry.description,
				badgeText = entry.badgeText,
				isRestoreDisabled = props.isRestoreDisabled,
				onRestore = function()
					v7(entry)
				end,
				testId = formatted
			})
		end

		return children
	end, {
		props.entries,
		props.isRestoreDisabled,
		props.latestVersion,
		state3,
		v7,
		testId
	})

	local element = React.createElement(view, {
		LayoutOrder = 1,
		tag = "row size-full-0 auto-y"
	}, {
		Checkbox = React.createElement(checkbox, {
			label = hideAutosaved,
			isChecked = state3,
			onActivated = setState3,
			testId = `{testId}-autosave-filter`
		})
	})

	local v11 = if props.statusText then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.statusText,
		tag = "size-full-0 auto-y padding-bottom-medium text-body-medium text-wrap text-align-x-left content-default"
	}) else nil

	local v12 = {
		AutosaveFilter = element,
		Status = v11,
		Cards = React.createElement(
			view,
			{
				LayoutOrder = 3,
				tag = "col gap-medium size-full-0 auto-y padding-bottom-large"
			},
			v10
		)
	}

	local allVersions = v5.allVersions
	local published = v5.published
	local v13 = useScaledValue(32)

	local createElement = React.createElement
	local v16 = {
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v13)
		},
		tag = "col size-full-0 auto-y",
		testId = `{testId}-sections`
	}

	local v18 = if props.liveVersion then React.createElement(
		VersionHistorySection,
		{ layoutOrder = 1, title = published, testId = `{testId}-published` },
		{
			LiveVersionCard = React.createElement(LiveVersionCardView, props.liveVersion)
		}
	) else nil
	local v14 = {
		Sections = createElement(view, v16, {
			Published = v18,
			AllVersions = React.createElement(
				VersionHistorySection,
				{
					layoutOrder = 2,
					title = allVersions,
					testId = `{testId}-all-versions`
				},
				v12
			)
		})
	}

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local v20 = {
		Sheet = React.createElement(sheet.Root, {
			isOpen = props.isOpen == nil or props.isOpen,
			snapPoints = { 0.5, 1 },
			defaultSnapPointIndex = 2,
			onClose = v6,
			testId = testId
		}, {
			Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
				Title = React.createElement(text, {
					LayoutOrder = 1,
					Text = title,
					tag = {
						["shrink auto-xy text-wrap text-align-x-left content-emphasis"] = true,
						["text-heading-medium"] = true
					}
				})
			}),
			Content = React.createElement(
				VersionHistoryContent,
				{
					scrollingFrameRef = scrollingFrameRef,
					onEndReached = props.onEndReached
				},
				v14
			)
		}),
		RestoreDialog = 0
	}

	local v21 = if state then React.createElement(RestoreVersionDialog, {
		isOpen = true,
		title = state.versionLabel,
		description = state.description,
		isLoading = state2,
		onRestore = v9,
		onCancel = v8
	}) else nil
	v20.RestoreDialog = v21
	return createElement2(fragment, nil, v20)
end

return VersionHistoryBottomSheet
