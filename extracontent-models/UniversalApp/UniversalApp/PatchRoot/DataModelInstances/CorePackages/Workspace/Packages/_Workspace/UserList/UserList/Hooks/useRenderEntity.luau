local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local View = require(UserListParent.Foundation).View

require(UserList.Common.Types)

local EntityRow = require(UserList.Components.UserRow).EntityRow

local function useRenderEntity(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), View (copy), EntityRow (copy)
	local onActivated = t1.onActivated
	local renderRow = t1.renderRow
	local entitiesMap = t1.entitiesMap
	local configs = t1.configs
	local layoutMode = t1.layoutMode

	return (React.useCallback(function(s1: string, n1: number, uDim2: UDim2?) -- line: 45
		-- upvalues: entitiesMap (copy), renderRow (copy), onActivated (copy), React (copy), View (copy), EntityRow (copy), configs (copy), layoutMode (copy)
		local v16 = entitiesMap[s1]

		if not v16 then
			return nil
		end

		if renderRow then
			return (renderRow(function(p1) -- line: 53
				-- upvalues: v16 (copy), n1 (copy), onActivated (copy), React (copy), View (copy), uDim2 (copy), EntityRow (copy), configs (copy), layoutMode (copy)
				local v18 = if not p1.onRowActivated then onActivated else function() -- line: 56
					-- upvalues: p1 (copy), v16 (copy), n1 (copy)
					p1.onRowActivated(v16.id, v16.type, n1)
				end

				return React.createElement(View, {
					tag = "size-full-full",
					Size = uDim2,
					LayoutOrder = n1
				}, { React.createElement(EntityRow, {
					entity = v16,
					onActivated = v18,
					primaryCta = p1.primaryCta,
					secondaryCta = p1.secondaryCta,
					contextualInfo = p1.contextualInfo,
					loadingState = p1.loadingState,
					presence = p1.presence,
					trailingContent = p1.trailingContent,
					configs = configs,
					layoutMode = layoutMode
				}) })
			end, v16, n1))
		end

		return (React.createElement(View, {
			tag = "size-full-full",
			Size = uDim2,
			LayoutOrder = n1
		}, { React.createElement(EntityRow, {
			entity = v16,
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
