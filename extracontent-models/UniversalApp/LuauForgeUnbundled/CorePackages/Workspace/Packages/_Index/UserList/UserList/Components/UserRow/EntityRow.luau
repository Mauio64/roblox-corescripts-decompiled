local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local UserRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/UserRow/UserRow")
local ContactRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/UserRow/ContactRow")

local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled

local function EntityRow(props)
	local entity = props.entity

	local v5 = React.useCallback(function()
		if props.onActivated then
			props.onActivated(entity.id, entity.type)
		end
	end, { props.onActivated, entity.id, entity.type })
	local v6

	if props.layoutMode == Enums.LayoutMode.Horizontal then
		v6 = Enums.RowLayoutMode.Compact
	else
		v6 = Enums.RowLayoutMode.Wide
	end

	if entity.type == Enums.EntityType.Contact then
		return React.createElement(ContactRow, {
			entityId = entity.id,
			layoutMode = v6,
			onActivated = v5,
			layoutOrder = props.layoutOrder,
			primaryCta = props.primaryCta,
			secondaryCta = props.secondaryCta,
			contextualInfo = props.contextualInfo,
			loadingState = props.loadingState,
			trailingContent = props.trailingContent,
			configs = props.configs
		})
	end

	local createElement = React.createElement
	local v8 = {
		entityId = entity.id,
		layoutMode = v6,
		onActivated = v5,
		primaryCta = props.primaryCta,
		secondaryCta = props.secondaryCta,
		ctaLoading = 0,
		contextualInfo = 0,
		layoutOrder = 0,
		loadingState = 0,
		presence = 0,
		shouldShowNewIndicator = 0,
		trailingContent = 0,
		configs = 0
	}
	local v9 = if fFlagUserListCtaIntegrationEnabled then props.ctaLoading else nil
	v8.ctaLoading = v9
	v8.contextualInfo = props.contextualInfo
	v8.layoutOrder = props.layoutOrder
	v8.loadingState = props.loadingState
	v8.presence = props.presence
	v8.shouldShowNewIndicator = props.shouldShowNewIndicator
	v8.trailingContent = props.trailingContent
	v8.configs = props.configs
	return createElement(UserRow, v8)
end

return React.memo(EntityRow)
