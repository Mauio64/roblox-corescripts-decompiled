local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
require(UserList.Common.Types)
local UserRow = require(UserList.Components.UserRow)
local EntityRow = UserRow.EntityRow

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags.FFlagUserListCtaIntegrationEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddStatusIndicatorToBaseRow = SharedFlags2.FFlagAddStatusIndicatorToBaseRow
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags3.FFlagUserListSurfaceExtensions

local function useRenderEntity(data)
	local onActivated = data.onActivated
	local renderRow = data.renderRow
	local entitiesMap = data.entitiesMap
	local configs = data.configs
	local layoutMode = data.layoutMode
	local firstRowRef

	if FFlagUserListSurfaceExtensions then
		firstRowRef = data.firstRowRef
	else
		firstRowRef = nil
	end

	local useCallback = React.useCallback
	local function fn(p: string, layoutOrder: number, size: UDim2?)
		local entity = entitiesMap[p]

		if not entity then
			return nil
		end

		if renderRow then
			return (renderRow(function(props)
				local onActivated2

				if props.onRowActivated then
					onActivated2 = function()
						props.onRowActivated(entity.id, entity.type, layoutOrder)
					end
				else
					onActivated2 = onActivated
				end

				local createElement = React.createElement
				local v = {
					tag = "size-full-full",
					Size = size,
					LayoutOrder = layoutOrder,
					ref = nil
				}
				local ref

				if FFlagUserListSurfaceExtensions and layoutOrder == 1 then
					ref = firstRowRef
				end

				v.ref = ref

				local createElement2 = React.createElement
				local v2 = {
					entity = entity,
					onActivated = onActivated2,
					primaryCta = props.primaryCta,
					secondaryCta = props.secondaryCta,
					ctaLoading = 0,
					contextualInfo = 0,
					loadingState = 0,
					presence = 0,
					shouldShowNewIndicator = 0,
					trailingContent = 0,
					configs = 0,
					layoutMode = 0
				}
				local ctaLoading

				if FFlagUserListCtaIntegrationEnabled then
					ctaLoading = props.ctaLoading
				end

				v2.ctaLoading = ctaLoading

				v2.contextualInfo = props.contextualInfo
				v2.loadingState = props.loadingState
				v2.presence = props.presence
				local shouldShowNewIndicator

				if FFlagAddStatusIndicatorToBaseRow then
					shouldShowNewIndicator = props.shouldShowNewIndicator
				end

				v2.shouldShowNewIndicator = shouldShowNewIndicator

				v2.trailingContent = props.trailingContent
				v2.configs = configs
				v2.layoutMode = layoutMode
				return createElement(View, v, { createElement2(EntityRow, v2) })
			end, entity, layoutOrder))
		end

		local createElement = React.createElement
		local v = { tag = "size-full-full", Size = size, LayoutOrder = layoutOrder, ref = nil }
		local ref

		if FFlagUserListSurfaceExtensions and layoutOrder == 1 then
			ref = firstRowRef
		end

		v.ref = ref
		return (createElement(View, v, {
			React.createElement(EntityRow, {
				entity = entity,
				onActivated = onActivated,
				configs = configs,
				layoutMode = layoutMode
			})
		}))
	end

	local v

	if FFlagUserListSurfaceExtensions then
		v = firstRowRef
	end

	return (useCallback(fn, { onActivated, renderRow, entitiesMap, configs, layoutMode, v }))
end

return useRenderEntity
