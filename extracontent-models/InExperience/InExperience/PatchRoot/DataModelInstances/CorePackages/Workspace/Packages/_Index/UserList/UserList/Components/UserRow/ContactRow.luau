local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
require(UserList.Common.Types)
require(UserList.Common.Enums)
local BaseRow = require(script.Parent.BaseRow)
local useContactsData = require(UserList.Hooks.useContactsData)

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags.FFlagUserListSurfaceExtensions

local function ContactRow(props)
	local v = useContactsData(props.entityId)

	if v == nil then
		return nil
	end

	local isTitleLoading

	if props.loadingState and props.loadingState.title ~= nil then
		isTitleLoading = props.loadingState.title
	else
		isTitleLoading = v.isLoading
	end

	local contextualInfo = props.loadingState and props.loadingState.contextualInfo

	local createElement = React.createElement
	local v2 = {
		avatarThumbnailUrl = v.avatarThumbnailUrl,
		title = v.name,
		layoutMode = props.layoutMode,
		onActivated = props.onActivated,
		isTitleLoading = isTitleLoading,
		isContextualInfoLoading = contextualInfo,
		contextualInfo = props.contextualInfo,
		primaryCta = props.primaryCta,
		secondaryCta = props.secondaryCta,
		trailingContent = props.trailingContent,
		layoutOrder = props.layoutOrder,
		disableRowActivation = 0
	}
	local disableRowActivation

	if FFlagUserListSurfaceExtensions and props.configs then
		disableRowActivation = props.configs.disableRowActivation
	end

	v2.disableRowActivation = disableRowActivation
	return createElement(BaseRow, v2)
end

return React.memo(ContactRow)
