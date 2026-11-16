local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local React = require(parent.React)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SocialProof = require(parent.SocialProof)

local FriendsOwnedChip = SocialProof.Chips.FriendsOwnedChip
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local v = { Asset = "Asset", Bundle = "Bundle" }

local function readItemId(itemId) -- 1 equivalent call inferred from this helper
	if typeof(itemId) == "number" then
		return (tostring(itemId))
	end

	if typeof(itemId) == "string" and itemId ~= "" then
		return itemId
	end

	return nil
end

local function SduiFriendsOwnedChip(props)
	local itemId = readItemId(props.itemId) -- inferred equivalent call
	local itemType = props.itemType
	local itemType2

	if itemType then
		itemType2 = v[itemType]
	end

	local v2

	if itemId == nil then
		v2 = false
	else
		v2 = itemType2 ~= nil
	end

	local sduiContext = props.sduiContext
	React.useEffect(function()
		if v2 then
			return
		end

		sduiContext.dependencies.logger.reportError(
			SduiErrorType.InvalidProps,
			{
				name = "FriendsOwnedChip",
				message = `Unsupported item: {itemType} {itemId}`
			},
			sduiContext.appPage
		)
	end, { v2, sduiContext, itemType, itemId })

	if itemId == nil or itemType2 == nil then
		return nil
	end

	return React.createElement(FriendsOwnedChip, {
		itemId = itemId,
		itemType = itemType2,
		fromProfile = false,
		layoutOrder = props.layoutOrder
	})
end

return React.memo(SduiFriendsOwnedChip)
