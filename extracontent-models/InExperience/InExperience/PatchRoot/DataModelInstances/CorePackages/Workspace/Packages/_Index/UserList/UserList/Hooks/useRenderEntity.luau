local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local View = require(UserListParent.Foundation).View

require(UserList.Common.Types)

local EntityRow = require(UserList.Components.UserRow).EntityRow
local FFlagUserListCtaIntegrationEnabled = require(UserListParent.SharedFlags).FFlagUserListCtaIntegrationEnabled

local function useRenderEntity(t1: {[any]: any}) -- line: 39
	-- upvalues: React (copy), View (copy), EntityRow (copy), FFlagUserListCtaIntegrationEnabled (copy)
	local onActivated = t1.onActivated
	local renderRow = t1.renderRow
	local entitiesMap = t1.entitiesMap
	local configs = t1.configs
	local layoutMode = t1.layoutMode

	return (React.useCallback(function(s1: string, n1: number, uDim2: UDim2?) -- line: 47
		-- upvalues: entitiesMap (copy), renderRow (copy), onActivated (copy), React (copy), View (copy), EntityRow (copy), FFlagUserListCtaIntegrationEnabled (copy), configs (copy), layoutMode (copy)
		local v17 = entitiesMap[s1]

		if not v17 then
			return nil
		end

		if renderRow then
			return (renderRow(function(p1) -- line: 55
				-- upvalues: v17 (copy), n1 (copy), onActivated (copy), React (copy), View (copy), uDim2 (copy), EntityRow (copy), FFlagUserListCtaIntegrationEnabled (copy), configs (copy), layoutMode (copy)
				local v19 = if not p1.onRowActivated then onActivated else function() -- line: 58
					-- upvalues: p1 (copy), v17 (copy), n1 (copy)
					p1.onRowActivated(v17.id, v17.type, n1)
				end

				return React.createElement(View, {
					tag = "size-full-full",
					Size = uDim2,
					LayoutOrder = n1
				}, { React.createElement(EntityRow, {
					entity = v17,
					onActivated = v19,
					primaryCta = p1.primaryCta,
					secondaryCta = p1.secondaryCta,
					ctaLoading = if not FFlagUserListCtaIntegrationEnabled then nil else p1.ctaLoading,
					contextualInfo = p1.contextualInfo,
					loadingState = p1.loadingState,
					presence = p1.presence,
					trailingContent = p1.trailingContent,
					configs = configs,
					layoutMode = layoutMode
				}) })
			end, v17, n1))
		end

		return (React.createElement(View, {
			tag = "size-full-full",
			Size = uDim2,
			LayoutOrder = n1
		}, { React.createElement(EntityRow, {
			entity = v17,
			onActivated = onActivated,
			configs = configs,
			layoutMode = layoutMode
		}) }))
	end, {
		onActivated,
		renderRow,
		entitiesMap,
		configs,
		layoutMode
	}))
end

return useRenderEntity
