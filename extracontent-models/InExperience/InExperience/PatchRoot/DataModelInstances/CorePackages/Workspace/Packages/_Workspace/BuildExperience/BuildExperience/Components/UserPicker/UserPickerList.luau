local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local UserPickerRow = require(script.Parent.UserPickerRow)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local List = Foundation.List
local Skeleton = Foundation.Skeleton
local FoundationText = Foundation.Text
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local EnumsRadius = Foundation.Enums.Radius
local USER_PICKER_NO_RESULTS = LocalizationStrings.USER_PICKER_NO_RESULTS

local function trim(s1: string) -- line: 42
	return (string.gsub(s1, "^%s*(.-)%s*$", "%1"))
end
local function renderSkeletonRow(n1: number, s2: string) -- line: 48
	-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	return React.createElement(View, {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small",
		LayoutOrder = n1,
		testId = s2
	}, {
		Avatar = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(36, 36),
			radius = EnumsRadius.Circle
		}),
		Lines = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col fill gap-small auto-y"
		}, {
			Title = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.5, 0, 0, 12),
				radius = EnumsRadius.Small
			}),
			Description = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(0.3, 0, 0, 10),
				radius = EnumsRadius.Small
			})
		})
	})
end
local function UserPickerList(t1: {[any]: any}) -- line: 77
	-- upvalues: renderSkeletonRow (copy), React (copy), View (copy), USER_PICKER_NO_RESULTS (copy), FoundationText (copy), UserPickerRow (copy), List (copy), InputSize (copy)
	local v21 = t1.testId or "user-picker-list"
	local userIds = t1.userIds

	if #userIds == 0 and t1.isLoading then
		local t2 = {}

		for i = 1, 6 do
			t2[`skeleton-{ i }`] = renderSkeletonRow(i, `{ v21 }-skeleton-{ i }`)
		end

		return React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = t1.layoutOrder,
			testId = `{ v21 }-loading`
		}, t2)
	end

	if #userIds == 0 and not t1.isLoading then
		local searchText = t1.searchText
		local v26 = if string.gsub(searchText, "^%s*(.-)%s*$", "%1") == "" then t1.emptyText else USER_PICKER_NO_RESULTS

		if v26 ~= nil then
			return React.createElement(View, {
				tag = "col align-x-center size-full-0 auto-y padding-y-xlarge",
				LayoutOrder = t1.layoutOrder,
				testId = `{ v21 }-empty`
			}, {
				Text = React.createElement(FoundationText, {
					tag = "auto-xy text-body-large text-align-x-center content-muted",
					Text = v26
				})
			})
		end
	end

	local t3 = {}

	for v28, v29 in userIds do
		t3[`row-{ v29 }`] = React.createElement(UserPickerRow, {
			userId = v29,
			isSelected = t1.isSelected(v29),
			isDisabled = not t1.canSelect(v29),
			onToggle = function() -- line: 118
				-- upvalues: t1 (copy), v29 (copy)
				t1.toggleSelected(v29)
			end,
			layoutOrder = v28,
			testId = `{ v21 }-user-{ v29 }`
		})
	end

	return React.createElement(List.Root, {
		hasDivider = false,
		isContained = false,
		LayoutOrder = t1.layoutOrder,
		size = InputSize.Medium,
		testId = `{ v21 }-results`
	}, t3)
end

return UserPickerList
