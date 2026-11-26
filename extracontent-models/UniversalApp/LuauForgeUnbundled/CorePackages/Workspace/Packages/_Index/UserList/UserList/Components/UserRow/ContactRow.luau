local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
local BaseRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/UserRow/BaseRow")
local useContactsData = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useContactsData")

local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions

local function ContactRow(props)
	local v5 = useContactsData(props.entityId)

	if v5 == nil then
		return nil
	end

	local v6

	if props.loadingState and props.loadingState.title ~= nil then
		v6 = props.loadingState.title
	else
		v6 = v5.isLoading
	end

	local contextualInfo = props.loadingState and props.loadingState.contextualInfo

	local createElement = React.createElement
	local v8 = {
		avatarThumbnailUrl = v5.avatarThumbnailUrl,
		title = v5.name,
		layoutMode = props.layoutMode,
		onActivated = props.onActivated,
		isTitleLoading = v6,
		isContextualInfoLoading = contextualInfo,
		contextualInfo = props.contextualInfo,
		primaryCta = props.primaryCta,
		secondaryCta = props.secondaryCta,
		trailingContent = props.trailingContent,
		layoutOrder = props.layoutOrder,
		disableRowActivation = 0
	}
	local v9 = if fFlagUserListSurfaceExtensions and props.configs then props.configs.disableRowActivation else nil
	v8.disableRowActivation = v9
	return createElement(BaseRow, v8)
end

return React.memo(ContactRow)
