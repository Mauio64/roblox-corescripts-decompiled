local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local CurrencyTransfers = require(CorePackages.Workspace.Packages.CurrencyTransfers)
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local TransferRobuxFlow = CurrencyTransfers.TransferRobuxFlow
local TransferDirection = CurrencyTransfers.Enums.TransferDirection

local function CurrencyTransferUniversalAppWrapper(_: {[any]: any}) -- line: 17
	-- upvalues: useNavigation (copy), useNavigationProps (copy), TransferDirection (copy), React (copy), TransferRobuxFlow (copy)
	local v10 = useNavigation()
	local v11 = useNavigationProps(function(_, p2) -- line: 19
		return {
			direction = p2.direction,
			recipientUserId = p2.recipientUserId,
			transferId = p2.transferId,
			transferOrigination = p2.transferOrigination
		}
	end)
	local direction = v11.direction
	local v13 = if not direction or string.lower(direction) ~= "receive" then TransferDirection.Send else TransferDirection.Receive
	local recipientUserId = v11.recipientUserId
	local v15 = if type(recipientUserId) ~= "string" then recipientUserId else tonumber(recipientUserId)

	return React.createElement(TransferRobuxFlow, {
		direction = v13,
		recipientUserId = v15,
		transferId = v11.transferId,
		transferOrigination = v11.transferOrigination,
		onClose = function() -- line: 43
			-- upvalues: v10 (copy)
			v10.pop()
		end
	})
end

return CurrencyTransferUniversalAppWrapper
