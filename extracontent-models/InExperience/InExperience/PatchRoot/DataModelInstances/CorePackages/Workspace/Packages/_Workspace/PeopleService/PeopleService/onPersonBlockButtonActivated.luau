local parent = script:FindFirstAncestor("PeopleService").Parent

local Promise = require(parent.Promise)

local function onPersonBlockButtonActivated(player, object, p: number, source: string, _, p2)
	object:trackBlockUserButtonClick(player.UserId, p, source)

	local resolvePromise = nil
	return {
		modalProps = {
			player = player,
			closeModal = function() end,
			analytics = {
				action = function(_, _: string, p3: string, _)
					if p3 == "blockUser" then
						object:trackBlockUser(player.UserId, p, source)
					elseif p3 == "unblockUser" then
						object:trackUnblockUser(player.UserId, p, source)
					elseif p3 == "blockUserButtonClick" then
						object:trackBlockUserButtonClick(player.UserId, p, source)
					end
				end
			},
			source = source,
			onBlockingSuccess = p2 and p2.onBlockingSuccess or nil
		},
		promise = Promise.new(function(p3)
			resolvePromise = p3
		end),
		resolvePromise = resolvePromise,
		useToastFlow = true
	}
end

return onPersonBlockButtonActivated
