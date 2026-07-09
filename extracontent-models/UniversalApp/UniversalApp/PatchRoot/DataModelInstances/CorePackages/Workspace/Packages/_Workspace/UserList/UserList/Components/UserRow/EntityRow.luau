local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local Enums = require(UserList.Common.Enums)

require(UserList.Common.Types)

local UserRow = require(script.Parent.UserRow)
local ContactRow = require(script.Parent.ContactRow)

local function EntityRow(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), Enums (copy), ContactRow (copy), UserRow (copy)
	local entity = t1.entity
	local v10 = React.useCallback(function() -- line: 40
		-- upvalues: t1 (copy), entity (copy)
		if t1.onActivated then
			t1.onActivated(entity.id, entity.type)
		end
	end, {
		t1.onActivated,
		entity.id,
		entity.type
	})
	local v11 = if t1.layoutMode ~= Enums.LayoutMode.Horizontal then Enums.RowLayoutMode.Wide else Enums.RowLayoutMode.Compact

	if entity.type == Enums.EntityType.Contact then
		return React.createElement(ContactRow, {
			entityId = entity.id,
			layoutMode = v11,
			onActivated = v10,
			layoutOrder = t1.layoutOrder,
			primaryCta = t1.primaryCta,
			secondaryCta = t1.secondaryCta,
			contextualInfo = t1.contextualInfo,
			loadingState = t1.loadingState,
			trailingContent = t1.trailingContent,
			configs = t1.configs
		})
	end

	return React.createElement(UserRow, {
		entityId = entity.id,
		layoutMode = v11,
		onActivated = v10,
		primaryCta = t1.primaryCta,
		secondaryCta = t1.secondaryCta,
		contextualInfo = t1.contextualInfo,
		layoutOrder = t1.layoutOrder,
		loadingState = t1.loadingState,
		presence = t1.presence,
		trailingContent = t1.trailingContent,
		configs = t1.configs
	})
end

return React.memo(EntityRow)
