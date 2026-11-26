local module = require("@luauforge/deferred/eaj")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module3 = require("@luauforge/deferred/eaG")

local module4 = require("@luauforge/deferred/eaH")
local module5 = require("@luauforge/deferred/eaJ")
local view = module.View

local module6 = require("@luauforge/deferred/eaM")

local useAppPolicy = require("@luauforge/deferred/dZk").useAppPolicy
local useUserExperiment = module3.useUserExperiment

local module7 = require("@luauforge/deferred/eaN")
local module8 = require("@luauforge/deferred/eaO")
local module9 = require("@luauforge/deferred/eaP")

return function(props)
	local v5 = useAppPolicy(function(p2)
		return p2.getEligibleForExternalContentSharing()
	end)

	local v6 = React.useMemo(function()
		return module6(props.additionalInfo)
	end, { props.additionalInfo })

	local v7 = false

	if module7 then
		v7 = true
	elseif module8 then
		v7 = useUserExperiment({ module9 }, function(p2)
			return (p2[module9] or {}).ContentFeedInspectEnabled
		end)
	end

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.layoutOrder,
		tag = "align-x-center align-y-center col auto-xy bg-action-subtle items-center gap-medium"
	}

	local v11 = if v7 and v6 then React.createElement(module4, {
		avatarItemIds = v6,
		layoutOrder = 1,
		postId = props.postId
	}) else nil

	local v12 = if v5 then React.createElement(module5, {
		creatorUserId = props.creatorUserId,
		layoutOrder = 2,
		postId = props.postId
	}) else nil
	return createElement(view, v9, { InspectCTA = v11, ShareCTA = v12 })
end
