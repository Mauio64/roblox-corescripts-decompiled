local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)

local UserRow = require(script.Parent.UserRow)
local ContactRow = require(script.Parent.ContactRow)

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags.FFlagUserListCtaIntegrationEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddStatusIndicatorToBaseRow = SharedFlags2.FFlagAddStatusIndicatorToBaseRow

local function EntityRow(props)
	local entity = props.entity

	local onActivated = React.useCallback(function()
		if props.onActivated then
			props.onActivated(entity.id, entity.type)
		end
	end, { props.onActivated, entity.id, entity.type })
	local layoutMode

	if props.layoutMode == Enums.LayoutMode.Horizontal then
		layoutMode = Enums.RowLayoutMode.Compact
	else
		layoutMode = Enums.RowLayoutMode.Wide
	end

	if entity.type == Enums.EntityType.Contact then
		return React.createElement(ContactRow, {
			entityId = entity.id,
			layoutMode = layoutMode,
			onActivated = onActivated,
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
	local v = {
		entityId = entity.id,
		layoutMode = layoutMode,
		onActivated = onActivated,
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
	local ctaLoading

	if FFlagUserListCtaIntegrationEnabled then
		ctaLoading = props.ctaLoading
	end

	v.ctaLoading = ctaLoading
	v.contextualInfo = props.contextualInfo
	v.layoutOrder = props.layoutOrder
	v.loadingState = props.loadingState
	v.presence = props.presence
	local shouldShowNewIndicator

	if FFlagAddStatusIndicatorToBaseRow then
		shouldShowNewIndicator = props.shouldShowNewIndicator
	end

	v.shouldShowNewIndicator = shouldShowNewIndicator
	v.trailingContent = props.trailingContent
	v.configs = props.configs
	return createElement(UserRow, v)
end

return React.memo(EntityRow)
