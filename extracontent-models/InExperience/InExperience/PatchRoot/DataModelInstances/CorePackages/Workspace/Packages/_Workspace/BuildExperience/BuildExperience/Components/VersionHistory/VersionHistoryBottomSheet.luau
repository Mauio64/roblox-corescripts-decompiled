local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local RestoreVersionDialog = require(script.Parent.RestoreVersionDialog)
local VersionHistoryCard = require(script.Parent.VersionHistoryCard)
local VersionHistoryUtils = require(script.Parent.VersionHistoryUtils)
local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local v10 = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else require(BuildExperience.Telemetry.useScrollPerformanceTracker)
local Checkbox = Foundation.Checkbox
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View

local function VersionHistoryContent(t1: {[any]: any}) -- line: 44
	-- upvalues: FFlagEnableBuildExperienceScrollPerformanceTracking (copy), v10 (copy), React (copy), Sheet (copy)
	if FFlagEnableBuildExperienceScrollPerformanceTracking then
		v10("LuaApp_Build_VersionHistory_Scroll", t1.scrollingFrameRef)
	end

	return React.createElement(Sheet.Content, {
		scrollingFrameRef = t1.scrollingFrameRef
	}, t1.children)
end
local function VersionHistoryBottomSheet(t2: {[any]: any}) -- line: 58
	-- upvalues: React (copy), VersionHistoryUtils (copy), VersionHistoryCard (copy), Sheet (copy), FoundationText (copy), LocalizationStrings (copy), VersionHistoryContent (copy), View (copy), Checkbox (copy), RestoreVersionDialog (copy)
	local v19 = t2.testId or "version-history-bottom-sheet"
	local v20 = React.useRef(nil)
	local v21 = t2.scrollingFrameRef or v20
	local v22, v23 = React.useState(nil)
	local v24, v25 = React.useState(true)
	local v26 = React.useCallback(function() -- line: 65
		-- upvalues: v23 (copy), t2 (copy)
		v23(nil)
		t2.onClose()
	end, { t2.onClose })
	local v27 = React.useCallback(function(t3: {[any]: any}) -- line: 70
		-- upvalues: v23 (copy)
		v23(t3)
	end, {})
	local v28 = React.useCallback(function() -- line: 74
		-- upvalues: v23 (copy)
		v23(nil)
	end, {})
	local v29 = React.useCallback(function() -- line: 78
		-- upvalues: v22 (copy), t2 (copy), v23 (copy)
		if v22 and not t2.isRestoreDisabled then
			t2.onRestore(v22)
		end

		v23(nil)
	end, {
		v22,
		t2.isRestoreDisabled,
		t2.onRestore
	})
	local v30 = React.useMemo(function() -- line: 86
		-- upvalues: t2 (copy), VersionHistoryUtils (copy), v24 (copy), v19 (copy), React (copy), VersionHistoryCard (copy), v27 (copy)
		local t4 = {}

		for v33, v34 in t2.entries do
			if VersionHistoryUtils.shouldShowEntry(v34.badgeText, v24) then
				local v35 = `{ v19 }-card-{ v34.id }`

				t4[v34.id] = React.createElement(VersionHistoryCard, {
					layoutOrder = v33,
					versionLabel = v34.versionLabel,
					title = v34.title,
					description = v34.description,
					badgeText = v34.badgeText,
					isRestoreDisabled = t2.isRestoreDisabled,
					onRestore = function() -- line: 98
						-- upvalues: v27 (copy), v34 (copy)
						v27(v34)
					end,
					testId = v35
				})
			end
		end

		return t4
	end, {
		t2.entries,
		t2.isRestoreDisabled,
		v24,
		v27,
		v19
	})

	return React.createElement(React.Fragment, nil, {
		Sheet = React.createElement(Sheet.Root, {
			defaultSnapPointIndex = 2,
			isOpen = t2.isOpen == nil or t2.isOpen,
			snapPoints = {
				0.5,
				1
			},
			onClose = v26,
			testId = v19
		}, {
			Header = React.createElement(Sheet.Header, {
				hasCloseAffordance = true
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "shrink auto-xy text-heading-small text-wrap text-align-x-left content-emphasis",
					Text = LocalizationStrings.VERSION_HISTORY_TITLE
				})
			}),
			Content = React.createElement(VersionHistoryContent, {
				scrollingFrameRef = v21
			}, {
				AutosaveFilter = React.createElement(View, {
					LayoutOrder = 1,
					tag = "row size-full-0 auto-y"
				}, {
					Checkbox = React.createElement(Checkbox, {
						label = LocalizationStrings.VERSION_HISTORY_HIDE_AUTOSAVED,
						isChecked = v24,
						onActivated = v25,
						testId = `{ v19 }-autosave-filter`
					})
				}),
				Status = if not t2.statusText then nil else React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y padding-bottom-medium text-body-medium text-wrap text-align-x-left content-default",
					Text = t2.statusText
				}),
				Cards = React.createElement(View, {
					LayoutOrder = 3,
					tag = "col gap-medium size-full-0 auto-y padding-bottom-large"
				}, v30)
			})
		}),
		RestoreDialog = if not v22 then nil else React.createElement(RestoreVersionDialog, {
			isOpen = true,
			title = v22.versionLabel,
			description = v22.description,
			onRestore = v29,
			onCancel = v28
		})
	})
end

return VersionHistoryBottomSheet
