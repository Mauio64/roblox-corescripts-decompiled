local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View

local Enums = require(InExperienceSideSheet.Common.Enums)
require(InExperienceSideSheet.Common.Types)
local ShortcutButton = require(InExperienceSideSheet.Components.ShortcutButton)

local ButtonWidth = Enums.ButtonWidth

local function createShortcutButton(props, layoutOrder: number, width) -- 3 equivalent calls inferred from this helper
	return React.createElement(ShortcutButton, {
		label = props.label,
		getShortcutIcon = props.getShortcutIcon,
		getOnActivated = props.getOnActivated,
		getIsEnabled = props.getIsEnabled,
		width = width,
		layoutOrder = layoutOrder
	})
end

local function buildHalfWidthRowLayoutItem(list, count: number)
	if #list == 1 then
		local item = list[1]
		return {
			key = item.name,
			node = createShortcutButton(item, count, ButtonWidth.Full) -- inferred equivalent call
		}
	else
		local v = {}

		for k, item in list do
			local name = item.name
			v[name] = createShortcutButton(item, k, ButtonWidth.Half) -- inferred equivalent call
		end

		return {
			key = "HalfWidthRow_" .. count,
			node = React.createElement(View, {
				tag = "row gap-small size-full-0 auto-y",
				LayoutOrder = count
			}, v)
		}
	end
end

local function buildSessionActionButtonLayout(items)
	local sessionActionButtonLayout = {}
	local count = 0
	local v = {}

	local function flushHalfRow() -- 3 equivalent calls inferred from this helper
		if #v == 0 then
			return
		end

		count += 1
		local halfWidthRowLayoutItem = buildHalfWidthRowLayoutItem(v, count)
		sessionActionButtonLayout[halfWidthRowLayoutItem.key] = halfWidthRowLayoutItem.node
		table.clear(v)
	end

	for _, item in items do
		if (item.width or ButtonWidth.Full) == ButtonWidth.Half then
			table.insert(v, item)

			if #v == 2 then
				flushHalfRow() -- inferred equivalent call
			end
		else
			flushHalfRow() -- inferred equivalent call
			count += 1
			local name = item.name
			sessionActionButtonLayout[name] = createShortcutButton(item, count, ButtonWidth.Full) -- inferred equivalent call
		end
	end

	flushHalfRow() -- inferred equivalent call
	return sessionActionButtonLayout
end

return buildSessionActionButtonLayout
