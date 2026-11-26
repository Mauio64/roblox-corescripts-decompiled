local module = require("@luauforge/deferred/enw")
local module2 = require("@luauforge/deferred/enx")

local view = module2.View
local list = module2.List
local inputSize = module2.Enums.InputSize
local accessoryType = module2.Enums.AccessoryType

local function ActivityTile(props)
	local v5

	if props.avatarUserId == nil then
		v5 = props.thumbnail ~= nil and { iconName = props.thumbnail } or nil
	else
		v5 = { type = accessoryType.Avatar, userId = props.avatarUserId }
	end

	local v6

	if props.isUnread then
		v6 = module.createElement(view, {
			tag = "size-200-200 auto-none radius-circle bg-system-emphasis"
		})
	end

	local v7

	if props.subtitle then
		v7 = { title = props.title, metadata = props.subtitle }
	else
		v7 = props.title
	end

	return module.createElement(
		list.Root,
		{ size = inputSize.Large, hasDivider = false, LayoutOrder = props.layoutOrder },
		{
			Item = module.createElement(list.Item, {
				leading = v5,
				title = v7,
				trailing = v6,
				onActivated = props.onActivated
			})
		}
	)
end

return ActivityTile
