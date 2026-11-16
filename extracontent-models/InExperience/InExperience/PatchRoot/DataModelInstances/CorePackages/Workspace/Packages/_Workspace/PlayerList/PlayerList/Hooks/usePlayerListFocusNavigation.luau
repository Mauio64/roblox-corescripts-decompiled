local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
require(parent2.Signals)

local ReactFocusNavigation = require(parent2.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local FocusNavHelper = require(parent.Common.FocusNavHelper)

require(parent2.LeaderboardStore)

local Constants = require(parent.Common.Constants)

local function usePlayerListFocusNavigation()
	local v = useFocusGuiObject()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef({})

	local v2 = React.useCallback(function(p, p2)
		local nextPlayerInstance = FocusNavHelper.getNextPlayerInstance(ref3.current, p, p2)

		if nextPlayerInstance then
			v(nextPlayerInstance.object)
		else
			v(ref.current)
		end
	end, {})

	local getFocus = React.useCallback(function()
		if ref2.current and ref2.current ~= Constants.SELECTED_TITLE_PLAYER_ID then
			for _, v3 in ref3.current do
				for _, player in v3.players do
					if player.userId == ref2.current then
						v(player.object)
						return
					end
				end
			end
		end

		if ref.current then
			v(ref.current)
			return
		end

		local firstPlayerInstance = FocusNavHelper.getFirstPlayerInstance(ref3.current)

		if firstPlayerInstance then
			v(firstPlayerInstance.object)
		end
	end, {})

	local v3 = React.useCallback(function(p)
		return function(userId: number, object, order)
			if object and ref3.current[p] then
				ref3.current[p].players[userId] = {
					userId = userId,
					object = object,
					order = order
				}
			end
		end
	end, {})

	local v4 = React.useCallback(function(p)
		return function(p2: number)
			local v4 = ref3.current[p]

			if not v4 then
				return
			end

			local player = v4.players[p2]

			if not player then
				return
			end

			if GuiService.SelectedCoreObject == player.object then
				v2(player, p)
			end

			ref3.current[p].players[p2] = nil
		end
	end, {})

	local registerTeamInstance = React.useCallback(function(teamId, order)
		local v5 = {
			teamId = teamId,
			order = order,
			players = {},
			registerPlayerInstance = v3(teamId),
			unregisterPlayerInstance = v4(teamId)
		}

		ref3.current[teamId] = v5

		return v5
	end, {})

	local unregisterTeamInstance = React.useCallback(function(p)
		ref3.current[p] = nil
	end, {})

	local setTitlePlayerInstance = React.useCallback(function(current)
		ref.current = current
	end, {})

	local setSelectedPlayerId = React.useCallback(function(current: number?)
		ref2.current = current
	end, {})

	local cleanup = React.useCallback(function(flag: boolean?)
		if flag then
			v(nil)
		end

		ref.current = nil
		ref2.current = nil
		ref3.current = {}
	end, {})

	return React.useMemo(function()
		return {
			getFocus = getFocus,
			registerTeamInstance = registerTeamInstance,
			unregisterTeamInstance = unregisterTeamInstance,
			setTitlePlayerInstance = setTitlePlayerInstance,
			setSelectedPlayerId = setSelectedPlayerId,
			cleanup = cleanup
		}
	end, {
		getFocus,
		registerTeamInstance,
		unregisterTeamInstance,
		setTitlePlayerInstance,
		setSelectedPlayerId,
		cleanup
	})
end

return usePlayerListFocusNavigation
