local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown

require(Parent.DiscoveryTypes)

local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

local function useNavigateToSeeAll(p1, b1: boolean, n1: number?, s1: string?, s2: string?, s3: string?) -- line: 18
	-- upvalues: useDispatch (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	local v15 = useDispatch()

	return (React.useCallback(function() -- line: 29
		-- upvalues: p1 (copy), AppPage (copy), s2 (copy), s1 (copy), s3 (copy), b1 (copy), n1 (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), v15 (copy), NavigateDown (copy)
		if p1 == nil then
			return
		end

		local t1 = {
			name = AppPage.GamesList,
			detail = s2,
			extraProps = {
				sortPageId = s1,
				sortName = s2,
				pageContext = s3,
				isOmni = b1,
				sortIndex = if not b1 then nil else n1
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t1))

			return
		end

		v15(NavigateDown(t1))
	end, {
		v15,
		b1,
		p1,
		n1,
		s2,
		s3,
		s1
	}))
end

return useNavigateToSeeAll
