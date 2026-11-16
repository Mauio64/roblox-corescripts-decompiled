local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/ehC")

local module4 = require("@luauforge/deferred/eWd")

local module5 = require("@luauforge/deferred/egW")
require("@luauforge/deferred/egX")

local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant

local verticalUserList = module3.VerticalUserList.VerticalUserList
local buttonTypes = module3.Enums.ButtonTypes
local viewportVisibilityImpressionsDetector = module4.ViewportVisibilityImpressionsDetector

local v5 = { showSubtitle = true }

local function InviteRowWithImpression(props)
	local ref = module.useRef(nil)
	local onImpression = props.onImpression
	local v6 = module.useCallback(function()
		onImpression(props.userId, props.position)
	end, { onImpression, props.userId, props.position })

	return module.createElement(
		view,
		{ ref = ref, tag = "size-full-0 auto-y", LayoutOrder = props.position },
		{
			Row = props.row,
			Detector = module.createElement(viewportVisibilityImpressionsDetector, {
				targetRef = ref,
				onImpression = v6
			})
		}
	)
end

local function onActivated() end

local function WaitlistInviteList(props)
	local rows = props.rows
	local onInvite = props.onInvite
	local onImpression = props.onImpression

	local v6 = module.useMemo(function()
		local result = table.create(#rows)

		for k, row in rows do
			table.insert(result, { id = row.userId, type = "User", status = row.status })
		end

		return result
	end, { rows })

	local v7 = module.useCallback(function(callback, p2, p3)
		local id = p2.id
		local status = p2.status
		local v8

		if status == module5.InviteRowStatus.Invited then
			v8 = {
				type = buttonTypes.Invited,
				onActivated = onActivated,
				isDisabled = true,
				variant = buttonVariant.Standard
			}
		else
			v8 = { type = buttonTypes.Invite, onActivated = 0, isLoading = 0 }
			local v9

			if status == module5.InviteRowStatus.Sending then
				v9 = onActivated
			else
				v9 = function()
					onInvite(id, p3)
				end
			end

			v8.onActivated = v9

			v8.isLoading = status == module5.InviteRowStatus.Sending
		end

		local v9 = callback({ primaryCta = v8 })

		if onImpression == nil then
			return v9
		end

		return module.createElement(InviteRowWithImpression, {
			userId = id,
			position = p3,
			row = v9,
			onImpression = onImpression
		})
	end, { onInvite, onImpression })

	return module.createElement(verticalUserList, {
		entities = v6,
		configs = v5,
		renderRow = v7,
		layoutOrder = props.LayoutOrder
	})
end

return WaitlistInviteList
