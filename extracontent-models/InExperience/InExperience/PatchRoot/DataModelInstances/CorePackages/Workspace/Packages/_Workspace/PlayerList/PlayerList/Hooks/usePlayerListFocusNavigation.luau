local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)

require(ParentParentParent.Signals)

local useFocusGuiObject = require(ParentParentParent.ReactFocusNavigation).useFocusGuiObject
local FocusNavHelper = require(ParentParent.Common.FocusNavHelper)

require(ParentParentParent.LeaderboardStore)

local Constants = require(ParentParent.Common.Constants)

local function usePlayerListFocusNavigation() -- line: 57
	-- upvalues: useFocusGuiObject (copy), React (copy), FocusNavHelper (copy), Constants (copy), GuiService (copy)
	local v9 = useFocusGuiObject()
	local v10 = React.useRef(nil)
	local v11 = React.useRef(nil)
	local v12 = React.useRef({})
	local v13 = React.useCallback(function(p1, p2) -- line: 66
		-- upvalues: FocusNavHelper (copy), v12 (copy), v9 (copy), v10 (copy)
		local v24 = FocusNavHelper.getNextPlayerInstance(v12.current, p1, p2)

		if v24 then
			v9(v24.object)

			return
		end

		v9(v10.current)
	end, {})
	local v14 = React.useCallback(function() -- line: 78
		-- upvalues: v11 (copy), Constants (copy), v12 (copy), v9 (copy), v10 (copy), FocusNavHelper (copy)
		if v11.current and v11.current ~= Constants.SELECTED_TITLE_PLAYER_ID then
			for _, v26 in v12.current do
				for _, v28 in v26.players do
					if v28.userId == v11.current then
						v9(v28.object)

						return
					end
				end
			end
		end

		if v10.current then
			v9(v10.current)

			return
		end

		local v29 = FocusNavHelper.getFirstPlayerInstance(v12.current)

		if v29 then
			v9(v29.object)
		end
	end, {})
	local v15 = React.useCallback(function(p3) -- line: 104
		-- upvalues: v12 (copy)
		return function(n1: number, p4, p5) -- line: 105
			-- upvalues: v12 (copy), p3 (copy)
			if not p4 or not v12.current[p3] then
				return
			end

			v12.current[p3].players[n1] = {
				userId = n1,
				object = p4,
				order = p5
			}
		end
	end, {})
	local v16 = React.useCallback(function(p6) -- line: 118
		-- upvalues: v12 (copy), GuiService (copy), v13 (copy)
		return function(n2: number) -- line: 119
			-- upvalues: v12 (copy), p6 (copy), GuiService (copy), v13 (copy)
			local v43 = v12.current[p6]

			if not v43 then
				return
			end

			local v44 = v43.players[n2]

			if not v44 then
				return
			end

			if GuiService.SelectedCoreObject == v44.object then
				v13(v44, p6)
			end

			v12.current[p6].players[n2] = nil
		end
	end, {})
	local v17 = React.useCallback(function(p7, p8) -- line: 138
		-- upvalues: v15 (copy), v16 (copy), v12 (copy)
		local t1 = {
			teamId = p7,
			order = p8,
			players = {},
			registerPlayerInstance = v15(p7),
			unregisterPlayerInstance = v16(p7)
		}

		v12.current[p7] = t1

		return t1
	end, {})
	local v18 = React.useCallback(function(p9) -- line: 152
		-- upvalues: v12 (copy)
		v12.current[p9] = nil
	end, {})
	local v19 = React.useCallback(function(p10) -- line: 156
		-- upvalues: v10 (copy)
		v10.current = p10
	end, {})
	local v20 = React.useCallback(function(n3: number?) -- line: 160
		-- upvalues: v11 (copy)
		v11.current = n3
	end, {})
	local v21 = React.useCallback(function(b1: boolean?) -- line: 164
		-- upvalues: v9 (copy), v10 (copy), v11 (copy), v12 (copy)
		if b1 then
			v9(nil)
		end

		v10.current = nil
		v11.current = nil
		v12.current = {}
	end, {})

	return React.useMemo(function() -- line: 175
		-- upvalues: v14 (copy), v17 (copy), v18 (copy), v19 (copy), v20 (copy), v21 (copy)
		return {
			getFocus = v14,
			registerTeamInstance = v17,
			unregisterTeamInstance = v18,
			setTitlePlayerInstance = v19,
			setSelectedPlayerId = v20,
			cleanup = v21
		}
	end, {
		v14,
		v17,
		v18,
		v19,
		v20,
		v21
	})
end

return usePlayerListFocusNavigation
