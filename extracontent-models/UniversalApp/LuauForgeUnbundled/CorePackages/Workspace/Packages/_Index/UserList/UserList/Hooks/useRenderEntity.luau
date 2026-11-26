local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").View
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local entityRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Components/UserRow").EntityRow

local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions

local function useRenderEntity(data)
	local onActivated = data.onActivated
	local renderRow = data.renderRow
	local entitiesMap = data.entitiesMap
	local configs = data.configs
	local layoutMode = data.layoutMode
	local firstRowRef = if fFlagUserListSurfaceExtensions then data.firstRowRef else nil

	local function fn(p2, p3, p4)
		local entity = entitiesMap[p2]

		if not entity then
			return nil
		end

		if renderRow then
			return renderRow(function(props)
				local onActivated2

				if props.onRowActivated then
					onActivated2 = function()
						props.onRowActivated(entity.id, entity.type, p3)
					end
				else
					onActivated2 = onActivated
				end

				local createElement = React.createElement
				local v6 = {
					tag = "size-full-full",
					Size = p4,
					LayoutOrder = p3,
					ref = nil
				}

				local v7 = if fFlagUserListSurfaceExtensions and p3 == 1 then firstRowRef else nil
				v6.ref = v7

				local createElement2 = React.createElement
				local v10 = {
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

				local v11 = if fFlagUserListCtaIntegrationEnabled then props.ctaLoading else nil
				v10.ctaLoading = v11

				v10.contextualInfo = props.contextualInfo
				v10.loadingState = props.loadingState
				v10.presence = props.presence
				v10.shouldShowNewIndicator = props.shouldShowNewIndicator
				v10.trailingContent = props.trailingContent
				v10.configs = configs
				v10.layoutMode = layoutMode
				return createElement(view, v6, { createElement2(entityRow, v10) })
			end, entity, p3)
		end

		local createElement = React.createElement
		local v6 = { tag = "size-full-full", Size = p4, LayoutOrder = p3, ref = nil }

		local v7 = if fFlagUserListSurfaceExtensions and p3 == 1 then firstRowRef else nil
		v6.ref = v7
		return createElement(view, v6, {
			React.createElement(entityRow, {
				entity = entity,
				onActivated = onActivated,
				configs = configs,
				layoutMode = layoutMode
			})
		})
	end

	return (React.useCallback(fn, {
		onActivated,
		renderRow,
		entitiesMap,
		configs,
		layoutMode,
		if fFlagUserListSurfaceExtensions then firstRowRef else nil
	}))
end

return useRenderEntity
