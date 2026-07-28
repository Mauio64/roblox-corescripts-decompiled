local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local useUserProfileInfo = require(script.Parent.useUserProfileInfo)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local IconButton = Foundation.IconButton
local List = Foundation.List
local Loading = Foundation.Loading
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local AccessoryType = Foundation.Enums.AccessoryType

local function PickedUserRow(t1: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), useUserProfileInfo (copy), React (copy), View (copy), Loading (copy), IconSize (copy), IconButton (copy), IconName (copy), List (copy), AccessoryType (copy), LocalizationStrings (copy)
	local v17 = useTokens()
	local v18 = useUserProfileInfo(t1.userId)
	local Size_1000 = v17.Size.Size_1000
	local v20 = if not t1.isRemoving then React.createElement(IconButton, {
		icon = IconName.TrashCan,
		onActivated = function() -- line: 55
			-- upvalues: t1 (copy)
			t1.onRemove(t1.userId)
		end,
		testId = `{ t1.testId }-remove`
	}) else React.createElement(View, {
		tag = "align-x-center align-y-center",
		Size = UDim2.fromOffset(Size_1000, Size_1000),
		testId = `{ t1.testId }-removing`
	}, {
		Spinner = React.createElement(Loading, {
			size = IconSize.Small
		})
	})

	return React.createElement(List.Item, {
		LayoutOrder = t1.LayoutOrder,
		leading = {
			type = AccessoryType.Avatar,
			userId = t1.userId
		},
		title = if v18.displayName == "" then LocalizationStrings.PRIVATE_INVITES_UNKNOWN_USER else v18.displayName,
		description = LocalizationStrings.formatUserPickerUsername(v18.username),
		trailing = v20,
		testId = t1.testId
	})
end

return PickedUserRow
