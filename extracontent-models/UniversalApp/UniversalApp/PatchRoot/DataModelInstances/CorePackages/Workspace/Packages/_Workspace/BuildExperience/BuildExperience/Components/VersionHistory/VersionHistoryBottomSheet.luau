local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local RestoreVersionDialog = require(script.Parent.RestoreVersionDialog)
local VersionHistoryCard = require(script.Parent.VersionHistoryCard)
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View

local function VersionHistoryBottomSheet(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), VersionHistoryCard (copy), Sheet (copy), FoundationText (copy), View (copy), RestoreVersionDialog (copy)
	local v11 = t1.testId or "version-history-bottom-sheet"
	local v12, v13 = React.useState(nil)
	local v14 = React.useCallback(function() -- line: 40
		-- upvalues: v13 (copy), t1 (copy)
		v13(nil)
		t1.onClose()
	end, { t1.onClose })
	local v15 = React.useCallback(function(t2: {[any]: any}) -- line: 45
		-- upvalues: v13 (copy)
		v13(t2)
	end, {})
	local v16 = React.useCallback(function() -- line: 49
		-- upvalues: v13 (copy)
		v13(nil)
	end, {})
	local v17 = React.useCallback(function() -- line: 53
		-- upvalues: v12 (copy), t1 (copy), v13 (copy)
		if v12 and not t1.isRestoreDisabled then
			t1.onRestore(v12)
		end

		v13(nil)
	end, {
		v12,
		t1.isRestoreDisabled,
		t1.onRestore
	})
	local v18 = React.useMemo(function() -- line: 60
		-- upvalues: t1 (copy), v11 (copy), React (copy), VersionHistoryCard (copy), v15 (copy)
		local t3 = {}

		for v21, v22 in t1.entries do
			local v23 = `{ v11 }-card-{ v22.id }`

			t3[v22.id] = React.createElement(VersionHistoryCard, {
				layoutOrder = v21,
				versionLabel = v22.versionLabel,
				title = v22.title,
				description = v22.description,
				badgeText = v22.badgeText,
				isRestoreDisabled = t1.isRestoreDisabled,
				onRestore = function() -- line: 71
					-- upvalues: v15 (copy), v22 (copy)
					v15(v22)
				end,
				testId = v23
			})
		end

		return t3
	end, {
		t1.entries,
		t1.isRestoreDisabled,
		v15,
		v11
	})

	return React.createElement(React.Fragment, nil, {
		Sheet = React.createElement(Sheet.Root, {
			defaultSnapPointIndex = 2,
			isOpen = t1.isOpen == nil or t1.isOpen,
			snapPoints = {
				0.5,
				1
			},
			onClose = v14,
			testId = v11
		}, {
			Header = React.createElement(Sheet.Header, {
				hasCloseAffordance = true
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					Text = "Version History",
					tag = "auto-xy text-heading-small text-truncate-end content-emphasis"
				})
			}),
			Content = React.createElement(Sheet.Content, {
				scrollingFrameRef = t1.scrollingFrameRef
			}, {
				Status = if not t1.statusText then nil else React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y padding-bottom-medium text-body-medium text-wrap text-align-x-left content-default",
					Text = t1.statusText
				}),
				Cards = React.createElement(View, {
					LayoutOrder = 2,
					tag = "col gap-medium size-full-0 auto-y padding-bottom-large"
				}, v18)
			})
		}),
		RestoreDialog = if not v12 then nil else React.createElement(RestoreVersionDialog, {
			isOpen = true,
			title = v12.versionLabel,
			description = v12.description,
			onRestore = v17,
			onCancel = v16,
			testId = `{ v11 }-restore-dialog`
		})
	})
end

return VersionHistoryBottomSheet
