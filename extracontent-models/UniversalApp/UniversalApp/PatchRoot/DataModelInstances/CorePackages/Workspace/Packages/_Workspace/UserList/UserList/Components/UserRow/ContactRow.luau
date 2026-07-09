local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)

require(UserList.Common.Types)
require(UserList.Common.Enums)

local BaseRow = require(script.Parent.BaseRow)
local useContactsData = require(UserList.Hooks.useContactsData)

local function ContactRow(t1: {[any]: any}) -- line: 34
	-- upvalues: useContactsData (copy), React (copy), BaseRow (copy)
	local v8 = useContactsData(t1.entityId)

	if v8 == nil then
		return nil
	end

	local v9 = if not t1.loadingState or t1.loadingState.title == nil then v8.isLoading else t1.loadingState.title
	local v10 = t1.loadingState and t1.loadingState.contextualInfo

	return React.createElement(BaseRow, {
		avatarThumbnailUrl = v8.avatarThumbnailUrl,
		title = v8.name,
		layoutMode = t1.layoutMode,
		onActivated = t1.onActivated,
		isTitleLoading = v9,
		isContextualInfoLoading = v10,
		contextualInfo = t1.contextualInfo,
		primaryCta = t1.primaryCta,
		secondaryCta = t1.secondaryCta,
		trailingContent = t1.trailingContent,
		layoutOrder = t1.layoutOrder
	})
end

return React.memo(ContactRow)
