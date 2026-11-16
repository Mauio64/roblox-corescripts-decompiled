local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FIntBuildExperienceVersionHistoryLoadMoreViewportPercent = require(BuildExperience.Flags.FIntBuildExperienceVersionHistoryLoadMoreViewportPercent)
local LatestVersionCardView = require(script.Parent.LatestVersionCard.LatestVersionCardView)
local LiveVersionCardView = require(script.Parent.LiveVersionCard.LiveVersionCardView)
local RestoreVersionDialog = require(script.Parent.RestoreVersionDialog)
local VersionHistoryCard = require(script.Parent.VersionHistoryCard)
local VersionHistorySection = require(script.Parent.VersionHistorySection)
local useScrollEndReached = require(script.Parent.useScrollEndReached)
local useScrollPerformanceTracker = require(BuildExperience.Telemetry.useScrollPerformanceTracker)

local Checkbox = Foundation.Checkbox
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue

local VERSION_HISTORY_VERSIONS_TITLE = LocalizationStrings.VERSION_HISTORY_VERSIONS_TITLE

local function VersionHistoryContent(props)
	useScrollPerformanceTracker("LuaApp_Build_VersionHistory_Scroll", props.scrollingFrameRef)
	useScrollEndReached(
		props.scrollingFrameRef,
		FIntBuildExperienceVersionHistoryLoadMoreViewportPercent / 100,
		props.onEndReached
	)

	return React.createElement(Sheet.Content, { scrollingFrameRef = props.scrollingFrameRef }, props.children)
end

local function VersionHistoryBottomSheet(props)
	local testId = props.testId or "version-history-bottom-sheet"
	local ref = React.useRef(nil)
	local scrollingFrameRef = props.scrollingFrameRef or ref
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(true)
	local v = useLocalization({
		allVersions = LocalizationStrings.VERSION_HISTORY_ALL_VERSIONS,
		hideAutosaved = LocalizationStrings.VERSION_HISTORY_HIDE_AUTOSAVED,
		published = LocalizationStrings.VERSION_HISTORY_PUBLISHED,
		title = VERSION_HISTORY_VERSIONS_TITLE
	})

	local hideAutosaved = v.hideAutosaved
	local title = v.title
	local onClose = React.useCallback(function()
		setState(nil)
		props.onClose()
	end, { props.onClose })

	local v2 = React.useCallback(function(p)
		setState(p)
	end, {})

	local onCancel = React.useCallback(function()
		if state2 then
			return
		end

		setState(nil)
	end, { state2 })

	local onRestore = React.useCallback(function()
		if state == nil or (props.isRestoreDisabled or state2) then
			return
		end

		setState2(true)
		local v3 = props.onRestore(state)

		if v3 == nil then
			setState2(false)
		else
			v3:andThen(function()
				setState2(false)
				setState(nil)

				if props.onRestoreStarted ~= nil then
					props.onRestoreStarted()
				end
			end):catch(function()
				setState2(false)
			end)
		end
	end, { state, props.isRestoreDisabled, props.onRestore, props.onRestoreStarted, state2 })

	local v3 = React.useMemo(function()
		local children = {}

		local v3 = props.latestVersion ~= nil

		if v3 then
			children.LatestVersionCard = React.createElement(LatestVersionCardView, props.latestVersion)
		end

		for k, entry in props.entries do
			if not (not v3 or k ~= 1) or state3 and entry.isAutosaved then
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
					v2(entry)
				end,
				testId = formatted
			})
		end

		return children
	end, { props.entries, props.isRestoreDisabled, props.latestVersion, state3, v2, testId })

	local element = React.createElement(View, { LayoutOrder = 1, tag = "row size-full-0 auto-y" }, {
		Checkbox = React.createElement(Checkbox, {
			label = hideAutosaved,
			isChecked = state3,
			onActivated = setState3,
			testId = `{testId}-autosave-filter`
		})
	})
	local status

	if props.statusText then
		status = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.statusText,
			tag = "size-full-0 auto-y padding-bottom-medium text-body-medium text-wrap text-align-x-left content-default"
		})
	end

	local v4 = {
		AutosaveFilter = element,
		Status = status,
		Cards = React.createElement(
			View,
			{ LayoutOrder = 3, tag = "col gap-medium size-full-0 auto-y padding-bottom-large" },
			v3
		)
	}

	local allVersions = v.allVersions
	local published = v.published
	local v5 = useScaledValue(32)

	local createElement = React.createElement
	local v6 = {
		layout = { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, v5) },
		tag = "col size-full-0 auto-y",
		testId = `{testId}-sections`
	}
	local published2

	if props.liveVersion then
		published2 = React.createElement(
			VersionHistorySection,
			{ layoutOrder = 1, title = published, testId = `{testId}-published` },
			{
				LiveVersionCard = React.createElement(LiveVersionCardView, props.liveVersion)
			}
		)
	end

	local v7 = {
		Sections = createElement(View, v6, {
			Published = published2,
			AllVersions = React.createElement(
				VersionHistorySection,
				{ layoutOrder = 2, title = allVersions, testId = `{testId}-all-versions` },
				v4
			)
		})
	}

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local v8 = {
		Sheet = React.createElement(Sheet.Root, {
			isOpen = props.isOpen == nil or props.isOpen,
			snapPoints = { 0.5, 1 },
			defaultSnapPointIndex = 2,
			onClose = onClose,
			testId = testId
		}, {
			Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
				Title = React.createElement(Text, {
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
				{ scrollingFrameRef = scrollingFrameRef, onEndReached = props.onEndReached },
				v7
			)
		}),
		RestoreDialog = 0
	}
	local restoreDialog

	if state then
		restoreDialog = React.createElement(RestoreVersionDialog, {
			isOpen = true,
			title = state.versionLabel,
			description = state.description,
			isLoading = state2,
			onRestore = onRestore,
			onCancel = onCancel
		})
	end

	v8.RestoreDialog = restoreDialog
	return createElement2(fragment, nil, v8)
end

return VersionHistoryBottomSheet
