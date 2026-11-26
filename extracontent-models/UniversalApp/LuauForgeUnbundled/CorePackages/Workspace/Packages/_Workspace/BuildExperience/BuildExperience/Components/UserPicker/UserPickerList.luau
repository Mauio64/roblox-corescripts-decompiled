local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local UserPickerRow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/UserPickerRow")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local list = Foundation.List
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local inputSize = Foundation.Enums.InputSize
local radius = Foundation.Enums.Radius

local function trim(value)
	return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
end

local function renderSkeletonRow(i, p2)
	return React.createElement(
		view,
		{
			LayoutOrder = i,
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small",
			testId = p2
		},
		{
			Avatar = React.createElement(skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(36, 36),
				radius = radius.Circle
			}),
			Lines = React.createElement(view, {
				LayoutOrder = 2,
				tag = "col fill gap-small auto-y"
			}, {
				Title = React.createElement(skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.5, 0, 0, 12),
					radius = radius.Small
				}),
				Description = React.createElement(skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.3, 0, 0, 10),
					radius = radius.Small
				})
			})
		}
	)
end

local function UserPickerList(props)
	local v5 = useLocalization({ noResults = LocalizationStrings.USER_PICKER_NO_RESULTS }).noResults
	local testId = props.testId or "user-picker-list"
	local userIds = props.userIds

	if #userIds == 0 and props.isLoading then
		local v6 = {}

		for i = 1, 6 do
			v6[`skeleton-{i}`] = renderSkeletonRow(i, `{testId}-skeleton-{i}`)
		end

		return React.createElement(
			view,
			{
				LayoutOrder = props.layoutOrder,
				tag = "col gap-small size-full-0 auto-y",
				testId = `{testId}-loading`
			},
			v6
		)
	else
		if #userIds == 0 and not props.isLoading then
			local searchText = props.searchText

			if string.gsub(searchText, "^%s*(.-)%s*$", "%1") == "" then
				v5 = props.emptyText
			end

			if v5 ~= nil then
				return React.createElement(
					view,
					{
						LayoutOrder = props.layoutOrder,
						tag = "col align-x-center size-full-0 auto-y padding-y-xlarge",
						testId = `{testId}-empty`
					},
					{
						Text = React.createElement(text, {
							Text = v5,
							tag = "auto-xy text-body-large text-align-x-center content-muted"
						})
					}
				)
			end
		end

		local children = {}

		for k, userId in userIds do
			children[`row-{userId}`] = React.createElement(UserPickerRow, {
				userId = userId,
				isSelected = props.isSelected(userId),
				isDisabled = not props.canSelect(userId),
				onToggle = function()
					props.toggleSelected(userId)
				end,
				layoutOrder = k,
				testId = `{testId}-user-{userId}`
			})
		end

		return React.createElement(list.Root, {
			LayoutOrder = props.layoutOrder,
			hasDivider = false,
			isContained = false,
			size = inputSize.Medium,
			testId = `{testId}-results`
		}, children)
	end
end

return UserPickerList
