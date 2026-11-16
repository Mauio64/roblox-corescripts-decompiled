local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UserPickerRow = require(script.Parent.UserPickerRow)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local List = Foundation.List
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local InputSize = Foundation.Enums.InputSize
local Radius = Foundation.Enums.Radius

local function trim(searchText: string) -- 1 equivalent call inferred from this helper
	return (string.gsub(searchText, "^%s*(.-)%s*$", "%1"))
end

local function renderSkeletonRow(i: number, testId: string)
	return React.createElement(
		View,
		{
			LayoutOrder = i,
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-y-small",
			testId = testId
		},
		{
			Avatar = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(36, 36),
				radius = Radius.Circle
			}),
			Lines = React.createElement(View, { LayoutOrder = 2, tag = "col fill gap-small auto-y" }, {
				Title = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.5, 0, 0, 12),
					radius = Radius.Small
				}),
				Description = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.3, 0, 0, 10),
					radius = Radius.Small
				})
			})
		}
	)
end

local function UserPickerList(props)
	local text = useLocalization({ noResults = LocalizationStrings.USER_PICKER_NO_RESULTS }).noResults
	local testId = props.testId or "user-picker-list"
	local userIds = props.userIds

	if #userIds == 0 and props.isLoading then
		local v = {}

		for i = 1, 6 do
			v[`skeleton-{i}`] = renderSkeletonRow(i, `{testId}-skeleton-{i}`)
		end

		return React.createElement(
			View,
			{
				LayoutOrder = props.layoutOrder,
				tag = "col gap-small size-full-0 auto-y",
				testId = `{testId}-loading`
			},
			v
		)
	else
		if #userIds == 0 and not props.isLoading then
			if trim(props.searchText) == "" then -- inferred equivalent call
				text = props.emptyText
			end

			if text ~= nil then
				return React.createElement(
					View,
					{
						LayoutOrder = props.layoutOrder,
						tag = "col align-x-center size-full-0 auto-y padding-y-xlarge",
						testId = `{testId}-empty`
					},
					{
						Text = React.createElement(Text, {
							Text = text,
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

		return React.createElement(List.Root, {
			LayoutOrder = props.layoutOrder,
			hasDivider = false,
			isContained = false,
			size = InputSize.Medium,
			testId = `{testId}-results`
		}, children)
	end
end

return UserPickerList
