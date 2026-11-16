local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/React")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local friendsOwnedChip = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SocialProof").Chips.FriendsOwnedChip
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local v5 = { Asset = "Asset", Bundle = "Bundle" }

local function readItemId(value)
	if typeof(value) == "number" then
		return (tostring(value))
	end

	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function SduiFriendsOwnedChip(props)
	local itemId = props.itemId

	if typeof(itemId) == "number" then
		itemId = tostring(itemId)
	elseif typeof(itemId) ~= "string" or itemId == "" then
		itemId = nil
	end

	local itemType = props.itemType
	local v6 = if itemType then v5[itemType] else nil
	local v7 = not (itemId == nil) and v6 ~= nil

	local sduiContext = props.sduiContext
	React.useEffect(function()
		if v7 then
			return
		end

		sduiContext.dependencies.logger.reportError(
			sduiErrorType.InvalidProps,
			{
				name = "FriendsOwnedChip",
				message = `Unsupported item: {itemType} {itemId}`
			},
			sduiContext.appPage
		)
	end, { v7, sduiContext, itemType, itemId })

	if itemId == nil or v6 == nil then
		return nil
	end

	return React.createElement(friendsOwnedChip, {
		itemId = itemId,
		itemType = v6,
		fromProfile = false,
		layoutOrder = props.layoutOrder
	})
end

return React.memo(SduiFriendsOwnedChip)
